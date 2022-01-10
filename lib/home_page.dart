import 'package:flutter/material.dart';
import 'package:newbie_bartender/alcolici.dart';
import 'package:newbie_bartender/analcolici.dart';
import 'package:newbie_bartender/utils/colors.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsPersonal.arancione_sfondo,
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 200),
                  elevation: 0,
                  padding: EdgeInsets.all(0)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Analcolici()));
              },
              child: Image.asset("assets/analcolici.jpg"),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 200),
                  elevation: 0,
                  padding: EdgeInsets.all(0)),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Alcolici()));
              },
              child: Image.asset("assets/alcolici.jpg"),
            )
          ],
        ),
      ),
    );
  }
}
