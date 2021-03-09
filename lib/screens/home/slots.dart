//This is the schedule page.

import 'package:booking_app/screens/authenticate/authenticate.dart';
import 'package:booking_app/screens/home/profile.dart';
import 'package:booking_app/services/auth.dart';
import 'package:booking_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:table_calendar/table_calendar.dart' ;
import 'package:shared_preferences/shared_preferences.dart';


import 'cart.dart';
import 'home.dart';
import 'orders.dart';

class Slots extends StatefulWidget {
  final String startHour;
  final String endHour;
  const Slots({Key key, this.startHour, this.endHour}) : super(key: key);

  @override
  _SlotsState createState() => _SlotsState();
}

class _SlotsState extends State<Slots> {
  bool _isVisible = false;
  Widget appBarTitle = new Text(" ");


  CalendarController _controller;

 @override
  void initState() {
    super.initState();
    _controller = CalendarController();
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
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            fontFamily: 'sans-serif-light',
                            color: Colors.teal)),
                          )
                      ],
                  ),
                ),
                SizedBox(height: 15.0,),
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

                Padding(
                  padding: const EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
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
            ],
        ),
      ),
      ),
    ),
    );
      }
}




