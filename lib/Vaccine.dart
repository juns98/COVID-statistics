import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pa3/NavigationPage.dart';

class Country {
  String country;
  List<Data> data;

  Country({this.country, this.data});

  Country.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

List<Country> parsePhotos(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Country>((json) => Country.fromJson(json)).toList();
}

Future<Map<String, dynamic>> fetchAlbum() async {
  final response = await http.get(
      "https://raw.githubusercontent.com/owid/covid-19-data/master/public/data/vaccinations/vaccinations.json");
  print('status = ${response.statusCode}');

  if (response.statusCode == 200) {
    final Map<String, dynamic> list = new Map<String, dynamic>();
    int daily = 0, total = 0, fully = 0;
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
    List<dynamic> totalList = new List<dynamic>();
    List<dynamic> fullyList = new List<dynamic>();
    List<dynamic> dailyList = new List<dynamic>();
    List<Country> countries = parsePhotos(response.body);
    int numofCountry = countries.length;
    int lastdate;
    for (int i = 0; i<countries.length; i++) {
      if (countries.elementAt(i).country.toString() == "South Korea") {
        lastdate = countries.elementAt(i).data.length;
      }
    }
    for (int i = 0; i < countries.length; i++) {
      if (countries.elementAt(i).country.toString() == "South Korea") {
        for(int j=0; j<7; j++) {
          int l = countries.elementAt(i).data.length;
          String temp = countries.elementAt(i).data.elementAt(l - 7 + j).date;
         temp = temp.substring(5,10);
          days7[j] = temp;
        }
        for(int j=0; j<28; j++) {
          int l = countries.elementAt(i).data.length;
          String temp = countries.elementAt(i).data.elementAt(l - 28 + j).date;
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
                .total_Vaccinations !=
                null)
          gcases1[j] += countries
              .elementAt(i)
              .data
              .elementAt(countries.elementAt(i).data.length - 7 + j)
              .total_Vaccinations;
        if (countries.elementAt(i).data.length - 7 + j >= 0 &&
            countries
                .elementAt(i)
                .data
                .elementAt(countries.elementAt(i).data.length - 7 + j)
                .daily_Vaccinations !=
                null)
          gdaily1[j] += countries
              .elementAt(i)
              .data
              .elementAt(countries.elementAt(i).data.length - 7 + j)
              .daily_Vaccinations;
      }
      for (int j = 0; j < 28; j++) {
        if (countries.elementAt(i).data.length - 28 + j >= 0 &&
            countries
                .elementAt(i)
                .data
                .elementAt(countries.elementAt(i).data.length - 28 + j)
                .total_Vaccinations !=
                null)
          gcases2[j] += countries
              .elementAt(i)
              .data
              .elementAt(countries.elementAt(i).data.length - 28 + j)
              .total_Vaccinations;
        if (countries.elementAt(i).data.length - 28 + j >= 0 &&
            countries
                .elementAt(i)
                .data
                .elementAt(countries.elementAt(i).data.length - 28 + j)
                .daily_Vaccinations !=
                null)
          gdaily2[j] += countries
              .elementAt(i)
              .data
              .elementAt(countries.elementAt(i).data.length - 28 + j)
              .daily_Vaccinations;
      }

      if (countries.elementAt(i).country != null) {
        temp = countries.elementAt(i).country;
        countryList.add(temp);
      }

      // daily vaccination
      if (lastdate == countries.elementAt(i).data.length) {
        if (countries
            .elementAt(i)
            .data
            .last
            .daily_Vaccinations != null) {
          daily += countries
              .elementAt(i)
              .data
              .last
              .daily_Vaccinations;
          dailyList.add(countries
              .elementAt(i)
              .data
              .last
              .daily_Vaccinations);
        } else {
          if (countries
              .elementAt(i)
              .data
              .elementAt(lastdate - 2)
              .daily_Vaccinations != null) {
            dailyList.add(countries
                .elementAt(i)
                .data
                .elementAt(lastdate - 2)
                .daily_Vaccinations);
          }
          else {
            dailyList.add("null");
          }
        }
      }
      else {
        if (countries.elementAt(i).data.last.people_Fully_Vaccinated != null) {
          dailyList.add(countries
              .elementAt(i)
              .data
              .last
              .people_Fully_Vaccinated);
        }
        else {
          dailyList.add("null");
  }
      }

      //fully vaccinated
      if (lastdate == countries.elementAt(i).data.length) {
        if (countries
            .elementAt(i)
            .data
            .last
            .people_Fully_Vaccinated != null) {
          fully += countries
              .elementAt(i)
              .data
              .last
              .people_Fully_Vaccinated;
          fullyList.add(countries
              .elementAt(i)
              .data
              .last
              .people_Fully_Vaccinated);
        } else {
          if (countries
              .elementAt(i)
              .data
              .elementAt(lastdate - 2)
              .people_Fully_Vaccinated != null) {
            fullyList.add(countries
                .elementAt(i)
                .data
                .elementAt(lastdate - 2)
                .people_Fully_Vaccinated);
          }
          else {
            fullyList.add("null");
          }
        }
      }
      else {
        if (countries.elementAt(i).data.last.people_Fully_Vaccinated != null) {
          fullyList.add(countries
              .elementAt(i)
              .data
              .last
              .people_Fully_Vaccinated);
        }
        else {
          fullyList.add("null");
        }
      }

      //total vaccination
      if (countries.elementAt(i).data.last.total_Vaccinations != null) {
        total += countries.elementAt(i).data.last.total_Vaccinations;
        totalList.add(countries.elementAt(i).data.last.total_Vaccinations);
      } else if (countries.elementAt(i).data.last.people_Fully_Vaccinated != null) {
        totalList.add(countries.elementAt(i).data.last.people_Fully_Vaccinated);
      } else if (countries.elementAt(i).data.last.people_Vaccinated != null) {
        totalList.add(countries.elementAt(i).data.last.people_Vaccinated);
      }

      if (countries.elementAt(i).country.toString() == "South Korea") {
        date = countries.elementAt(i).data.last.date;
      }
    }
    list["num"] = numofCountry;
    list["date"] = date;
    list["daily"] = daily;
    list["fully"] = fully;
    list["total"] = total;
    list["countryList"] = countryList;
    list["dailyList"] = dailyList;
    list["fullyList"] = fullyList;
    list["totalList"] = totalList;
    list["days7"] = days7;
    list["days28"] = days28;
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
  int total_Vaccinations;
  int people_Vaccinated;
  int daily_Vaccinations;
  int people_Fully_Vaccinated;

  Data(
      {this.date,
      this.total_Vaccinations,
      this.people_Vaccinated,
      this.daily_Vaccinations,
      this.people_Fully_Vaccinated});

  Data.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    total_Vaccinations = json['total_vaccinations'];
    people_Vaccinated = json['people_vaccinated'];
    daily_Vaccinations = json['daily_vaccinations'];
    people_Fully_Vaccinated = json['people_fully_vaccinated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['total_vaccinations'] = this.total_Vaccinations;
    data['people_vaccinated'] = this.people_Vaccinated;
    data['daily_vaccinations'] = this.daily_Vaccinations;
    data['people_fully_vaccinated'] = this.people_Fully_Vaccinated;
    return data;
  }
}

class Vaccine extends StatelessWidget {
  //changeState counter = new changeState(0);
  final String ID;
  final String title = "Vaccine";
  String country;
  String temp;
  List<Widget> data0 = new List<Widget>();
  List<Widget> data1;
  List<Widget> data2 = new List<Widget>();
  LineChartData ch;
  LineChartData first, second, third, fourth;
  List<FlSpot> list1 = new List<FlSpot>(7);
  List<FlSpot> list2 = new List<FlSpot>(7);
  List<FlSpot> list3 = new List<FlSpot>(28);
  List<FlSpot> list4 = new List<FlSpot>(28);

  Vaccine(this.ID, this.data1, this.ch);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            Text("total" + "          "),
                            Text("fully" + "          "),
                            Text("daily" + "          "),
                          ],
                        ));
                        data2.add(Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text("Country" + "           "),
                            Text("total" + "           "),
                            Text("fully" + "           "),
                            Text("daily" + "           "),
                          ],
                        ));
                        for (int i = 0; i < 7; i++) {
                          data1.add(Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data["countryList"].elementAt(i) +
                                  "      "),
                              Text(snapshot.data["totalList"]
                                      .elementAt(i)
                                      .toString() +
                                  "       "),
                              Text(snapshot.data["fullyList"]
                                      .elementAt(i)
                                      .toString() +
                                  "       "),
                              Text(snapshot.data["dailyList"]
                                      .elementAt(i)
                                      .toString() +
                                  "       "),
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
                            if (snapshot.data["totalList"].elementAt(j) !=
                                "null") {
                              if (snapshot.data["totalList"].elementAt(max) <
                                  snapshot.data["totalList"].elementAt(j)) {
                                max = j;
                              }
                            }
                          }
                          selected.add(max);
                          data2.add(Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(snapshot.data["countryList"].elementAt(max) +
                                  "     "),
                              Text(snapshot.data["totalList"]
                                      .elementAt(max)
                                      .toString() +
                                  "     "),
                              Text(snapshot.data["fullyList"]
                                      .elementAt(max)
                                      .toString() +
                                  "     "),
                              Text(snapshot.data["dailyList"]
                                      .elementAt(max)
                                      .toString() +
                                  "     "),
                            ],
                          ));
                        }
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Total Vacc.                       "),
                                Text("Parsed latest date"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(snapshot.data["total"].toString() +
                                    " people                        "),
                                Text(snapshot.data["date"]),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                    "Total fully Vacc.                       "),
                                Text("Daily Vacc."),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(snapshot.data["fully"].toString() +
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
                              builder: (context) => Vaccine(ID, data0, first),
                            ),
                          );
                        },
                        child: Text("   Graph1   ")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Vaccine(ID, data0, second),
                            ),
                          );
                        },
                        child: Text("   Graph2    ")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Vaccine(ID, data0, third),
                            ),
                          );
                        },
                        child: Text("   Graph3   ")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Vaccine(ID, data0, fourth),
                            ),
                          );
                        },
                        child: Text("   Graph4    ")),
                  ],
                ),
                Divider(
                    color: Colors.black
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    height: 600,
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
                              builder: (context) => Vaccine(ID, data1, ch),
                            ),
                          );
                        },
                        child: Text("         Country_name          ")),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Vaccine(ID, data2, ch),
                            ),
                          );
                        },
                        child: Text("         Total_vacc          ")),
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
            mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget> [
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
            })),
    borderData: FlBorderData(show: true),
    lineBarsData: [
      LineChartBarData(
        spots: spots,
      )
    ],
  );
}
