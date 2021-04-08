import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditClientProfile extends StatefulWidget {
  final String editFieldChoice;
  const EditClientProfile({Key key, this.editFieldChoice}) : super(key: key);
  @override
  _EditClientProfileState createState() => _EditClientProfileState();
}

class _EditClientProfileState extends State<EditClientProfile> {
  String drpOption1 = '00:00 AM';
  String drpOption2 = '00:00 AM';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if(widget.editFieldChoice == 'description'){
      String description = '';
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              TextFormField(
                onChanged: (val){
                  description = val;
                  },
                decoration: InputDecoration(
                    hintText: 'Enter Description',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                          // hintText: 'EMAIL',
                          // hintStyle: ,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal))),
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
                child: Container(
                  height: 40.0,
                  width: 300.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.tealAccent,
                    color: Colors.teal,
                    elevation: 5.0,
                    child: GestureDetector(
                      onTap: () async{
                        CollectionReference col = FirebaseFirestore.instance.collection("client");
                         col.doc(user.uid).update({
                          'description': description
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child : Text('SUBMIT', textAlign: TextAlign.center,
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
            ],
          ),
        ),
      );
      }else if(widget.editFieldChoice == 'prices'){
      String mornPrice = '';
      String evePrice = '';
      return Scaffold(
        appBar: AppBar(),
        body: Container(
          child:  Column(
            children: <Widget>[
              SizedBox(
                height:  100,
              ),
              TextFormField(
                onChanged: (val){
                  mornPrice = val;
                },
                decoration: InputDecoration(
                    hintText: 'Morning price',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    // hintText: 'EMAIL',
                    // hintStyle: ,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal))),
              ),
              TextFormField(
                onChanged: (val){
                  evePrice = val;
                },
                decoration: InputDecoration(
                    hintText: 'Evening price',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.grey),
                    // hintText: 'EMAIL',
                    // hintStyle: ,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.teal))),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
                child: Container(
                  height: 40.0,
                  width: 300.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.tealAccent,
                    color: Colors.teal,
                    elevation: 5.0,
                    child: GestureDetector(
                      onTap: () async{
                        CollectionReference col = FirebaseFirestore.instance.collection("client");
                        col.doc(user.uid).update({
                          'morningPrice': mornPrice,
                          'eveningPrice': evePrice
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child : Text('SUBMIT', textAlign: TextAlign.center,
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
            ],
          ),
        ),
      );
    }else if(widget.editFieldChoice == 'timing'){
      List<String> timing = List<String>();
      List<String> timingInternal = List<String>();
      for(int i = 0; i <= 24; i++){
        timingInternal.add(i.toString());
        if(i < 12){
          timing.add(i.toString() +':00 AM');

        }else if (i == 12){
          timing.add('12:00 PM');
        }
        else if(i > 12){
          if(i == 24){
            timing.add('12:00 AM');
          }else{
            timing.add((i-12).toString()+':00 PM');
          }
        }
      }

      return Scaffold(
        appBar: AppBar(

        ),
        body: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Row(
                children: <Widget>[
              DropdownButton<String>(
              value: drpOption1,
                icon: const Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (value){
                setState(() {
                  drpOption1 = value;
                });
                },
                items: timing.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()
              ),
                  SizedBox(
                    height: 100,
                    width: 100,
                  ),
                  DropdownButton<String>(
                      value: drpOption2,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (value){
                        setState(() {
                          drpOption2 = value;
                        });
                      },
                      items: timing.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList()
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 50.0, right: 50.0),
                child: Container(
                  height: 40.0,
                  width: 300.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.tealAccent,
                    color: Colors.teal,
                    elevation: 5.0,
                    child: GestureDetector(
                      onTap: () async{
                        int index1 = timing.indexOf(drpOption1);
                        int index2 = timing.indexOf(drpOption2);
                        CollectionReference col = FirebaseFirestore.instance.collection("client");
                        col.doc(user.uid).update({
                          'startHour': timingInternal.elementAt(index1),
                          'endHour': timingInternal.elementAt(index2),
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        child : Text('SUBMIT', textAlign: TextAlign.center,
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
            ],
          ),
        ),
      );
    }
  }
}
