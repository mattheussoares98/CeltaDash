import 'package:celta_dash/features/home/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('logout option asks for confirmation', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MorePage()));

    await tester.tap(find.byKey(const ValueKey('logout_button')));
    await tester.pumpAndSettle();

    expect(find.text('Do you really want to logout?'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Logout'), findsWidgets);
  });
}
