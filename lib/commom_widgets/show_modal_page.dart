import 'package:celta_dash/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showModalPage(Widget body, BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows the modal to be full-screen
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (context) {
      return Stack(
        children: [
          Positioned.fill(child: GestureDetector(onTap: context.pop)),
          DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.95,
            minChildSize: 0.5,
            maxChildSize: 0.95,
            builder: (_, controller) {
              return SafeArea(child: _Body(body: body));
            },
          ),
        ],
      );
    },
  );
}

class _Body extends StatelessWidget {
  final Widget body;
  const _Body({required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          //dragglable indicator
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: Sizes.p12),
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Scaffold(backgroundColor: Colors.transparent, body: body),
          ),
          // const SizedBox(height: Sizes.p12),
        ],
      ),
    );
  }
}
