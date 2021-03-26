import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/screens/home/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Checkout extends StatefulWidget {
  final String clientId;
  final String customerId;
  final String time;
  final String date;
  final String price;

  const Checkout({Key key, this.clientId, this.customerId, this.time, this.date, this.price}) : super(key: key);
  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {


  String radioItem = '';

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
                SizedBox(height: 15.0,),
                Container(
                  height: 400,
                  width: 350,
                  child: Card(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Order Details",
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
                        onTap: () async{
                          final CollectionReference collection = FirebaseFirestore.instance.collection("bookingRecords");
                          await collection.doc().set({
                            'client_id': widget.clientId,
                            'customer_id': widget.customerId,
                            'date' : widget.date,
                            'time' : widget.time,
                            'price' : widget.price,
                            'payment_mode' : radioItem,
                          });
                          Fluttertoast.showToast(msg: "Booking Successfull");
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Home()),
                          );
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