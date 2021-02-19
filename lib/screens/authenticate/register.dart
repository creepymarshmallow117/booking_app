import 'dart:io';

import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'file:///D:/College/Project/App/lib/screens/home/Verification.dart';
import 'package:booking_app/screens/authenticate/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'package:booking_app/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body:Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text('Signup', textAlign: TextAlign.center,
                  style:
                  TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold),
                ),
             ),
            ],
            ),
            ),
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
                          hintText: 'Enter Display Name',
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
                        validator: (val) => val.isEmpty ? "Enter email address" : null,
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
                          onTap: () async{
                            print(email);
                            print(password);
                            if (formKey.currentState.validate()){
                              dynamic result = await auth.registerWithEmail(email, password, displayName);
                              if(result == null){
                                setState((){
                                  error = 'Please enter a valid email address';
                                });
                              }
                              else{
                                User user = FirebaseAuth.instance.currentUser;
                                if (!user.emailVerified) {
                                  await user.sendEmailVerification();
                                }
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Login()),
                                  );
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
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                    SizedBox(height: 15.0),
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
                                 decoration: TextDecoration.underline)),
                      ),
                    ],
                    )
                  ]
              )
          )

      ),
      )
    ]
      )
    );
  }
}
