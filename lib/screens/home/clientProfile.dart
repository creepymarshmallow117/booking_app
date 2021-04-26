//This is the profiles page.

import 'dart:io';

import 'package:booking_app/Animation/animation.dart';
import 'package:booking_app/Animation/animation1.dart';
import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/authenticate/login.dart';
import 'package:booking_app/screens/home/editClientProfile.dart';
import 'package:booking_app/screens/home/forgotpassword.dart';
import 'package:booking_app/screens/home/profileImage.dart';
import 'package:booking_app/screens/home/updateClientProfile.dart';
import 'package:booking_app/screens/home/updateTurfImage.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'cart.dart';
import 'orders.dart';
import 'home.dart';

import 'package:provider/provider.dart';
import 'package:booking_app/services/database.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ClientProfile extends StatefulWidget {
  final DocumentSnapshot userDocument;
  ClientProfile({this.userDocument});
  @override
  _ClientProfileState createState() => _ClientProfileState();
}

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}

class _ClientProfileState extends State<ClientProfile> {

  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home");
  Icon searchIcon = new Icon(Icons.search);
  int _currentIndex=0;
  String profileImage;
  int index1 = 0;


  Future<void> _pickImage(ImageSource source , String uid, String url, int index) async{
    //function to select image from camera or gallery
    final picker = ImagePicker();
    PickedFile selected = await picker.getImage(source: source);
    print("this is the image path:"+selected.path);
    if(selected != null){
      Navigator.pop(context);
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => UpdateTurfImage(imageFile: selected, uid: uid, index: index, url: url)),
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
              title: Text('Are you sure?',style: TextStyle(fontFamily: "Kollektif")),
              content: Text('You are going to delete your account', style: TextStyle(fontFamily: "Kollektif-Bold")),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO', style: TextStyle(color: Colors.teal, fontFamily: "Kollektif-Bold")),
                  onPressed: () {
                    WidgetsBinding.instance.handlePopRoute();
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('YES', style: TextStyle(color: Colors.teal, fontFamily: "Kollektif-Bold")),
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
    String name = widget.userDocument.data()['groundName'];
    String description = widget.userDocument.data()["description"];
    String contactInfo = widget.userDocument.data()["contactInfo"];
    String address = widget.userDocument.data()["address"];
    String morningPrice = widget.userDocument.data()["morningPrice"];
    String eveningPrice = widget.userDocument.data()["eveningPrice"];
    String email = user.email;
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;
    profileImage = 'gs://booking-app-63e61.appspot.com/profileImages/${user.uid}.png';
    imageCache.clear();
    imageCache.clearLiveImages();

    List groundImages = widget.userDocument['groundImages'];

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
              child: Container(
                color: Colors.white,
                child: Column(
                    children: <Widget>[
                      GestureDetector(
                        child: GFCarousel(
                          autoPlay: true,
                          height: 210,
                          items: groundImages.map(
                                (url) {
                              return Container(
                                margin: EdgeInsets.all(3.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    width: 1000.0,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onPageChanged: (index) {
                            setState(() {
                              index;
                              index1 = index;
                            });
                          },
                        ),
                      ),
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
                                                left: 25.0, right: 25.0, top: 20.0),
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
                                                    ),
                                                  ],
                                                ),
                                                new Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: <Widget>[
                                                    new GestureDetector(
                                                      child: new CircleAvatar(
                                                        backgroundColor: Colors.teal,
                                                        radius: 14.0,
                                                        child: new Icon(
                                                          Icons.edit,
                                                          color: Colors.white,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => updatedClientProfile(userDocument: widget.userDocument,))
                                                          );
                                                        },
                                                      ),
                                                  ],
                                                )
                                              ],
                                            )),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                left: 25.0, right: 25.0, top: 20.0),
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
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
                                                      hintStyle: TextStyle(color: Colors.black, fontFamily: 'Kollektif-Bold',),
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
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
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
                                                      hintStyle: TextStyle(color: Colors.black, fontFamily: 'Kollektif-Bold',),
                                                    ),
                                                    enabled: !_status,
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
                                                      'Contact Number',
                                                      style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
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
                                                      hintText: contactInfo,
                                                      hintStyle: TextStyle(color: Colors.black, fontFamily: 'Kollektif-Bold',),
                                                    ),
                                                    enabled: !_status,
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
                                                      'Description',
                                                      style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
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
                                                    minLines: 1,
                                                    maxLines : 10,
                                                    decoration: new InputDecoration(
                                                      hintText: description,
                                                      hintStyle: TextStyle(color: Colors.black, fontFamily: 'Kollektif-Bold',),
                                                    ),
                                                    enabled: !_status,
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
                                                      'Address',
                                                      style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
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
                                                  child: new TextField(
                                                    minLines: 1,
                                                    maxLines : 7,
                                                    decoration: new InputDecoration(
                                                      hintText: address,
                                                      hintStyle: TextStyle(color: Colors.black, fontFamily: 'Kollektif-Bold',),
                                                    ),
                                                    enabled: !_status,
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
                                                      'Morning Price',
                                                      style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
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
                                                      hintText: morningPrice,
                                                      hintStyle: TextStyle(color: Colors.black, fontFamily: 'Kollektif-Bold',),
                                                    ),
                                                    enabled: !_status,
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
                                                      'Evening Price',
                                                      style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
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
                                                      hintText: eveningPrice,
                                                      hintStyle: TextStyle(color: Colors.black, fontFamily: 'Kollektif-Bold',),
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
                                                      fontFamily: 'Kollektif',
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
                              ),
                            ],
                          )
                      ),
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

