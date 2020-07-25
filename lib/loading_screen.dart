import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'second_page.dart';
import 'local_notications_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

double startingLatitude = 0;
double startingLongitude = 0;
double endingLatitude = 0;
double endingLongitude = 0;
double traveledDistanceTemp = 0;
double traveledDistancePermanent = 0;

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  ///Initialise LocalNotificationPlugin
  final notifications = FlutterLocalNotificationsPlugin();

  void getStartingLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      startingLatitude = position.latitude;
      startingLongitude = position.longitude;
      print('Trip started');
      print(startingLatitude);
      print(startingLongitude);
    } catch (e) {
      print(e);
    }
  }

  void getEndingLocation() async {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      endingLatitude = position.latitude;
      endingLongitude = position.longitude;
      print('Trip ended');
      print(endingLatitude);
      print(endingLongitude);
    } catch (e) {
      print(e);
    }
  }

  void calculateDistance(
      double startLat, double startLong, double endLat, double endLong) async {
    try {
      double distanceInMeters = await Geolocator()
          .distanceBetween(startLat, startLong, endLat, endLong);
      traveledDistanceTemp = distanceInMeters;
      print('$distanceInMeters meters traveled');
    } catch (e) {
      print(e);
    }
  }

  void updateDistance() {
    traveledDistancePermanent = traveledDistanceTemp;
  }

  @override
  void initState() {
    super.initState();

    ///Initializing notification the settings for Android and iOS
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) =>
            onSelectNotification(payload));

    notifications.initialize(
        InitializationSettings(settingsAndroid, settingsIOS),
        onSelectNotification: onSelectNotification);
  }

  ///what will happen after clicking on he notification
  Future onSelectNotification(String payload) async => await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondPage(
            payload: traveledDistancePermanent.toStringAsFixed(2),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'FareMate',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    getStartingLocation();

                    Fluttertoast.showToast(msg: 'Trip Started');
                  },
                  child: Text(
                    'Start Trip',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.0,
                ),
                RaisedButton(
                  onPressed: () {
                    getEndingLocation();
                    Fluttertoast.showToast(msg: 'Trip Ended');
                  },
                  child: Text(
                    'End Trip',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            RaisedButton(
              onPressed: () {
                showOngoingNotification(notifications,
                    title: 'Get Distance',
                    body: 'Tap to see how much you have travelled');
                setState(
                  () {
                    calculateDistance(startingLatitude, startingLongitude,
                        endingLatitude, endingLongitude);
                    //print('$traveledDistance meters travelled');
                    updateDistance();
                  },
                );
              },
              child: Text(
                'Get Distance',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
