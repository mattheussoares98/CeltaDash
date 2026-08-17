import 'package:celta_dash/commom_widgets/scaffold/device_orientation_stub.dart'
    if (dart.library.io) 'package:celta_dash/commom_widgets/scaffold/device_orientation_mobile.dart';
import 'package:celta_dash/core/presentation/controllers/controllers.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';

import '../commom_widgets.dart';

class BaseScaffold extends StatelessWidget {
  const BaseScaffold({
    super.key,
    this.showAnnotatedRegion = false,
    this.onPopInvokedWithResult,
    this.resizeToAvoidBottomInset = false,
    this.appBar,
    this.refreshProviders,
    this.onRefresh,
    this.isScrollable = true,
    this.scrollPhysics,
    this.padding,
    this.usePadding = true,
    required this.body,
    this.bottomNavigationBar,
    this.observeScreenChanges = false,
    this.drawer,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.safeAreaTop,
  });

  final bool showAnnotatedRegion;
  final void Function()? onPopInvokedWithResult;
  final bool? resizeToAvoidBottomInset;
  final Widget? appBar;
  final List<ProviderBase<AsyncValue<dynamic>>>? refreshProviders;
  final VoidCallback? onRefresh;
  final bool isScrollable;
  final ScrollPhysics? scrollPhysics;
  final EdgeInsets? padding;
  final bool usePadding;
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool observeScreenChanges;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;

  /// When null (default), the top safe area is applied automatically:
  /// enabled when there is no [appBar], disabled when one is present.
  /// Set to [false] explicitly when this scaffold is rendered inside a
  /// parent scaffold that already handles the status-bar inset.
  final bool? safeAreaTop;

  @override
  Widget build(BuildContext context) {
    if (observeScreenChanges) {
      return Consumer(
        builder: (context, ref, child) {
          ref.watch(screenObserverProvider);
          return buildOrientationReader(
            builder: (context) => _BaseScaffold(this),
          );
        },
      );
    }

    return buildOrientationReader(builder: (context) => _BaseScaffold(this));
  }
}

class _BaseScaffold extends ConsumerWidget {
  const _BaseScaffold(this.params);
  final BaseScaffold params;

