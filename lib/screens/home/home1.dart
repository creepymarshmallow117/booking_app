//This is the Client's home page.

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/home/home.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'file:///D:/College/Project/App/lib/screens/home/orders.dart';
import 'file:///D:/College/Project/App/lib/screens/home/profile.dart';
import 'package:provider/provider.dart';


class Home1 extends StatefulWidget{
  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home");
  int _currentIndex=0;


  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('You are going to exit the application'),
            actions: <Widget>[
              FlatButton(
                child: Text('NO'),
                onPressed: () {
                  WidgetsBinding.instance.handlePopRoute();
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();
    final user = Provider.of<User>(context);
    if(user == null){
      setState(() => _isVisible = false);
    }else{
      setState(() => _isVisible = true);
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Home", style: TextStyle(color: Colors.white)),
      ),
      drawer : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Text('Welcome Client',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Visibility(
              visible: _isVisible,
              child: ListTile(
                leading: Icon(Icons.message, color: Colors.teal),
                title: Text('Orders'),
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
                leading: Icon(Icons.account_circle, color: Colors.teal),
                title: Text('Profile'),
                onTap: () async{
                  if(user != null) {
                    print("Inside here");
                    dynamic result =  await db.getDocument(user.uid.toString());
                    if (result == null) {
                      print("This is a problem");
                    }
                    else {
                      print(result);
                      Navigator.pop(context);
                      Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile(userDocument: result)),
                      );
                    }
                  }
                  else{
                    print("This is a big problem");
                  }
                },
              ),
            ),
            Visibility(
              visible: _isVisible,
              child: ListTile(
                leading: Icon(Icons.logout, color: Colors.teal),
                title: Text('Log Out'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Home()),
                  );
                  auth.signOut();
                },
              ),
            ),
            Visibility(
              visible: !_isVisible,
              child: ListTile(
                leading: Icon(Icons.account_circle,color: Colors.teal),
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
      body : WillPopScope(
          onWillPop: _onBackPressed,
          child : SingleChildScrollView(
            child: Column(
              children: <Widget>[

                ]
            ),
          )
      ),
    );
  }
}





/*

class Datasearch extends SearchDelegate<String> {

  final DatabaseService data = DatabaseService();


  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {
      query = "";
    })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ), onPressed: () {
      close(context, null);
    }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(

    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      child : StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("client").orderBy("groundName").snapshots(),
          builder: (context,snapshot){
            List<String> suggestionList = List<String>();
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              DocumentSnapshot data = snapshot.data.docs.elementAt(i);
              suggestionList.add(data.data()['groundName']);
            }
            String query1 = toBeginningOfSentenceCase(query);
            print(query1);
            print(query);
            List<String> searchList = suggestionList.where((element) =>
                element.startsWith(query1)).toList();
            print(suggestionList);
            print(searchList);
            List<String> idList = List<String>();
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              DocumentSnapshot data = snapshot.data.docs.elementAt(i);
              for (int j = 0; j < searchList.length; j++) {
                if (data.data()['groundName'] ==
                    searchList.elementAt(j)) {
                  idList.add(data.id);
                }
              }
            }
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                :ListView.builder(
                itemCount: searchList.length,
                itemBuilder: (context,index){
                  return ListTile(
                    title: Text(searchList.elementAt(index)),
                    onTap: (){
                      String id = snapshot.data.docs.elementAt(index).id;
                      print(index);
                      print(id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Search(id: idList.elementAt(index))),
                      );
                    },
                  );
                }
            );
          }
      ),
    );
  }
}





class Item1 extends StatelessWidget {
  const Item1({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[800],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.local_offer, size: 40, color: Colors.white,),
          SizedBox(height: 20),
          Text(
              "Great Offers Coming Soon!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              )
          ),
        ],
      ),
    );
  }
}

class Item2 extends StatelessWidget {
  const Item2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [Color(0xff5f2c82), Color(0xff49a09d)]
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              "Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
              )
          ),
          Text(
              "Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600
              )
          ),
        ],
      ),
    );
  }
}

class Item3 extends StatelessWidget {
  const Item3({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.3, 1],
            colors: [Color(0xffff4000),Color(0xffffcc66),]
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

        ],
      ),
    );
  }
}

class Item4 extends StatelessWidget {
  const Item4({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
              "Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
              )
          ),
          Text(
              "Data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600
              )
          ),
        ],
      ),
    );
  }
}





final db = FirebaseFirestore.instance.reference().child("places");
    db.once().then((iterable<DataSnapshot> snapshot){
      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key,values) {
        print(values["DisplayName"]);

StreamBuilder<DocumentSnapshot>(
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
                :









final suggestionList = query.isEmpty
        ? recentTurfs
        : turfs.where((p)=>p.startsWith(query)).toList();
    return ListView.builder(itemBuilder: (context,index)=>ListTile(
      onTap: (){
        showResults(context);
      },
      title: Text(suggestionList[index]),
    ),
      itemCount: suggestionList.length,
    );
    final turfs = [
    "EcoGrass",
    "Sundial Gardening",
    "Fairy Yardmother",
    "Solid Ground Landscaping",
    "Grass Masters",
    "Star Landscape Design",
    "A Cut Above",
    "Forest Green Lawn and Landscaping",
    "Budget Lawn Mowing",
    "Push Lawn Care",
    "Navlan’s Landscape",
    "Sharp Lawn Inc.",
    "Plush Lawns",
    "Turf Pros",
    "Turf Terminators",
    "Yard Smart",
    "CleanMe Lawn",
    "Green Acres",
    "A Good Turf",
    "Edge Cut Lawn",
    "Lawn & Turf Contracting",
    "Curb Appeal",
    "LawnStarter",
    "Perfect Lawncare",
    "Cloverdale Mowing"
  ];

  final recentTurfs = [
    "Yard Smart",
    "Lawn & Turf Contracting",
    "Curb Appeal",
    "LawnStarter"
  ];*/

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