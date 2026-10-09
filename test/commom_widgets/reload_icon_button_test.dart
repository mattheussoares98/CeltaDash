import 'dart:async';

import 'package:celta_dash/commom_widgets/scaffold/reload_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('buttons and refresh do not initialize unused providers', (
    tester,
  ) async {
    var builds = 0;
    var refreshes = 0;
    final provider = FutureProvider<int>((ref) async => ++builds);
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Row(
            children: [
              ReloadIconButton(
                refreshProviders: [provider],
                onRefresh: () => refreshes++,
              ),
              ReloadIconButton(refreshProviders: [provider]),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(IconButton).first);
    await tester.pumpAndSettle();
    expect(builds, 0);
    expect(refreshes, 1);
  });

  testWidgets('observes and refreshes an already initialized provider', (
    tester,
  ) async {
    var builds = 0;
    final response = Completer<int>();
    final provider = FutureProvider<int>((ref) {
      builds++;
      return response.future;
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.read(provider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          home: ReloadIconButton(refreshProviders: [provider]),
        ),
      ),
    );
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNull,
    );
    response.complete(1);
    await tester.pumpAndSettle();
    expect(
      tester.widget<IconButton>(find.byType(IconButton)).onPressed,
      isNotNull,
    );
    await tester.tap(find.byType(IconButton));
    await tester.pumpAndSettle();
    expect(builds, 2);
  });
}
