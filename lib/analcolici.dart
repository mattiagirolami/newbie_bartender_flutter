import 'package:flutter/material.dart';
import 'package:newbie_bartender/lista_visualizzazione.dart';

class Analcolici extends StatefulWidget {
  Analcolici({Key? key}) : super(key: key);

  @override
  _AnalcoliciState createState() => _AnalcoliciState();
}

class _AnalcoliciState extends State<Analcolici> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Analcolici",
          ),
          elevation: 0,
        ),
        body: listaVisualizzazione("analcolico"));
  }
}
