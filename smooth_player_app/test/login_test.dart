import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/authentication/login.dart';

void main() {
  testWidgets("login form", (WidgetTester tester) async {
    // Finding the required widgets
    final emailTxt = find.byKey(ValueKey("username_email"));
    final pwTxt = find.byKey(ValueKey("password"));

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: Login()));
    await tester.enterText(emailTxt, "nishan");
    await tester.enterText(pwTxt, "12345678");
    await tester.pump();

    // Checking outputs
    expect(find.text("nishan"), findsOneWidget);
    expect(find.text("12345678"), findsOneWidget);
    expect(find.text("Username or Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
    expect(find.byType(ElevatedButton), findsNWidgets(2));
  });
}
