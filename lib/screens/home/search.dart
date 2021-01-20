import 'package:booking_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'file:///D:/College/Project/App/lib/screens/home/profile.dart';
import 'file:///D:/College/Project/App/lib/screens/home/orders.dart';
import 'file:///D:/College/Project/App/lib/screens/home/cart.dart';

class Search extends StatefulWidget {
  final String id;
  const Search({Key key, this.id}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Here is your search result'),
          backgroundColor: Colors.blueGrey,
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
                  Navigator.pop(context);
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
                  Navigator.pop(context);
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
                  Navigator.pop(context);
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
                  Navigator.pop(context);
                  auth.signOut();
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child : StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection("client").doc(widget.id).snapshots(),
          builder: (context,snapshot){
            DocumentSnapshot data = snapshot.data;
            String groundName = data.data()["groundName"];
            String groundAddress = data.data()["address"];
            String groundDescription = data.data()["description"];
            String groundContactInfo = data.data()["contactInfo"];
            print(groundName);
            print(groundContactInfo);
            print(groundDescription);
            print(groundAddress);
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : Container(
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Text(groundName),
                          Text(groundContactInfo),
                          Text(groundDescription),
                          Text(groundAddress),
                        ],
                      ),
                    ),
                  );
                }
            )

      )
          ),

    );
  }
}
