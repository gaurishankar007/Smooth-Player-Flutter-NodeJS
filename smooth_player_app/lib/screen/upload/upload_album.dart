import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/album_http.dart';
import 'package:smooth_player_app/api/model/album_model.dart';
import 'package:smooth_player_app/colors.dart';
import 'package:smooth_player_app/screen/home.dart';
import 'package:smooth_player_app/screen/my_music.dart';

class UploadAlbum extends StatefulWidget {
  const UploadAlbum({Key? key}) : super(key: key);

  @override
  State<UploadAlbum> createState() => _UploadAlbumState();
}

class _UploadAlbumState extends State<UploadAlbum> {
  final _albumForm = GlobalKey<FormState>();

  File? _image;
  String albumTitle = "";

  OutlineInputBorder formBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.form,
      width: 2,
      style: BorderStyle.solid,
    ),
  );

  void _pickAlbumImg() async {
    final image = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
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
            "Upload an Album",
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
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Form(
              key: _albumForm,
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
                                  _pickAlbumImg();
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
                            _pickAlbumImg();
                          },
                        ),
                  SizedBox(
                    height: screenHight * .040,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      key: ValueKey("album_title"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Album name is required";
                          }
                        },
                        onSaved: ((value) {
                          albumTitle = value!;
                        }),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.form,
                          hintText: "Enter Album Name",
                          enabledBorder: formBorder,
                          focusedBorder: formBorder,
                          errorBorder: formBorder,
                          focusedErrorBorder: formBorder,
                        )),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ElevatedButton(
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
                        } else if (_albumForm.currentState!.validate()) {
                          _albumForm.currentState!.save();
                          final res_data = await AlbumHttp().createAlbum(
                            AlbumUploadModal(
                              title: albumTitle,
                              cover_image: _image,
                            ),
                          );

                          if (res_data["statusCode"] == 201) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyMusic()));
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              msg: res_data["body"]["resM"],
                            );
                          } else {
                            // print(res_data);
                            Fluttertoast.showToast(
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 3,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              msg: res_data["body"]["resM"],
                            );
                          }
                        } else {
                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            msg: "Please fill the required form",
                          );
                        }
                      },
                      child: Text('Upload Album'),
                    ),
                  )
                ],
              ),
            ),
          ),
        )));
  }
}
