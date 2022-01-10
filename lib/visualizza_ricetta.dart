import 'dart:collection';
import 'dart:ffi';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newbie_bartender/utils/colors.dart';

class VisualizzaRicetta extends StatefulWidget {
  DocumentSnapshot document;

  VisualizzaRicetta({Key? key, required this.document}) : super(key: key);

  @override
  _VisualizzaRicettaState createState() => _VisualizzaRicettaState();
}

class _VisualizzaRicettaState extends State<VisualizzaRicetta> {
  User auth = FirebaseAuth.instance.currentUser!;

  List<String> favouriteList = [];

  bool isFav = false;

  bool isRated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.document["tipoRicetta"]}",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (!checkFavourite()) {
                addFavourite();
              } else {
                removeFavourite();
              }
              Navigator.pop(context);
            },
            icon: (!checkFavourite())
                ? Icon(
                    Icons.star_border_outlined,
                    color: ColorsPersonal.grigio_batman,
                  )
                : Icon(
                    Icons.star,
                    color: ColorsPersonal.grigio_batman,
                  ),
          )
        ],
      ),
      body: Center(
          child: Column(
        children: [
          Text("${widget.document["titolo"]}"),
          Text("${calculateAvg()}")
        ],
      )),
    );
  }

  double calculateAvg() {
    int somma = 0;
    int counter = 0;

    for (var valutazione in widget.document["valutazioni"]) {
      int voto = int.parse(widget.document["valutazioni"][counter]["voto"]);
      somma += voto;
      counter++;
    }
    if (somma == 0) {
      return 0;
    } else {
      return (somma / counter);
    }
  }

  checkRatings() {
    int counter = 0;
    for (var valutazione in widget.document["valutazioni"]) {
      if (widget.document["valutazioni"][counter]["email"] ==
          auth.email) {
        isRated = true;
      }
      counter++;
    }
    return isRated;
  }

  checkFavourite() {
    for (String favourite in widget.document["preferiti"]) {
      if (favourite == auth.email) {
        isFav = true;
      }
    }
    return isFav;
  }

  addFavourite() {
    isFav = true;
    favouriteList.length = 1;
    favouriteList[0] = auth.email.toString();

    FirebaseFirestore.instance
        .collection(widget.document["tipoRicetta"])
        .doc(widget.document.id)
        .update({"preferiti": FieldValue.arrayUnion(favouriteList)});

    return Fluttertoast.showToast(msg: "Aggiunto ai Preferiti");
  }

  removeFavourite() {
    isFav = false;
    favouriteList.length = 1;
    favouriteList[0] = auth.email.toString();

    FirebaseFirestore.instance
        .collection(widget.document["tipoRicetta"])
        .doc(widget.document.id)
        .update({"preferiti": FieldValue.arrayRemove(favouriteList)});

    return Fluttertoast.showToast(msg: "Rimosso dai Preferiti");
  }
}
