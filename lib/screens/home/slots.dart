//This is the schedule page.

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/home/profile.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:table_calendar/table_calendar.dart' ;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:booking_app/screens/home/checkout.dart';


import 'cart.dart';
import 'checkout.dart';
import 'home.dart';
import 'orders.dart';

class Slots extends StatefulWidget {
  final String uid;
  final String groundName;
  final String startHour;
  final String endHour;
  final String morningPrice;
  final String eveningPrice;
  const Slots({Key key, this.startHour, this.groundName,this.endHour, this.uid, this.morningPrice, this.eveningPrice}) : super(key: key);

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  bool _isVisible = false;
  Widget appBarTitle = new Text(" ");


  CalendarController _controller;
  DateTime today = DateTime.now();
  DateTime endDate;
  DateFormat formatter = DateFormat("dd-MM-yyy");
  String currentDate;
  String selectedDate;
  String name;
  String currentTime;
  String time1;
  String time2;

  void _onDaySelected(DateTime date) {
    setState(() {
      selectedDate = formatter.format(date);
      print(selectedDate);
    });
  }

 @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _onDaySelected(today);
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


    currentTime = DateFormat.H().format(today);

    currentDate = formatter.format(today);
    endDate = today.add(Duration(days: 7));

    DateTime lastDay(DateTime dateTime) {
      return dateTime.add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
    }
    double startHour = double.parse(widget.startHour);
    double endHour = double.parse(widget.endHour);
    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            height: height1,
            color: Colors.white,
            child: Column(
              children: [
                      Padding(padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            GestureDetector(
                              child: new Icon(
                                Icons.arrow_back_ios,
                                color: Colors.teal,
                                size: 22.0,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                          ),
                        Padding(
                        padding: EdgeInsets.only(left: 25.0),
                          child: new Text('SLOTS',
                            style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'Kollektif',
                            color: Colors.teal)),
                          )
                      ],
                  ),
                ),

                SizedBox(height: 15.0,),
                Column(
                    children: [
                    StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection("user").doc(user.uid).snapshots(),
                    builder: (context, snapshot) {
                        if(snapshot.data == null) return CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                        );
                        else {
                          name = snapshot.data['displayName'];
                          return TableCalendar(
                            calendarController: _controller,
                            initialCalendarFormat: CalendarFormat.week,
                            startDay: today,
                            startingDayOfWeek: StartingDayOfWeek.monday,
                            initialSelectedDay: today,
                            calendarStyle: CalendarStyle(
                              weekdayStyle: TextStyle(
                                fontFamily: 'Kollektif',
                              ),
                              weekendStyle: TextStyle(
                                fontFamily: 'Kollektif',
                              ),
                              eventDayStyle: TextStyle(
                                fontFamily: 'Kollektif',
                              ),
                              todayColor: Colors.teal,
                              selectedColor: Colors.teal.shade100,
                            ),
                            headerStyle: HeaderStyle(
                                centerHeaderTitle: true,
                                rightChevronVisible: false,
                                leftChevronVisible: false,
                                formatButtonVisible: false,
                                headerPadding: EdgeInsets.only(bottom: 15.0),
                                titleTextStyle: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Kollektif',
                                  fontWeight: FontWeight.bold,
                                )
                            ),
                            onDaySelected: (DateTime date, List event1,
                                List event2) {
                              _onDaySelected(date);
                            },
                          );
                        }
                      }
                      ),
                      Container(
                        height: 670,
                        child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection("bookingRecords").where("date", isEqualTo: selectedDate).where("client_id", isEqualTo: widget.uid).snapshots(),
                            builder: (context, snapshot) {
                              print(selectedDate);
                              if(snapshot.data == null) return CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                              );
                              else{
                                List availSlots= List();
                                List availSlotsInternal = List();
                                List bookedSlots = List();
                                List next7days = List();
                                for(int i = 0; i < snapshot.data.docs.length; i++){
                                  DocumentSnapshot doc = snapshot.data.docs.elementAt(i);
                                  bookedSlots.add(int.parse(doc.data()["time"]));
                                }
                                for(int i = selectedDate==currentDate ? int.parse(currentTime)+1 : int.parse(widget.startHour); i < int.parse(widget.endHour); i++){
                                  if(bookedSlots.contains(i)){
                                    continue;
                                  }
                                  else{
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
                                    int i1 = i+1;
                                    availSlotsInternal.add(i.toString());
                                    availSlots.add(time + " - "+ time1);
                                  }
                                }
                                for(int i = 0; i < availSlots.length; i++){
                                  print(availSlots.elementAt(i));
                                }
                                for(int i = 1; i < 8; i++){
                                  if(i == 1){
                                    DateTime toD = DateTime.now();
                                    DateFormat formatter1 = DateFormat("dd-MM-yyyy");
                                    String finalNeededDate = formatter1.format(toD);
                                    next7days.add(finalNeededDate);
                                  }else{
                                    DateTime toD = DateTime.now();
                                    DateTime neededDate = toD.add(Duration(days: i-1));
                                    DateFormat formatter1 = DateFormat("dd-MM-yyyy");
                                    String finalNeededDate = formatter1.format(neededDate);
                                    next7days.add(finalNeededDate);
                                  }
                                }
                                for(int i = 0; i < next7days.length; i++){
                                  print(i);
                                  print(next7days.elementAt(i));
                                }
                                return ListView.builder(
                                        itemCount: availSlots.length,
                                        itemBuilder: (context, index){
                                          return Card(
                                              color: Colors.teal,
                                              margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
                                              child: ListTile(
                                                title: Text(availSlots.elementAt(index), style: TextStyle(color: Colors.white,fontFamily: 'Kollektif'),),
                                                onTap: () {
                                                Navigator.push(context,
                                                MaterialPageRoute(
                                                builder: (context) =>
                                                Checkout(clientId: widget.uid, customerId: user.uid, customerName: name ,groundName: widget.groundName ,time: availSlotsInternal.elementAt(index), date: selectedDate==null ? currentDate : selectedDate, price: int.parse(availSlotsInternal.elementAt(index))<17 ? widget.morningPrice : widget.eveningPrice)));
                                                },
                                              ),
                                            );
                                        });
                              }
                            }
                        ),
                      ),

                    ],
                  ),
            ],
        ),
      ),
      ),
    ),
    );
      }
}


/*

Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 50.0, right: 50.0),
                  child: Container(
                    height: 40.0,
                    width: 350.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.tealAccent,
                      color: Colors.teal,
                      elevation: 5.0,
                      child: GestureDetector(
                        onTap: () async{

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child : Text('PROCEED TO CHECKOUT', textAlign: TextAlign.center,
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



Container(
                  height: 690,
                  child: TableCalendar(
                    calendarController: _controller,
                    initialCalendarFormat: CalendarFormat.week,
                    startDay: today,
                    endDay: lastDay(today),
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    initialSelectedDay: today,
                    calendarStyle: CalendarStyle(
                      todayColor: Colors.teal,
                      selectedColor: Colors.teal,
                    ),
                    headerStyle: HeaderStyle(
                      centerHeaderTitle: true,
                      rightChevronVisible: false,
                      leftChevronVisible: false,
                      formatButtonVisible: false,
                      headerPadding: EdgeInsets.only(bottom: 15.0),
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )
                    ),


                  ),
                ),
 */



