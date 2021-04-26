import 'dart:io';

import 'package:booking_app/Animation/animation1.dart';
import 'package:booking_app/screens/home/home1.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
class UpdateTurfImage extends StatefulWidget {
  final String url;
  final int index;
  final PickedFile imageFile;
  final String uid;
  const UpdateTurfImage({Key key, this.url, this.index, this.imageFile, this.uid}) : super(key: key);

  @override
  _UpdateTurfImageState createState() => _UpdateTurfImageState();
}

class _UpdateTurfImageState extends State<UpdateTurfImage> {
  final FirebaseStorage _storage = FirebaseStorage.instanceFor(bucket: 'gs://booking-app-63e61.appspot.com');
  UploadTask _storageUploadTask;


  PickedFile _imageFile;
  bool showPickImage = false;
  bool _clicked = true;
  Future<void> _pickImage(ImageSource source, uid) async{ //Function to pick image from camera or gallery
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
      sourcePath: _imageFile == null ? widget.imageFile.path : _imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ]
          : [
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio5x3,
        CropAspectRatioPreset.ratio5x4,
        CropAspectRatioPreset.ratio7x5,
        CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          activeControlsWidgetColor: Colors.teal,
          toolbarWidgetColor: Colors.teal,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false
      ),
    );
    print(cropped.path);
    setState(() {
      _imageFile = PickedFile(cropped.path) ?? _imageFile;
      print(_imageFile.path);
    });
  }

  Future<bool> _clearImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?', style: TextStyle(
                fontFamily: "Kallektif"
            ),),
            content: Text('You are going to clear this image', style: TextStyle(
              fontFamily: 'Kollektif-Bold',
            ),),
            actions: <Widget>[
              FlatButton(
                child: Text('NO', style: TextStyle(color: Colors.teal,fontFamily: 'Kollektif-Bold',)),
                onPressed: () {
                  WidgetsBinding.instance.handlePopRoute();
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES', style: TextStyle(color: Colors.teal, fontFamily: 'Kollektif-Bold',)),
                onPressed: () {
                  WidgetsBinding.instance.handlePopRoute();
                  Navigator.of(context).pop(false);
                  showDialog(context: context, builder: (context){
                    return FadeAnimation1(
                      0.1, Container(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
                        child : Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            new GestureDetector(
                              onTap: () => _pickImage(ImageSource.camera, widget.uid),
                              child: roundedButton(
                                  "CAMERA",
                                  EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                  const Color(0xFF167F67),
                                  const Color(0xFFFFFFFF)),
                            ),
                            SizedBox(height: 10.0),
                            new GestureDetector(
                              onTap: () =>  _pickImage(ImageSource.gallery, widget.uid),
                              child: roundedButton(
                                  "GALLERY",
                                  EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                  const Color(0xFF167F67),
                                  const Color(0xFFFFFFFF)),
                            ),
                            SizedBox(height: 25.0),
                            new GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: new Padding(
                                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                                child: roundedButton(
                                    "CANCEL",
                                    EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                    const Color(0xFF167F67),
                                    const Color(0xFFFFFFFF)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    );
                  },
                  );
                },
              ),
            ],
          );
        });
  }


  void startUpload(){//Function to upload image to firebase storage
    print('inside startUpload');

    String filePath = 'groundImages/${widget.uid}${widget.index}.png';
    print(filePath);
    print(widget.uid);
    print(widget.index);
    setState(() {
      _storageUploadTask = _storage.ref().child(filePath).putFile(File(_imageFile == null ? widget.imageFile.path : _imageFile.path));
    });
  }


  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();
    final user = Provider.of<User>(context);

    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    if(_storageUploadTask != null){
      _storageUploadTask.whenComplete(() async{
        CollectionReference col = FirebaseFirestore.instance.collection("client");
        DocumentSnapshot doc = await col.doc(user.uid).get();
        _storageUploadTask.snapshot.ref.getDownloadURL().then((value) {
          List groundImages = doc.data()['groundImages'];
          groundImages.removeAt(widget.index);
          groundImages.add(value);
          for(int i = 0; i < groundImages.length; i++){
            print("item no. $i :"+groundImages.elementAt(i).toString());
          }
          col.doc(user.uid).update(
            {
              'groundImages': FieldValue.arrayRemove(
                [doc.data()['groundImages'][widget.index]]
              )
            }
          ).then((value){
            col.doc(user.uid).update(
                {
                  'groundImages': FieldValue.arrayUnion(groundImages),
                }
            ).then((value){
              Fluttertoast.showToast(
                  msg: "Image Added Successfully"
              );
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    Home1()),
              );
            });
          });
        });

      });
    }

    print("index url of old image:"+widget.index.toString());
    print("image url of old image:"+widget.url);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Text('SETTINGS',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Kollektif',
                  color: Colors.teal)),
        ),
        leading: Padding(padding: EdgeInsets.only(left: 10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                child: new Icon(
                  Icons.arrow_back_ios,
                  color: Colors.teal,
                  size: 22.0,
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child : Column(
            children : [
              SizedBox(height: 15.0),
                        Visibility(
                          visible: !showPickImage,
                          child: Image.file(
                            File(_imageFile == null ? widget.imageFile.path: _imageFile.path),
                            height: 400,
                            width: 400,
                          ),
                        ),
                        Row(
                          children: [
                            Visibility(
                              visible: !showPickImage,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0, left: 30.0, right: 50.0),
                                child: Container(
                                  height: 40.0,
                                  width: 150.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.tealAccent,
                                    color: Colors.teal,
                                    elevation: 5.0,
                                    child: GestureDetector(
                                      onTap: () async{
                                        _cropImage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 12.0),
                                        child : Text('CROP IMAGE', textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Kollektif',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: !showPickImage,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30.0),
                                child: Container(
                                  height: 40.0,
                                  width: 150.0,
                                  child: Material(
                                    borderRadius: BorderRadius.circular(20.0),
                                    shadowColor: Colors.tealAccent,
                                    color: Colors.teal,
                                    elevation: 5.0,
                                    child: GestureDetector(
                                      onTap: () async{
                                        _clearImage();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 12.0),
                                        child : Text('CLEAR IMAGE', textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Kollektif',
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: !showPickImage,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 30.0),
                            child: Container(
                              height: 40.0,
                              width: 200.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.tealAccent,
                                color: Colors.teal,
                                elevation: 5.0,
                                child: GestureDetector(
                                  onTap: () async{
                                    if (_clicked == true) {
                                      setState(() {
                                        _clicked = false;
                                      });
                                      startUpload();

                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 12.0),
                                    child : Text('UPLOAD IMAGE', textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Kollektif',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
            ),
    );
  }

  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var Btn = new Container(
      height: 45.0,
      width: 300.0,
      child: Material(
        borderRadius: BorderRadius.circular(100.0),
        shadowColor: Colors.grey,
        color: Colors.teal,
        elevation: 5.0,
        child: Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child : Text(buttonLabel, textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kollektif',
            ),
          ),
        ),
      ),
    );
    return Btn;
  }
}
