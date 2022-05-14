// import 'package:assignment/screens/login/login.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smooth_player_app/screen/my_music.dart';

void main() {
  testWidgets("my_music", (WidgetTester tester) async {

    final elevatedButton = find.byType(ElevatedButton);
    


    await tester.pumpWidget(MaterialApp(home: MyMusic()));

    expect(elevatedButton, findsNWidgets(2));
    expect(find.text("Upload Album"), findsOneWidget);
    expect(find.text("Upload Song"), findsOneWidget);
    expect(find.text("sdkfja askldjf"), findsNothing);

  });
}
