import 'dart:io';

import 'package:path/path.dart';
import 'package:booking_app/services/auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Register extends StatefulWidget {
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
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign up to Booking app"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: formKey,
          child: Column(
              children: <Widget>[
              SizedBox(height: 20.0),
            TextFormField(
                validator: (val) => val.isEmpty ? "Enter email" : null,
                onChanged: (val){
                  print(val);
                  setState(() => email = val);
                }
                ,decoration: new InputDecoration(
                hintText: 'Email'
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
                      hintText: 'password'
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  validator: (val) => password != val ? "Password mismatch": null,
                  obscureText: true,
                  decoration: new InputDecoration(
                      hintText: 're enter password'
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  validator: (val) => displayName.isEmpty ? "a display name is required": null,
                  decoration: new InputDecoration(
                      hintText: 'display name'
                  ),
                  onChanged: (val){
                    setState(() {
                      displayName = val;
                    });
                  },
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.red[200],
                  child: Text('Upload Image', style: TextStyle(color: Colors.brown[400])),
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
                    color: Colors.red[200],
                    child: Text('Register', style: TextStyle(color: Colors.brown[400])),
                    onPressed: () async{
                      print(email);
                      print(password);
                      if (formKey.currentState.validate()){
                        dynamic result = await auth.registerWithEmail(email, password, displayName);
                        if(result == null){
                          setState((){
                            error = 'please supply a valid email';
                          });
                        }
                        else{
                          setState(() {
                            error = 'done';
                            print(result);
                          });
                        }
                      }
                    }),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                )
            ]
        )
      ),
      )
    );
  }
}
