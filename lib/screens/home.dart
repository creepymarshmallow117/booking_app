//This is the home page.

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/screens/orders.dart';
import 'package:booking_app/screens/profile.dart';
import 'package:booking_app/screens/logout.dart';
import 'package:booking_app/screens/cart.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon : Icon(Icons.shopping_cart,color: Colors.white),
                  iconSize: 30,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Cart()),
                    );
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
                child: Text(
                  'Welcome User',
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Your Orders'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orders()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Profile()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Logout()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Grid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          backgroundColor: Colors.teal,
          body:CustomScrollView(
            primary: false,
            slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text("6"),
                      color: Colors.blueAccent,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('5'),
                      color: Colors.blueAccent,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('4'),
                      color: Colors.blueAccent,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('3'),
                      color: Colors.blueAccent,
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('2'),
                      color: Colors.green[500],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('1'),
                      color: Colors.green[600],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('1'),
                      color: Colors.green[600],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('1'),
                      color: Colors.green[600],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('1'),
                      color: Colors.green[600],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('1'),
                      color: Colors.green[600],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('1'),
                      color: Colors.green[600],
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: const Text('1'),
                      color: Colors.green[600],
                    ),
                  ],
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