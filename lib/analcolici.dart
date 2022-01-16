import 'package:flutter/material.dart';
import 'package:newbie_bartender/lista_visualizzazione.dart';

class Analcolici extends StatefulWidget {
  Analcolici({Key? key}) : super(key: key);

  @override
  _AnalcoliciState createState() => _AnalcoliciState();
}

class _AnalcoliciState extends State<Analcolici> {
  String ingrediente = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Analcolici",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: Container(
          child: Column(
            children: [
              Card(
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Ricerca ingrediente"),
                  onChanged: (value) {
                    setState(() {
                      ingrediente = value;
                    });
                  },
                ),
              ),
              Expanded(child: listaVisualizzazione("analcolico", ingrediente))
            ],
          ),
        ));
  }
}
