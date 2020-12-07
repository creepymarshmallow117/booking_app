import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});

  Future updateDocument(String typeOfUser) async {
    final CollectionReference collection = FirebaseFirestore.instance.collection(typeOfUser);
    if(typeOfUser == "user"){
      return await collection.doc(uid).set({
        typeOfUser: typeOfUser
      });
    }
    else{
      return await collection.doc(uid).set({
        typeOfUser: typeOfUser
      });
    }
  }
}