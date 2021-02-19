import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'package:booking_app/screens/authenticate/register.dart';
import 'package:booking_app/screens/home/home1.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/services/auth.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({ this.toggleView });
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final DatabaseService _data = DatabaseService();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Text field state
  String email = '';
  String password = '';
  String error = '';

  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Container(
            child: Stack(
              children: <Widget>[
                Container(
                padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text('Login', textAlign: TextAlign.center,
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
                      obscureText: _obscureText,
                      validator: (val) => val.length < 6 ? 'Enter valid password' : null,
                      onChanged: (val){
                        setState(() => password = val);
                      },
                      decoration: InputDecoration(
                      hintText: 'Enter Password',
                          suffixIcon: IconButton(
                            onPressed: _toggle,
                            icon: Icon(Icons.visibility),
                              color: Colors.teal,
                          ),

                      labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                      // hintText: 'EMAIL',
                      // hintStyle: ,
                      focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal))
                      ),
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
                            if(_formKey.currentState.validate() ) {
                              dynamic result = await _auth.signInWithEmail(email, password);
                              if (result == null) {
                                setState((){
                                  error = 'Invalid Credentials';
                                });
                              }
                              else{
                                User u = result;
                                try {
                                  CollectionReference collection = FirebaseFirestore.instance.collection(
                                      "user");
                                  DocumentSnapshot document = await collection.doc(u.uid).get();
                                  Map<String, Object> map = document.data();
                                  if(map.length > 0){
                                    if(!user.emailVerified){
                                      setState(() {
                                        error = "Please verify your email";
                                      });
                                    }
                                    else{
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => Home()),
                                      );
                                    }
                                  }
                                }on NoSuchMethodError{
                                  CollectionReference collection = FirebaseFirestore.instance.collection(
                                      "client");
                                  DocumentSnapshot document = await collection.doc(u.uid).get();
                                  Map<String, Object> map = document.data();
                                  if(map.length > 0){
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Home1()),
                                    );
                                  }
                                }
                                catch(e){
                                  print(e.toString());
                                }

                              }
                            }
                        },
                        child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child : Text('LOGIN', textAlign: TextAlign.center,
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
                          "Don't have an account?",
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        SizedBox(width: 5.0),
                        InkWell(
                          onTap: () async{
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Register()),
                            );
                          },
                          child: Text('Signup',
                              style: TextStyle(
                                  color: Colors.teal,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        ),
                      ],
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ]
              )
          ),
        )
    )
    ]
          ),
    );
  }
}