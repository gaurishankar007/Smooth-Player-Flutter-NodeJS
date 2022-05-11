import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import "package:form_field_validator/form_field_validator.dart";

class UploadAlbum extends StatefulWidget {
  const UploadAlbum({Key? key}) : super(key: key);

  @override
  State<UploadAlbum> createState() => _UploadAlbumState();
}

class _UploadAlbumState extends State<UploadAlbum> {
  final _songForm = GlobalKey<FormState>();


  File? _song;
  File? _image;
  String albumTitle = "";
  String album = "";
  String image_path = "";

  void _pickSongImg() async {
    final image = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.image,
        dialogTitle: "Select an image");

    if (image == null) return;
    setState(() {
      _image = null;
    });
    PlatformFile file = image.files.first;
    print("image file path ${file.path}");
    image_path = file.path.toString();
    _image = File(file.path.toString());
  }

  void _pickSong() async {
    final song = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
      dialogTitle: "Select a song",
    );
    if (song == null) return;
    setState(() {
      _song = null;
    
    });
    _song = File(song.files.first.name.toString());
  }


  @override
  Widget build(BuildContext context) {
  double screenHight = MediaQuery.of(context).size.height ;
  double screenWidth = MediaQuery.of(context).size.width ;
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload an Album"),
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
                      height:screenHight*.05,
                      ),
                  Stack(children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _image == null
                          ? AssetImage("assets/images/noimage.png") as ImageProvider
                          : FileImage(_image!),
                      child: InkWell(
                        onTap: () {
                          _pickSongImg();
                        },
                      ),
                    )
                  ]),
                  SizedBox(
                    height: screenHight*.02,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Album name is required";
                        }  
                      },
                        onSaved: ((value) {
                          albumTitle = value!;
                        }),
                        decoration: InputDecoration(
                          labelText: "Album Name",
                          hintText: "24/7, Best of 2021,...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "User Name";
                        }
                      },
                        onSaved: ((value) {
                          albumTitle = value!;
                        }),
                        decoration: InputDecoration(
                          labelText: "User Name/ID",
                          hintText: "12121223, Sony,...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        )),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: ElevatedButton(
                      
                      style: ElevatedButton.styleFrom(minimumSize: Size.fromHeight(45),),
                      onPressed: () {
                        _songForm.currentState!.validate();
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
