//This is the profiles page.

import 'dart:io';

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/home/profileImage.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
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

class _ProfileState extends State<Profile> {
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home");
  Icon searchIcon = new Icon(Icons.search);
  int _currentIndex=0;

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
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();
    final user = Provider.of<User>(context);
    if(user == null){
      setState(() => _isVisible = false);
    }else{
      setState(() => _isVisible = true);
    }
    print("this is document id:"+widget.userDocument.data()['displayName']);
    return Scaffold (
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Profile"),
        ),
        drawer : Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.teal,
                ),
                child: Text('Welcome User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.teal),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              Visibility(
                visible: _isVisible,
                child: ListTile(
                  leading: Icon(Icons.message, color: Colors.teal),
                  title: Text('Your Orders'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push( context,
                      MaterialPageRoute(builder: (context) => Orders()),
                    );
                  },
                ),
              ),
              Visibility(
                visible: _isVisible,
                child: ListTile(
                  leading: Icon(Icons.account_circle, color: Colors.teal),
                  title: Text('Profile'),
                  onTap: () async{
                    if(user != null) {
                      print("Inside here");
                      dynamic result =  await db.getDocument(user.uid.toString());
                      if (result == null) {
                        print("This is a problem");
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
                      print("This is a big problem");
                    }
                  },
                ),
              ),
              Visibility(
                visible: _isVisible,
                child: ListTile(
                  leading: Icon(Icons.logout, color: Colors.teal),
                  title: Text('Log Out'),
                  onTap: () {
                    Navigator.pop(context);
                    auth.signOut();
                  },
                ),
              ),
              Visibility(
                visible: !_isVisible,
                child: ListTile(
                  leading: Icon(Icons.account_circle,color: Colors.teal),
                  title: Text('Login/Sign up'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Authenticate()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                CircleAvatar(
                  radius: 80.0,
                  backgroundImage:
                  FirebaseImage('gs://booking-app-63e61.appspot.com/profileImages/${user.uid}.png',
                  maxSizeBytes: 5000 * 1000,
                  shouldCache: false,
                  cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE
                  ),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: MaterialButton(
                      color: Colors.white,
                      shape: CircleBorder(
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.teal,
                      ),
                      onPressed: (){
                        showDialog(context: context, builder: (context){
                            return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                elevation: 16,
                                child: Center(
                                    child: Column(
                                      children: [
                                        RaisedButton(
                                            child: Text('Click Image', style: TextStyle(color: Colors.white)),
                                            onPressed: () async {
                                              _pickImage(ImageSource.camera, user.uid);
                                            }),
                                        RaisedButton(
                                            child: Text('Import from gallery'),
                                            onPressed: () async {
                                              _pickImage(ImageSource.gallery, user.uid);
                                            })
                                      ],
                                    )
                                )
                            );
                        });
                      },
                    )
                  ),
                ),

                Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.person,
                            color: Colors.teal,
                          ),
                          title: Text(
                            widget.userDocument.data()['displayName'],
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal.shade900,
                                fontFamily: 'Source Sans Pro'),
                          ),
                        )
                      ],
                    )
                   ),

                Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Colors.teal,
                          ),
                          title: Text(
                            user.email,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.teal.shade900,
                                fontFamily: 'Source Sans Pro'),
                          ),
                        )
                      ],
                    )
                    ),

                RaisedButton(
                  child: Text("Update Profile", style: TextStyle(color: Colors.white)),
                  color: Colors.teal,
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImageUpload())
                    );
                  },
                ),
              ],
            )),
      /*Container(
          child: Center(
            child: Column(
              children: [
                Text('User details:\n', style: TextStyle(backgroundColor: Colors.lightGreenAccent, color: Colors.green,fontWeight: FontWeight.bold)),
                Text('Display Name:\n', style: TextStyle(backgroundColor: Colors.lightGreenAccent, color: Colors.green,fontWeight: FontWeight.bold)),
                Text(widget.userDocument.data()['displayName']+'\n', style: TextStyle(color: Colors.green)),
                Text('Type Of User:\n', style: TextStyle(backgroundColor: Colors.lightGreenAccent, color: Colors.green,fontWeight: FontWeight.bold)),
                Text(widget.userDocument.data()['typeOfUser']+'\n', style: TextStyle(color: Colors.green)),
                RaisedButton(
                    child: Text("Click Image"),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ImageUpload())
                      );
                    },
                )
              ],
            ),
          )
          ),*/

      )
    );
  }
}
