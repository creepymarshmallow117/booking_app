//This is the Client's home page.

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/home/custom_divider_view.dart';
import 'package:booking_app/screens/home/home.dart';
import 'package:booking_app/screens/home/slots1.dart';
import 'package:booking_app/screens/home/ui_helper.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'clientCheckout.dart';
import 'orders.dart';
import 'clientProfile.dart';
import 'package:provider/provider.dart';


class Home1 extends StatefulWidget{
  @override
  _Home1State createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home",style: TextStyle(fontFamily: "Kallektif"));
  int _currentIndex=0;


  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?', style: TextStyle(fontFamily: "Kallektif")),
            content: Text('You are going to exit the application',style: TextStyle(fontFamily: "Kallektif-Bold")),
            actions: <Widget>[
              FlatButton(
                child: Text('NO', style: TextStyle(color: Colors.teal,fontFamily: "Kallektif-Bold")),
                onPressed: () {
                  WidgetsBinding.instance.handlePopRoute();
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('YES', style: TextStyle(color: Colors.teal,fontFamily: "Kallektif-Bold"),),
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

    DateTime today = DateTime.now();
    DateFormat formatter = DateFormat("dd-MM-yyy");
    String todayDate = formatter.format(today);

    String currentTime = DateFormat.H().format(today);

    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("Home", style: TextStyle(color: Colors.white, fontFamily: 'Kollektif', fontSize: 22)),
      ),
      drawer : Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(decoration: BoxDecoration(
              color: Colors.teal,
            ),
              accountName: Text("Welcome!", style: TextStyle(
                fontFamily: 'Kollektif',
                fontSize: 25.0,
              ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.teal),
              title: Text('Home', style: TextStyle(fontFamily: 'Kollektif'),),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Home1()),
                );
              },
            ),
            Visibility(
              visible: _isVisible,
              child: ListTile(
                leading: Icon(Icons.history_edu, color: Colors.teal),
                title: Text('Slots',style: TextStyle(fontFamily: 'Kollektif')),
                onTap: () async {
                  CollectionReference collection = FirebaseFirestore.instance.collection(
                      "client");
                  DocumentSnapshot doc = await collection.doc(user.uid).get();
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Slots1(groundName: doc.data()['groundName'], startHour: doc.data()['startHour'], endHour: doc.data()['endHour'], morningPrice: doc.data()['morningPrice'], eveningPrice: doc.data()['eveningPrice'],)),
                  );
                },
              ),
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
                            ClientProfile(userDocument: result)),
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
      body : WillPopScope(
          onWillPop: _onBackPressed,
          child : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: StreamBuilder<DocumentSnapshot>(
                            stream: user != null ?FirebaseFirestore.instance.collection("client").doc(user.uid).snapshots() : null,
                            builder: (context,snapshot){
                              DocumentSnapshot data = snapshot.data;
                              return StreamBuilder<QuerySnapshot>(
                                  stream: user != null? FirebaseFirestore.instance.collection("bookingRecords").where("date", isEqualTo: todayDate).where("client_id", isEqualTo: user.uid).snapshots(): null,
                                  builder: (context, snapshot1){
                                    if(snapshot.data != null && snapshot1.data != null){
                                      List bookedSlots = List();
                                      List bookedSlotsDisplay = List();
                                      List availSlots = List();
                                      List availSlotsDisplay = List();
                                      String morningPrice = snapshot.data.data()["morningPrice"];
                                      String eveningPrice = snapshot.data.data()["eveningPrice"];
                                      String groundName = snapshot.data.data()["groundName"];
                                      DateTime today = DateTime.now();
                                      String currentDate = formatter.format(today);
                                      for(int i = 0; i < snapshot1.data.docs.length; i++){
                                        DocumentSnapshot doc = snapshot1.data.docs.elementAt(i);
                                        bookedSlots.add(int.parse(doc.data()["time"]));
                                      }
                                      for(int i = int.parse(currentTime)+1; i < int.parse(data['endHour']); i++){
                                        if(bookedSlots.contains(i)){
                                          String time = '';
                                          String time1 = '';
                                          if(i < 12){
                                            time = i.toString() +':00 AM';
                                            time1 = (i+1).toString() + ':00 AM';
                                            if(i+1 == 12){
                                              time1 = '12:00 PM';
                                            }
                                          }else if (i == 12){
                                            time = '12:00 PM';
                                            time1 = (1).toString() + ':00 PM';
                                          }
                                          else if(i > 12){
                                            if(i == 24){
                                              time = '12:00 AM';
                                              time1 = (1).toString() + ':00 AM';
                                            }else{
                                              time = (i-12).toString() + ':00 PM';
                                              time1 = ((i-12)+1).toString() + ':00 PM';
                                            }
                                          }
                                          bookedSlotsDisplay.add(time + " - "+ time1);
                                        }else{
                                          String time2 = '';
                                          String time3 = '';
                                          if(i < 12){
                                            time2 = i.toString() +':00 AM';
                                            time3 = (i+1).toString() + ':00 AM';
                                            if(i+1 == 12){
                                              time3 = '12:00 PM';
                                            }
                                          }else if (i == 12){
                                            time2 = '12:00 PM';
                                            time3 = (1).toString() + ':00 PM';
                                          }
                                          else if(i > 12){
                                            if(i == 24){
                                              time2 = '12:00 AM';
                                              time3 = (1).toString() + ':00 AM';
                                            }else{
                                              time2 = (i-12).toString() + ':00 PM';
                                              time3 = ((i-12)+1).toString() + ':00 PM';
                                            }
                                            if(i+1 == 24){
                                              time3 = '12:00 AM';
                                            }
                                          }
                                          availSlots.add(i.toString());
                                          availSlotsDisplay.add(time2 + " - "+ time3);
                                        }
                                        for(int i = 0; i < bookedSlotsDisplay.length; i++){
                                          print(bookedSlotsDisplay.elementAt(i));
                                        }
                                        for(int i = 0; i < availSlotsDisplay.length; i++){
                                          print(availSlotsDisplay.elementAt(i));
                                        }
                                      }
                                      return Column(
                                          children: <Widget>[
                                            Container(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Today's Bookings",
                                                      style: TextStyle(
                                                        fontFamily: 'Kollektif', fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey,
                                              indent: 20,
                                              endIndent: 20,
                                            ),
                                            Container(
                                              height : 350,
                                              child: ListView.builder(
                                                  itemCount: bookedSlotsDisplay.length,
                                                  itemBuilder: (context,index){
                                                    return Card(
                                                      color: Colors.grey,
                                                      margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                                                      child: ListTile(
                                                        title: Text(bookedSlotsDisplay.elementAt(index), style: TextStyle(color: Colors.white),),
                                                        onTap: () {

                                                        },
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            UIHelper.verticalSpaceSmall(),
                                            Container(
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 20),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Availaible Slots",
                                                      style: TextStyle(
                                                        fontFamily: 'Kollektif', fontSize: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              color: Colors.grey.shade400,
                                              indent: 20,
                                              endIndent: 20,
                                            ),
                                            Container(
                                              height : 350,
                                              child: ListView.builder(
                                                  itemCount: availSlotsDisplay.length,
                                                  itemBuilder: (context,index){
                                                    return Card(
                                                      color: Colors.teal,
                                                      margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                                                      child: ListTile(
                                                        title: Text(availSlotsDisplay.elementAt(index), style: TextStyle(color: Colors.white),),
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(builder: (context) => clientCheckout(clientId: user.uid, groundName: groundName, price: int.parse(availSlots.elementAt(index))<17 ? morningPrice : eveningPrice, time: availSlots.elementAt(index), date: currentDate, timestamp : today)),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }),
                                            )
                                          ]
                                      );
                                    }else{
                                      return CircularProgressIndicator(
                                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                                      );
                                    }
                                  }
                              );
                            },

                          ),
                        ),
                      ],
                    )
                  )
                ]
            ),
          )
      ),
    );
  }
}





