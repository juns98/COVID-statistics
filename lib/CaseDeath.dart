import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pa3/NavigationPage.dart';

class CD {
  String country;
  List<Data> data;

  CD({this.country, this.data});

  CD.fromJson(Map<String, dynamic> json, String code) {
    country = json[code]['location'];
    if (json[code]['data'] != null) {
      data = new List<Data>();
      json[code]['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }
}

List<CD> parsePhotos(String responseBody) {
  Map<String, dynamic> responseJson = json.decode(responseBody);
  List<CD> cds = new List<CD>();
  for (int i = 0; i < responseJson.length; i++) {
    cds.add(CD.fromJson(responseJson, responseJson.keys.toList()[i]));
  }
  return cds;
}

Future<Map<String, dynamic>> fetchAlbum() async {
  final response = await http
      .get("https://covid.ourworldindata.org/data/owid-covid-data.json");
  print('status = ${response.statusCode}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> list = new Map<String, dynamic>();
    double daily = 0, deaths = 0, cases = 0;
    String date;
    String temp;
    List<double> gdaily1 = new List<double>(7);
    List<double> gcases1 = new List<double>(7);
    List<double> gdaily2 = new List<double>(28);
    List<double> gcases2 = new List<double>(28);
    for (int i = 0; i < 7; i++) {
      gdaily1[i] = 0;
      gcases1[i] = 0;
    }
    for (int i = 0; i < 28; i++) {
      gdaily2[i] = 0;
      gcases2[i] = 0;
    }
    List<String> days7 = new List<String>(7);
    List<String> days28 = new List<String>(28);
    List<String> countryList = new List<String>();
    List<dynamic> deathsList = new List<dynamic>();
    List<dynamic> casesList = new List<dynamic>();
    List<dynamic> dailyList = new List<dynamic>();
    List<CD> countries = parsePhotos(response.body);
    int numofCountry = countries.length;
    int lastdate;
    for (int i = 0; i < countries.length; i++) {
      if (countries
          .elementAt(i)
          .country
          .toString() == "South Korea") {}
    }

    for (int i = 0; i < countries.length; i++) {
      if (countries.elementAt(i).country.toString() == "South Korea") {
        for(int j=0; j<7; j++) {
          String temp = countries.elementAt(i).data.elementAt(countries.elementAt(i).data.length - 7 + j).date;
          temp = temp.substring(5,10);
          days7[j] = temp;
        }
        for(int j=0; j<28; j++) {
          String temp = countries.elementAt(i).data.elementAt(countries.elementAt(i).data.length - 28 + j).date;
          temp = temp.substring(5,10);
          days28[j] = temp;
        }
      }
      for (int j = 0; j < 7; j++) {
        if (countries.elementAt(i).data.length - 7 + j >= 0 &&
            countries
                    .elementAt(i)
                    .data
                    .elementAt(countries.elementAt(i).data.length - 7 + j)
                    .total_cases !=
                null)
          gcases1[j] += countries
              .elementAt(i)
              .data
              .elementAt(countries.elementAt(i).data.length - 7 + j)
              .total_cases;
        if (countries.elementAt(i).data.length - 7 + j >= 0 &&
            countries
                    .elementAt(i)
                    .data
                    .elementAt(countries.elementAt(i).data.length - 7 + j)
                    .new_cases !=
                null)
          gdaily1[j] += countries
              .elementAt(i)
              .data
              .elementAt(countries.elementAt(i).data.length - 7 + j)
              .new_cases;
      }
      for (int j = 0; j < 28; j++) {
        if (countries.elementAt(i).data.length - 28 + j >= 0 &&
            countries
                    .elementAt(i)
                    .data
                    .elementAt(countries.elementAt(i).data.length - 28 + j)
                    .total_cases !=
                null)
          gcases2[j] += countries
              .elementAt(i)
              .data
              .elementAt(countries.elementAt(i).data.length - 28 + j)
              .total_cases;
        if (countries.elementAt(i).data.length - 28 + j >= 0 &&
            countries
                    .elementAt(i)
                    .data
                    .elementAt(countries.elementAt(i).data.length - 28 + j)
                    .new_cases !=
                null)
          gdaily2[j] += countries
              .elementAt(i)
              .data
              .elementAt(countries.elementAt(i).data.length - 28 + j)
              .new_cases;
      }
      if (countries.elementAt(i).country != null) {
        temp = countries.elementAt(i).country;
        countryList.add(temp);
      }
      if (countries.elementAt(i).data.last.new_cases != null) {
        daily += countries.elementAt(i).data.last.new_cases;
        dailyList.add(countries.elementAt(i).data.last.new_cases);
      } else {
        dailyList.add("null");
      }
      /*
      else {
        int k=1;
        while (countries.elementAt(i).data.elementAt(countries.elementAt(i).data.length-k).daily_Vaccinations == null) {
          k++;
        }
        daily += countries.elementAt(i).data.elementAt(countries.elementAt(i).data.length-k).daily_Vaccinations;
      }*/
      if (countries.elementAt(i).data.last.total_deaths != null) {
        deaths += countries.elementAt(i).data.last.total_deaths;
        deathsList.add(countries.elementAt(i).data.last.total_deaths);
      } else {
        deathsList.add("null");
      }

      if (countries.elementAt(i).data.last.total_cases != null) {
        cases += countries.elementAt(i).data.last.total_cases;
        casesList.add(countries.elementAt(i).data.last.total_cases);
      } else {
        casesList.add("null");
      }

      if (countries.elementAt(i).country.toString() == "South Korea") {
        date = countries.elementAt(i).data.last.date;
      }
    }
    list["days7"] = days7;
    list["days28"] = days28;
    list["num"] = numofCountry;
    list["date"] = date;
    list["daily"] = daily;
    list["cases"] = cases;
    list["deaths"] = deaths;
    list["countryList"] = countryList;
    list["dailyList"] = dailyList;
    list["casesList"] = casesList;
    list["deathsList"] = deathsList;
    list["gdaily1"] = gdaily1;
    list["gdaily2"] = gdaily2;
    list["gcases1"] = gcases1;
    list["gcases2"] = gcases2;
    return list;
  } else {
    throw Exception('Failed to load album');
  }
}

class Data {
  String date;
  double total_cases;
  double total_deaths;
  double new_cases;

  Data({this.date, this.total_cases, this.total_deaths, this.new_cases});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    total_cases = json['total_cases'];
    total_deaths = json['total_deaths'];
    new_cases = json['new_cases'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['total_cases'] = this.total_cases;
    data['total_deaths'] = this.total_deaths;
    data['new_cases'] = this.new_cases;
    return data;
  }
}

class CaseDeath extends StatelessWidget {
  final String ID;
  final String title = "CaseDeath";
  List<Widget> data0 = new List<Widget>();
  List<Widget> data1;
  List<Widget> data2 = new List<Widget>();
  LineChartData ch;
  LineChartData first, second, third, fourth;
  List<FlSpot> list1 = new List<FlSpot>(7);
  List<FlSpot> list2 = new List<FlSpot>(7);
  List<FlSpot> list3 = new List<FlSpot>(28);
  List<FlSpot> list4 = new List<FlSpot>(28);

  CaseDeath(this.ID, this.data1, this.ch);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration:
            BoxDecoration(border: Border.all(color: Colors.grey, width: 3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                FutureBuilder<Map<String, dynamic>>(
                    future: fetchAlbum(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        for (int i = 0; i < 7; i++) {
                          FlSpot fl = FlSpot((i + 1).toDouble(),
                              snapshot.data["gcases1"].elementAt(i).toDouble());
                          list1[i] = fl;
                        }
                        for (int i = 0; i < 28; i++) {
                          FlSpot fl = FlSpot((i + 1).toDouble(),
                              snapshot.data["gcases2"].elementAt(i).toDouble());
                          list3[i] = fl;
                        }
                        for (int i = 0; i < 7; i++) {
                          FlSpot fl = FlSpot((i + 1).toDouble(),
                              snapshot.data["gdaily1"].elementAt(i).toDouble());
                          list2[i] = fl;
                        }
                        for (int i = 0; i < 28; i++) {
                          FlSpot fl = FlSpot((i + 1).toDouble(),
                              snapshot.data["gdaily2"].elementAt(i).toDouble());
                          list4[i] = fl;
                        }
                        ch = first;
                        first = chart(list1, snapshot.data["days7"]);
                        third = chart(list3, snapshot.data["days28"]);
                        second = chart(list2, snapshot.data["days7"]);
                        fourth = chart(list4, snapshot.data["days28"]);
                        data1.clear();
                        data2.clear();
                        data1.add(Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Country" + "          "),
                            Text("cases" + "          "),
                            Text("deaths" + "          "),
                            Text("daily" + "          "),
                          ],
                        ));
                        data2.add(Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Country" + "           "),
                            Text("cases" + "           "),
                            Text("deaths" + "           "),
                            Text("daily" + "           "),
                          ],
                        ));
                        List<int> select = new List<int>();
                        for (int i = 0; i < 7; i++) {
                          int max = 0;
                          for (int j = 0; j < snapshot.data["num"]; j++) {
                            if (select.contains(j)) {
                              continue;
                            }
                            if (snapshot.data["casesList"].elementAt(j) !=
                                "null") {
                              if (snapshot.data["casesList"].elementAt(max) <
                                  snapshot.data["casesList"].elementAt(j)) {
                                max = j;
                              }
                            }
                          }
                          select.add(max);
                          data1.add(Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data["countryList"].elementAt(i) +
                                  "    "),
                              Text(snapshot.data["casesList"]
                                      .elementAt(i)
                                      .toString() +
                                  "    "),
                              Text(snapshot.data["deathsList"]
                                      .elementAt(i)
                                      .toString() +
                                  "    "),
                              Text(snapshot.data["dailyList"]
                                      .elementAt(i)
                                      .toString() +
                                  "    "),
                            ],
                          ));
                        }
                        List<int> selected = new List<int>();
                        for (int i = 0; i < 7; i++) {
                          int max = 0;
                          for (int j = 0; j < snapshot.data["num"]; j++) {
                            if (selected.contains(j)) {
                              continue;
                            }
                            if (snapshot.data["deathsList"].elementAt(j) !=
                                "null") {
                              if (snapshot.data["deathsList"].elementAt(max) <
                                  snapshot.data["deathsList"].elementAt(j)) {
                                max = j;
                              }
                            }
                          }
                          selected.add(max);
                          data2.add(Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data["countryList"].elementAt(max) +
                                  "    "),
                              Text(snapshot.data["casesList"]
                                      .elementAt(max)
                                      .toString() +
                                  "    "),
                              Text(snapshot.data["deathsList"]
                                      .elementAt(max)
                                      .toString() +
                                  "    "),
                              Text(snapshot.data["dailyList"]
                                      .elementAt(max)
                                      .toString() +
                                  "    "),
                            ],
                          ));
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Total Cases.                       "),
                                Text("Parsed latest date"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(snapshot.data["cases"].toString() +
                                    " people                        "),
                                Text(snapshot.data["date"]),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Total Deaths.                       "),
                                Text("Daily Cases"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(snapshot.data["deaths"].toString() +
                                    " people                       "),
                                Text(snapshot.data["daily"].toString() +
                                    " people"),
                              ],
                            ),
                          ],
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    })
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            height: 350,
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey, width: 3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaseDeath(ID, data0, first),
                            ),
                          );
                        },
                        child: Text("   Graph1   ")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaseDeath(ID, data0, second),
                            ),
                          );
                        },
                        child: Text("   Graph2   ")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaseDeath(ID, data0, third),
                            ),
                          );
                        },
                        child: Text("   Graph3   ")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaseDeath(ID, data0, fourth),
                            ),
                          );
                        },
                        child: Text("   Graph4   ")),
                  ],
                ),
                Divider(
                    color: Colors.black
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 350,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: LineChart(ch),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Container(
            height: 150,
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration:
                BoxDecoration(border: Border.all(color: Colors.grey, width: 3)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaseDeath(ID, data1, ch),
                            ),
                          );
                        },
                        child: Text("         Total Cases          ")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CaseDeath(ID, data2, ch),
                            ),
                          );
                        },
                        child: Text("         Total Deaths          ")),
                  ],
                ),
                Divider(
                    color: Colors.black
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data1.length,
                      itemBuilder: (context, index) {
                        return data1[index];
                      }),
                ),
                //Text(counter.counters),
              ],
            ),
          ),
          Row(
            mainAxisAlignment:MainAxisAlignment.end,
          children: <Widget>[
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NavigationPage(ID, title),
                ),
              );
            },
            child: Icon(Icons.list),
          ),
          ],
          ),
        ],
      ),
    );
  }
}

LineChartData chart(List<FlSpot> spots, List<String> days) {
  return LineChartData(
    gridData: FlGridData(
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.black12,
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
        leftTitles: SideTitles(
      showTitles: true,
      margin: 20,
    ),
      bottomTitles: SideTitles(
        showTitles: true,
        getTitles: (value) {
          int i = value.toInt();
          String t = days[i - 1];
          if (i % 3 == 2) {
            t = "\n" + t;
          }
          else if (i % 3 == 0) {
            t = "\n\n" + t;
          }
          return t;
        }
      ),
    ),
    borderData: FlBorderData(show: true),
    lineBarsData: [
      LineChartBarData(
        spots: spots,
      )
    ],
  );
}
