//This is the User's home page.

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/home/search.dart';
import 'package:booking_app/screens/home/ui_helper.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'file:///D:/College/Project/App/lib/screens/home/orders.dart';
import 'file:///D:/College/Project/App/lib/screens/home/profile.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:getwidget/getwidget.dart';


class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home");
  Icon searchIcon = new Icon(Icons.search);
  int _currentIndex = 0;

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


  Future<bool> _onBackPressed() { //For when someone tries to press back on the home screen
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?', style: TextStyle(
                fontFamily: "Kallektif"
            ),),
            content: Text('You are going to exit the application',style: TextStyle(
                fontFamily: "Kallektif-Bold"
            ),),
            actions: <Widget>[
              FlatButton(
                child: Text('NO', style: TextStyle(color: Colors.teal, fontFamily: "Kallektif-Bold")),
                onPressed: () {
                  WidgetsBinding.instance.handlePopRoute();
                  Navigator.of(context).pop(false);
                  imageCache.clear();
                  imageCache.clearLiveImages();
                },
              ),
              FlatButton(
                child: Text('YES', style: TextStyle(color: Colors.teal,fontFamily: "Kallektif-Bold")),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ],
          );
        });
  }

  final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  );

  bool isExpanded = false;


  String name = "";
  String email = "";
  String uid1 = "";
  String image = "";
  int _current;

  final List<String> imageList = [ //Images for carousel slider
    "assets/images/Offers/1.jpeg",
    "assets/images/Offers/2.jpeg",
    "assets/images/Offers/3.jpeg",
  ];

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService(); //Handles all the authentication
    final DatabaseService db = DatabaseService(); //Handles the work related to database
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
    imageCache.clear(); //To show
    imageCache.clearLiveImages();
    imageCache.clear(); //To show
    imageCache.clearLiveImages();
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("client").orderBy("groundName").snapshots(),
        builder: (context,snapshot) {
          if(snapshot.data == null) return CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
          );
          List<String> suggestionList = List<String>();
          for (int i = 0; i < snapshot.data.docs.length; i++) {
            DocumentSnapshot data = snapshot.data.docs.elementAt(i);
            suggestionList.add(data.data()['groundName']);
          }
          List<String> idList = List<String>();
          for (int i = 0; i < snapshot.data.docs.length; i++) {
            DocumentSnapshot data = snapshot.data.docs.elementAt(i);
            for (int j = 0; j < suggestionList.length; j++) {
              if (data.data()['groundName'] ==
                  suggestionList.elementAt(j)) {
                idList.add(data.id);
              }
            }
          }
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: Text("Home", style: TextStyle(color: Colors.white, fontFamily: 'Kollektif', fontSize: 22)),
              actions: <Widget>[
                IconButton(icon: Icon(Icons.search, color: Colors.white,),
                    iconSize: 30,
                    onPressed: () {
                      showSearch(context: context, delegate: Datasearch());
                    }),
              ],
            ),
            drawer: Drawer(
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
                                fontFamily: 'Kollektif',
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
                              fontFamily: 'Kollektif',
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
                              accountName: Text(name, style: TextStyle(fontFamily: 'Kollektif',),),
                              accountEmail: Text(email, style: TextStyle(fontFamily: 'Kollektif',),),
                              currentAccountPicture: CircleAvatar(backgroundImage: FirebaseImage(image), backgroundColor: Colors.teal,),
                            )
                        );
                      }
                  ),
                  ListTile(
                    leading: Icon(Icons.home, color: Colors.teal),
                    title: Text('Home', style: TextStyle(fontFamily: 'Kollektif'),),
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
                      leading: Icon(Icons.shopping_cart_rounded, color: Colors.teal),
                      title: Text('Bookings', style: TextStyle(fontFamily: 'Kollektif')),
                      onTap: () async{
                        DocumentSnapshot doc = await db.getDocument(user.uid);
                        Navigator.pop(context);
                        Navigator.push( context,
                          MaterialPageRoute(builder: (context) => Orders(uid: user.uid, userDoc: doc,)),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: ListTile(
                      leading: Icon(Icons.settings, color: Colors.teal),
                      title: Text('Settings', style: TextStyle(fontFamily: 'Kollektif')),
                      onTap: () async {
                        if (user != null) {
                          imageCache.clear();
                          print("Inside here");
                          dynamic result = await db.getDocument(user.uid
                              .toString());
                          if (result == null) {
                            print("This is a problem");
                          }
                          else {
                            print(result);
                            Navigator.pop(context);
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>
                                  Profile(userDocument: result)),
                            );
                          }
                        }
                        else {
                          print("This is a big problem");
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: ListTile(
                      leading: Icon(Icons.logout, color: Colors.teal),
                      title: Text('Log Out',style: TextStyle(fontFamily: 'Kollektif')),
                      onTap: () {
                        Navigator.pop(context);
                        auth.signOut();
                      },
                    ),
                  ),
                  Visibility(
                    visible: !_isVisible,
                    child: ListTile(
                      leading: Icon(Icons.account_circle, color: Colors.teal),
                      title: Text('Login/Sign up', style: TextStyle(fontFamily: 'Kollektif')),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              Authenticate()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            body: WillPopScope(
                onWillPop: _onBackPressed,
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        GFCarousel(
                          autoPlay: true,
                          autoPlayAnimationDuration: Duration(seconds: 1),
                          height: 200,
                          items: imageList.map(
                                (url) {
                              return Container(
                                width: 1000,
                                margin: EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  image: DecorationImage(
                                    image: AssetImage(url),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onPageChanged: (index) {
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: imageList.map((image) {
                            int index=imageList.indexOf(image);
                            return Container(
                              width: 8.0,
                              height: 8.0,
                              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _current == index
                                      ? Colors.teal
                                      : Colors.grey
                              ),
                            );
                          },
                          ).toList(), // this was the part the I had to add
                        ),
                        SizedBox(height: 5.0,),
                        StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection("topplaces").doc("VEZwlQ3dgtlO8dX6HPe2").snapshots(),
                            builder: (context,snapshots) {
                              if (snapshots.data == null)
                                return CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                                );
                              else {
                                List topPlaces = List();
                                topPlaces = (snapshots.data['top']);
                                print(topPlaces);
                                return Container(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 5,),
                                      Container(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 20),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Trending Now",
                                                style: TextStyle(
                                                  fontFamily: 'Kollektif', fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      UIHelper.verticalSpaceMedium(),
                                      Divider(
                                        color: Colors.grey,
                                        indent: 20,
                                        endIndent: 20,
                                      ),
                                      StreamBuilder<DocumentSnapshot>(
                                          stream: topPlaces.length > 0 ? FirebaseFirestore.instance.collection("client").doc(topPlaces[0].toString()).snapshots() : null,
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null) return CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                                            );
                                            String groundName = snapshot.data["groundName"];
                                            String hours = snapshot.data["hours"];
                                            String imageUrl = snapshot.data["groundImages"][0];
                                            String description = snapshot.data["description"];
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(10, 15, 10, 0),
                                              height: 260,
                                              width: double.maxFinite,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Search(id: topPlaces[0],customer_name: name)),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                  child: Card(
                                                    elevation: 5.0,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: 190,
                                                          width: double.maxFinite,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(
                                                              topLeft: Radius.circular(5),
                                                              topRight: Radius.circular(5),
                                                            ),
                                                            image: DecorationImage(
                                                              image: NetworkImage(imageUrl),
                                                              fit: BoxFit.fill,
                                                            )
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                            width: double.maxFinite,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(5),
                                                                topRight: Radius.circular(5),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              mainAxisSize: MainAxisSize.max,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Text(
                                                                      groundName,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Kollektif',
                                                                        fontSize: 18,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      hours,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: 'Kollektif-Bold',
                                                                      ),
                                                                    )

                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                      StreamBuilder<DocumentSnapshot>(
                                          stream: topPlaces.length > 1
                                              ? FirebaseFirestore.instance
                                              .collection("client").doc(
                                              topPlaces[1].toString()).snapshots()
                                              : null,
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null)
                                              return CircularProgressIndicator(
                                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                                              );
                                            String groundName = snapshot.data["groundName"];
                                            String hours = snapshot.data["hours"];
                                            String imageUrl = snapshot.data["groundImages"][0];
                                            String description = snapshot.data["description"];
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(10, 18, 10, 0),
                                              height: 260,
                                              width: double.maxFinite,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Search(id: topPlaces[1], customer_name: name)),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                  child: Card(
                                                    elevation: 5.0,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: 190,
                                                          width: double.maxFinite,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(5),
                                                                topRight: Radius.circular(5),
                                                              ),
                                                              image: DecorationImage(
                                                                image: NetworkImage(imageUrl),
                                                                fit: BoxFit.fill,
                                                              )
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                            width: double.maxFinite,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(5),
                                                                topRight: Radius.circular(5),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              mainAxisSize: MainAxisSize.max,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Text(
                                                                      groundName,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Kollektif',
                                                                        fontSize: 18,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      hours,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: 'Kollektif-Bold',
                                                                      ),
                                                                    )

                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                      StreamBuilder<DocumentSnapshot>(
                                          stream: topPlaces.length > 2 ? FirebaseFirestore.instance.collection("client").doc(topPlaces[2].toString()).snapshots()
                                              : null,
                                          builder: (context, snapshot) {
                                            if (snapshot.data == null) return CircularProgressIndicator(
                                              valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                                            );
                                            String groundName = snapshot.data["groundName"];
                                            String hours = snapshot.data["hours"];
                                            String imageUrl = snapshot.data["groundImages"][0];
                                            String description = snapshot.data["description"];
                                            return Container(
                                              margin: EdgeInsets.fromLTRB(10, 18, 10, 0),
                                              height: 260,
                                              width: double.maxFinite,
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Search(id: topPlaces[2], customer_name: name)),
                                                  );
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                                  child: Card(
                                                    elevation: 5.0,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          height: 190,
                                                          width: double.maxFinite,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(5),
                                                                topRight: Radius.circular(5),
                                                              ),
                                                              image: DecorationImage(
                                                                image: NetworkImage(imageUrl),
                                                                fit: BoxFit.fill,
                                                              )
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                                            width: double.maxFinite,
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.only(
                                                                topLeft: Radius.circular(5),
                                                                topRight: Radius.circular(5),
                                                              ),
                                                            ),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              mainAxisSize: MainAxisSize.max,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: <Widget>[
                                                                Column(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[
                                                                    Text(
                                                                      groundName,
                                                                      style: TextStyle(
                                                                        fontFamily: 'Kollektif',
                                                                        fontSize: 18,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      hours,
                                                                      style: TextStyle(
                                                                        fontSize: 14,
                                                                        fontFamily: 'Kollektif-Bold',
                                                                      ),
                                                                    )

                                                                  ],
                                                                )

                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                      ),
                                    ],
                                  ),
                                );
                              }
                            }
                        ),

                      ],
                    ),
                  ),
                )
            ),
          );
        }
    );
  }
}



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
                  if(snapshot.data == null) return CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                  );
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
                      ? Center(child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                  ))
                      :ListView.builder(
                      itemCount: searchList.length,
                      itemBuilder: (context,index){
                        return ListTile(
                          title: Text(searchList.elementAt(index), style: TextStyle(fontFamily: 'Kollektif',),),
                          onTap: (){
                            String id = snapshot.data.docs.elementAt(index).id;
                            print(index);
                            print(id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Search(id: idList.elementAt(index),)),
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


/*



Card(
                                                child: Row(
                                                  children: <Widget>[
                                                    SizedBox(width: 10.0,height: 10.0),
                                                    Image(
                                                        height: 150.0,
                                                        width: 180.0,
                                                        image: NetworkImage(imageUrl)
                                                    ),
                                                    Column(
                                                      children: [
                                                        SizedBox(height: 15),
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child : Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: <Widget>[
                                                              Text("Name : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                                              Text(
                                                                groundName,
                                                                style: TextStyle(fontSize: 15),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            Text("Contact : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                                            Text(
                                                              contactInfo,
                                                              style: TextStyle(fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 5),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: <Widget>[
                                                            Padding(padding: EdgeInsets.only(left : 3,top: 10,)),
                                                            Text("Hours : ",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                                                            Text(
                                                              hours,
                                                              style: TextStyle(fontSize: 15),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                elevation: 5,
                                              ),




Future verification() async {
    if (!user.emailVerified) {
      await user.sendEmailVerification();
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
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
        }
        );
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