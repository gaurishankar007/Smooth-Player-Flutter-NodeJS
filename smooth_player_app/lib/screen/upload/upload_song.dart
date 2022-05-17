import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/song_http.dart';
import 'package:smooth_player_app/api/model/album_model.dart';
import 'package:smooth_player_app/colors.dart';
import 'package:smooth_player_app/screen/my_music.dart';

class UploadSong extends StatefulWidget {
  const UploadSong({Key? key}) : super(key: key);

  @override
  State<UploadSong> createState() => _UploadSongState();
}

class _UploadSongState extends State<UploadSong> {
  final _songForm = GlobalKey<FormState>();

  // final double height = MediaQuery.of(context).size.height

  File? _song;
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

  void _pickSong() async {
    final song = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: [
        'mp3',
        'mp4',
      ],
      dialogTitle: "Select a song",
    );
    if (song == null) return;
    PlatformFile file = song.files.first;

    setState(() {
      _song = File(file.path.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Upload a Song",
            style: TextStyle(color: Colors.black),
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
                    key: ValueKey("song_title"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Song title is required";
                      }
                    },
                    onSaved: ((value) {
                      title = value!;
                    }),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.form,
                      hintText: "Enter Song Title",
                      enabledBorder: formBorder,
                      focusedBorder: formBorder,
                      errorBorder: formBorder,
                      focusedErrorBorder: formBorder,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text("Pick a song:"),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: screenWidth * .4,
                            child: Text(
                              _song == null
                                  ? "No song selected"
                                  : _song!.path.split('/').last,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(5),
                          minimumSize: Size.zero,
                          primary: AppColors.primary,
                          elevation: 10,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          _pickSong();
                        },
                        child: Icon(
                          Icons.upload,
                        ),
                      )
                    ],
                  ),
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
                    } else if (_song == null) {
                      Fluttertoast.showToast(
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        msg: "Please select a song",
                      );
                    } else if (_songForm.currentState!.validate()) {
                      _songForm.currentState!.save();
                      final resData =
                          await SongHttp().uploadSingleSong(SongUploadModal(
                        title: title,
                        cover_image: _image,
                        music_file: _song,
                      ));

                      if (resData["statusCode"] == 201) {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => MyMusic()));
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
                    // _songForm.currentContext!.save();
                  },
                  child: Text('Upload Song'),
                )
              ],
            ),
          ),
        )));
  }
}
