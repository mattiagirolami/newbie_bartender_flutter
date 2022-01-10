import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newbie_bartender/lista_visualizzazione.dart';
import 'package:newbie_bartender/visualizza_ricetta.dart';

class Alcolici extends StatefulWidget {
  Alcolici({Key? key}) : super(key: key);

  @override
  _AlcoliciState createState() => _AlcoliciState();
}

class _AlcoliciState extends State<Alcolici> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Alcolici",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: listaVisualizzazione("alcolico"));
  }
}
