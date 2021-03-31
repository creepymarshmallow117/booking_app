import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/screens/home/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Checkout extends StatefulWidget {
  final String clientId;
  final String customerId;
  final String customerName;
  final String groundName;
  final String time;
  final String date;
  final String price;

  const Checkout({Key key, this.clientId, this.customerId, this.customerName, this.groundName,this.time, this.date, this.price}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {


  String radioItem = '';
  bool _clicked = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    String time = widget.time;
    int time1 = int.parse(time) + 1;


    return Scaffold(
      body : SingleChildScrollView(
        child: SafeArea(
          child : Container(
              height: height1,
            child: Column(
              children: <Widget>[
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
                        child: new Text('CHECKOUT',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontFamily: 'sans-serif-light',
                                color: Colors.teal)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  height: 600,
                  width: 400,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Order Summary",
                            style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 5.0)),
                            Text("Date : ",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                            Text(widget.date,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 5.0)),
                            Text("Time : ",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                            Text(time+":00 - "+time1.toString()+":00",style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 5.0)),
                            Text("Price : ",style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
                            Text(widget.price,style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18)),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, left: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 "Payment Options",
                                 style: TextStyle(
                                   fontWeight: FontWeight.w600, fontSize: 18,
                                 ),
                               )
                             ],
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        RadioListTile(
                            title: Text("Cash"),
                            value: "Cash",
                            groupValue: radioItem,
                            onChanged: (val) {
                              setState(() {
                                radioItem = val;
                              });
                            }
                        ),
                        RadioListTile(
                            selected: false,
                              title: Text("Online Payment", style: TextStyle(color: Colors.grey),),
                              value: "Online Payment",
                              groupValue: radioItem,
                              onChanged: (val) {
                                Fluttertoast.showToast(msg: "Coming Soon");
                            }
                        ),
                      ],
                    ),
                  ),
                ),
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
                        onTap: () async {
                          if (_clicked == true) {
                            setState(() {
                              _clicked = false;
                            });
                            Dialogs.showLoadingDialog(context, _keyLoader);
                            final CollectionReference collection = FirebaseFirestore
                                .instance.collection("bookingRecords");
                            await collection.doc().set({
                              'client_id': widget.clientId,
                              'customer_id': widget.customerId,
                              'customer_name': widget.customerName,
                              'ground_name': widget.groundName,
                              'date': widget.date,
                              'time': widget.time,
                              'price': widget.price,
                              'payment_mode': radioItem,
                            });
                            Fluttertoast.showToast(msg: "Booking Successfull");
                            Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()),
                            );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child : Text('BOOK SLOT', textAlign: TextAlign.center,
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
            )
        ),
      ),
      ),
    );
  }
}

class Dialogs {
  static Future<void> showLoadingDialog(
      BuildContext context, GlobalKey key) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Center(
                      child: Column(children: [
                        CircularProgressIndicator(
                         valueColor: new AlwaysStoppedAnimation<Color>(Colors.teal),
                        ),
                        SizedBox(height: 10,),
                        Text("Please Wait....",style: TextStyle(color: Colors.black),)
                      ]),
                    )
                  ]));
        });
  }
}