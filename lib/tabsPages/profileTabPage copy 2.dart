import 'dart:io';

import 'package:drivers_app/AllScreens/loginScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../Assistants/assistantMethods.dart';

class ProfileTabPage extends StatefulWidget {
  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  File _image;

  final picker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User user;

  bool _isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    AssistantMethods.getCurrentOnlineDriverUserInfo();
    _auth.userChanges().listen((event) => setState(() => user = event));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoggedIn
          ? SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Driver Profile",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(left: 8, right: 8, bottom: 2),
                            height: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.blue[700],
                            ),
                            child: Row(
                              children: <Widget>[
                                /*Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                ),*/
                                SizedBox(
                                  width: 2,
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Verify Account",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    )),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Expanded(
                      flex: 4,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.all(Radius.circular(15)),
                          gradient: RadialGradient(
                            colors: [Colors.orange[100], Colors.orange[400]],
                          ),
                        ),
                        child: Column(children: [
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            driversInformation.name,
                            style: TextStyle(
                              fontSize: 35.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _getFromCamera();
                            },
                            child: Container(
                              height: 85,
                              width: 85,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: _image == null
                                  ? Image.asset(
                                      'images/user_icon.png') // set a placeholder image when no photo is set
                                  : Image.file(_image),
                            ),
                          ),
                          /*GestureDetector(
                      onTap: () {
                        uploadToFirebase();
                      },
                      child: Container(
                        height: 85,
                        width: 85,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          'Upload',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),*/
                          Text(
                            'Driver',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  InfoCard(
                    text: driversInformation.phone,
                    icon: Icons.phone,
                    onPressed: () async {
                      print("This is phone number.");
                    },
                  ),
                  InfoCard(
                    text: driversInformation.email,
                    icon: Icons.email,
                    onPressed: () async {
                      print("This is email.");
                    },
                  ),
                  InfoCard(
                    text: driversInformation.car_color +
                        " " +
                        driversInformation.car_model +
                        " " +
                        driversInformation.car_number,
                    icon: Icons.car_repair,
                    onPressed: () async {
                      print("This is car info.");
                    },
                  ),
                  GestureDetector(
                    onTap: () {
                      Geofire.removeLocation(currentfirebaseUser.uid);
                      rideRequestRef.onDisconnect();
                      rideRequestRef.remove();
                      rideRequestRef = null;

                      FirebaseAuth.instance.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginScreen.idScreen, (route) => false);
                    },
                    child: Card(
                      color: Colors.red,
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 110.0),
                      child: ListTile(
                        trailing: Icon(
                          Icons.follow_the_signs_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Sign out",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontFamily: 'Brand Bold',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox(
              height: 10.0,
            ),
    );
  }

  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    }
  }

  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
    }
  }
}

/// Selection dialog that prompts the user to select an existing photo or take a new one

class InfoCard extends StatelessWidget {
  final String text;
  final IconData icon;
  Function onPressed;

  InfoCard({
    this.text,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        color: Colors.orangeAccent,
        margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 35.0),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.black87,
          ),
          title: Text(
            text,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 13.0,
              fontFamily: 'Brand Bold',
            ),
          ),
        ),
      ),
    );
  }
}
