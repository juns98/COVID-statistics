import 'package:flutter/material.dart';
import 'package:pa3/StartCorona.dart';

void main() {
  runApp(
    MaterialApp(
      title: 'Covid',
      home: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  @override
    Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Main Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (routerSettings) {
        switch(routerSettings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => MyHomePage(title: "Home"));
            break;
          case '/start':
            return MaterialPageRoute(
                builder: (_) => StartCorona(routerSettings.arguments));
            break;
          default:
            return MaterialPageRoute(builder: (_) => MyHomePage(title: "Error",));
        }
      },
    );
    }
}



class MyHomePage extends StatelessWidget {
  // This widget is the root of your application.
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  final TextController1 = TextEditingController();
  final TextController2 = TextEditingController();


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Hello"),
      ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  "Corona Live",
              ),
              Text(
                "Login Please..",
              ),
              Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 3)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("ID:"),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: TextController1,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("PW:"),
                        SizedBox(
                          width: 200,
                          child: TextField(
                            controller: TextController2,
                          ),
                        )
                      ],
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (TextController1.text == "skku" && TextController2.text == "1234") {
                            Navigator.pushNamed(
                              context,
                              '/start',
                             arguments: TextController1.text,
                              );
                          }
                        },
                        child: Text("Login")
                    )
                  ],
                )
              )
            ],
          )
        ),
      );
  }
}
