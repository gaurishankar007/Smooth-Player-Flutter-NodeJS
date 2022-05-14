import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/upload/upload_song.dart';

void main() {
  testWidgets("Song Form", (WidgetTester tester) async {
    // Finding the required widgets
    final song_title = find.byKey(ValueKey("song_title"));

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: UploadSong()));
    await tester.enterText(song_title, "mero desh");
    final eleBtn = find.byType(ElevatedButton);  
    await tester.pump();

    // Checking outputs
    expect(eleBtn, findsNWidgets(2));
    expect(find.text("mero desh"), findsOneWidget);
    expect(find.text("Upload a Song"), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byType(SizedBox), findsWidgets);
  });
}
