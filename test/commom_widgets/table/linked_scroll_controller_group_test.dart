import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LinkedScrollControllerGroup Tests', () {
    testWidgets('synchronizes offsets across attached scroll controllers', (
      tester,
    ) async {
      final group = LinkedScrollControllerGroup();
      final controller1 = group.addAndGet();
      final controller2 = group.addAndGet();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: ListView.builder(
                    controller: controller1,
                    itemCount: 100,
                    itemExtent: 50,
                    itemBuilder: (_, i) => Text('Left $i'),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ListView.builder(
                    controller: controller2,
                    itemCount: 100,
                    itemExtent: 50,
                    itemBuilder: (_, i) => Text('Right $i'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      expect(controller1.offset, 0.0);
      expect(controller2.offset, 0.0);

      // Drag left list down (scroll forward)
      await tester.drag(find.text('Left 0'), const Offset(0, -200));
      await tester.pump();

      expect(controller1.offset, 200.0);
      expect(controller2.offset, 200.0);

      // Drag right list up (scroll back)
      await tester.drag(find.text('Right 4'), const Offset(0, 100));
      await tester.pump();

      expect(controller1.offset, 100.0);
      expect(controller2.offset, 100.0);

      controller1.dispose();
      controller2.dispose();
    });

    testWidgets('jumpTo updates all attached controllers', (tester) async {
      final group = LinkedScrollControllerGroup();
      final controller1 = group.addAndGet();
      final controller2 = group.addAndGet();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Row(
              children: [
                SizedBox(
                  width: 100,
                  child: ListView.builder(
                    controller: controller1,
                    itemCount: 100,
                    itemExtent: 50,
                    itemBuilder: (_, i) => Text('Left $i'),
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: ListView.builder(
                    controller: controller2,
                    itemCount: 100,
                    itemExtent: 50,
                    itemBuilder: (_, i) => Text('Right $i'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      group.jumpTo(300.0);
      await tester.pump();

      expect(controller1.offset, 300.0);
      expect(controller2.offset, 300.0);
      expect(group.offset, 300.0);

      group.resetScroll();
      await tester.pump();

      expect(controller1.offset, 0.0);
      expect(controller2.offset, 0.0);

      controller1.dispose();
      controller2.dispose();
    });

    testWidgets(
      'touching one controller immediately halts ballistic animation on the other without delay',
      (tester) async {
        final group = LinkedScrollControllerGroup();
        final controller1 = group.addAndGet();
        final controller2 = group.addAndGet();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  SizedBox(
                    width: 100,
                    child: ListView.builder(
                      controller: controller1,
                      itemCount: 100,
                      itemExtent: 50,
                      itemBuilder: (_, i) => Text('Left $i'),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: ListView.builder(
                      controller: controller2,
                      itemCount: 100,
                      itemExtent: 50,
                      itemBuilder: (_, i) => Text('Right $i'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Fling left list rapidly
        await tester.fling(
          find.text('Left 0'),
          const Offset(0, -500),
          2000,
        );
        // Advance slightly mid-animation
        await tester.pump(const Duration(milliseconds: 50));
        final offsetMidFling = controller1.offset;
        expect(offsetMidFling, greaterThan(0));
        expect(controller2.offset, equals(offsetMidFling));

        // Touch the right list during the fling animation - should immediately halt and take control
        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(ListView).last),
        );
        await tester.pump();

        // Move the right list manually
        await gesture.moveBy(const Offset(0, -50));
        await tester.pump();

        expect(controller2.offset, closeTo(offsetMidFling + 50, 1.0));
        expect(controller1.offset, closeTo(controller2.offset, 1.0));

        await gesture.up();
        await tester.pumpAndSettle();

        controller1.dispose();
        controller2.dispose();
      },
    );
  });
}
