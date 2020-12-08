import 'register.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showLogin = false;
  void toggleView(){
    setState(() => showLogin = !showLogin);
  }
  @override
  Widget build(BuildContext context) {
    if(showLogin == true){
      print(showLogin);
      return Login(toggleView: toggleView);
    }else{
      print(showLogin);
      return Register(toggleView: toggleView);
    }
  }
}
