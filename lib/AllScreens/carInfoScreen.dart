import 'package:drivers_app/AllScreens/add_image.dart.dart';
import 'package:drivers_app/AllScreens/loginScreen.dart';
import 'package:drivers_app/AllScreens/mainscreen.dart';
import 'package:drivers_app/AllScreens/registerationScreen.dart';
import 'package:drivers_app/configMaps.dart';
import 'package:drivers_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class CarInfoScreen extends StatefulWidget {
  static const String idScreen = "carinfo";

  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();

  TextEditingController carNumberTextEditingController =
      TextEditingController();

  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ['Taxi', 'Tricycle', 'Jeep'];

  String selectedCarType;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.thumb_up),
        label: Text('Credential'),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddImage()));
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 22.0,
              ),
              Image.asset(
                "images/tnrdriverpng.png",
                width: 390.0,
                height: 250.0,
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(22.0, 22.0, 22.0, 32.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 12.0,
                    ),
                    Text(
                      "Enter Vehicle Details",
                      style:
                          TextStyle(fontFamily: "Brand Bold", fontSize: 24.0),
                    ),
                    SizedBox(
                      height: 26.0,
                    ),
                    TextField(
                      controller: carModelTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Vehicle Model",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: carNumberTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Vehicle Number",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      controller: carColorTextEditingController,
                      decoration: InputDecoration(
                        labelText: "Vehicle Color",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: 10.0),
                      ),
                      style: TextStyle(fontSize: 15.0),
                    ),
                    SizedBox(
                      height: 26.0,
                    ),
                    DropdownButton(
                      iconSize: 40,
                      hint: Text('Please Choose Vehicle Type'),
                      value: selectedCarType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedCarType = newValue;
                          displayToastMessage(selectedCarType, context);
                        });
                      },
                      items: carTypesList.map((car) {
                        return DropdownMenuItem(
                          child: new Text(car),
                          value: car,
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20,),
                    Text(
                      "Credentials (Valid ID or NBI Clearance)",
                      style:
                      TextStyle(fontFamily: "Brand Bold", fontSize: 18.0),
                    ),
                    StreamBuilder(
                      stream: FirebaseDatabase.instance.reference().child("drivers").child(FirebaseAuth.instance.currentUser.uid).child("credentials").onChildChanged,
                      builder: (context, snapshot) {
                        List<String> urls = [];
                        if (snapshot.hasData && !snapshot.hasError && snapshot.data.snapshot.value!=null) {
                          DataSnapshot snapshot1 = snapshot.data.snapshot;

                          final keys = snapshot1.value.keys;
                          for(var key in keys) {
                            print(key);
                            urls.add(snapshot1.value[key]['url']);
                          }
                        }

                        return !(urls.length > 0)
                            ? Center(
                          child: CircularProgressIndicator(),
                        )
                            : Container(
                          padding: EdgeInsets.all(4),
                          child: GridView.builder(
                              shrinkWrap: true,
                              itemCount: urls.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(3),
                                  child: FadeInImage.memoryNetwork(
                                      fit: BoxFit.cover,
                                      placeholder: kTransparentImage,
                                      image: urls[index],
                                ));
                              }),
                        );
                      },
                    ),
                    SizedBox(
                      height: 42.0,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                        onPressed: () {
                          if (carModelTextEditingController.text.isEmpty) {
                            displayToastMessage(
                                "please write Vehicle Model.", context);
                          } else if (carNumberTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "please write Vehicle Number.", context);
                          } else if (carColorTextEditingController
                              .text.isEmpty) {
                            displayToastMessage(
                                "please write Vehicle Color.", context);
                          } else if (selectedCarType == null) {
                            displayToastMessage(
                                "please choose Vehicle Type.", context);
                          } else {
                            saveDriverCarInfo(context);
                          }
                        },
                        color: Colors.black54,
                        child: Padding(
                          padding: EdgeInsets.all(17.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "NEXT",
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 26.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void saveDriverCarInfo(context) {
    String userId = currentfirebaseUser.uid;

    Map carInfoMap = {
      "car_color": carColorTextEditingController.text,
      "car_number": carNumberTextEditingController.text,
      "car_model": carModelTextEditingController.text,
      "type": selectedCarType,
    };

    driversRef.child(userId).child("car_details").set(carInfoMap);

    FirebaseAuth.instance.signOut();
    displayToastMessage(
        "Please wait for the Admin Approval. Thank you.",
        context);

    Navigator.pushNamedAndRemoveUntil(
        context, LoginScreen.idScreen, (route) => false);

    // Navigator.pushNamedAndRemoveUntil(
    //     context, MainScreen.idScreen, (route) => false);
  }
}
