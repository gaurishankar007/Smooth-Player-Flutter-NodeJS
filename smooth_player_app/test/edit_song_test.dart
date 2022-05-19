import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/upload/edit_song.dart';

void main() {
  testWidgets("Song Form", (WidgetTester tester) async {
    // Finding the required widgets
    final songTitle = find.byKey(ValueKey("songTitle"));

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: EditSong(songId: "627cb473e397402203368334",),),);
    await tester.enterText(songTitle, "Imagine");
    final eleBtn = find.byType(ElevatedButton);  
    await tester.pump();

    // Checking outputs
    expect(eleBtn, findsNWidgets(2));
    expect(find.text("Imagine"), findsOneWidget);
    expect(find.text("Edit Song Title"), findsOneWidget);
    expect(find.byIcon(Icons.upload), findsOneWidget);
    expect(find.text("Asfdsfsf"), findsNothing);
    expect(find.byType(Form), findsOneWidget);
  });
}
