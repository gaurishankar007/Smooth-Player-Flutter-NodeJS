import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/setting/user_setting.dart';

void main() {
  testWidgets("User Setting", (WidgetTester tester) async {
    // final eleBtn = find.byType(ElevatedButton);
    await tester.pumpWidget(MaterialApp(home: UserSetting()));

    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text("Update Personal Info"), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    // Checking outputs
  });
}
