import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/setting/password_setting.dart';

void main() {
  testWidgets("PassworSetting", (WidgetTester tester) async {
    // final eleBtn = find.byType(ElevatedButton);
    await tester.pumpWidget(MaterialApp(home: PasswordSetting()));

    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);

    // Checking outputs
  });
}
