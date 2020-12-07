import 'package:booking_app/services/auth.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

enum TypeOfUser { user, client}
class _RegisterState extends State<Register> {
  final AuthService auth = AuthService();
  final formKey = GlobalKey<FormState>();

  //email and password
  String email = '';
  String password = '';
  String error = '';
  TypeOfUser typeUser = TypeOfUser.user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text("Sign up to Booking app"),
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
                TextFormField(
                  validator: (val) => password != val ? "Password mismatch": null,
                  obscureText: true,
                  decoration: new InputDecoration(
                      hintText: 're enter password'
                  ),
                ),
                SizedBox(height: 20.0),
                ListTile(
                    title: const Text("User"),
                    leading: Radio(
                      value: TypeOfUser.user,
                      groupValue: typeUser,
                      onChanged: (TypeOfUser value){
                        setState(() {
                          typeUser = value;
                        });
                      },
                    )
                ),
                ListTile(
                    title: const Text("Client"),
                    leading: Radio(
                      value: TypeOfUser.client,
                      groupValue: typeUser,
                      onChanged: (TypeOfUser value){
                        setState(() {
                          typeUser = value;
                        });
                      },
                    )
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                    color: Colors.red[200],
                    child: Text('Register', style: TextStyle(color: Colors.brown[400])),
                    onPressed: () async{
                      print(email);
                      print(password);
                      if (formKey.currentState.validate()){
                        dynamic result = await auth.registerWithEmail(email, password, typeUser.toString());
                        if(result == null){
                          setState((){
                            error = 'please supply a valid email';
                          });
                        }
                        else{
                          setState(() {
                            error = 'done';
                            print(result);
                          });
                        }
                      }
                    }),
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
