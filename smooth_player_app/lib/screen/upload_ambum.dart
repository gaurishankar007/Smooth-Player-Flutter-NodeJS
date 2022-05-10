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

  // final double height = MediaQuery.of(context).size.height

  File? _song;
  File? _image;
  String title = "";
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
    return Scaffold(
        appBar: AppBar(
          title: Text("Upload Song"),
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
                      // height: 15,
                      ),
                  Stack(children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundImage: _image == null
                          ? AssetImage("images/noimages.png") as ImageProvider
                          : FileImage(_image!),
                      child: InkWell(
                        onTap: () {
                          _pickSongImg();
                        },
                      ),
                    )
                  ]),
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
                          labelText: "Enter Song Title",
                          hintText: "BATASH, Saami Saami,...",
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
                          return "Album name is required";
                        }
                      },
                        onSaved: ((value) {
                          title = value!;
                        }),
                        decoration: InputDecoration(
                          labelText: "Enter Album Name",
                          hintText: "Weekend, Romantic,...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
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
                          width: MediaQuery.of(context).size.width * .4,
                          child: Text(
                            _song == null ? "No song selected" : _song!.path,
                            
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
                    onPressed: () {
                      _songForm.currentState!.validate();
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
