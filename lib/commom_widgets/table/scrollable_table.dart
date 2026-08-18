import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

part 'fixed_layout.dart';
part 'scrollable_hand_animation.dart';
part 'scrollable_header_cell_wrapper.dart';
part 'scrollable_layout.dart';
part 'scrollable_row.dart';
part 'scrollable_table_cell.dart';
part 'scrollable_table_column_spec.dart';
part 'scrollable_table_header.dart';

final Set<String> _playedRouteNames = {};

class ScrollableTable<T> extends StatefulWidget {
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
  });

  @override
  State<ScrollableTable<T>> createState() => _ScrollableTableState<T>();
}

class _ScrollableTableState<T> extends State<ScrollableTable<T>>
    with SingleTickerProviderStateMixin {
  final _fixedVerticalController = ScrollController();
  final _scrollableVerticalController = ScrollController();
  final _horizontalScrollController = ScrollController();

  late final AnimationController _handAnimationController;
  late final Animation<double> _handPositionAnimation;
  late final Animation<double> _handOpacityAnimation;
  bool _showHand = false;
  bool _hasPlayedAnimation = false;

  bool _isSyncing = false;
  ScrollController? _activeScrollController;

  int? _sortColumnIndex;
  bool _sortAscending = true;

  late List<T> _sortedItems;

  late List<ScrollableTableColumnSpec<T>> _scrollableColumns;

  bool get _hasFooter =>
      widget.columns.any((col) => col.footerCellBuilder != null);

  static const double footerH = 40;

  @override
  void initState() {
    super.initState();

    _fixedVerticalController.addListener(_syncFixedToScrollable);
    _scrollableVerticalController.addListener(_syncScrollableToFixed);

    _rebuildCache();

    _handAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );

    _handOpacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 80),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 10),
    ]).animate(_handAnimationController);

    _handPositionAnimation = TweenSequence<double>([
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
    ]).animate(_handAnimationController);
  }

  @override
  void didUpdateWidget(covariant ScrollableTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    final itemsChanged = !identical(widget.items, oldWidget.items);
    final columnsChanged = !identical(widget.columns, oldWidget.columns);

    if (itemsChanged || columnsChanged) {
      _rebuildCache();
    }
  }

  void _rebuildCache() {
    _scrollableColumns = widget.fixFirstColumn && widget.columns.isNotEmpty
        ? widget.columns.sublist(1)
        : widget.columns;

    _applySort();
  }

  void _applySort() {
    final items = List<T>.of(widget.items);

    if (_sortColumnIndex != null) {
      final mapper = widget.columns[_sortColumnIndex!].sortValueMapper;
      if (mapper != null) {
        items.sort((a, b) {
          final cmp = Comparable.compare(mapper(a), mapper(b));
          return _sortAscending ? cmp : -cmp;
        });
      }
    }

    _sortedItems = items;
  }

  void _handleScrollNotification(ScrollController controller, bool isStart) {
    if (!mounted) return;
    if (isStart && _activeScrollController != null) return;
    if (!isStart && _activeScrollController != controller) return;

    setState(() {
      if (isStart) {
        _activeScrollController = controller;
      } else {
        _activeScrollController = null;
      }
    });
  }

  bool _shouldConsumeScrollNotification(ScrollController controller) {
    final activeController = _activeScrollController;
    return activeController != null && activeController != controller;
  }

  void _syncFixedToScrollable() {
    if (_isSyncing) return;
    if (!_scrollableVerticalController.hasClients) return;
    if (_activeScrollController != null &&
        _activeScrollController != _fixedVerticalController) {
      return;
    }

    final offset = _fixedVerticalController.offset;
    if (_scrollableVerticalController.offset == offset) return;

    _isSyncing = true;
    _scrollableVerticalController.jumpTo(offset);
    _isSyncing = false;
  }

  void _syncScrollableToFixed() {
    if (_isSyncing) return;
    if (!_fixedVerticalController.hasClients) return;
    if (_activeScrollController != null &&
        _activeScrollController != _scrollableVerticalController) {
      return;
    }

    final offset = _scrollableVerticalController.offset;
    if (_fixedVerticalController.offset == offset) return;

    _isSyncing = true;
    _fixedVerticalController.jumpTo(offset);
    _isSyncing = false;
  }

  @override
  void dispose() {
    _fixedVerticalController.removeListener(_syncFixedToScrollable);
    _scrollableVerticalController.removeListener(_syncScrollableToFixed);
    _fixedVerticalController.dispose();
    _scrollableVerticalController.dispose();
    _horizontalScrollController.dispose();
    _handAnimationController.dispose();
    super.dispose();
  }

  void _handleHeaderTap(int columnIndex) {
    if (widget.columns[columnIndex].sortValueMapper == null) return;

    setState(() {
      if (_sortColumnIndex == columnIndex) {
        _sortAscending = !_sortAscending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAscending = true;
      }
      _applySort();
    });
  }

  void _checkAndPlayScrollHint(double totalMinWidth, double available) {
    if (_hasPlayedAnimation) return;

    final routeName = ModalRoute.of(context)?.settings.name;
    if (routeName != null && _playedRouteNames.contains(routeName)) {
      _hasPlayedAnimation = true;
      return;
    }

    if (totalMinWidth > available) {
      _hasPlayedAnimation = true;
      if (routeName != null) {
        _playedRouteNames.add(routeName);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _playScrollHint();
      });
    }
  }

  Future<void> _playScrollHint() async {
    if (!mounted || !_horizontalScrollController.hasClients) return;
    final maxScroll = _horizontalScrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    setState(() {
      _showHand = true;
    });

    _handAnimationController.reset();
    _handAnimationController.forward();

    await _horizontalScrollController.animateTo(
      maxScroll,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
    );

    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    await _horizontalScrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOut,
    );

    if (!mounted) return;
    setState(() {
      _showHand = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.columns.isEmpty) return const SizedBox.shrink();

    final physics = widget.refreshProvider != null
        ? const AlwaysScrollableScrollPhysics()
        : null;

    final fixedPhysics =
        _activeScrollController == _scrollableVerticalController
        ? _PassiveScrollPhysics(parent: physics)
        : physics;

    final scrollablePhysics =
        _activeScrollController == _fixedVerticalController
        ? _PassiveScrollPhysics(parent: physics)
        : physics;

    Widget table = LayoutBuilder(
      builder: (context, constraints) {
        final double totalMinWidth = widget.columns.fold(
          0.0,
          (sum, col) => sum + col.minWidth,
        );
        final double available = constraints.maxWidth;
        final double extraPerColumn = available > totalMinWidth
            ? (available - totalMinWidth) / widget.columns.length
            : 0.0;

        final double firstColWidth = widget.columns.isNotEmpty
            ? widget.columns.first.minWidth + extraPerColumn
            : 0.0;

        final bool shouldFix =
            widget.fixFirstColumn && firstColWidth < available;

        Widget mainLayout;
        if (shouldFix) {
          mainLayout = _FixedLayout<T>(
            columns: widget.columns,
            scrollableColumns: _scrollableColumns,
            sortedItems: _sortedItems,
            extraPerColumn: extraPerColumn,
            headerHeight: widget.headerHeight,
            rowHeight: widget.rowHeight,
            footerHeight: footerH,
            headerBackgroundColor: widget.headerBackgroundColor,
            rowBackgroundColor: widget.rowBackgroundColor,
            footerBackgroundColor: widget.footerBackgroundColor,
            fixedVerticalController: _fixedVerticalController,
            scrollableVerticalController: _scrollableVerticalController,
            horizontalScrollController: _horizontalScrollController,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            onHeaderTap: _handleHeaderTap,
            onScrollNotification: _handleScrollNotification,
            shouldConsumeScrollNotification: _shouldConsumeScrollNotification,
            hasFooter: _hasFooter,
            fixedPhysics: fixedPhysics,
            scrollablePhysics: scrollablePhysics,
            onTapRow: widget.onTapRow,
            rowColor: widget.rowColor,
          );
        } else {
          mainLayout = _ScrollableLayout<T>(
            columns: widget.columns,
            sortedItems: _sortedItems,
            totalMinWidth: totalMinWidth,
            extraPerColumn: extraPerColumn,
            headerHeight: widget.headerHeight,
            rowHeight: widget.rowHeight,
            footerHeight: footerH,
            headerBackgroundColor: widget.headerBackgroundColor,
            rowBackgroundColor: widget.rowBackgroundColor,
            footerBackgroundColor: widget.footerBackgroundColor,
            horizontalScrollController: _horizontalScrollController,
            sortColumnIndex: _sortColumnIndex,
            sortAscending: _sortAscending,
            onHeaderTap: _handleHeaderTap,
            hasFooter: _hasFooter,
            physics: physics,
            onTapRow: widget.onTapRow,
            rowColor: widget.rowColor,
          );
        }

        _checkAndPlayScrollHint(totalMinWidth, available);

        return Stack(
          children: [
            mainLayout,
            if (_showHand)
              _ScrollableHandAnimation(
                animation: _handAnimationController,
                handPositionAnimation: _handPositionAnimation,
                handOpacityAnimation: _handOpacityAnimation,
                available: available,
                headerHeight: widget.headerHeight,
                rowHeight: widget.rowHeight,
              ),
          ],
        );
      },
    );

    if (widget.refreshProvider != null) {
      table = Consumer(
        builder: (context, ref, child) {
          final asyncState = ref.watch(widget.refreshProvider!);
          final isLoading = asyncState.isLoading || widget.isLoading;
          return IgnorePointer(
            ignoring: isLoading,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              opacity: isLoading ? 0.4 : 1.0,
              child: RefreshIndicator.adaptive(
                onRefresh: () async {
                  ref.invalidate(widget.refreshProvider!);
                  try {
                    await ref.read((widget.refreshProvider! as dynamic).future);
                  } catch (_) {}
                },
                notificationPredicate: (notification) {
                  return notification.depth <= 2;
                },
                backgroundColor: context.theme.colorScheme.surface,
                strokeWidth: 2,
                child: child!,
              ),
            ),
          );
        },
        child: table,
      );
    } else {
      table = IgnorePointer(
        ignoring: widget.isLoading,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          opacity: widget.isLoading ? 0.4 : 1.0,
          child: table,
        ),
      );
    }

    return table;
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

Color _getRowBackgroundColor<T>({
  required BuildContext context,
  required int index,
  required Color? Function(T item)? rowColor,
  required T item,
  required Color? rowBackgroundColor,
}) {
  final isOdd = index.isOdd;
  final customColor = rowColor?.call(item);
  if (customColor != null) {
    return isOdd ? customColor.withAlpha(255) : customColor.withAlpha(200);
  }
  return isOdd
      ? (rowBackgroundColor ?? context.theme.cardColor)
      : context.theme.scaffoldBackgroundColor;
}
