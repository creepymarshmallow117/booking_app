//This is the profiles page.

import 'dart:io';

import 'package:booking_app/screens/home/profileImage.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'file:///C:/Users/Aditya/AndroidStudioProjects/booking_app/lib/screens/home/home.dart';
import 'file:///C:/Users/Aditya/AndroidStudioProjects/booking_app/lib/screens/home/orders.dart';
import 'package:provider/provider.dart';
import 'package:booking_app/services/database.dart';

class Profile extends StatefulWidget {
  final DocumentSnapshot userDocument;
  Profile({this.userDocument});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final AuthService auth = AuthService(); //AuthService instance
  final DatabaseService db = DatabaseService();//DatabaseService instance


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
    //final DatabaseService db = DatabaseService();
    final user = Provider.of<User>(context);
    //print(user.uid);
    print("this is document id:"+widget.userDocument.data()['displayName']);
    return Scaffold (
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: Text('Profile Page', style: TextStyle(color: Colors.teal)),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.teal),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Welcome User',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Your Orders'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orders()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile(userDocument: widget.userDocument,)),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  auth.signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 110.0,
                  width: 150.0,
                  child: Divider(
                    color: Colors.teal,
                  ),
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
                                            child: Text('Click Image'),
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
                Text(
                  widget.userDocument.data()['displayName'],
                  style: TextStyle(
                    fontFamily: 'Pacifico',
                    fontSize: 40.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.userDocument.data()['typeOfUser'],
                  style: TextStyle(
                    fontFamily: 'Source Sans Pro',
                    color: Colors.teal.shade100,
                    fontSize: 20.0,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20.0,
                  width: 150.0,
                  child: Divider(
                    color: Colors.teal.shade100,
                  ),
                ),
                Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Colors.teal,
                      ),
                      title: Text(
                        'phone number',
                        style: TextStyle(
                          color: Colors.teal.shade900,
                          fontFamily: 'Source Sans Pro',
                          fontSize: 20.0,
                        ),
                      ),
                    )),
                Card(
                    margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    child: ListTile(
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
                    )),
                RaisedButton(
                  child: Text("Click Image", style: TextStyle(color: Colors.teal)),
                  color: Colors.white,
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

      );
  }
}
