import 'package:flutter/material.dart';

import '../widget/navigator.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text("Search Page"),
            ],
          ),
        ),
      ),
      bottomNavigationBar: PageNavigator(pageIndex: 1),
    );
  }
}
