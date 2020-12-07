import 'package:booking_app/services/auth.dart';
import 'package:flutter/material.dart';

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
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign in to Brew Crew"),
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
                RaisedButton(
                    color: Colors.red[200],
                    child: Text('Register', style: TextStyle(color: Colors.brown[400])),
                    onPressed: () async{
                      print(email);
                      print(password);
                      if (formKey.currentState.validate()){
                        dynamic result = await auth.registerWithEmail(email, password);
                        if(result == null){
                          setState((){
                            error = 'please supply a valid email';
                          });
                        }
                        else{
                          setState(() {
                            error = 'done';
                          });
                        }
                      }
                    }),
                SizedBox(height: 12.0),
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
