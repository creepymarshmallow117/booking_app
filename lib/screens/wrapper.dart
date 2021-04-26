import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/authenticate/login.dart';
import 'package:booking_app/screens/authenticate/register.dart';
import 'package:booking_app/screens/home/home.dart';
import 'package:booking_app/screens/home/home1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  void checkUserType(String uid, BuildContext context) async{
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection(
          "user");
      DocumentSnapshot document = await collection.doc(uid).get();
      Map<String, Object> map = document.data();
      if(map.length > 0){
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      }
    }on NoSuchMethodError{
      CollectionReference collection = FirebaseFirestore.instance.collection(
          "client");
      DocumentSnapshot document = await collection.doc(uid).get();
      Map<String, Object> map = document.data();
      if(map.length > 0){
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => Home1()),
        );
      }
    }
    catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    imageCache.clearLiveImages();
    final user = Provider.of<User>(context);
    if(user == null){
      return Home();
    }else{
      checkUserType(user.uid, context);
    }
    return Container();
  }
}
