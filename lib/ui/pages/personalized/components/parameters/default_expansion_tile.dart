import 'package:flutter/material.dart';

class DefaultExpansionTile extends StatefulWidget {
  final Widget title;
  final List<Widget> children;
  final ExpansibleController controller;

  const DefaultExpansionTile({
    super.key,
    required this.title,
    required this.children,
    required this.controller,
  });

  @override
  State<DefaultExpansionTile> createState() => _DefaultExpansionTileState();
}

class _DefaultExpansionTileState extends State<DefaultExpansionTile> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFFE8F5E9);
    const Color inactiveColor = Colors.white;
    final Color primaryColor = Theme.of(context).primaryColor;

    final Color cardBackgroundColor =
        widget.controller.isExpanded ? activeColor : inactiveColor;

    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        controller: widget.controller,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: cardBackgroundColor,
        collapsedBackgroundColor: cardBackgroundColor,
        tilePadding:
            const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        childrenPadding: const EdgeInsets.all(0),
        iconColor: primaryColor,
        collapsedIconColor: primaryColor,
        title: widget.title,
        children: widget.children,
      ),
    );
  }
}
