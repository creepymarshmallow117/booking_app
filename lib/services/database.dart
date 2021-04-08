
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class DatabaseService{
  final String uid;
  DatabaseService({this.uid});

  Future createDocument(String displayName, String typeOfUser) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection("user");
      return await collection.doc(uid).set({
        'displayName': displayName,
        'typeOfUser': 'user'
      });
  }
  Future getDocument(String uid) async{
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection(
          "user");
      DocumentSnapshot document = await collection.doc(uid).get();
      Map<String, Object> map = document.data();
      if(map.length > 0){
        return document;
      }
    }on NoSuchMethodError{
      CollectionReference collection = FirebaseFirestore.instance.collection(
          "client");
      DocumentSnapshot document = await collection.doc(uid).get();
      Map<String, Object> map = document.data();
      if(map.length > 0){
        return document;
      }
    }
    catch(e){
      print(e.toString());
    }
  }


}



