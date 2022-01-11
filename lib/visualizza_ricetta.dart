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

  List<String> ingredientiList = [];

  bool isFav = false;

  bool isRated = false;

  final List<String> votiPossibili = ["1", "2", "3", "4", "5"];

  String? voto;

  HashMap<String, String> valutazione = HashMap();

  List pacca = [];

  @override
  Widget build(BuildContext context) {
    final spinnerVoti = DropdownButton<String>(
        hint: Text("Voto"),
        items: votiPossibili.map((String value) {
          return DropdownMenuItem<String>(
            value: voto,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) => setState(() {
              voto = value;
            }));

    return Scaffold(
      backgroundColor: ColorsPersonal.arancione_bello,
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
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          children: [
            Stack(children: [
              Ink.image(
                image: NetworkImage(
                    "https://firebasestorage.googleapis.com/v0/b/newbie-bartender.appspot.com/o/images%2Fdrink_default.jpg?alt=media&token=59abc9b0-02c7-4410-beaf-c66b63131d6e"),
                height: 240,
                fit: BoxFit.cover,
              ),
              Positioned(
                  bottom: 16,
                  right: 16,
                  left: 32,
                  child: Text(
                    "${widget.document["titolo"]}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.bold),
                  )),
            ]),
            Container(
              padding: EdgeInsets.only(top: 15),
              color: Color(0xFFF8E9BC),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Tipologia:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("${widget.document["tipoRicetta"]}",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Column(
                        children: [
                          Text("Difficoltà:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20,
                          ),
                          Text("${widget.document["difficoltà"]}",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                      SizedBox(
                        width: 60,
                      ),
                      Column(
                        children: [
                          Text("Rating:",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 20,
                          ),
                          Text("${calculateAvg()} su 5",
                              style: TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Ingredienti:",
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("${getIngredienti()}"),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Procedimento:",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${widget.document["descrizione"]}",
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Aggiungi la tua valutazione:",
                      style: TextStyle(fontWeight: FontWeight.bold))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, top: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    child: SafeArea(
                      child: Column(
                        children: [spinnerVoti],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          addRating();
                        },
                        child: Text(
                          "Salva",
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: ColorsPersonal.verde_button,
                          elevation: 0,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 60),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Ricetta di ${widget.document["autore"]}",
                  )
                ],
              ),
            ),
          ],
        )),
      ),
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
      if (widget.document["valutazioni"][counter]["email"] == auth.email) {
        isRated = true;
      }
      counter++;
    }
    return isRated;
  }

  addRating() {
    pacca.length = 1;

    valutazione["email"] = auth.email!;
    valutazione["voto"] = voto!;

    pacca[0] = valutazione;

    FirebaseFirestore.instance
        .collection("${widget.document["tipoRicetta"]}")
        .doc(widget.document.id)
        .update({"valutazioni": FieldValue.arrayUnion(pacca)});
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

  getIngredienti() {
    for (var ingrediente in widget.document["ingredienti"]) {
      ingredientiList.add(ingrediente);
    }
    return ingredientiList;
  }
}
