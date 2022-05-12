import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_player_app/api/http/song_http.dart';
import 'package:smooth_player_app/colors.dart';

import '../../api/model/upload_modal.dart';



class UploadSongAlbum extends StatefulWidget {
  final String? albumId;
  const UploadSongAlbum({ Key? key, @required this.albumId }) : super(key: key);

  @override
  State<UploadSongAlbum> createState() => _UploadSongAlbumState();
}

class _UploadSongAlbumState extends State<UploadSongAlbum> {
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
      allowedExtensions: ['mp3', 'mp4',],
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
          title: Text("Upload a Song from Album",style: TextStyle(color: Colors.black),),
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
              key: _songForm,
              child: Column(
                children: [
                  SizedBox(
                    height: screenHight * .010,
                  ),
                  Stack(children: [_image == null
                          ? CircleAvatar(
                      radius: 95,
                      backgroundColor: AppColors.primary,
                      child: InkWell(
                        onTap: () {
                          _pickSongImg();
                        },
                      )):
                    CircleAvatar(
                      radius: 95,
                      backgroundImage: FileImage(_image!),
                      child: InkWell(
                        onTap: () {
                          _pickSongImg();
                        },
                      ),
                    ),
                  ]),
                  SizedBox(
                    height: screenHight * .040,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
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
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      children: [
                        Text("Pick song"),
                        SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                          width: screenWidth * .4,
                          child: Text(
                            _song == null ? "No song selected" : _song!.path.split('/').last,
                            overflow: TextOverflow.fade,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              _pickSong();
                            },
                            child: Text("Pick"))
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
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
                        final res_data =
                            await SongHttp().uploadAlbumSong(SongUploadModal(
                          title: title,
                          cover_image: _image,
                          music_file: _song,
                        ),
                          widget.albumId!,
                        );
                        
                        if (res_data["statusCode"] == 201) {
                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            msg: res_data["body"]["resM"],
                          );
                        } else {
                          Fluttertoast.showToast(
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 3,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            msg: res_data["body"]["resM"],
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
          ),
        )));
  }
   
}