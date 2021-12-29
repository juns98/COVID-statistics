import 'package:flutter/material.dart';
import 'package:pa3/NavigationPage.dart';
import 'package:pa3/main.dart';


class StartCorona extends StatelessWidget{
  final String argument;
  final String title = "StartCorona";
  StartCorona(this.argument);

   getArgs(String argument, String title) {

  }
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text("2017313973 백준선"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("CORONA LIVE"),
            Text("Login Success. Hello $argument!"),
            SizedBox(
              width: 400,
              height: 400,
              child: Image.asset("assets/images/covid.jpg"),
            ),
            ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NavigationPage(argument, title)
                    ),
                  );
                }, child: Text("Start Corona Live"))
          ],
        ),
      ),
    );
  }
}