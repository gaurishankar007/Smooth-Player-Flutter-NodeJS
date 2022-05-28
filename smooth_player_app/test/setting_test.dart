import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/setting.dart';
// import 'package:smooth_player_app/screen/admin/featured_playlist.dart';

void main() {
  testWidgets("SettingPage", (WidgetTester tester) async {
    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: Setting()));

    // Checking outputs
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.key), findsOneWidget);
    expect(find.byIcon(Icons.people), findsOneWidget);
    expect(find.byIcon(Icons.logout_outlined), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });
}
