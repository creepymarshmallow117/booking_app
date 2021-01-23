

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/home/profile.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart.dart';
import 'home.dart';
import 'orders.dart';

class Schedule extends StatefulWidget {
  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  bool _isVisible = false;
  Widget appBarTitle = new Text(" ");
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
    return Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                icon : Icon(Icons.shopping_cart,color: Colors.white),
                iconSize: 30,
                onPressed: () {
                  if(_isVisible == true){
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cart()),
                  );
                  }
                  else{
                  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Authenticate()),
                  );
                  }
                  },
                )
            ],
          ),
          ],
          ),
        drawer : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
          DrawerHeader(
          decoration: BoxDecoration(
          color: Colors.blue,
          ),
          child: Text('Welcome User',
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
          Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home()),
          );
          },
        ),
        Visibility(
          visible: _isVisible,
          child: ListTile(
          leading: Icon(Icons.message),
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
          leading: Icon(Icons.account_circle),
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
        leading: Icon(Icons.logout),
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
        leading: Icon(Icons.account_circle),
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
    );
      }
}
