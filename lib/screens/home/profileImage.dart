import 'dart:io';

import 'package:booking_app/screens/home/profile.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileImage extends StatefulWidget {
  final PickedFile imageFile;
  final String uid;
  ProfileImage({Key key, this.imageFile, this.uid}) : super(key: key);

  @override
  _ProfileImageState createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://booking-app-63e61.appspot.com');
  UploadTask _storageUploadTask;

  PickedFile _imageFile;
  bool showPickImage = false;
  Future<void> _pickImage(ImageSource source) async{ //Function to pick image from camera or gallery
    final picker = ImagePicker();
    PickedFile selected = await picker.getImage(source: source);
    if(selected != null){
      setState(() {
        _imageFile = selected;
        showPickImage = false;
      });
    }
  }

  Future<void> _cropImage() async{//Function to crop image
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path);
    print(cropped.path);
    setState(() {
      _imageFile = PickedFile(cropped.path) ?? _imageFile;
      print(_imageFile.path);
    });
  }

  void _clearImage() async{//Function to clear image selection
    setState(() {
      _imageFile = null;
      showPickImage = true;
    });
  }

  void startUpload(){//Function to upload image to firebase storage
    print('inside startUpload');

    String filePath = 'profileImages/${widget.uid}.png';
    print(filePath);
    setState(() {
      _storageUploadTask = _storage.ref().child(filePath).putFile(File(_imageFile.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();
    final user = Provider.of<User>(context);
    if(_imageFile == null) {
      setState(() {
        _imageFile = widget.imageFile;
      });
    }

    if(_storageUploadTask != null){
      _storageUploadTask.whenComplete(() async{
        if(user != null) {
          print("inside here");
          dynamic result =  await db.getDocument(user.uid.toString());
          if (result == null) {
            print("this is a problem");
          }
          else {
            print(result);
            Navigator.pop(context);
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => Profile(userDocument: result)),
            );
          }
        }
        else{
          print("this is a big problem");
        }
      });
    }
    return Scaffold(
      appBar: AppBar(),
      body:
      Center(
          child: Column(
           children: [
              Visibility(
                visible: !showPickImage,
                child: Image.file(
                  File(_imageFile.path),
                  height: 400,
                  width: 400,
                ),
              ),
              Row(
                 children: [
                   Visibility(
                     visible: !showPickImage,
                     child: RaisedButton(
                         child: Text('Crop Image'),
                         onPressed: () {
                           _cropImage();
                         }),
                   ),
                   Visibility(
                     visible: !showPickImage,
                     child: RaisedButton(
                         child: Text('Clear image'),
                         onPressed: () {
                           _clearImage();
                         }),
                   ),
                 ],
               ),
              Row(
                 children:[
                   Visibility(
                     visible: showPickImage,
                     child: RaisedButton(
                       child: Text('Click an image'),
                       onPressed: (){
                         _pickImage(ImageSource.camera);
                       },
                     ),
                   ),
                   Visibility(
                     visible: showPickImage,
                     child: RaisedButton(
                       child: Text('Import from gallery'),
                       onPressed: (){
                         _pickImage(ImageSource.gallery);
                       },
                     ),
                   )
                   ]
               ),
             RaisedButton(
               child: Text('Upload Image'),
               onPressed: (){
                startUpload();
             },),
           ],
         )
       ), 
      );
  }
}
