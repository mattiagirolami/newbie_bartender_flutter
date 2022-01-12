import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:newbie_bartender/visualizza_ricetta.dart';

Widget listaVisualizzazione(String? tipoRicetta) {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("cocktail").where("tipoRicetta", isEqualTo: tipoRicetta).snapshots(),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot document = snapshot.data!.docs[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        document["titolo"],
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VisualizzaRicetta(
                                      document: document,
                                    )));
                      },
                    ),
                  );
                },
              );
      });
}
