import 'dart:io';

import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'file:///D:/College/Project/App/lib/screens/home/Verification.dart';
import 'package:booking_app/Animation/animation.dart';
import 'package:booking_app/screens/authenticate/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:booking_app/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:flutter/animation.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}


class _RegisterState extends State<Register> {
  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>();

  //email and password
  String email = '';
  String password = '';
  String displayName = '';
  String error = '';
  bool _clicked = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body:Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
            FadeAnimation(
              1,
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                              child: FadeAnimation(
                                1,
                                Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage("assets/images/1.png"),
                                    ),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    Container(
                    padding: EdgeInsets.fromLTRB(15.0, 200.0, 0.0, 0.0),
                    child: Text('Signup', textAlign: TextAlign.center,
                    style:
                    TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                  ),
               ),
              ],
              ),
              ),
            ),
        FadeAnimation(
          1,
          Container(
            padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) => displayName.isEmpty ? "A display name is required": null,
                        decoration: new InputDecoration(
                            hintText: 'Enter Full Name',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.teal))),
                        onChanged: (val){
                          setState(() {
                            displayName = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                          validator: (val) => !val.contains("@") ? "Enter a valid email address" : null,
                          onChanged: (val){
                            print(val);
                            setState(() => email = val);
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter Email',
                            labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal))),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
                        validator: (val) => val.length < 6 ? "Enter a password more than 6 characters long" : null,
                        onChanged: (val){
                          setState(() => password = val);
                        },
                        decoration: new InputDecoration(
                            hintText: 'Enter Password',
                            labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal))),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        validator: (val) => password != val ? "Passwords do not match": null,
                        obscureText: true,
                        decoration: new InputDecoration(
                            hintText: 'Re-enter Password',
                            labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.teal))),
                      ),
                      SizedBox(height: 50.0),
                      Container(
                        height: 40.0,
                        width: 300.0,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.tealAccent,
                          color: Colors.teal,
                          elevation: 7.0,
                          child: GestureDetector(
                            onTap: () async {
                              if (_clicked == true) {
                                setState(() {
                                  _clicked = false;
                                });
                                if (formKey.currentState.validate()) {
                                  dynamic result = await auth.registerWithEmail(
                                      email, password, displayName);
                                  if (result == null) {
                                    setState(() {
                                      error = 'Email Address already exists';
                                    });
                                  }
                                  else {
                                    User user = FirebaseAuth.instance
                                        .currentUser;
                                    if (!user.emailVerified) {
                                      Dialogs.showLoadingDialog(
                                          context, _keyLoader);
                                      await user.sendEmailVerification();
                                      Fluttertoast.showToast(
                                          msg: "A verification link has been sent to your email. Please verify your email");
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  }
                                }
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 12.0),
                              child : Text(
                                'SIGNUP', textAlign: TextAlign.center,
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
                      SizedBox(height: 30.0),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: <Widget>[
                           Text(
                            'Already have an account?',
                            style: TextStyle(
                               fontFamily: 'Montserrat',
                            ),
                          ),
                           SizedBox(width: 5.0),
                           InkWell(
                             onTap: () async{
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => Login()),
                               );
                             },
                            child: Text('Login',
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                   decoration: TextDecoration.none)),
                        ),
                      ],
                      ),
                      SizedBox(height : 10.0),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red, fontSize: 14.0),
                      ),
                    ]
                )
            )

      ),
      ),
        )
    ]
      )
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                        ),
                        SizedBox(height: 10,),
                        Text("Please Wait....",style: TextStyle(color: Colors.black),)
                      ]),
                    )
                  ]));
        });
  }
}