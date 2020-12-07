import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future registerWithEmail(String email, String password) async{
    try{
      User user = (await auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      //create a new document for the user with the uid
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
}