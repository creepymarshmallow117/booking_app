//This is the home page.

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///C:/Users/Aditya/AndroidStudioProjects/booking_app/lib/screens/home/orders.dart';
import 'file:///C:/Users/Aditya/AndroidStudioProjects/booking_app/lib/screens/home/profile.dart';
import 'file:///C:/Users/Aditya/AndroidStudioProjects/booking_app/lib/screens/home/cart.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home");
  Icon searchIcon = new Icon(Icons.search);
  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final user = Provider.of<User>(context);
    if(user == null){
      setState(() => _isVisible = false);
    }else{
      setState(() => _isVisible = true);
    }
    return Scaffold(
        appBar: AppBar(
          title: appBarTitle,
          actions: <Widget>[
            new IconButton(icon: searchIcon,iconSize : 30,onPressed:(){
              setState(() {
                if (this.searchIcon.icon == Icons.search)
                {
                  this.searchIcon = new Icon(Icons.close);
                  this.appBarTitle = new TextField(
                    style: new TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    decoration: new InputDecoration(
                        hintText: "Search...",
                        border: InputBorder.none,
                        hintStyle: new TextStyle(color: Colors.white,fontSize: 20)
                    ),
                  );}
                  else {
                    this.searchIcon = new Icon(Icons.search);
                    this.appBarTitle = new Text("Home");
                }
              });
            },),
            Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                          icon : Icon(Icons.shopping_cart,color: Colors.white),
                          iconSize: 30,
                          onPressed: () {
                            if(_isVisible == true){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Cart()),
                            );
                            }else{
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Authenticate()),
                              );
                            }
                          },
                        )
                      ],
                    ),
                    ],
                  ),
      drawer: Drawer(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Welcome User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
             ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => Home()),
              );
            },
          ),
          Visibility(
            visible: _isVisible,
            child: ListTile(
            leading: Icon(Icons.message),
            title: Text('Your Orders'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push( context,
              MaterialPageRoute(builder: (context) => Orders()),
              );
            },
          ),
          ),
          Visibility(
            visible: _isVisible,
            child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
              MaterialPageRoute(builder: (context) => Profile()),
            );
            },
          ),
          ),
          Visibility(
            visible: _isVisible,
            child: ListTile(
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              auth.signOut();
            },
            ),
          ),
          Visibility(
            visible: !_isVisible,
            child: ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Login/Sign up'),
            onTap: () {
              Navigator.pop(context);
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Authenticate()),
          );
          },
          ),
          ),
      ],
    ),
    ),
  );
  }
}






/*class dropdown extends StatefulWidget {
  dropdown({Key key}) : super(key: key);

  @override
  _dropdown createState() => _dropdown();
}


class _dropdown extends State<dropdown> {
  String dropdownValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.account_circle),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.white),
      underline: Container(
        height: 2,
        color: Colors.black,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>['Orders', 'Profile', 'Log Out']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}*/

/*appBar: AppBar(
backgroundColor: Colors.blueGrey[800],
title : SizedBox(
child : Row(
mainAxisAlignment: MainAxisAlignment.end,
children: <Widget> [
new DropdownButton<String>(
icon: Icon(Icons.account_circle),
iconSize: 24,
elevation: 16,
items: <String>['Orders','Profile','Log Out'].map((String value) {
return new DropdownMenuItem<String>(
value: value,
child: new Text(value),
);
}).toList(),
onChanged: (_) {
},
),
],
),
),
),
*/