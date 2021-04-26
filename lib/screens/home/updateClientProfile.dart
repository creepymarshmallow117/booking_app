//This is the profiles page.

import 'package:booking_app/Animation/animation1.dart';
import 'package:booking_app/screens/home/home1.dart';
import 'package:booking_app/screens/home/profileImage.dart';
import 'package:booking_app/screens/home/updateTurfImage.dart';
import 'package:booking_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/components/carousel/gf_carousel.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'package:booking_app/services/database.dart';

class updatedClientProfile extends StatefulWidget {
  final DocumentSnapshot userDocument;
  updatedClientProfile({this.userDocument});
  @override
  _updatedClientProfileState createState() => _updatedClientProfileState();
}

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}

class _updatedClientProfileState extends State<updatedClientProfile> {


  final _formKey = GlobalKey<FormState>();
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home");
  Icon searchIcon = new Icon(Icons.search);
  int _currentIndex=0;
  String profileImage;


  Future<void> _pickImage(ImageSource source , String uid) async{
    //function to select image from camera or gallery
    final picker = ImagePicker();
    PickedFile selected = await picker.getImage(source: source);
    if(selected != null){
      Navigator.pop(context);
      Navigator.push(context,
        MaterialPageRoute(builder: (context) => ProfileImage(imageFile: selected, uid: uid)),
      );
    }
  }

  String updateAddress = '';
  String updateDescription = '';
  String updateContactNumber = '';
  String updateMorningPrice = '';
  String updateEveningPrice = '';
  String drpOption1 = '12:00 AM';
  String drpOption2 = '12:00 AM';
  String error = '';
  String drpDownValue1;
  String drpDownValue2;
  int index1 = 0;


