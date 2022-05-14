import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/my_music.dart';

void main() {
  testWidgets("my_music", (WidgetTester tester) async {
    // Finding the required widgets
    final elevatedButton = find.byType(ElevatedButton);  

    // Executing the actual test
    await tester.pumpWidget(MaterialApp(home: MyMusic()));
    // Checking outputs

    expect(elevatedButton, findsNWidgets(2));
    expect(find.text("Upload Album"), findsOneWidget);
    expect(find.text("Upload Song"), findsOneWidget);
    expect(find.text("sdkfja askldjf"), findsNothing);
    expect(find.byType(Padding),findsWidgets);
    expect(find.byType(GestureDetector),findsWidgets);
    
    

  });
}
