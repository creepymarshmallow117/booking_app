//This is the profiles page.

import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final AuthService auth = AuthService();
  final DatabaseService db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    //final DatabaseService db = DatabaseService();
    final user = Provider.of<User>(context);
    //print(user.uid);
    print("this is document id:"+widget.userDocument.data()['displayName']);
    return Scaffold (
        appBar: AppBar(
          title: Text('Profile Page'),
          backgroundColor: Colors.green,
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
        body: Container(
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
          ),
      );
  }
}
