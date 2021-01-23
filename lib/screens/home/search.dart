//This is the search result page.

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/authenticate/login.dart';
import 'package:booking_app/screens/home/schedule.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'file:///D:/College/Project/App/lib/screens/home/profile.dart';
import 'file:///D:/College/Project/App/lib/screens/home/orders.dart';
import 'file:///D:/College/Project/App/lib/screens/home/cart.dart';
import 'package:provider/provider.dart';

class Search extends StatefulWidget {
  final String id;
  const Search({Key key, this.id}) : super(key: key);
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {


  bool _isVisible = false;
  Widget appBarTitle = new Text(" ");
  Icon searchIcon = new Icon(Icons.search);
  int _currentIndex=0;

  List cardList=[
    Item1(),
    Item2(),
    Item3(),
    Item4()
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
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
          title: appBarTitle,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search),iconSize : 30,onPressed:() {
              showSearch(context: context, delegate: Datasearch());
            }),
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
        drawer : Drawer(
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
        body : SingleChildScrollView(
        child : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection("client").doc(widget.id).snapshots(),
                builder: (context,snapshot) {
                DocumentSnapshot data = snapshot.data;
                String groundName = data.data()["groundName"];
                String groundAddress = data.data()["address"];
                String groundDescription = data.data()["description"];
                String groundContactInfo = data.data()["contactInfo"];
                print(groundName);
                print(groundContactInfo);
                print(groundDescription);
                print(groundAddress);
                return Container(
                      child : Column(
                      children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 220.0,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration: Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          pauseAutoPlayOnTouch: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                        ),
                        items: cardList.map((card) {
                          return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.30,
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  child: Card(
                                    color: Colors.blueAccent,
                                    child: card,
                                  ),
                                );
                              }
                          );
                        }).toList(),
                      ),
                        Container(
                          width: double.maxFinite,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(padding: EdgeInsets.only(left: 7)),
                                  Text(
                                      groundName,
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                              ),
                              SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        groundContactInfo,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        groundDescription,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        groundAddress,
                                        textAlign: TextAlign.end,
                                        style: TextStyle(fontSize: 15),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    child : Align(
                                        alignment: Alignment.bottomCenter,
                                        heightFactor: 9.0,
                                        child : SizedBox(
                                          child: MaterialButton(
                                            child: Text("Book Now", style: TextStyle(fontSize: 20),),
                                            padding: EdgeInsets.all(7.0),
                                            minWidth: 350,
                                            color: Colors.blueGrey,
                                            onPressed: () async{
                                              if(_isVisible==true)
                                                {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => Schedule()),
                                                  );
                                                }
                                              else{
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => Authenticate()),
                                                );
                                              }

                                            },
                                          ),
                                        )
                                    ),
                                  )
                            ],
                          ),
                        )
                      ],
                    ),
              );
                }
        ),
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
          Text(
              "Image 1",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
              )
          ),
          Text(
              "Image 1",
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
              "Image 2",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
              )
          ),
          Text(
              "Image 2",
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
              "Image 4",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold
              )
          ),
          Text(
              "Image 4",
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