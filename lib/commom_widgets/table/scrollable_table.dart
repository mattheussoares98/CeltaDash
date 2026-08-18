import 'dart:math' as math;

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part 'fixed_layout.dart';
part 'scrollable_hand_animation.dart';
part 'scrollable_header_cell_wrapper.dart';
part 'scrollable_layout.dart';
part 'scrollable_row.dart';
part 'scrollable_table_cell.dart';
part 'scrollable_table_column_spec.dart';
part 'scrollable_table_header.dart';

final Set<String> _playedRouteNames = {};

class ScrollableTable<T> extends HookConsumerWidget {
  final List<T> items;
  final List<ScrollableTableColumnSpec<T>> columns;
  final bool fixFirstColumn;
  final double headerHeight;
  final double rowHeight;
  final Color? headerBackgroundColor;
  final Color? rowBackgroundColor;
  final Color? footerBackgroundColor;
  final ProviderBase<AsyncValue<dynamic>>? refreshProvider;
  final void Function(T item)? onTapRow;
  final Color? Function(T item)? rowColor;
  final bool isLoading;
  final int? initialSortColumnIndex;
  final bool initialSortAscending;
  final bool highlightBestAndWorst;

  const ScrollableTable({
    super.key,
    required this.items,
    required this.columns,
    this.fixFirstColumn = false,
    this.headerHeight = 48.0,
    this.rowHeight = 48.0,
    this.headerBackgroundColor,
    this.rowBackgroundColor,
    this.footerBackgroundColor,
    this.refreshProvider,
    this.onTapRow,
    this.rowColor,
    this.isLoading = false,
    this.initialSortColumnIndex,
    this.initialSortAscending = true,
    this.highlightBestAndWorst = false,
  });

  static const double footerH = 40;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (columns.isEmpty) return const SizedBox.shrink();

    final fixedVerticalController = useScrollController();
    final scrollableVerticalController = useScrollController();
    final horizontalScrollController = useScrollController();

    final handAnimationController = useAnimationController(
      duration: const Duration(milliseconds: 3500),
    );

