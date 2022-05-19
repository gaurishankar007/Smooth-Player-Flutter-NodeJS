import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/admin/featured_playlist.dart';

void main() {
  testWidgets("FeaturedPlaylistPage", (WidgetTester tester) async {

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: FeaturedPlaylistView()));

    // Checking outputs
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
