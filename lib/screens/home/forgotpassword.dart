import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'package:booking_app/Animation/animation.dart';
import 'package:booking_app/screens/authenticate/register.dart';
import 'package:booking_app/screens/home/home1.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class forgotpassword extends StatefulWidget {
  @override
  _forgotpasswordState createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
  final DatabaseService _data = DatabaseService();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String error = '';

  @override

  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: height1,
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20.0, top: 20.0),
                      child: GestureDetector(
                        child: new Icon(
                          Icons.arrow_back_ios,
                          color: Colors.teal,
                          size: 22.0,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                        child: Text('Reset Password',
                          style:
                          TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold, fontFamily: 'Kollektif',),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                  child: Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0),
                          TextFormField(
                            validator: (val) => val.isEmpty ? 'Enter valid email' : null,
                            onChanged: (val){
                              setState(() => email = val);
                            },
                            decoration: InputDecoration(
                                hintText: 'Enter Email',
                                labelStyle: TextStyle(
                                    fontFamily: 'Kollektif-Bold',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                // hintText: 'EMAIL',
                                // hintStyle: ,
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.teal))),
                          ),
                          SizedBox(height: 35.0),
                          Container(
                            height: 40.0,
                            width: 300.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.tealAccent,
                              color: Colors.teal,
                              elevation: 7.0,
                              child: GestureDetector(
                                onTap: () async{
                                  if(_formKey.currentState.validate() ) {
                                    if (email == null) {
                                      setState((){
                                        error = 'Invalid Credentials';
                                      });
                                    }
                                    else{
                                      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                                      Fluttertoast.showToast(
                                          msg:
                                          "Reset password link has been sent to your mail.");
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child : Text('RESET PASSWORD', textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Kollektif-Bold',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height : 10.0),
                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14.0, fontFamily: 'Kollektif-Bold',),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



/*

Column(
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
            padding: EdgeInsets.only(left: 20.0, top: 2.0),
            child: new Text('SETTINGS',
                style: TextStyle(
                    fontSize: 20.0,
                    fontFamily: 'Kollektif',
                    color: Colors.teal)),
          )
        ],
      ),
    ),
        Padding(padding: EdgeInsets.only(left: 20.0, top: 20.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

      ],
      ),
    )
    ]



Container(
            child: Stack(
              children: <Widget>[
                Container(
                padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                child: Text('Reset Password', textAlign: TextAlign.start,
                style:
                  TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold, fontFamily: 'Kollektif',),
              ),
            ),
          ],
          ),
        ),
        Container(
        padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => val.isEmpty ? 'Enter valid email' : null,
                      onChanged: (val){
                      setState(() => email = val);
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter Email',
                        labelStyle: TextStyle(
                            fontFamily: 'Kollektif-Bold',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                          focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal))),
                ),
                  SizedBox(height: 35.0),
                  Container(
                    height: 40.0,
                    width: 300.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.tealAccent,
                      color: Colors.teal,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () async{
                          if(_formKey.currentState.validate() ) {
                            if (email == null) {
                              setState((){
                                error = 'Invalid Credentials';
                              });
                            }
                          else{
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                            Fluttertoast.showToast(
                                msg:
                                "Reset password link has been sent to your mail.");
                            Navigator.pop(context);
                            }
                          }
                          },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child : Text('RESET PASSWORD', textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kollektif-Bold',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height : 10.0),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0, fontFamily: 'Kollektif-Bold',),
                  ),
                ],
              ),
          ),
        ),
      ),
 */
