import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/resource/colors.dart';
import 'package:smooth_player_app/screen/my_music.dart';

import '../../api/http/album_http.dart';

class EditAlbum extends StatefulWidget {
  final String? albumId;
  const EditAlbum({Key? key, @required this.albumId}) : super(key: key);

  @override
  State<EditAlbum> createState() => _EditAlbumState();
}

class _EditAlbumState extends State<EditAlbum> {
  final _songForm = GlobalKey<FormState>();

  // final double height = MediaQuery.of(context).size.height

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
            "Edit a Album",
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
            top: screenHight * .1,
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
                  key: ValueKey("albumTitle"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Album title is required";
                    }
                  },
                  onSaved: ((value) {
                    title = value!;
                  }),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.form,
                    hintText: "Enter New Album Title",
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          final resData = await AlbumHttp()
                              .editAlbumTitle(title, widget.albumId!);

                          if (resData["statusCode"] == 200) {
                            Navigator.pop(context);
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
                      child: Text('Edit Album Title'),
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
                          final resData = await AlbumHttp()
                              .editAlbumImage(_image!, widget.albumId!);

                          if (resData["statusCode"] == 200) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (builder) => MyMusic()));
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
                      child: Text('Edit Album Image'),
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
