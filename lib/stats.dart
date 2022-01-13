// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:newbie_bartender/visualizza_ricetta.dart';

class Stats extends StatefulWidget {
  Stats({Key? key}) : super(key: key);

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
  String urlImmagine = "";

  String defaultImage =
      "https://firebasestorage.googleapis.com/v0/b/newbie-bartender.appspot.com/o/images%2Fdrink_default.jpg?alt=media&token=59abc9b0-02c7-4410-beaf-c66b63131d6e";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("I più amati",
              style: TextStyle(
                color: Colors.white,
              )),
        ),
        body: listaVisualizzazione());
  }

  Widget listaVisualizzazione() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("cocktail")
            .where("mediaValutazioni", isGreaterThanOrEqualTo: 4.0)
            .where("mediaValutazioni", isLessThanOrEqualTo: 5.0)
            .orderBy("mediaValutazioni", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return (snapshot.connectionState == ConnectionState.waiting)
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    return FutureBuilder(
                      future: getImmagine(document),
                      builder:
                          (BuildContext context, AsyncSnapshot<String> text) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisualizzaRicetta(
                                          document: document,
                                        )));
                          },
                          child: Container(
                            padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                            child: Card(
                              color: Colors.black87,
                              clipBehavior: Clip.antiAlias,
                              elevation: 20,
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Ink.image(
                                      image: (urlImmagine == "")
                                          ? NetworkImage(defaultImage)
                                          : NetworkImage(urlImmagine),
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ]),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(20, 0, 0, 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${document["titolo"]}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "Ricetta di ${document["autore"]}",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 50,
                                              ),
                                              RatingBar.builder(
                                                minRating: 0,
                                                itemSize: 20,
                                                initialRating: document[
                                                    "mediaValutazioni"],
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.yellow,
                                                ),
                                                onRatingUpdate: (rating) {},
                                                ignoreGestures: true,
                                              )
                                            ],
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
        });
  }

  Future<String> getImmagine(DocumentSnapshot document) async {
    urlImmagine = await FirebaseStorage.instance
        .ref()
        .child("${document["tipoRicetta"]}/${document.id}.jpg")
        .getDownloadURL();

    return urlImmagine;
  }
}
