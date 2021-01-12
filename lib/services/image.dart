import 'dart:io';

import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:booking_app/services/uploader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImageUpload extends StatefulWidget {
  @override
  _ImageUploadState createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  final AuthService auth = AuthService();
  PickedFile _imageFile;
  bool showCropButton =false;
  Future<void> _pickImage(ImageSource source) async{
    final _picker = ImagePicker();
    PickedFile selected = await _picker.getImage(source: source);
    print(selected.path);
    setState(() {
      _imageFile = selected;
      showCropButton = true;
      print(_imageFile.path);
    });
  }

  Future<void> _cropImage() async{
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path);
    print(cropped.path);
    setState(() {
      _imageFile = PickedFile(cropped.path) ?? _imageFile;
      print(_imageFile.path);
    });
  }

  Future<void> _clear() async{
    setState(() {
      _imageFile = null;
      showCropButton = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              RaisedButton(
                  child: Text('Click an Image'),
                  onPressed: () => _pickImage(ImageSource.camera)),
              RaisedButton(
                  child: Text('Pick an Image from gallery'),
                  onPressed: () => _pickImage(ImageSource.gallery)),
              Visibility(
                visible: showCropButton,
                child: RaisedButton(
                    child: Text('Crop Image'),
                    onPressed: () => _cropImage()),
              ),
              Visibility(
                visible: showCropButton,
                child:  RaisedButton(
                    child: Text('Clear selection'),
                    onPressed: () => _clear()),
              ),
              /*Visibility(
                visible: showCropButton,
                child:  RaisedButton(
                  child: Text('Upload Image'),
                  onPressed: () async{
                      print('here');
                      Uploader(file: _imageFile, uid: user.uid,);
                  }),
              ),*/
              Uploader(file: _imageFile, uid: user.uid,)
            ],
          ),
        ),
      )
    );
  }
}
