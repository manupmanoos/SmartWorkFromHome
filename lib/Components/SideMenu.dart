import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs7ns2_smartwfh_iotrix/Routes/Statistics.dart';
import 'package:cs7ns2_smartwfh_iotrix/Routes/user_dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

var sideMenuIndex = 0;
late Map<dynamic,dynamic> postureHistory;
late Map<dynamic,dynamic> waterLevelHistory;
late Map<dynamic,dynamic> screenTimeHistory;
List<ChartSampleData> postureData = <ChartSampleData>[];
List<ChartSampleData> screenTimeData = <ChartSampleData>[];
List<ChartSampleData> waterLevelData = <ChartSampleData>[];
class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  checkFirebase(){
    FirebaseFirestore.instance.collection('iot').get().then((collection) {
      if (collection.docs.isNotEmpty) {
        collectionDocs(collection.docs);
      }
    });
  }
  void collectionDocs(var firebaseList){
    // _JsonQueryDocumentSnapshot = firebaseList[0];
    postureHistory =  firebaseList[0]['postureHistory'];
    waterLevelHistory =  firebaseList[0]['waterLevelHistory'];
    screenTimeHistory =  firebaseList[0]['screenTime'];

    postureHistory.forEach((key, value) {
      ChartSampleData temp = new ChartSampleData(key, value);
      postureData.add(temp);
    });
    waterLevelHistory.forEach((key, value) {
      ChartSampleData temp = new ChartSampleData(key, value);
      waterLevelData.add(temp);
    });
    screenTimeHistory.forEach((key, value) {
      ChartSampleData temp = new ChartSampleData(key, value);
      screenTimeData.add(temp);
    });
  }

  var color = const Color(0xffE6E6E6);
  String? auth = FirebaseAuth.instance.currentUser == null
      ? "guest"
      : FirebaseAuth.instance.currentUser?.email;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkFirebase();
    setState(() {
      sideMenuIndex == null?0:sideMenuIndex;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(
                            'https://source.unsplash.com/50x50/?portrait',
                          ),
                        ),
                      )
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      auth!,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              )),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: Text('Dashboard',style:TextStyle(
              color: sideMenuIndex == 0 ?Colors.teal:Colors.black
            )),
            tileColor: sideMenuIndex == 0 ?color:null,
            onTap: () {
              setState(() {
                sideMenuIndex = 0;
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>const UserDashboard(),
                ));
              });
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.of(context).pushNamed("/userDashboard",arguments: "Dublin Bikes");
            },
          ),
          ListTile(
            leading: const Icon(Icons.query_stats_outlined),
            title: Text('Statistics',style:TextStyle(
                color: sideMenuIndex == 1 ?Colors.teal:Colors.black
            )),
            tileColor: sideMenuIndex == 1 ?color:null,
            onTap: () {
              setState(() {
                sideMenuIndex = 1;
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context)=> Statistics(),
                    ));
              });
              // Update the state of the app
              // ...
              // Then close the drawer
              // Navigator.of(context).pushNamed("/userDashboard",arguments: "Buses");
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text('Logout'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pushNamedAndRemoveUntil(context, "/", (r) => false);
              FirebaseAuth.instance.signOut();
            },
          ),

        ],
      ),
    );
  }
}


