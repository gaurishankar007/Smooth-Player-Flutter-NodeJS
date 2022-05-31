import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/upload/edit_album.dart';

void main() {
  testWidgets("Album Form", (WidgetTester tester) async {
    // Finding the required widgets
    final albumTitle = find.byKey(ValueKey("albumTitle"));

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: EditAlbum(albumId: "627b5f293ccd72f5aaa5e500",),),);
    await tester.enterText(albumTitle, "New Album");
    final eleBtn = find.byType(ElevatedButton);  
    await tester.pump();

    // Checking outputs
    expect(eleBtn, findsNWidgets(2));
    expect(find.text("New Album"), findsOneWidget);
    expect(find.text("Edit Album Title"), findsOneWidget);
    expect(find.byIcon(Icons.upload), findsOneWidget);
    expect(find.byIcon(Icons.downhill_skiing), findsNothing);
    expect(find.byType(Form), findsOneWidget);
  });
}