    final handOpacityAnimation = useMemoized(
      () => TweenSequence<double>([
        TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
        TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
        TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 10),
      ]).animate(handAnimationController),
      [handAnimationController],
    );

    final handPositionAnimation = useMemoized(
      () => TweenSequence<double>([
        TweenSequenceItem(
          tween: Tween(
            begin: 0.8,
            end: 0.2,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 35,
        ),
        TweenSequenceItem(tween: ConstantTween(0.2), weight: 10),
        TweenSequenceItem(
          tween: Tween(
            begin: 0.2,
            end: 0.8,
          ).chain(CurveTween(curve: Curves.easeInOut)),
          weight: 35,
        ),
        TweenSequenceItem(tween: ConstantTween(0.8), weight: 20),
      ]).animate(handAnimationController),
      [handAnimationController],
    );

    final showHand = useState(false);
    final hasPlayedAnimation = useRef(false);
    final isSyncing = useRef(false);
    final activeScrollController = useState<ScrollController?>(null);

    final sortColumnIndex = useState<int?>(initialSortColumnIndex);
    final sortAscending = useState(initialSortAscending);

    final scrollableColumns = useMemoized(
      () => fixFirstColumn && columns.isNotEmpty ? columns.sublist(1) : columns,
      [fixFirstColumn, columns],
    );

    final sortedItems = useMemoized(() {
      final list = List<T>.of(items);
      final sortCol = sortColumnIndex.value;
      if (sortCol != null && sortCol < columns.length) {
        final mapper = columns[sortCol].sortValueMapper;
        if (mapper != null) {
          list.sort((a, b) {
            final cmp = Comparable.compare(mapper(a), mapper(b));
            return sortAscending.value ? cmp : -cmp;
          });
        }
      }
      return list;
    }, [items, columns, sortColumnIndex.value, sortAscending.value]);

    final (bestRow, worstRow) = useMemoized(() {
      if (!highlightBestAndWorst || sortedItems.length <= 1) {
        return (null, null);
      }

      final activeColIndex = sortColumnIndex.value ?? initialSortColumnIndex;
      if (activeColIndex == null || activeColIndex >= columns.length) {
        return (null, null);
      }

      final mapper = columns[activeColIndex].sortValueMapper;
      if (mapper == null) return (null, null);

      // When sortedItems is already sorted by activeColIndex, O(1) instant lookup:
      if (sortColumnIndex.value == activeColIndex) {
        final first = sortedItems.first;
        final last = sortedItems.last;
        final firstVal = mapper(first);
        final lastVal = mapper(last);

        if (firstVal == lastVal) return (null, null);

        return sortAscending.value
            ? (last, first) // ascending: largest is last, smallest is first
            : (first, last); // descending: largest is first, smallest is last
      }

      // Fast single-pass O(N) fallback with pre-initialized baseline
      T best = sortedItems.first;
      T worst = sortedItems.first;
      Comparable bestVal = mapper(best);
      Comparable worstVal = bestVal;

      for (int i = 1; i < sortedItems.length; i++) {
        final item = sortedItems[i];
        final val = mapper(item);
        if (val.compareTo(bestVal) > 0) {
          bestVal = val;
          best = item;
        } else if (val.compareTo(worstVal) < 0) {
          worstVal = val;
          worst = item;
        }
      }

      if (bestVal == worstVal) return (null, null);
      return (best, worst);
    }, [
      sortedItems,
      columns,
      highlightBestAndWorst,
      sortColumnIndex.value,
      sortAscending.value,
      initialSortColumnIndex,
    ]);

    Color? getEffectiveRowColor(T item) {
      final custom = rowColor?.call(item);
      if (custom != null) return custom;

      if (highlightBestAndWorst) {
        if (item == bestRow) return Colors.green.withAlpha(100);
        if (item == worstRow) return Colors.red.withAlpha(100);
      }

      return null;
    }

    useEffect(() {
      void syncFixedToScrollable() {
        if (isSyncing.value) return;
        if (!scrollableVerticalController.hasClients) return;
        if (activeScrollController.value != null &&
            activeScrollController.value != fixedVerticalController) {
          return;
        }

        final offset = fixedVerticalController.offset;
        if (scrollableVerticalController.offset == offset) return;

        isSyncing.value = true;
        scrollableVerticalController.jumpTo(offset);
        isSyncing.value = false;
      }

      void syncScrollableToFixed() {
        if (isSyncing.value) return;
        if (!fixedVerticalController.hasClients) return;
        if (activeScrollController.value != null &&
            activeScrollController.value != scrollableVerticalController) {
          return;
        }

        final offset = scrollableVerticalController.offset;
        if (fixedVerticalController.offset == offset) return;

        isSyncing.value = true;
        fixedVerticalController.jumpTo(offset);
        isSyncing.value = false;
      }

      fixedVerticalController.addListener(syncFixedToScrollable);
      scrollableVerticalController.addListener(syncScrollableToFixed);

      return () {
        fixedVerticalController.removeListener(syncFixedToScrollable);
        scrollableVerticalController.removeListener(syncScrollableToFixed);
      };
    }, [fixedVerticalController, scrollableVerticalController]);

    void handleHeaderTap(int columnIndex) {
      if (columns[columnIndex].sortValueMapper == null) return;

      if (sortColumnIndex.value == columnIndex) {
        sortAscending.value = !sortAscending.value;
      } else {
        sortColumnIndex.value = columnIndex;
        sortAscending.value = true;
      }
    }

    void handleScrollNotification(ScrollController controller, bool isStart) {
      if (isStart && activeScrollController.value != null) return;
      if (!isStart && activeScrollController.value != controller) return;

      activeScrollController.value = isStart ? controller : null;
    }

    bool shouldConsumeScrollNotification(ScrollController controller) {
      final active = activeScrollController.value;
      return active != null && active != controller;
    }

    Future<void> playScrollHint() async {
      if (!horizontalScrollController.hasClients) return;
      final maxScroll = horizontalScrollController.position.maxScrollExtent;
      if (maxScroll <= 0) return;

      showHand.value = true;
      handAnimationController.reset();
      handAnimationController.forward();

      await horizontalScrollController.animateTo(
        maxScroll,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
      );

      await Future.delayed(const Duration(milliseconds: 500));

      await horizontalScrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeInOut,
      );

      showHand.value = false;
    }

    void checkAndPlayScrollHint(double totalMinWidth, double available) {
      if (hasPlayedAnimation.value) return;

      final routeName = ModalRoute.of(context)?.settings.name;
      if (routeName != null && _playedRouteNames.contains(routeName)) {
        hasPlayedAnimation.value = true;
        return;
      }

      if (totalMinWidth > available) {
        hasPlayedAnimation.value = true;
        if (routeName != null) {
          _playedRouteNames.add(routeName);
        }
        WidgetsBinding.instance.addPostFrameCallback((_) {
          playScrollHint();
        });
      }
    }

    final hasFooter = columns.any((col) => col.footerCellBuilder != null);

    final physics = refreshProvider != null
        ? const AlwaysScrollableScrollPhysics()
        : null;

    final fixedPhysics =
        activeScrollController.value == scrollableVerticalController
        ? _PassiveScrollPhysics(parent: physics)
        : physics;

    final scrollablePhysics =
        activeScrollController.value == fixedVerticalController
        ? _PassiveScrollPhysics(parent: physics)
        : physics;

    Widget table = LayoutBuilder(
      builder: (context, constraints) {
        final double totalMinWidth = columns.fold(
          0.0,
          (sum, col) => sum + col.effectiveMinWidth,
        );
        final double available = constraints.maxWidth;
        final double extraPerColumn = available > totalMinWidth
            ? (available - totalMinWidth) / columns.length
            : 0.0;

        final double firstColWidth = columns.isNotEmpty
            ? columns.first.effectiveMinWidth + extraPerColumn
            : 0.0;

        final double totalContentHeight =
            headerHeight +
            (sortedItems.length * rowHeight) +
            (hasFooter ? footerH : 0.0);
        final bool fitsInAvailableHeight =
            constraints.maxHeight.isFinite &&
            totalContentHeight <= constraints.maxHeight;

        final bool shouldFix = fixFirstColumn && firstColWidth < available;

        Widget mainLayout;
        if (shouldFix) {
          mainLayout = _FixedLayout<T>(
            columns: columns,
            scrollableColumns: scrollableColumns,
            sortedItems: sortedItems,
            extraPerColumn: extraPerColumn,
            headerHeight: headerHeight,
            rowHeight: rowHeight,
            footerHeight: footerH,
            headerBackgroundColor: headerBackgroundColor,
            rowBackgroundColor: rowBackgroundColor,
            footerBackgroundColor: footerBackgroundColor,
            fixedVerticalController: fixedVerticalController,
            scrollableVerticalController: scrollableVerticalController,
            horizontalScrollController: horizontalScrollController,
            sortColumnIndex: sortColumnIndex.value,
            sortAscending: sortAscending.value,
            onHeaderTap: handleHeaderTap,
            onScrollNotification: handleScrollNotification,
            shouldConsumeScrollNotification: shouldConsumeScrollNotification,
            hasFooter: hasFooter,
            fixedPhysics: fixedPhysics,
            scrollablePhysics: scrollablePhysics,
            onTapRow: onTapRow,
            rowColor: getEffectiveRowColor,
            fitsInAvailableHeight: fitsInAvailableHeight,
          );
        } else {
          mainLayout = _ScrollableLayout<T>(
            columns: columns,
            sortedItems: sortedItems,
            totalMinWidth: totalMinWidth,
            extraPerColumn: extraPerColumn,
            headerHeight: headerHeight,
            rowHeight: rowHeight,
            footerHeight: footerH,
            headerBackgroundColor: headerBackgroundColor,
            rowBackgroundColor: rowBackgroundColor,
            footerBackgroundColor: footerBackgroundColor,
            horizontalScrollController: horizontalScrollController,
            sortColumnIndex: sortColumnIndex.value,
            sortAscending: sortAscending.value,
            onHeaderTap: handleHeaderTap,
            hasFooter: hasFooter,
            physics: physics,
            onTapRow: onTapRow,
            rowColor: getEffectiveRowColor,
            fitsInAvailableHeight: fitsInAvailableHeight,
          );
        }

        checkAndPlayScrollHint(totalMinWidth, available);

        return Stack(
          children: [
            mainLayout,
            if (showHand.value)
              _ScrollableHandAnimation(
                animation: handAnimationController,
                handPositionAnimation: handPositionAnimation,
                handOpacityAnimation: handOpacityAnimation,
                available: available,
                headerHeight: headerHeight,
                rowHeight: rowHeight,
              ),
          ],
        );
      },
    );

    final isRefreshing = refreshProvider != null
        ? (ref.watch(refreshProvider!).isLoading || isLoading)
        : isLoading;

    return IgnorePointer(
      ignoring: isRefreshing,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        opacity: isRefreshing ? 0.4 : 1.0,
        child: refreshProvider != null
            ? RefreshIndicator.adaptive(
                onRefresh: () async {
                  ref.invalidate(refreshProvider!);
                  try {
                    await ref.read((refreshProvider! as dynamic).future);
                  } catch (_) {}
                },
                notificationPredicate: (notification) =>
                    notification.depth <= 2,
                backgroundColor: context.theme.colorScheme.surface,
                strokeWidth: 2,
                child: table,
              )
            : table,
      ),
    );
  }
}

class _PassiveScrollPhysics extends ScrollPhysics {
  const _PassiveScrollPhysics({super.parent});

  @override
  _PassiveScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _PassiveScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Prevents automatic bounce-back or deceleration animation on the passive list
    return null;
  }
}

Color _resolveRowBackgroundColor<T>({
  required int index,
  required Color? Function(T item)? rowColor,
  required T item,
  required Color evenRowBg,
  required Color oddRowBg,
}) {
  final baseColor = index.isOdd ? oddRowBg : evenRowBg;
  final customColor = rowColor?.call(item);

  if (customColor != null) {
    return Color.alphaBlend(customColor, baseColor);
  }

  return baseColor;
}
