import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VisualizzaRicetta extends StatefulWidget {
  DocumentSnapshot document;

  VisualizzaRicetta({Key? key, required this.document}) : super(key: key);

  @override
  _VisualizzaRicettaState createState() => _VisualizzaRicettaState();
}

class _VisualizzaRicettaState extends State<VisualizzaRicetta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("${widget.document["titolo"]}")),
    );
  }
}
