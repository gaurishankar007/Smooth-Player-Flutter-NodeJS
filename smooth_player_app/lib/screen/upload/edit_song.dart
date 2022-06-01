import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/song_http.dart';
import 'package:smooth_player_app/resource/colors.dart';
import 'package:smooth_player_app/screen/albums.dart';

import '../../resource/player.dart';
import '../../widget/song_bar.dart';

class EditSong extends StatefulWidget {
  final String? songId;
  final String? albumId;
  final String? title;
  final String? albumImage;
  final int? like;
  final int? pageIndex;
  const EditSong({
    Key? key,
    @required this.songId,
    @required this.albumId,
    @required this.title,
    @required this.albumImage,
    @required this.like,
    @required this.pageIndex,
  }) : super(key: key);

  @override
  State<EditSong> createState() => _EditSongState();
}

class _EditSongState extends State<EditSong> {
  final _songForm = GlobalKey<FormState>();

  bool songBarVisibility = Player.isPlaying;

  File? _image;
  String title = "";

  String dropdownValue = '';

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.form,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  void _pickSongImg() async {
    final image = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        dialogTitle: "Select an image");

    if (image == null) return;
    PlatformFile file = image.files.first;
    setState(() {
      _image = File(file.path.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit a Song",
          style: TextStyle(color: AppColors.text),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            top: 30,
            left: screenWidth * .05,
            right: screenWidth * .05,
          ),
          child: Form(
            key: _songForm,
            child: Column(
              children: [
                SizedBox(
                  height: screenHight * .010,
                ),
                _image == null
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: screenHight * .3,
                            width: screenWidth * .75,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [
                                  Color(0XFF36D1DC),
                                  Color(0XFF5B86E5),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black38,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(2, 2),
                                )
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {
                                _pickSongImg();
                              },
                              child: Icon(
                                Icons.upload,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ],
                      )
                    : GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image(
                            height: screenHight * .3,
                            width: screenWidth * .75,
                            fit: BoxFit.cover,
                            image: FileImage(_image!),
                          ),
                        ),
                        onTap: () {
                          _pickSongImg();
                        },
                      ),
                SizedBox(
                  height: screenHight * .040,
                ),
                TextFormField(
                  key: ValueKey("songTitle"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Song title is required";
                    }
                    return null;
                  },
                  onSaved: ((value) {
                    title = value!;
                  }),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.form,
                    hintText: "Enter New Song Title",
                    enabledBorder: formBorder,
                    focusedBorder: formBorder,
                    errorBorder: formBorder,
                    focusedErrorBorder: formBorder,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primary,
                        elevation: 10,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_songForm.currentState!.validate()) {
                          _songForm.currentState!.save();
                          final resData = await SongHttp()
                              .editSongTitle(title, widget.songId!);

                          if (resData["statusCode"] == 200) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => AlbumView(
                                  albumId: widget.albumId,
                                  title: widget.title,
                                  albumImage: widget.albumImage,
                                  like: widget.like,
                                  pageIndex: widget.pageIndex,
                                ),
                              ),
                            );
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              msg: resData["body"]["resM"],
                            );
                          } else {
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              msg: resData["body"]["resM"],
                            );
                          }
                        }
                      },
                      child: Text('Edit Song Title'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppColors.primary,
                        elevation: 10,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        if (_image == null) {
                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            msg: "Please select an image",
                          );
                        } else {
                          final resData = await SongHttp().editSongImage(
                            _image!,
                            widget.songId!,
                          );

                          if (resData["statusCode"] == 200) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (builder) => AlbumView(
                                  albumId: widget.albumId,
                                  title: widget.title,
                                  albumImage: widget.albumImage,
                                  like: widget.like,
                                  pageIndex: widget.pageIndex,
                                ),
                              ),
                            );

                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              msg: resData["body"]["resM"],
                            );
                          } else {
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              msg: resData["body"]["resM"],
                            );
                          }
                        }
                      },
                      child: Text('Edit Song Image'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: songBarVisibility
          ? SongBar(
              songData: Player.playingSong,
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
