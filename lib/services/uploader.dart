import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Uploader extends StatefulWidget {
  final PickedFile file;
  final String uid;
  Uploader({Key key, this.file,this.uid}) : super(key: key);

  @override
  _UploaderState createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://booking-app-63e61.appspot.com');
  UploadTask _storageUploadTask;

  void startUpload(){
    print('inside startUpload');
    
    String filePath = 'images/${widget.uid}.png';
    print(filePath);
    setState(() {
      _storageUploadTask = _storage.ref().child(filePath).putFile(File(widget.file.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    if(_storageUploadTask != null){
      print(_storageUploadTask);
    }
    else{
      print('upload failed');
    }
    return RaisedButton(
        child: Text('Upload image'),
        onPressed: startUpload);
  }
}
