//This is the profiles page.

import 'package:booking_app/Animation/animation1.dart';
import 'package:booking_app/screens/home/home1.dart';
import 'package:booking_app/screens/home/profileImage.dart';
import 'package:booking_app/screens/home/updateTurfImage.dart';
import 'package:booking_app/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_image/firebase_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'home.dart';
import 'package:provider/provider.dart';
import 'package:booking_app/services/database.dart';

class updateProfile extends StatefulWidget {
  final DocumentSnapshot userDocument;
  updateProfile({this.userDocument});
  @override
  _updateProfileState createState() => _updateProfileState();
}

class Constants{
  Constants._();
  static const double padding =20;
  static const double avatarRadius =45;
}

class _updateProfileState extends State<updateProfile> {

  final _formKey = GlobalKey<FormState>();
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  bool _isVisible = false;
  Widget appBarTitle = new Text("Home");
  Icon searchIcon = new Icon(Icons.search);
  int _currentIndex=0;
  String profileImage;


  String updatedName = '';
  String error = '';
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
                  SizedBox(height: 15.0,),
                  profileImage == null ? new Stack(
                    children: <Widget>[
                      new Center(
                        child: new CircleAvatar(
                          radius: 80.0,
                          backgroundColor: const Color(0xFF778899),
                        ),
                      ),
                      new Center(
                        child: new Image.asset("assets/photo_camera.png"),
                      ),
                    ],
                  ) :  CircleAvatar(
                    backgroundColor: Colors.black,
                    radius: 75.0,
                    backgroundImage: FirebaseImage(profileImage,
                      maxSizeBytes: 5000 * 1000,
                      shouldCache: true,
                      cacheRefreshStrategy: CacheRefreshStrategy.BY_METADATA_DATE,
                    ),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: MaterialButton(
                        color: Colors.teal,
                        minWidth: 10.0,
                        shape: CircleBorder(
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: (){
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
                                      onTap: () => _pickImage(ImageSource.camera, user.uid),
                                      child: roundedButton(
                                          "CAMERA",
                                          EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                                          const Color(0xFF167F67),
                                          const Color(0xFFFFFFFF)),
                                    ),
                                    SizedBox(height: 10.0),
                                    new GestureDetector(
                                      onTap: () =>  _pickImage(ImageSource.gallery, user.uid),
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
                        },
                      ),
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
                                            'Name',
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
                                            setState(() => updatedName = val);
                                          },
                                          decoration: new InputDecoration(
                                              hintText: "Enter Name",
                                              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal))
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
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
                                                if(updatedName.isNotEmpty)
                                                {
                                                  if (_formKey.currentState.validate()) {
                                                    CollectionReference col = FirebaseFirestore.instance.collection("user");
                                                    col.doc(user.uid).update({
                                                      'displayName' : updatedName == null || updatedName.isEmpty ? widget.userDocument.data()['displayName'] : updatedName,
                                                    });
                                                    Fluttertoast.showToast(
                                                        msg: "Profile Successfully Updated"
                                                    );
                                                    Navigator.push(context,
                                                      MaterialPageRoute(builder: (context) => Home()),
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

