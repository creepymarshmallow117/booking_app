import 'package:booking_app/screens/home/ui_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:booking_app/screens/home/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'custom_divider_view.dart';

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
  String error = '';
  bool _clicked = true;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    int time = int.parse(widget.time);
    String time1;
    String time2;
    if(time < 12)
      {
        time1 = time.toString()+':00 AM';
        time2 = (time+1).toString() + ':00 AM';
        if(time+1 == 12)
          {
            time2 = '12:00 PM';
          }
      }else if (time == 12){
      time1 = '12:00 PM';
      time2 = (1).toString() + ':00 PM';
    }
    else if(time > 12){
      if(time == 24){
        time1 = '12:00 AM';
        time2 = (1).toString() + ':00 AM';
      }else{
        time1 = (time-12).toString() + ':00 PM';
        time2 = ((time-12)+1).toString() + ':00 PM';
      }
    }



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Padding(
          padding: EdgeInsets.only(top: 2.0),
          child: Text('CHECKOUT',
              style: TextStyle(
                  fontSize: 20.0,
                  fontFamily: 'Kollektif',
                  color: Colors.teal)),
        ),
        leading: Padding(padding: EdgeInsets.only(left: 10.0),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
            ],
          ),
        ),
      ),
      body : SingleChildScrollView(
        child: SafeArea(
          child : Container(
            color: Colors.white,
            child: Column(
              children: <Widget>[
                SizedBox(height: 20.0,),
                Container(
                  height: 450,
                  width: 400,
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.0, left: 5.0),
                              child: Text(
                                "Order Details".toUpperCase(),
                                style: TextStyle(
                                  fontFamily: 'Kollektif', fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        UIHelper.verticalSpaceMedium(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("Place Name ",style: TextStyle(fontSize: 17, fontFamily: 'Kollektif')),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall(),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 5.0)),
                            Text(widget.groundName,style: TextStyle(fontFamily: 'Kollektif-Bold', fontSize: 16, )),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("Date ",style: TextStyle(fontSize: 17,fontFamily: 'Kollektif',)),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall(),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 5.0)),
                            Text(widget.date,style: TextStyle(fontFamily: 'Kollektif-Bold', fontSize: 16, )),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(left: 5)),
                            Text("Time ",style: TextStyle(fontSize: 17,fontFamily: 'Kollektif',)),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall(),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 5.0)),
                            Text(time1+" - "+time2,style: TextStyle(fontFamily: 'Kollektif-Bold', fontSize: 16,)),
                          ],
                        ),
                        UIHelper.verticalSpaceSmall(),
                        Divider(
                          color: Colors.grey,
                        ),
                        SizedBox(height: 5.0,),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 5.0)),
                            Text("Total ".toUpperCase(),style: TextStyle(fontSize: 16,fontFamily: 'Kollektif', fontWeight: FontWeight.bold)),
                            Spacer(),
                            Padding(padding : EdgeInsets.only(right: 5.0),
                                child: Text(widget.price+"rs",style: TextStyle(fontFamily: 'Kollektif-Bold', fontSize: 16))),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Divider(
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5.0, left: 5.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                             children: [
                               Text(
                                 "Payment Options",
                                 style: TextStyle(
                                   fontFamily: 'Kollektif', fontSize: 18,
                                 ),
                               )
                             ],
                          ),
                        ),
                        SizedBox(height: 15.0,),
                        Container(
                          child: Flexible(
                              fit: FlexFit.loose,
                              child: RadioListTile(
                                  title: Text("Cash", style: TextStyle(fontFamily: 'Kollektif',),),
                                  activeColor: Colors.teal,
                                  value: "Cash",
                                  groupValue: radioItem,
                                  onChanged: (val) {
                                    setState(() {
                                      radioItem = val;
                                    });
                                  }
                              ),
                          )
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: RadioListTile(
                              selected: false,
                              title: Text("Online Payment", style: TextStyle(color: Colors.grey, fontFamily: 'Kollektif',),),
                              value: "Online Payment",
                              groupValue: radioItem,
                              onChanged: (val) {
                                Fluttertoast.showToast(msg: "Coming Soon");
                              }
                          ),
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
                            if (radioItem == '') {
                              setState(() {
                                error = "Please select payment mode";
                                _clicked = true;
                              });
                            }
                            else {
                              Dialogs.showLoadingDialog(context, _keyLoader);
                              final CollectionReference collection = FirebaseFirestore.instance.collection("bookingRecords");
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
                              Fluttertoast.showToast(
                                  msg: "Booking Successfull");
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            }
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child : Text('BOOK SLOT', textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Kollektif',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15.0,),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0, fontFamily: 'Kollektif',),
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

/*
Container(
                              width: 50,
                              child: RadioListTile(
                                  title: Text("Cash"),
                                  value: "Cash",
                                  groupValue: radioItem,
                                  onChanged: (val) {
                                    setState(() {
                                      radioItem = val;
                                    });
                                  }
                              ),
                            ),
                            Container(
                              width: 50,
                              child: RadioListTile(
                                  selected: false,
                                  title: Text("Online Payment", style: TextStyle(color: Colors.grey),),
                                  value: "Online Payment",
                                  groupValue: radioItem,
                                  onChanged: (val) {
                                    Fluttertoast.showToast(msg: "Coming Soon");
                                  }
                              ),
                            ),




 */