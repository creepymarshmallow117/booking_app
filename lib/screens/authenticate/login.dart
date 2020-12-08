import 'package:flutter/material.dart';
import 'package:booking_app/services/auth.dart';

class Login extends StatefulWidget {

  final Function toggleView;
  Login({ this.toggleView });
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  //Text field state
  String email = '';
  String password = '';
  String error = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:  Colors.brown[100],
        appBar: AppBar(backgroundColor: Colors.brown[400],
            elevation: 0.0,
            title: Text("Sign in to Booking app"),
            actions: <Widget>[
              FlatButton.icon(
                  icon: Icon(Icons.person),
                  label: Text('Register'),
                  onPressed: (){
                    widget.toggleView();
                  }
              )
            ]),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
              key: _formKey,
              child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0),
                    TextFormField(
                        validator: (val) => val.isEmpty ? 'Enter valid email' : null,
                        onChanged: (val){
                          setState(() => email = val);
                        }
                        ,decoration: new InputDecoration(
                        hintText: 'Email'
                    )
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      validator: (val) => val.length < 6 ? 'Enter valid password' : null,
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
                        child: Text('Sign in', style: TextStyle(color: Colors.brown[400])),
                        onPressed: () async{
                          if(_formKey.currentState.validate()) {
                            dynamic result = await _auth.signInWithEmail(email, password);
                            if (result == null) {
                              setState((){
                                error = 'could not sign in with credentials';
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