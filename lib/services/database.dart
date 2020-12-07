import 'package:cloud_firestore/cloud_firestore.dart';

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
}