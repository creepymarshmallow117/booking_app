import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'package:booking_app/screens/authenticate/login.dart';
import 'package:booking_app/screens/authenticate/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Verification extends StatefulWidget {
  final User user;
  const Verification({Key key, this.user}) : super(key: key);
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    if(widget.user.emailVerified)
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    return Scaffold(

    );
  }
}
