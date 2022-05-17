import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs7ns2_smartwfh_iotrix/Components/SideMenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class Statistics extends StatefulWidget {


  const Statistics( {Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

graphContainer (){
  return Container (
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
            labelRotation: 90,
      title: AxisTitle(
      text: 'Date',
        textStyle: TextStyle(
            color: Colors.deepOrange,
            fontFamily: 'Roboto',
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w300,

        ))),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text:'Time in seconds',)
        ),
        series: <ColumnSeries<ChartSampleData, String>>[
          ColumnSeries<ChartSampleData, String>(
              dataSource: postureData,
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.y,
              dataLabelSettings: DataLabelSettings(isVisible: true)
          ),
        ],
      )
  );
}

ScreenTimeContainer (){
  return Container (
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
            labelRotation: 90,
            title: AxisTitle(
                text: 'Date',
                textStyle: TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,

                ))),
        primaryYAxis: NumericAxis(
            title: AxisTitle(
              text:'Time in seconds',)
        ),
        series: <ColumnSeries<ChartSampleData, String>>[
          ColumnSeries<ChartSampleData, String>(
              dataSource: screenTimeData,
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.y,
              dataLabelSettings: DataLabelSettings(isVisible: true)
          ),
        ],
      )
  );
}

waterLevelContainer (){
  return Container (
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
            labelRotation: 90,
            title: AxisTitle(
                text: 'Date',
                textStyle: TextStyle(
                  color: Colors.deepOrange,
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,

                ))),
        primaryYAxis: NumericAxis(
                title: AxisTitle(
                  text:'Time in seconds',)

        ),
        series: <ColumnSeries<ChartSampleData, String>>[
          ColumnSeries<ChartSampleData, String>(
              dataSource: waterLevelData,
              xValueMapper: (ChartSampleData data, _) => data.x,
              yValueMapper: (ChartSampleData data, _) => data.y,
              dataLabelSettings: DataLabelSettings(isVisible: true)
          ),
        ],
      )
  );
}
List _children = [
  graphContainer(),
  ScreenTimeContainer(),
  waterLevelContainer()
];
class _StatisticsState extends State<Statistics> {


  /// Specifies the list of chart sample data.
  ///
  int _selectedIndex = 0;
  AppBar appBar = AppBar(
    title: Text("Statistics"),
    backgroundColor: Colors.teal,
  );

  /// Creates an instance of random to generate the random number.
  // final Random random = Random();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
navbarContainer (){
    return Container (
        child : BottomNavigationBar(
          currentIndex: _selectedIndex, // this will be set when a new tab is tapped
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.person_outline_sharp),
              label: 'Posture',

            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.screen_search_desktop),
              label: 'Screen Time',
            ),
            const BottomNavigationBarItem(
                icon: Icon(Icons.wine_bar),
                label: 'Water Intake'
            )
          ],
        )
    );
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: appBar,
        resizeToAvoidBottomInset: false,
        drawer: SideMenu(),
        body: Center(
          child: Container(
            padding: EdgeInsets.all(8),
            //height: MediaQuery.of(context).size.height - heightOfFilter,
            // child: Card(
            //     child: Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Column(
            //           children: <Widget>[
            //           graphContainer(),
            //             Spacer(),
            //             navbarContainer(),
            //           ],
            //         ))),
            child:_children[_selectedIndex],

          ),
        ),
        bottomNavigationBar: navbarContainer()
    );
  }


}

class ChartSampleData {
  var x;
  var y;

  ChartSampleData(x, y) {
    this.x = x;
    this.y = y;
  }

}