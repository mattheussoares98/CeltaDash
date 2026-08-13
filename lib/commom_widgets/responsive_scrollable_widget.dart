import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:celta_dash/utils/constants/constants.dart';
import 'package:flutter/material.dart';

/// Scrollable widget that shows a responsive card with a given child widget.
/// Useful for displaying forms and other widgets that need to be scrollable.
class ResponsiveScrollableWidget extends StatelessWidget {
  final bool? centralize;
  final double? maxContentWidth;
  final bool? isSliverPage;
  const ResponsiveScrollableWidget({
    super.key,
    required this.child,
    this.centralize,
    this.maxContentWidth = Breakpoint.desktop,
    this.isSliverPage = false,
  });
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.sizeOf(context);
    return isSliverPage == true
        ? SizedBox(
            height: centralize == true ? mediaSize.height : null,
            width: centralize == true ? mediaSize.width : null,
            child: ResponsiveCenter(
              maxContentWidth: maxContentWidth!,
              child: child,
            ),
          )
        : SingleChildScrollView(
            child: SizedBox(
              height: centralize == true ? mediaSize.height : null,
              width: centralize == true ? mediaSize.width : null,
              child: ResponsiveCenter(
                maxContentWidth: maxContentWidth!,
                child: child,
              ),
            ),
          );
  }
}
