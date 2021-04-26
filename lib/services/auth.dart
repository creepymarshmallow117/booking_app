import 'dart:async';

import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService{

  final FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User> get user {
    return auth.authStateChanges();
  }
  Future registerWithEmail(String email, String password, String displayName) async{
    try{
      User user = (await auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      //create a new document for the user with the uid
      await DatabaseService(uid: user.uid).createDocument(displayName, "user");
      return user;
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmail(String email, String password) async{
    try{
      User user = (await auth.signInWithEmailAndPassword(email: email, password: password))
          .user;
      return user;
    }catch(e){
      print(e.toString());
    }
  }
  Future signOut() async{
    try{
      return await auth.signOut();
    }catch(e){
      print(e.toString());
    }
  }




  Future<void> updatePassword(String password) async {
    var firebaseUser = await auth.currentUser;
    firebaseUser.updatePassword(password);
  }

}


