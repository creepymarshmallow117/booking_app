//This is the schedule page.

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/home/profile.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'cart.dart';
import 'home.dart';
import 'orders.dart';

class Slots extends StatefulWidget {
  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
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
          backgroundColor: Colors.teal,
          title: Text("Slots", style: TextStyle(color: Colors.white),),
          ),
      body: SingleChildScrollView(

      ),
    );
      }
}




