import 'package:cs7ns2_smartwfh_iotrix/Components/SideMenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cs7ns2_smartwfh_iotrix/main.dart';

class UserDashboard extends StatefulWidget {

  const UserDashboard({Key? key}) : super(key: key);

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

const AndroidNotificationDetails androidPlatformChannelSpecifics =
AndroidNotificationDetails(
    "1", //Required for Android 8.0 or after
    "summa", //Required for Android 8.0 or after
    "sending notify", //Required for Android 8.0 or after
    importance: Importance.high,
    priority: Priority.high);

const NotificationDetails platformChannelSpecifics =
NotificationDetails(android: androidPlatformChannelSpecifics);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class _UserDashboardState extends State<UserDashboard> {
  var state = "0";
  var buttonString = "start";
  final Firestoreinstance = FirebaseFirestore.instance;

  AppBar appBar = AppBar(
    title: Text("Dashboard - Today"),
    backgroundColor: Colors.teal,
  );

  @override
  Widget build(BuildContext context) {
    fetchdata(url) async {
      http.Response response = await http.get(Uri.parse(url));
      return response.body;
    }
    singleCard2(cardcode, cardtitle, Status) {
      return GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(cardtitle,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 40,
                  ),
                  Text(Status,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black, fontSize: 20)),
                ],
              ),
            ),
          ));
    }

    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: false,
      drawer: SideMenu(),
      body: GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          ValueListenableBuilder(
              valueListenable: totalWaterLevel,
              builder: (context, value, widget) {
                return singleCard2(
                    0, 'Water Intake', totalWaterLevel.value.toString() + ' times');
              }
          ),
          ValueListenableBuilder(
              valueListenable: totalST,
              builder: (context, value, widget) {
                Text(totalST.value.toString());
                return singleCard2(1, 'Screen Time', totalST.value.toString() + ' seconds');
              }
          ),
          ValueListenableBuilder(
              valueListenable: totalPostureTIme,
              builder: (context, value, widget) {
                return  singleCard2(2, 'Posture', totalPostureTIme.value.toString() + ' seconds');
              }
          ),
        ],
      ),
    );
  }
}
