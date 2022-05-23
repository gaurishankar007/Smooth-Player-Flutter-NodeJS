import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/user_http.dart';
import 'package:smooth_player_app/api/model/user_model.dart';
import 'package:smooth_player_app/api/urls.dart';
import 'package:smooth_player_app/resource/player.dart';
import 'package:smooth_player_app/screen/setting/password_setting.dart';
import 'package:smooth_player_app/screen/setting/user_setting.dart';

import '../api/log_status.dart';
import '../resource/colors.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final profileUrl = ApiUrls.profileUrl;
  late Future<User> getUser;
  bool accountPublication = false,
      followedArtistPublication = false,
      likedSongPublication = false,
      likedAlbumPublication = false,
      likedFeaturedPlaylistPublication = false,
      createdPlaylistPublication = false;

  void _pickProfileImg() async {
    final image = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        dialogTitle: "Select an image");
    if (image == null) return;
    PlatformFile file = image.files.first;

    await UserHttp().ChangeProfilePicture(File(file.path.toString()));
    setState(() {
      getUser = UserHttp().getUser();
    });
    Fluttertoast.showToast(
      msg: "Your profile picture updated.",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  @override
  void initState() {
    super.initState();
    getUser = UserHttp().getUser();
  }

  @override
  Widget build(BuildContext context) {
    final sWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          right: sWidth * .05,
          bottom: 25,
          left: sWidth * .05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 5,
            ),
            FutureBuilder<User>(
                future: getUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundImage: NetworkImage(
                                  profileUrl + snapshot.data!.profile_picture!),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _pickProfileImg();
                              },
                              child: Icon(
                                Icons.edit,
                                color: AppColors.text,
                                size: 25,
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(4),
                                minimumSize: Size.zero,
                                primary: Colors.white,
                                elevation: 10,
                                shadowColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          snapshot.data!.profile_name!,
                          style: TextStyle(
                            color: AppColors.text,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "${snapshot.error}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      color: AppColors.primary,
                    ),
                  );
                }),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserSetting(),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Update your personal information."),
                    ],
                  ),
                ),
                Icon(
                  Icons.people,
                  color: AppColors.primary,
                ),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => PasswordSetting(),
                  ),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Change your password."),
                    ],
                  ),
                  Icon(
                    Icons.key,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Account Pulication",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Publish Profile Information",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 25,
                    child: Switch(
                      activeColor: AppColors.primary,
                      value: accountPublication,
                      onChanged: (value) {
                        setState(() {
                          accountPublication = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Followed Artist Pulication",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Publish artists that you have followed",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 25,
                    child: Switch(
                      activeColor: AppColors.primary,
                      value: followedArtistPublication,
                      onChanged: (value) {
                        setState(() {
                          followedArtistPublication = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Liked Song Pulication",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Publish songs that you have liked",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 25,
                    child: Switch(
                      activeColor: AppColors.primary,
                      value: likedSongPublication,
                      onChanged: (value) {
                        setState(() {
                          likedSongPublication = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Liked Album Publication",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Publish albums that you have liked",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 25,
                    child: Switch(
                      activeColor: AppColors.primary,
                      value: likedAlbumPublication,
                      onChanged: (value) {
                        setState(() {
                          likedAlbumPublication = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Featured Playlist Publication",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Publish featured playlists that you have liked",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 25,
                    child: Switch(
                      activeColor: AppColors.primary,
                      value: likedFeaturedPlaylistPublication,
                      onChanged: (value) {
                        setState(() {
                          likedFeaturedPlaylistPublication = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Created Playlist Publication",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Publish playlists that you have created",
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 25,
                    child: Switch(
                      activeColor: AppColors.primary,
                      value: createdPlaylistPublication,
                      onChanged: (value) {
                        setState(() {
                          createdPlaylistPublication = value;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GestureDetector(
              onTap: () {
                LogStatus().removeToken();
                LogStatus.token = "";
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "login",
                  (route) => false,
                );
                Player().stopSong();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Log out",
                        style: TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "You are currently logged in",
                      ),
                    ],
                  ),
                  Icon(
                    Icons.logout_outlined,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
