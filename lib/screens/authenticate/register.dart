import 'dart:io';

import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0.0,
        title: Text("Register",style: TextStyle(color: Colors.black)),
          actions: <Widget>[
      FlatButton.icon(
      icon: Icon(Icons.person),
        label: Text('Log in',),
        onPressed: (){
          widget.toggleView();
        }
    )
    ]),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                        validator: (val) => val.isEmpty ? "Enter email address" : null,
                        onChanged: (val){
                          print(val);
                          setState(() => email = val);
                        }
                        ,decoration: new InputDecoration(
                        hintText: 'Enter Email'
                    )
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      validator: (val) => val.length < 6 ? "Enter a password more than 6 characters long" : null,
                      onChanged: (val){
                        setState(() => password = val);
                      },
                      decoration: new InputDecoration(
                          hintText: 'Enter Password'
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => password != val ? "Passwords do not match": null,
                      obscureText: true,
                      decoration: new InputDecoration(
                          hintText: 'Re-enter Password'
                      ),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      validator: (val) => displayName.isEmpty ? "A display name is required": null,
                      decoration: new InputDecoration(
                          hintText: 'Enter Display Name'
                      ),
                      onChanged: (val){
                        setState(() {
                          displayName = val;
                        });
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                      color: Colors.grey,
                      child: Text('Upload Image', style: TextStyle(color: Colors.black)),
                      onPressed: () async{
                        File _image;
                        final picker = ImagePicker();
                        final pickedFile = await picker.getImage(source: ImageSource.gallery);
                        setState(() {
                          _image = File(pickedFile.path);
                        });
                        String fileName = basename(_image.path);
                        Reference firebaseStorageRef =
                        FirebaseStorage.instance.ref().child('uploads/$fileName');
                        UploadTask uploadTask = firebaseStorageRef.putFile(_image);
                        TaskSnapshot taskSnapshot = await uploadTask;
                        taskSnapshot.ref.getDownloadURL().then(
                              (value) => print("Done: $value"),
                        );
                      },
                    ),
                    SizedBox(height: 20.0),
                    RaisedButton(
                        color: Colors.grey,
                        child: Text('Register', style: TextStyle(color: Colors.black)),
                        onPressed: () async{
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            }
                          }
                        }),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ]
              )
          )

      ),
      )
    );
  }
}
