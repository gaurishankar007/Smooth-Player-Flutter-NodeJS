import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/setting/password_setting.dart';

void main() {
  testWidgets("PasswordSetting", (WidgetTester tester) async {
    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: PasswordSetting()));

    // Checking outputs
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);  });
}
