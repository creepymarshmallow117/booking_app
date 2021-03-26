//This is the orders page.

import 'package:booking_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'file:///D:/College/Project/App/lib/screens/home/home.dart';
import 'file:///D:/College/Project/App/lib/screens/home/profile.dart';


class Orders extends StatefulWidget {
  final String uid;
  const Orders({Key key, this.uid}) : super(key: key);
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final AuthService auth = AuthService();
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;

    return Scaffold(
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
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
                            child: new Text('ORDERS',
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
                      height: height1,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("bookingRecords").where("customer_id", isEqualTo: widget.uid).snapshots(),
                        builder: (context,snapshot) {
                          if (snapshot.data == null)
                            return CircularProgressIndicator();
                          else {
                            List orders = List();
                            for (int i = 0; i < snapshot.data.docs.length; i++) {
                              DocumentSnapshot doc = snapshot.data.docs.elementAt(i);
                              orders.add([
                                doc.data()["ground_name"],
                                doc.data()["date"],
                                doc.data()["price"],
                                doc.data()["time"]+":00 - "+(int.parse(doc.data()["time"])+1).toString()+":00",
                                doc.data()["payment_mode"],
                              ]);
                            }
                            print("This is shit"+orders[0][0]);
                            return ListView.builder(
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                        title: Container(
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(orders[index][0]),
                                              Text(orders[index][1]),
                                              Text(orders[index][2]),
                                              Text(orders[index][3]),
                                              Text(orders[index][4]),
                                            ],
                                          ),
                                        )
                                    ),
                                  );
                                }
                            );
                          }
                        },
                      ),
                    )
              ],
            ),
          ),
      ),
          ),
      );
  }
}

/*

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
                          child: new Text('ORDERS',
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
                      height: 300,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("bookingRecords").where("customer_id", isEqualTo: widget.uid).snapshots(),
                        builder: (context,snapshot) {
                          if (snapshot.data == null)
                            return CircularProgressIndicator();
                          else {
                            List orders = List();
                            for (int i = 0; i < snapshot.data.docs.length; i++) {
                              DocumentSnapshot doc = snapshot.data.docs.elementAt(i);
                              orders.add([
                                doc.data()["ground_name"],
                                doc.data()["date"],
                                doc.data()["price"],
                                doc.data()["time"],
                                doc.data()["payment_mode"],
                              ]);
                            }
                            print("This is shit"+orders[0][0]);
                            return ListView.builder(
                              itemCount: orders.length,
                              itemBuilder: (context, index) {
                                return Card(
                                   child: ListTile(
                                      title: Container(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Text(orders[index][0]),
                                            Text(orders[index][1]),
                                            Text(orders[index][2]),
                                            Text(orders[index][3]),
                                            Text(orders[index][4]),
                                          ],
                                        ),
                                      )
                                   ),
                                );
                              }
                            );
                          }
                        },
                      ),
                    )


StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("bookingRecords").where("customer_id", isEqualTo: widget.uid).snapshots(),
        builder: (context,snapshot) {
          if (snapshot.data == null) return CircularProgressIndicator();
          else {
            List orders = List();
            for(int i = 0; i < snapshot.data.docs.length; i++){
              DocumentSnapshot doc = snapshot.data.docs.elementAt(i);
              orders.add([doc.data()["date"], doc.data()["price"], doc.data()["time"], doc.data()["payment_mode"]]);
            }
            }
            ),
 */
