import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _DummyItem {
  final int id;
  final String name;
  final double value;

  const _DummyItem({
    required this.id,
    required this.name,
    required this.value,
  });
}

void main() {
  group('ScrollableTable Scroll Interaction Tests', () {
    late List<ScrollableTableColumnSpec<_DummyItem>> columns;
    late List<_DummyItem> items;

    setUp(() {
      columns = [
        ScrollableTableColumnSpec<_DummyItem>(
          headerTitle: 'ID',
          minWidth: 120,
          cellBuilder: (item) => Text('Item ${item.id}'),
          sortValueMapper: (item) => item.id,
        ),
        ScrollableTableColumnSpec<_DummyItem>(
          headerTitle: 'Nome',
          minWidth: 150,
          cellBuilder: (item) => Text(item.name),
          sortValueMapper: (item) => item.name,
        ),
        ScrollableTableColumnSpec<_DummyItem>(
          headerTitle: 'Valor',
          minWidth: 120,
          cellBuilder: (item) => Text('${item.value}'),
          sortValueMapper: (item) => item.value,
        ),
      ];

      items = List.generate(
        100,
        (i) => _DummyItem(id: i, name: 'Product $i', value: i * 10.5),
      );
    });

    testWidgets(
      'scrolling fixed column synchronizes scrollable columns and vice-versa',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 400,
                width: 300,
                child: ScrollableTable<_DummyItem>(
                  items: items,
                  columns: columns,
                  fixFirstColumn: true,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Initially top items are visible
        expect(find.text('Item 0'), findsOneWidget);
        expect(find.text('Product 0'), findsOneWidget);

        // Drag fixed column up (scroll forward)
        await tester.drag(find.text('Item 0'), const Offset(0, -200));
        await tester.pump();

        // Both columns should have moved in sync
        expect(find.text('Item 0'), findsNothing);
        expect(find.text('Product 0'), findsNothing);

        // Drag scrollable column back down
        final visibleProduct = find.byWidgetPredicate(
          (w) => w is Text && (w.data?.startsWith('Product ') ?? false),
        );
        await tester.drag(visibleProduct.first, const Offset(0, 200));
        await tester.pump();

        // Both columns back at top
        expect(find.text('Item 0'), findsOneWidget);
        expect(find.text('Product 0'), findsOneWidget);
      },
    );

    testWidgets(
      'flinging fixed column to bottom reaches the exact maximum offset on both columns',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 400,
                width: 300,
                child: ScrollableTable<_DummyItem>(
                  items: items,
                  columns: columns,
                  fixFirstColumn: true,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Fling from the fixed column to the very bottom
        await tester.fling(
          find.text('Item 0'),
          const Offset(0, -10000),
          15000,
        );
        await tester.pumpAndSettle();

        // Both columns must reach the bottom (item 99) together with no misalignment
        expect(find.text('Item 99'), findsOneWidget);
        expect(find.text('Product 99'), findsOneWidget);

        final fixedItemPos = tester.getTopLeft(find.text('Item 99'));
        final productItemPos = tester.getTopLeft(find.text('Product 99'));
        expect(fixedItemPos.dy, equals(productItemPos.dy));

        // Now fling from the fixed column back to the very top
        await tester.fling(
          find.text('Item 99'),
          const Offset(0, 10000),
          15000,
        );
        await tester.pumpAndSettle();

        // Both columns must reach the top (item 0) together with no misalignment
        expect(find.text('Item 0'), findsOneWidget);
        expect(find.text('Product 0'), findsOneWidget);

        final topFixedPos = tester.getTopLeft(find.text('Item 0'));
        final topProductPos = tester.getTopLeft(find.text('Product 0'));
        expect(topFixedPos.dy, equals(topProductPos.dy));
      },
    );

    testWidgets(
      'flinging scrollable column to bottom reaches the exact maximum offset on both columns',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 400,
                width: 300,
                child: ScrollableTable<_DummyItem>(
                  items: items,
                  columns: columns,
                  fixFirstColumn: true,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Fling from the scrollable column to the very bottom
        await tester.fling(
          find.text('Product 0'),
          const Offset(0, -10000),
          15000,
        );
        await tester.pumpAndSettle();

        // Both columns must reach the bottom (item 99) together with no misalignment
        expect(find.text('Item 99'), findsOneWidget);
        expect(find.text('Product 99'), findsOneWidget);

        final fixedItemPos = tester.getTopLeft(find.text('Item 99'));
        final productItemPos = tester.getTopLeft(find.text('Product 99'));
        expect(fixedItemPos.dy, equals(productItemPos.dy));

        // Now fling from the scrollable column back to the very top
        await tester.fling(
          find.text('Product 99'),
          const Offset(0, 10000),
          15000,
        );
        await tester.pumpAndSettle();

        // Both columns must reach the top (item 0) together with no misalignment
        expect(find.text('Item 0'), findsOneWidget);
        expect(find.text('Product 0'), findsOneWidget);

        final topFixedPos = tester.getTopLeft(find.text('Item 0'));
        final topProductPos = tester.getTopLeft(find.text('Product 0'));
        expect(topFixedPos.dy, equals(topProductPos.dy));
      },
    );

    testWidgets(
      'flinging to bottom and immediately interacting with the other column takes over without blocking',
      (tester) async {
        _DummyItem? tappedItem;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SizedBox(
                height: 400,
                width: 300,
                child: ScrollableTable<_DummyItem>(
                  items: items,
                  columns: columns,
                  fixFirstColumn: true,
                  onTapRow: (item) {
                    tappedItem = item;
                  },
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Fast fling on the scrollable column to simulate scrolling fast towards bottom
        await tester.fling(
          find.text('Product 0'),
          const Offset(0, -800),
          3000,
        );

        // Advance slightly so it is mid-motion/animating
        await tester.pump(const Duration(milliseconds: 60));

        // Now immediately touch the fixed column while animation was in progress
        final fixedList = find.byType(ListView).first;
        final gesture = await tester.startGesture(tester.getCenter(fixedList));
        await tester.pump();

        // Drag fixed column smoothly
        await gesture.moveBy(const Offset(0, -100));
        await tester.pump();
        await gesture.up();
        await tester.pumpAndSettle();

        // Now tapping a row should work immediately
        final visibleItem = find.byWidgetPredicate(
          (w) => w is Text && (w.data?.startsWith('Item ') ?? false),
        );
        expect(visibleItem, findsWidgets);

        await tester.tap(visibleItem.first);
        await tester.pump();

        expect(tappedItem, isNotNull);
      },
    );
  });
}