  EdgeInsets _getHorizontalPadding() => EdgeInsets.symmetric(
    horizontal: ScreenUtil.I.getResponsiveValue(
      base: 24,
      screens: {
        {ScreenType.largeTablet}: 22.widthPart(),
        {ScreenType.desktop}: kIsWeb ? 32.5.widthPart() : 27.widthPart(),
      },
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget newChild = params.body;

    Widget? finalAppBar = params.appBar;
    final hasRefreshParams =
        params.refreshProviders != null || params.onRefresh != null;

    if (hasRefreshParams && (PlatformUtil.isWeb || PlatformUtil.isDesktop)) {
      if (finalAppBar is BaseAppBar) {
        final refreshAction = ReloadIconButton(
          refreshProviders: params.refreshProviders,
          onRefresh: params.onRefresh,
        );
        finalAppBar = finalAppBar.copyWith(
          actions: [
            ...?finalAppBar.actions,
            refreshAction,
          ].map((e) => FittedBox(child: e)).toList(),
        );
      }
    }

    final effectivePadding = params.usePadding
        ? params.padding ??
              (params.observeScreenChanges
                  ? _getHorizontalPadding()
                  : ScreenUtil.I.pagePadding().copyWith(
                      bottom: params.bottomNavigationBar == null ? null : 0,
                    ))
        : EdgeInsets.zero;

    if (params.isScrollable) {
      newChild = SingleChildScrollView(
        padding: effectivePadding,
        physics: params.scrollPhysics,
        child: params.body,
      );
    } else {
      newChild = Padding(padding: effectivePadding, child: params.body);
    }

    if (hasRefreshParams) {
      newChild = Consumer(
        builder: (context, ref, child) {
          return RefreshIndicator.adaptive(
            onRefresh: () async {
              params.onRefresh?.call();
              if (params.refreshProviders?.isNotEmpty ?? false) {
                for (final provider in params.refreshProviders!) {
                  ref.invalidate(provider);
                }
              }
            },
            backgroundColor: context.theme.colorScheme.surface,
            strokeWidth: 2,
            child: child!,
          );
        },
        child: newChild,
      );
    }

    PreferredSizeWidget? appBarWidget;
    if (finalAppBar != null) {
      if (finalAppBar is PreferredSizeWidget) {
        if (context.isCupertino) {
          appBarWidget = PreferredSize(
            preferredSize: Size.fromHeight(
              finalAppBar.preferredSize.height +
                  MediaQuery.paddingOf(context).top,
            ),
            child: finalAppBar,
          );
        } else {
          appBarWidget = finalAppBar;
        }
      } else {
        appBarWidget = PreferredSize(
          preferredSize: const Size(double.maxFinite, 50),
          child: finalAppBar,
        );
      }
    }

    Widget? bottomNavigationWidget = params.bottomNavigationBar;

    Widget scaffold;

    if (context.isCupertino && params.drawer == null) {
      var cupertinoBody = bottomNavigationWidget != null
          ? Consumer(
              builder: (_, ref, _) {
                final keyboardIsOpened = ref.watch(
                  keyboardVisibilityStateControllerProvider,
                );
                const cupertinoTabBarHeight = 49.0;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        (keyboardIsOpened ? 0 : cupertinoTabBarHeight) +
                        (params.bottomNavigationBar == null ? Sizes.p8 : 0),
                  ),
                  child: newChild,
                );
              },
            )
          : newChild;

      final orientation = NativeDeviceOrientationReaderWrapper.orientation(
        context,
      );
      final isRotatedLeft =
          orientation == NativeDeviceOrientation.landscapeLeft;
      final isRotatedRight =
          orientation == NativeDeviceOrientation.landscapeRight;

      cupertinoBody = SafeArea(
        top: params.safeAreaTop ?? finalAppBar == null,
        bottom: bottomNavigationWidget != null,
        left: isRotatedLeft,
        right: isRotatedRight,
        child: cupertinoBody,
      );

      if (finalAppBar != null) {
        cupertinoBody = Column(
          children: [
            finalAppBar,
            Expanded(child: cupertinoBody),
          ],
        );
      }

      scaffold = CupertinoPageScaffold(
        resizeToAvoidBottomInset: params.resizeToAvoidBottomInset ?? true,
        child: cupertinoBody,
      );

      if (bottomNavigationWidget != null) {
        scaffold = Stack(
          children: [
            scaffold,
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SafeArea(top: false, child: bottomNavigationWidget),
            ),
          ],
        );
      }

      if (params.floatingActionButton != null) {
        scaffold = Stack(
          children: [
            scaffold,
            Positioned(
              right: 16.0,
              bottom: bottomNavigationWidget != null
                  ? 49.0 + 16.0 + MediaQuery.paddingOf(context).bottom
                  : 16.0 + MediaQuery.paddingOf(context).bottom,
              child: params.floatingActionButton!,
            ),
          ],
        );
      }

      scaffold = Material(color: Colors.transparent, child: scaffold);

      // Wrap in a transparent Material Scaffold so that ScaffoldMessenger
      // can find an anchor to render SnackBars on iOS (CupertinoPageScaffold
      // has no Material Scaffold, so ShowToast is otherwise silently ignored).
      scaffold = Scaffold(
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: scaffold,
      );
    } else {
      scaffold = Scaffold(
        resizeToAvoidBottomInset: params.resizeToAvoidBottomInset,
        appBar: appBarWidget,
        body: SafeArea(child: newChild),
        bottomNavigationBar: bottomNavigationWidget,
        drawer: params.drawer,
        floatingActionButton: params.floatingActionButton,
        floatingActionButtonLocation: params.floatingActionButtonLocation,
      );
    }

    if (params.onPopInvokedWithResult != null) {
      scaffold = PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          params.onPopInvokedWithResult?.call();
        },
        child: scaffold,
      );
    }

    if (params.showAnnotatedRegion) {
      return AnnotatedRegion<SystemUiOverlayStyle>(
        value: context.systemOverlayStyle,
        child: scaffold,
      );
    }

    return scaffold;
  }
}
