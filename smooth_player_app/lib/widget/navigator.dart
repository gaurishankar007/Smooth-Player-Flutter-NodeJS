import 'package:flutter/material.dart';

import '../screen/library.dart';
import '../screen/search.dart';

class PageNavigator extends StatelessWidget {
  final int? pageIndex;
  const PageNavigator({Key? key, @required this.pageIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.home_filled,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.home_filled,
            color: Color(0XFF5B86E5),
          ),
          label: "",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.search,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.search,
            color: Color(0XFF5B86E5),
          ),
          label: "",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.library_music_rounded,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.library_music_rounded,
            color: Color(0XFF5B86E5),
          ),
          label: "",
        ),
      ],
      height: 40,
      selectedIndex: pageIndex!,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      backgroundColor: Colors.transparent,
      onDestinationSelected: (int index) {
        if (index == 0) {
          Navigator.pushNamed(
            context,
            "/home",
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Search(
                pageIndex: 1,
              ),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => Library(
                pageIndex: 2,
              ),
            ),
          );
        }
      },
    );
  }
}
