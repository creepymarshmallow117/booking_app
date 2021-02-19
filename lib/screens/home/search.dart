//This is the search result page.

import 'dart:ffi';

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/authenticate/login.dart';
import 'package:booking_app/screens/home/slots.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("client").doc(widget.id).snapshots(),
      builder: (context, snapshot) {
        if(snapshot.data == null) return CircularProgressIndicator();
        DocumentSnapshot data = snapshot.data;
        String groundName = data.data()["groundName"];
        String groundAddress = data.data()["address"];
        String groundDescription = data.data()["description"];
        String groundContactInfo = data.data()["contactInfo"];
        String hours = data.data()["hours"];
        List groundImages = data.data()["groundImages"];
        print(groundName);
        print(groundContactInfo);
        print(groundDescription);
        print(groundAddress);
        print(hours);
        print(groundImages);
        List cardList=[
          Item1(image : groundImages[0]),
          Item2(image : groundImages[1]),
          Item3(image : groundImages[2]),
          Item4(image : groundImages[3])
        ];
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            title: Text(" "),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.search, color: Colors.white,),iconSize : 30,onPressed:() {
                showSearch(context: context, delegate: Datasearch());
              }),
            ],
          ),
          drawer : Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                  ),
                  child: Text('Welcome User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home, color: Colors.teal),
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
                    leading: Icon(Icons.message, color: Colors.teal),
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
                      Navigator.pop(context);
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
            body : SingleChildScrollView(
            child : Container(
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
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 7)),
                      Text(
                        groundName,
                        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, fontFamily: 'Montserrat'),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text(
                        groundDescription,
                        style: TextStyle(fontSize: 15,),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text("Hours : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      Text(
                        hours,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text("Contact : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      Text(
                        groundContactInfo,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(padding: EdgeInsets.only(left: 10)),
                      Text("Address : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                      Text(
                        groundAddress,
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      heightFactor: 8.5,
                      child : SizedBox(
                        child: MaterialButton(
                          child: Text("Book Now", style: TextStyle(fontSize: 20, color: Colors.white)),
                          padding: EdgeInsets.all(7.0),
                          minWidth: 350,
                          color: Colors.teal,
                          onPressed: () async{
                            if(_isVisible==true)
                            {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Slots()),
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
                ],
              ),
            ),
            ),
        );
      }
    );
  }
}


class Item1 extends StatelessWidget {
  final String image;
  const Item1( {Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(image, fit: BoxFit.fill)
    );
  }
}

class Item2 extends StatelessWidget {
  final String image;
  const Item2({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(image,fit: BoxFit.fill)
    );
  }
}

class Item3 extends StatelessWidget {
  final String image;
  const Item3({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(image,fit: BoxFit.fill)
    );
  }
}

class Item4 extends StatelessWidget {
  final String image;
  const Item4({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(image,fit: BoxFit.fill)
    );
  }
}
