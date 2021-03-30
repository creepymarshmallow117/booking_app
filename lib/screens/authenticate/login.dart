import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'package:booking_app/Animation/animation.dart';
import 'package:booking_app/screens/authenticate/register.dart';
import 'package:booking_app/screens/home/forgotpassword.dart';
import 'package:booking_app/screens/home/home1.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/services/auth.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/animation.dart';

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



  bool flag = false;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    void _verify() {
      if(flag==false)
      {
        user = FirebaseAuth.instance.currentUser;
        if(user.emailVerified)
        {
          setState(() {
            flag = true;
          });
        }
      }
    }
    return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
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
            FadeAnimation(
              1,
              Container(
              child: Stack(
                children: <Widget>[
                  Container(
                  padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: Text('Login', textAlign: TextAlign.center,
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
                      SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(width: 5.0),
                          InkWell(
                            onTap: () async{
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => forgotpassword()),
                              );
                            },
                            child: Text('Forgot Password?',
                                style: TextStyle(
                                    color: Colors.teal,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline)),
                          ),
                        ],
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
                                dynamic result = await _auth.signInWithEmail(email, password);
                                if (result == null) {
                                  setState((){
                                    error = 'Invalid Credentials';
                                  });
                                }
                                else{
                                  User u = result;
                                  _verify();
                                  try {
                                    Dialogs.showLoadingDialog(context, _keyLoader);
                                    CollectionReference collection = FirebaseFirestore.instance.collection(
                                        "user");
                                    DocumentSnapshot document = await collection.doc(u.uid).get();
                                    Map<String, Object> map = document.data();
                                    if(map.length > 0){
                                      if(flag == false){
                                        Dialogs.showLoadingDialog(context, _keyLoader);
                                        setState(() {
                                          error = "Please verify your email";
                                        });
                                        print(flag);
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
            ),
        )
    ),
          )
    ]
          ),
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