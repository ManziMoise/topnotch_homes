import 'package:flutter_test/flutter_test.dart';

import 'package:topnotch_homes/app.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TopnotchHomesApp());
    expect(find.text('Topnotch Homes'), findsOneWidget);
    expect(find.text('Find your perfect stay in Rwanda'), findsOneWidget);
  });
}
