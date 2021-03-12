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
import 'package:firebase_image/firebase_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
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

  String name = "";
  String email = "";
  String uid1 = "";
  String image = "";

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();

    final user = Provider.of<User>(context);
    if(user == null){
      setState(() {
        _isVisible = false;
        name = "";
        email = "";
        uid1 = "none";
      });
    }else{
      setState(() {
        _isVisible = true;
        email = user.email;
        uid1 = user.uid;
        image = "gs://booking-app-63e61.appspot.com/profileImages/${user.uid}.png";

      });
    }
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - kToolbarHeight;
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
          String startHour = data.data()["startHour"];
          String endHour = data.data()["endHour"];
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
              title: Text(groundName),
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
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance.collection("user").doc(uid1).snapshots(),
                      builder: (context, snapshot) {
                        if(snapshot.data == null) return Container(
                            height: 230.0,
                            child: UserAccountsDrawerHeader(decoration: BoxDecoration(
                              color: Colors.teal,
                            ),
                              accountName: Text("Welcome!", style: TextStyle(
                                fontSize: 25.0,
                              ),
                              ),
                            )
                        );
                        if(user != null){
                          name = snapshot.data['displayName'];
                        }
                        return(_isVisible==false)? Container(
                            height: 230.0,
                            child: UserAccountsDrawerHeader(decoration: BoxDecoration(
                              color: Colors.teal,
                            ),
                              accountName: Text("Welcome!", style: TextStyle(
                                fontSize: 25.0,
                              ),
                              ),
                            )
                        )
                            : Container(
                            height: 230.0,
                            child : UserAccountsDrawerHeader(decoration: BoxDecoration(
                              color: Colors.teal,
                            ),
                              accountName: Text(name),
                              accountEmail: Text(email),
                              currentAccountPicture: CircleAvatar(backgroundImage: FirebaseImage(image)),
                            )
                        );
                      }
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
                      leading: Icon(Icons.settings, color: Colors.teal),
                      title: Text('Settings'),
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
              child : SafeArea(
                child : Container(
                  height: height1,
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
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Expanded(
                            child: Text("Description".toUpperCase(), style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16
                            ),
                          ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Expanded(
                            child: Text(
                              groundDescription,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 15,fontWeight : FontWeight.w300,),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("Hours ".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text(
                            hours,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text("Contact ".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(padding: EdgeInsets.only(left: 5)),
                          Text(
                            groundContactInfo,
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Address ".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(padding: EdgeInsets.only(left: 5),
                        child : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(child: Text(
                              groundAddress,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300,),
                            ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      Container(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 40.0,
                            width: 350.0,
                            child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.tealAccent,
                              color: Colors.teal,
                              elevation: 5.0,
                              child: GestureDetector(
                                onTap: () async {
                                  if (_isVisible == true) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) =>
                                          Slots(startHour: startHour,
                                              endHour: endHour,
                                              uid: widget.id)),
                                    );
                                  }
                                  else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Authenticate()),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 12.0),
                                  child : Text('BOOK NOW', textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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



/*


SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Expanded(
                                child: Text(
                                groundDescription,
                                style: TextStyle(fontSize: 15,fontWeight : FontWeight.w300,),
                              ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(padding: EdgeInsets.only(left: 10)),
                              Text("Hours : ".toUpperCase(),style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                              Text(
                                hours,
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),



drawer : Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection("user").doc(uid1).snapshots(),
                    builder: (context, snapshot) {
                      if(snapshot.data == null) return Container(
                          height: 230.0,
                          child: UserAccountsDrawerHeader(decoration: BoxDecoration(
                            color: Colors.teal,
                          ),
                            accountName: Text("Welcome!", style: TextStyle(
                              fontSize: 25.0,
                            ),
                            ),
                          )
                      );
                      if(user != null){
                        name = snapshot.data['displayName'];
                      }
                      return(_isVisible==false)? Container(
                          height: 230.0,
                          child: UserAccountsDrawerHeader(decoration: BoxDecoration(
                            color: Colors.teal,
                          ),
                            accountName: Text("Welcome!", style: TextStyle(
                              fontSize: 25.0,
                            ),
                            ),
                          )
                      )
                          : Container(
                          height: 230.0,
                          child : UserAccountsDrawerHeader(decoration: BoxDecoration(
                            color: Colors.teal,
                          ),
                            accountName: Text(name),
                            accountEmail: Text(email),
                            currentAccountPicture: CircleAvatar(backgroundImage: FirebaseImage(image)),
                          )
                      );
                    }
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
                    leading: Icon(Icons.settings, color: Colors.teal),
                    title: Text('Settings'),
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

 */