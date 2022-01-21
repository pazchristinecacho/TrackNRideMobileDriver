import 'dart:io';

import 'package:drivers_app/AllScreens/loginScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ProfileTabPage extends StatelessWidget {
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 8, right: 8, bottom: 2),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            child: imageFile == null
                                ? Container(
                                    alignment: Alignment.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 40.0,
                                        ),
                                        RaisedButton(
                                          color: Colors.lightGreenAccent,
                                          onPressed: () {
                                            _getFromCamera();
                                          },
                                          child: Text("PICK FROM CAMERA"),
                                        )
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                    ),
                                  )),
                        Align(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Color(0xff476cfb),
                            child: ClipOval(
                              child: new SizedBox(
                                  width: 65.0,
                                  height: 65.0,
                                  child: Image.asset(
                                    'images/user_icon.png',
                                    height: 65.0,
                                    width: 65.0,
                                  )),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: IconButton(
                            icon: Icon(
                              FontAwesomeIcons.camera,
                              size: 20.0,
                            ),
                            onPressed: () {
                              _getFromCamera();
                            },
                          ),
                        ),
                      ],
                    ),
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
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 110.0),
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
      ),
    );
  }
}

_getFromGallery() async {
  PickedFile pickedFile = await ImagePicker().getImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
  }
}

/// Get from camera
_getFromCamera() async {
  PickedFile pickedFile = await ImagePicker().getImage(
    source: ImageSource.camera,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedFile != null) {
    File imageFile = File(pickedFile.path);
  }
}

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
