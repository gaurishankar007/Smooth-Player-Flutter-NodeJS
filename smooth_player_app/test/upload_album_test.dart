import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/upload/upload_album.dart';

void main() {
  testWidgets("Album Form", (WidgetTester tester) async {
    // Finding the required widgets
    final albumTitle = find.byKey(ValueKey("album_title"));

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: UploadAlbum()));
    await tester.enterText(albumTitle, "Boy");
    await tester.pump();

    // Checking outputs
    expect(find.text("Boy"), findsOneWidget);
    expect(find.text("Upload an Album"), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.upload), findsOneWidget);
    expect(find.byType(SizedBox), findsWidgets);
  });
}
