import 'package:flutter/material.dart';
import 'package:smooth_player_app/screen/admin/artist_verification.dart';
import 'package:smooth_player_app/screen/admin/featured_playlist.dart';
import 'package:smooth_player_app/screen/admin/reports.dart';

class AdminPageNavigator extends StatelessWidget {
  final int? pageIndex;
  const AdminPageNavigator({Key? key, @required this.pageIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(
            Icons.playlist_add_rounded,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.playlist_add_rounded,
            color: Color(0XFF5B86E5),
          ),
          label: "",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.manage_accounts_rounded,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.manage_accounts_rounded,
            color: Color(0XFF5B86E5),
          ),
          label: "",
        ),
        NavigationDestination(
          icon: Icon(
            Icons.report,
            color: Colors.black,
          ),
          selectedIcon: Icon(
            Icons.report,
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => FeaturedPlaylistView(),
            ),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => VerifyArtist(),
            ),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (builder) => ReportedSongs(),
            ),
          );
        }
      },
    );
  }
}
