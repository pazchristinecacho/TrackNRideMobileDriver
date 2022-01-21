import 'dart:async';

//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:drivers_app/Models/drivers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:drivers_app/Models/allUsers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//String mapKey = "AIzaSyAfMKosk4rMfm6XuWi5K9jOZYHNAGSs2iY";
String mapKey = "AIzaSyBj5lVfz6WfCLgDFwhODLRO_KrVeyxqJ9k";

User firebaseUser;

Users userCurrentInfo;

User currentfirebaseUser;

StreamSubscription<Position> homeTabPageStreamSubscription;

StreamSubscription<Position> rideStreamSubscription;

//final assetsAudioPlayer = AssetsAudioPlayer();

Position currentPosition;

Drivers driversInformation;

String title = "";
double starCounter = 0.0;

String rideType = "";
