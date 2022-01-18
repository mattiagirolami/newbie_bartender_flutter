import 'dart:collection';
import 'dart:ffi';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newbie_bartender/utils/colors.dart';

class VisualizzaRicetta extends StatefulWidget {
  DocumentSnapshot document;

  VisualizzaRicetta({Key? key, required this.document}) : super(key: key);

  @override
  _VisualizzaRicettaState createState() => _VisualizzaRicettaState();
}

// visualizza specifiche ricetta
class _VisualizzaRicettaState extends State<VisualizzaRicetta> {
  User auth = FirebaseAuth.instance.currentUser!;

  List<String> favouriteList = [];

  List<String> ingredientiList = [];

  bool isFav = false;

  bool isRated = false;

  final List<String> votiPossibili = ["0", "1", "2", "3", "4", "5"];

  String? voto;

  HashMap<String, String> valutazioneMap = HashMap();

  List valutazioneList = [];

  String urlImmagine = "";

// immagine di default su storage
  String defaultImage =
      "https://firebasestorage.googleapis.com/v0/b/newbie-bartender.appspot.com/o/images%2Fdrink_default.jpg?alt=media&token=59abc9b0-02c7-4410-beaf-c66b63131d6e";

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)));

// spinner voti
    final spinnerVoti = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1)),
      child: DropdownButtonFormField<String>(
        hint: Text("Voto"),
        value: voto,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 36,
        isExpanded: true,
        items: votiPossibili.map(buildMenuItem).toList(),
        onChanged: (value) => setState(() {
          emptyIngredienti();
          voto = value;
        }),
        validator: (value) {
          if (value!.isEmpty) {
            return ("Inserire un voto");
          }
        },
      ),
    );

    return FutureBuilder(
        future: getImmagine(),
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return FutureBuilder(
              future: emptyIngredienti(),
              builder: (BuildContext context, AsyncSnapshot<String> text) {
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
                            image: (urlImmagine == "")
                                ? NetworkImage(defaultImage)
                                : NetworkImage(urlImmagine),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("${widget.document["tipoRicetta"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Column(
                                    children: [
                                      Text("Difficoltà:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("${widget.document["difficoltà"]}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                  SizedBox(
                                    width: 60,
                                  ),
                                  Column(
                                    children: [
                                      Text("Rating:",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text("${calculateAvg()} su 5",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 40, right: 40),
                                child: Text("${getIngredienti()}"),
                              ),
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
                              Expanded(
                                child: Text(
                                  "${widget.document["descrizione"]}",
                                ),
                              )
                            ],
                          ),
                        ),
                        (!checkRatings())
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text("Aggiungi la tua valutazione:",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold))
                                  ],
                                ),
                              )
                            : Container(),
                        (!checkRatings())
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 40),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      child: spinnerVoti,
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
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            primary:
                                                ColorsPersonal.verde_button,
                                            elevation: 0,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : Container(),
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
                        SizedBox(
                          height: 30,
                        )
                      ],
                    )),
                  ),
                );
              });
        });
  }

// calcola media valutazione
  double calculateAvg() {
    int somma = 0;
    int counter = 0;
    double media = 0;

    for (var valutazione in widget.document["valutazioni"]) {
      int voto = int.parse(widget.document["valutazioni"][counter]["voto"]);
      somma += voto;
      counter++;
    }
    if (somma != 0) {
      media = (somma / counter);
    }

// aggiorna media
    FirebaseFirestore.instance
        .collection("cocktail")
        .doc(widget.document.id)
        .update({"mediaValutazioni": media});

    return media;
  }

// controlla se hai inserito voto
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

  // aggiunge voto
  addRating() {
    isRated = true;
    valutazioneList.length = 1;

    valutazioneMap["email"] = auth.email!;
    valutazioneMap["voto"] = voto!;

    valutazioneList[0] = valutazioneMap;

    FirebaseFirestore.instance
        .collection("cocktail")
        .doc(widget.document.id)
        .update({"valutazioni": FieldValue.arrayUnion(valutazioneList)});

    Fluttertoast.showToast(msg: "Hai inserito una valutazione di $voto/5");
  }

// controlla se aggiunto a preferiti
  checkFavourite() {
    for (String favourite in widget.document["preferiti"]) {
      if (favourite == auth.email) {
        isFav = true;
      }
    }
    return isFav;
  }

// aggiunge a preferiti
  addFavourite() {
    isFav = true;
    favouriteList.length = 1;
    favouriteList[0] = auth.email.toString();

    FirebaseFirestore.instance
        .collection("cocktail")
        .doc(widget.document.id)
        .update({"preferiti": FieldValue.arrayUnion(favouriteList)});

    return Fluttertoast.showToast(msg: "Aggiunto ai Preferiti");
  }

// rimuove da preferiti
  removeFavourite() {
    isFav = false;
    favouriteList.length = 1;
    favouriteList[0] = auth.email.toString();

    FirebaseFirestore.instance
        .collection("cocktail")
        .doc(widget.document.id)
        .update({"preferiti": FieldValue.arrayRemove(favouriteList)});

    return Fluttertoast.showToast(msg: "Rimosso dai Preferiti");
  }

// visualizza ingredienti cocktail
  getIngredienti() {
    for (var ingrediente in widget.document["ingredienti"]) {
      ingredientiList.add(ingrediente);
    }
    return ingredientiList;
  }

// visualizza immagine cocktail (se caricata)
  Future<String> getImmagine() async {
    urlImmagine = await FirebaseStorage.instance
        .ref()
        .child("${widget.document["tipoRicetta"]}/${widget.document.id}.jpg")
        .getDownloadURL();

    return urlImmagine;
  }

// per non duplicare la lista degli ingredienti
  emptyIngredienti() {
    ingredientiList = [];
  }
}