  @override
  Widget build(BuildContext context) {
    imageCache.clear();
    imageCache.clearLiveImages();
    final AuthService auth = AuthService();
    final DatabaseService db = DatabaseService();
    final user = Provider.of<User>(context);
    if (user == null) {
      setState(() => _isVisible = false);
    } else {
      setState(() {
        _isVisible = true;
      });
    }
    Future<bool> _onDeletePressed() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Are you sure?',style: TextStyle(fontFamily: "Kollektif")),
              content: Text('You are going to delete your account', style: TextStyle(fontFamily: "Kollektif-Bold")),
              actions: <Widget>[
                FlatButton(
                  child: Text('NO', style: TextStyle(color: Colors.teal, fontFamily: "Kollektif-Bold")),
                  onPressed: () {
                    WidgetsBinding.instance.handlePopRoute();
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: Text('YES', style: TextStyle(color: Colors.teal, fontFamily: "Kollektif-Bold")),
                  onPressed: () {
                    user.delete();
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );
                  },
                ),
              ],
            );
          });
    }

    Future<void> _pickImage(ImageSource source , String uid, String url, int index) async{
      //function to select image from camera or gallery
      final picker = ImagePicker();
      PickedFile selected = await picker.getImage(source: source);
      print("this is the image path:"+selected.path);
      if(selected != null){
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => UpdateTurfImage(imageFile: selected, uid: uid, index: index, url: url)),
        );
      }
    }


    print("this is document id:" + widget.userDocument.data()['displayName']);
    String name = widget.userDocument.data()['groundName'];
    String description = widget.userDocument.data()["description"];
    String contactInfo = widget.userDocument.data()["contactInfo"];
    String address = widget.userDocument.data()["address"];
    String morningPrice = widget.userDocument.data()["morningPrice"];
    String eveningPrice = widget.userDocument.data()["eveningPrice"];
    String email = user.email;


    double height = MediaQuery.of(context).size.height;
    var padding = MediaQuery.of(context).padding;
    double height1 = height - padding.top - padding.bottom;
    profileImage = 'gs://booking-app-63e61.appspot.com/profileImages/${user.uid}.png';
    imageCache.clear();
    imageCache.clearLiveImages();

    List<String> timing = List<String>();
    List<String> timingInternal = List<String>();
    for(int i = 1; i <= 24; i++){
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

    List groundImages = widget.userDocument['groundImages'];

    Future<bool> _onAddPressed() {
      showDialog(context: context, builder: (context){
        return FadeAnimation1(
          0.1, Container(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
            child : Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                new GestureDetector(
                  onTap: () => _pickImage(ImageSource.camera, user.uid, groundImages[index1], index1),
                  child: roundedButton(
                      "CAMERA",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      const Color(0xFF167F67),
                      const Color(0xFFFFFFFF)),
                ),
                SizedBox(height: 10.0),
                new GestureDetector(
                  onTap: () =>  _pickImage(ImageSource.gallery, user.uid, groundImages[index1], index1),
                  child: roundedButton(
                      "GALLERY",
                      EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      const Color(0xFF167F67),
                      const Color(0xFFFFFFFF)),
                ),
                SizedBox(height: 25.0),
                new GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: new Padding(
                    padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                    child: roundedButton(
                        "CANCEL",
                        EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        const Color(0xFF167F67),
                        const Color(0xFFFFFFFF)),
                  ),
                ),
              ],
            ),
          ),
        ),
        );
      });
    }


    Future<bool> _onImageDeletePressed() async {
      CollectionReference col = FirebaseFirestore.instance.collection("client");
      DocumentSnapshot doc = await col.doc(user.uid).get();
      print(index1);
      col.doc(user.uid).update(
          {
            'groundImages': FieldValue.arrayRemove([doc.data()['groundImages'][index1]])
          }
      );
      Fluttertoast.showToast(
          msg: "Image Removed Successfully"
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home1()),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          title: Padding(
            padding: EdgeInsets.only(top: 2.0),
            child: Text('EDIT PROFILE',
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
        body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                color: Colors.white,
                child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: (){
                          showDialog(context: context, builder: (context){
                            return FadeAnimation1(
                              0.1, Container(
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
                                child : Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    new GestureDetector(
                                      onTap: () => _onAddPressed(),
                                      child: roundedButton(
                                          "ADD IMAGE",
                                          EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                          const Color(0xFF167F67),
                                          const Color(0xFFFFFFFF)),
                                    ),
                                    SizedBox(height: 10.0),
                                    new GestureDetector(
                                      onTap: () =>  _onImageDeletePressed(),
                                      child: roundedButton(
                                          "DELETE IMAGE",
                                          EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                          const Color(0xFF167F67),
                                          const Color(0xFFFFFFFF)),
                                    ),
                                    SizedBox(height: 25.0),
                                    new GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: new Padding(
                                        padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 0.0),
                                        child: roundedButton(
                                            "CANCEL",
                                            EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                            const Color(0xFF167F67),
                                            const Color(0xFFFFFFFF)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            );
                          });
                        },
                        child: GFCarousel(
                          autoPlay: true,
                          height: 210,
                          items: groundImages.map(
                                (url) {
                              return Container(
                                margin: EdgeInsets.all(3.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  child: Image.network(
                                    url,
                                    fit: BoxFit.cover,
                                    width: 1000.0,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onPageChanged: (index) {
                            setState(() {
                              index;
                              index1 = index;
                            });
                          },
                        ),
                      ),
                              Container(
                                  color: Color(0xffFFFFFF),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 25.0),
                                    child: new Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 15.0),
                                              child: new Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        'Personal Information',
                                                        style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Kollektif',),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 20.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        'Description',
                                                        style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Kollektif',),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 2.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Flexible(
                                                    child : TextField(
                                                      minLines : 1,
                                                      maxLines: 10,
                                                      onChanged: (val){
                                                        print(val);
                                                        setState(() => updateDescription = val);
                                                      },
                                                      decoration: new InputDecoration(
                                                          hintText: "Enter Description",
                                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal))
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        'Contact Number',
                                                        style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Kollektif',),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Form(
                                            key: _formKey,
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 25.0, right: 25.0, top: 2.0),
                                                child: new Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: <Widget>[
                                                    new Flexible(
                                                      child : TextFormField(
                                                        validator: (val) => val.length < 10 && val.length != 0 || val.length > 10 ? 'Enter valid contact number' : null,
                                                        onChanged: (val){
                                                          print(val);
                                                          setState(() => updateContactNumber = val);
                                                        },
                                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                        decoration: new InputDecoration(
                                                            hintText: "Enter Contact Info",
                                                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal))
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        'Address',
                                                        style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Kollektif',),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 2.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Flexible(
                                                    child : TextField(
                                                      minLines : 1,
                                                      maxLines: 7,
                                                      onChanged: (val){
                                                        print(val);
                                                        setState(() => updateAddress = val);
                                                      },
                                                      decoration: new InputDecoration(
                                                          hintText: "Enter Address",
                                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal))
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        'Morning Price',
                                                        style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Kollektif',),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 2.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Flexible(
                                                    child : TextFormField(
                                                      onChanged: (val){
                                                        print(val);
                                                        setState(() => updateMorningPrice = val);
                                                      },
                                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                      decoration: new InputDecoration(
                                                          hintText: "Enter Morning Price",
                                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal))
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 25.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: <Widget>[
                                                      new Text(
                                                        'Evening Price',
                                                        style: TextStyle(
                                                          fontSize: 17.0,
                                                          fontWeight: FontWeight.bold,
                                                          fontFamily: 'Kollektif',),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 25.0, right: 25.0, top: 2.0),
                                              child: new Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: <Widget>[
                                                  new Flexible(
                                                    child : TextFormField(
                                                      onChanged: (val){
                                                        print(val);
                                                        setState(() => updateEveningPrice = val);
                                                      },
                                                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                                      decoration: new InputDecoration(
                                                          hintText: "Enter Evening Price",
                                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal))
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 25.0,right: 25.0, top: 25.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'Start Hour',
                                                      style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
                                                    ),
                                                    DropdownButton<String>(
                                                        icon: const Icon(Icons.arrow_downward),
                                                        iconSize: 24,
                                                        elevation: 16,
                                                        style: const TextStyle(color: Colors.black),
                                                        underline: Container(
                                                          height: 2,
                                                          color: Colors.teal,
                                                        ),
                                                        items: timing.map<DropdownMenuItem<String>>((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }).toList(),
                                                      onChanged: (value){
                                                        setState(() {
                                                          drpDownValue1 = value;
                                                        });
                                                      },
                                                      value: drpDownValue1,
                                                      hint: Text(drpOption1),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left: 25.0,right: 25.0, top: 25.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      'End Hour',
                                                      style: TextStyle(
                                                        fontSize: 17.0,
                                                        fontWeight: FontWeight.bold,
                                                        fontFamily: 'Kollektif',),
                                                    ),
                                                    DropdownButton<String>(
                                                        icon: const Icon(Icons.arrow_downward),
                                                        iconSize: 24,
                                                        elevation: 16,
                                                        underline: Container(
                                                          height: 2,
                                                          color: Colors.teal,
                                                        ),
                                                      style: const TextStyle(color: Colors.black),
                                                        items: timing.map<DropdownMenuItem<String>>((String value) {
                                                          return DropdownMenuItem<String>(
                                                            value: value,
                                                            child: Text(value),
                                                          );
                                                        }
                                                        ).toList(),
                                                        onChanged: (value){
                                                          setState(() {
                                                            drpDownValue2 = value;
                                                          });
                                                        },
                                                      value: drpDownValue2,
                                                      hint: Text(drpOption2),
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                                            child: new Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(right: 10.0),
                                                    child: Container(
                                                        child: new RaisedButton(
                                                          child: new Text("Save"),
                                                          textColor: Colors.white,
                                                          color: Colors.teal,
                                                          onPressed: () async {
                                                            if(updateAddress.isNotEmpty || updateContactNumber.isNotEmpty || updateDescription.isNotEmpty || updateMorningPrice.isNotEmpty || updateEveningPrice.isNotEmpty || drpDownValue1 != drpDownValue2)
                                                            {
                                                              if (_formKey.currentState.validate()) {
                                                                int index1 = timing.indexOf(drpDownValue1);
                                                                int index2 = timing.indexOf(drpDownValue2);
                                                                print(index2);
                                                                CollectionReference col = FirebaseFirestore.instance.collection("client");
                                                                col.doc(user.uid).update({
                                                                  'address' : updateAddress == null || updateAddress.isEmpty ? widget.userDocument.data()['address'] : updateAddress,
                                                                  'description': updateDescription == null || updateDescription.isEmpty ? widget.userDocument.data()['description'] :updateDescription,
                                                                  'contactInfo': updateContactNumber == null || updateContactNumber.isEmpty ? widget.userDocument.data()['contactInfo'] :updateContactNumber,
                                                                  'morningPrice': updateMorningPrice == null || updateMorningPrice.isEmpty ? widget.userDocument.data()['morningPrice'] :updateMorningPrice,
                                                                  'eveningPrice': updateEveningPrice == null || updateEveningPrice.isEmpty ? widget.userDocument.data()['eveningPrice'] :updateEveningPrice,
                                                                  'startHour': drpDownValue1 == drpOption1 ? widget.userDocument.data()['startHour'] : timingInternal.elementAt(index1),
                                                                  'endHour': drpDownValue2 == drpOption2 ?  widget.userDocument.data()['endHour'] : timingInternal.elementAt(index2),
                                                                });
                                                                Fluttertoast.showToast(
                                                                    msg: "Profile Successfully Updated"
                                                                );
                                                                Navigator.push(context,
                                                                  MaterialPageRoute(builder: (context) => Home1()),
                                                                );
                                                              }
                                                            }
                                                            else
                                                              {
                                                                setState(() {
                                                                  error = "Please enter something";
                                                                });
                                                              }
                                                            },
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius: new BorderRadius.circular(20.0)),
                                                        )),
                                                  ),
                                                  flex: 2,
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(left: 10.0),
                                                    child: Container(
                                                        child: new RaisedButton(
                                                          child: new Text("Cancel"),
                                                          textColor: Colors.white,
                                                          color: Colors.grey,
                                                          onPressed: () {
                                                            setState(() {
                                                              Navigator.pop(context);
                                                            });

                                                          },
                                                          shape: new RoundedRectangleBorder(
                                                              borderRadius: new BorderRadius.circular(20.0)),
                                                        )),
                                                  ),
                                                  flex: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height : 10.0),
                                          Padding(
                                            padding: EdgeInsets.only(left: 140.0, top: 2.0),
                                            child: Text(
                                              error,
                                              style: TextStyle(color: Colors.red, fontSize: 14.0, fontFamily: 'Kollektif-Bold',),
                                            ),
                                          ),
                                        ]
                                    ),
                                  )
                              )
                            ],
                          ),
                ),
              ),
            )
    );
  }
  Widget roundedButton(
      String buttonLabel, EdgeInsets margin, Color bgColor, Color textColor) {
    var Btn = new Container(
      height: 45.0,
      width: 300.0,
      child: Material(
        borderRadius: BorderRadius.circular(100.0),
        shadowColor: Colors.grey,
        color: Colors.teal,
        elevation: 5.0,
        child: Container(
          alignment: FractionalOffset.center,
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child : Text(buttonLabel, textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Kollektif',
            ),
          ),
        ),
      ),
    );
    return Btn;
  }
}

