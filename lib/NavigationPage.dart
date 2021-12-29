import 'package:flutter/material.dart';
import 'package:pa3/CaseDeath.dart';
import 'package:pa3/Vaccine.dart';
import 'package:fl_chart/fl_chart.dart';

class NavigationPage extends StatelessWidget{
  final String ID;
  final String prev;
  final List<Widget> widgets = [Text("")];
  final LineChartData ch = new LineChartData();
  NavigationPage(this.ID, this.prev);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Menu"),),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
              ListTile(
                leading: Icon(Icons.coronavirus_outlined),
                title: Text("Cases/Deaths"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CaseDeath(ID, widgets, ch),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.local_hospital),
                title: Text("Vaccine"),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Vaccine(ID, widgets, ch),
                    ),
                  );
                },
              ),
          Text("Welcome! $ID"),
          Text("Previous: $prev page"),

            ],
          ),
      ),
    );
  }
}