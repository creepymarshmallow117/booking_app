//This is the profiles page.

import 'dart:async';
import 'dart:io';

import 'package:booking_app/Animation/animation.dart';
import 'package:booking_app/Animation/animation1.dart';
import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/authenticate/login.dart';
import 'package:booking_app/screens/home/forgotpassword.dart';
import 'package:booking_app/screens/home/profileImage.dart';
import 'package:booking_app/screens/home/updateprofile.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'cart.dart';
import 'file:///D:/College/Project/App/lib/screens/home/orders.dart';
import 'file:///D:/College/Project/App/lib/screens/home/home.dart';

import 'package:provider/provider.dart';
import 'package:booking_app/services/database.dart';

class Profile extends StatefulWidget {
  final DocumentSnapshot userDocument;
  Profile({this.userDocument});
  @override
  _ProfileState createState() => _ProfileState();
}

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}

class _ProfileState extends State<Profile> {

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home");
  Icon searchIcon = new Icon(Icons.search);
  int _currentIndex=0;
  String profileImage;


  Future<void> _pickImage(ImageSource source , String uid) async{
    //function to select image from camera or gallery
    final picker = ImagePicker();
    PickedFile selected = await picker.getImage(source: source);
    if(selected != null){
      Navigator.pop(context);
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfileImage(imageFile: selected, uid: uid)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    imageCache.clearLiveImages();
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();
    final user = Provider.of<User>(context);
    if (user == null) {
      setState(() => _isVisible = false);
    } else {
      setState(() {
        _isVisible = true;
      });
    }
    Future<bool> _onDeletePressed() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure?'),
              content: Text('You are going to delete your account'),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO', style: TextStyle(color: Colors.teal)),
                  onPressed: () {
                    WidgetsBinding.instance.handlePopRoute();
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('YES', style: TextStyle(color: Colors.teal)),
                  onPressed: () {
                    user.delete();
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                ),
              ],
            );
          });
    }


    print("this is document id:" + widget.userDocument.data()['displayName']);
    String name = widget.userDocument.data()['displayName'];
    String email = user.email;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;
    profileImage = 'gs://booking-app-63e61.appspot.com/profileImages/${user.uid}.png';
    imageCache.clear();
    imageCache.clearLiveImages();



    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: height1,
            color: Colors.white,
            child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: new Text('SETTINGS',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: 'sans-serif-light',
                                          color: Colors.teal)),
                                )
                              ],
                          ),
                          ),
                          SizedBox(height: 15.0),
                          profileImage == null ? new Stack(
                            children: <Widget>[
                              new Center(
                                child: new CircleAvatar(
                                  radius: 80.0,
                                  backgroundColor: const Color(0xFF778899),
                                ),
                              ),
                              new Center(
                                child: new Image.asset("assets/photo_camera.png"),
                              ),
                            ],
                          ) :  CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 75.0,
                            backgroundImage: FirebaseImage(profileImage,
                                maxSizeBytes: 5000 * 1000,
                                shouldCache: true,
                              cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE,
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: MaterialButton(
                                color: Colors.teal,
                                minWidth: 10.0,
                                shape: CircleBorder(
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                                onPressed: (){
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
                                              onTap: () => _pickImage(ImageSource.camera, user.uid),
                                              child: roundedButton(
                                                  "CAMERA",
                                                  EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                                  const Color(0xFF167F67),
                                                  const Color(0xFFFFFFFF)),
                                            ),
                                            SizedBox(height: 10.0),
                                            new GestureDetector(
                                              onTap: () =>  _pickImage(ImageSource.gallery, user.uid),
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
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                          color: Color(0xffFFFFFF),
                            child: Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 25.0, right: 25.0, top: 25.0),
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: <Widget>[
                                        new Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                          new Text(
                                            'Personal Information',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                              )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Name',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: TextFormField(
                                      decoration: new InputDecoration(
                                        hintText: name,
                                        hintStyle: TextStyle(color: Colors.black),
                                      ),
                                      enabled: !_status,
                                      autofocus: !_status,
                                    ),
                                  ),
                                ],
                              )),
                                Padding(
                                padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Text(
                                        'Email ID',
                                        style: TextStyle(
                                            fontSize: 17.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 2.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Flexible(
                                    child: new TextFormField(
                                      decoration: new InputDecoration(
                                          hintText: email,
                                      hintStyle: TextStyle(color: Colors.black),
                                         ),
                                      enabled: !_status,
                                    ),
                                  ),
                                ],
                              )),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
                                  child: Container(
                                    height: 40.0,
                                    width: 300.0,
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20.0),
                                      shadowColor: Colors.tealAccent,
                                      color: Colors.teal,
                                      elevation: 5.0,
                                      child: GestureDetector(
                                        onTap: () async{
                                          Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => forgotpassword()),
                                          );
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(vertical: 12.0),
                                          child : Text('RESET PASSWORD', textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat',
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
                                child: Container(
                                height: 40.0,
                                width: 300.0,
                                  child: Material(
                                  borderRadius: BorderRadius.circular(20.0),
                                  shadowColor: Colors.tealAccent,
                                  color: Colors.teal,
                                  elevation: 5.0,
                                    child: GestureDetector(
                                    onTap: () async{
                                      _onDeletePressed();
                                      },
                                        child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 12.0),
                                        child : Text('DELETE ACCOUNT', textAlign: TextAlign.center,
                                        style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                ),
                          ),
                        ),
                              ),
                        ],
                      ),
                    )
                  )

                  ],
                )
            ),
          ]
          ),
        ),
      )
      )
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
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
      );
    return Btn;
  }
}

/*
AlertDialog(
                                      elevation: 10,
                                      title: Text('Are you sure?'),
                                      content: Text('You are going to change your display picture.'),
                                      actions: <Widget>[
                                        FlatButton(
                                          child: Text('Click Image', style: TextStyle(color: Colors.teal)),
                                            onPressed: () async {
                                              _pickImage(ImageSource.camera, user.uid);
                                            }
                                        ),
                                        FlatButton(
                                          child: Text('Import from gallery', style: TextStyle(color: Colors.teal)),
                                            onPressed: () async {
                                              _pickImage(ImageSource.gallery, user.uid);
                                            }
                                        ),
                                      ],
                                    );
 */
