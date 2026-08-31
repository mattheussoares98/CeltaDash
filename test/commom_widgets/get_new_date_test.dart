// test/commom_widgets/get_new_date_test.dart
import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('GetNewDate', () {
    testWidgets('returns initial date when confirmed without scrolling in Cupertino mode', (
      tester,
    ) async {
      final now = DateTime(2026, 8, 28);
      final minimumDate = DateTime(2021, 8, 29);
      final maximumDate = DateTime(2026, 8, 28);
      DateTime? pickedDate;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: Builder(
                builder: (innerContext) => ElevatedButton(
                  onPressed: () async {
                    pickedDate = await GetNewDate.get(
                      context: innerContext,
                      insertHoursAndMinutes: false,
                      currentSelectedDate: now,
                      minimumDate: minimumDate,
                      maximumDate: maximumDate,
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoDatePicker), findsOneWidget);

      // Tap OK without scrolling
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(pickedDate, equals(now));
    });

    testWidgets('clamps initial date to minimumDate when selected date is in the past', (
      tester,
    ) async {
      final selectedDate = DateTime(2020);
      final minimumDate = DateTime(2021, 8, 29);
      final maximumDate = DateTime(2026, 8, 28);
      DateTime? pickedDate;

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: Builder(
                builder: (innerContext) => ElevatedButton(
                  onPressed: () async {
                    pickedDate = await GetNewDate.get(
                      context: innerContext,
                      insertHoursAndMinutes: false,
                      currentSelectedDate: selectedDate,
                      minimumDate: minimumDate,
                      maximumDate: maximumDate,
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(pickedDate, equals(minimumDate));
    });
  });
}
