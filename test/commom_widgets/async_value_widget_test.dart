// ignore_for_file: invalid_use_of_internal_member

import 'package:celta_dash/commom_widgets/commom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpValue(
    WidgetTester tester,
    AsyncValue<String> value, {
    required bool preserveValue,
  }) => tester.pumpWidget(
    MaterialApp(
      home: AsyncValueWidget(
        value: value,
        preserveValue: preserveValue,
        tryAgain: null,
        data: Text.new,
      ),
    ),
  );

  testWidgets('shows the previous value while refreshing when enabled', (
    tester,
  ) async {
    final value = const AsyncLoading<String>().copyWithPrevious(
      const AsyncData('cached payments'),
    );

    await pumpValue(tester, value, preserveValue: true);

    expect(find.text('cached payments'), findsOneWidget);
    expect(find.byType(LoadingWidget), findsNothing);
  });

  testWidgets('shows loading without a previous value', (tester) async {
    await pumpValue(tester, const AsyncLoading<String>(), preserveValue: true);

    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets('keeps the original loading behavior when disabled', (
    tester,
  ) async {
    final value = const AsyncLoading<String>().copyWithPrevious(
      const AsyncData('cached payments'),
    );

    await pumpValue(tester, value, preserveValue: false);

    expect(find.text('cached payments'), findsNothing);
    expect(find.byType(LoadingWidget), findsOneWidget);
  });

  testWidgets(
    'shows error when error occurs even if previous value exists and preserveValue is true',
    (tester) async {
      final value = AsyncError<String>(
        Exception('Network error'),
        StackTrace.empty,
      ).copyWithPrevious(const AsyncData('cached payments'));

      await pumpValue(tester, value, preserveValue: true);

      expect(find.text('cached payments'), findsNothing);
      expect(find.text('Network error'), findsOneWidget);
    },
  );
}
