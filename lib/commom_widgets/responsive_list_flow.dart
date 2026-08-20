import 'dart:math';

import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ResponsiveListFlow extends StatelessWidget {
  const ResponsiveListFlow({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.maxItemWidth = 380,
    this.isSliver = false,
    this.padding,
    this.physics,
    this.useMultiColumnWhenMobile = false,
    this.useMasonryLayout = true,
    this.scrollController,
  }) : assert(
         !isSliver || !useMasonryLayout,
         'SliverMasonryGrid has a known scroll-jumping bug when used inside '
         'a CustomScrollView with other slivers. Use useMasonryLayout: false '
         'when isSliver is true. See: '
         'https://github.com/letsar/flutter_staggered_grid_view/issues/308',
       );

  final int itemCount;
  final Widget Function(BuildContext context, int index) itemBuilder;
  final double? maxItemWidth;
  final bool isSliver;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final bool useMultiColumnWhenMobile;
  final bool useMasonryLayout;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context) {
    final effectivePadding =
        padding ?? const EdgeInsets.only(bottom: Sizes.p48);

    if (PlatformUtil.isMobile && !useMultiColumnWhenMobile) {
      if (isSliver) {
        return SliverPadding(
          padding: effectivePadding,
          sliver: SliverList.builder(
            itemBuilder: itemBuilder,
            itemCount: itemCount,
          ),
        );
      }
      return ListView.builder(
        controller: scrollController,
        physics: physics,
        padding: effectivePadding,
        itemBuilder: itemBuilder,
        itemCount: itemCount,
      );
    }

    // const maxWidthSize = Breakpoint.desktop;
    final screenWidth = MediaQuery.sizeOf(context).width;
    // final width = min(maxWidthSize, screenWidth);
    final effectiveItemWidth = maxItemWidth ?? 380.0;
    final itemsPerRow = max((screenWidth / effectiveItemWidth).floor(), 1);

    if (isSliver) {
      // Always uses SliverAlignedGrid — SliverMasonryGrid is blocked by the
      // constructor assert (known scroll-jumping bug).
      final grid = SliverAlignedGrid.count(
        crossAxisCount: itemsPerRow,
        mainAxisSpacing: Sizes.p8,
        crossAxisSpacing: Sizes.p8,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );

      return SliverPadding(padding: effectivePadding, sliver: grid);
    }

    if (useMasonryLayout) {
      return MasonryGridView.count(
        controller: scrollController,
        physics: physics,
        padding: effectivePadding is EdgeInsets ? effectivePadding : null,
        crossAxisCount: itemsPerRow,
        mainAxisSpacing: Sizes.p8,
        crossAxisSpacing: Sizes.p8,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }

    return AlignedGridView.count(
      controller: scrollController,
      physics: physics,
      padding: effectivePadding is EdgeInsets ? effectivePadding : null,
      crossAxisCount: itemsPerRow,
      mainAxisSpacing: Sizes.p8,
      crossAxisSpacing: Sizes.p8,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
