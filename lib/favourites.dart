import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newbie_bartender/visualizza_ricetta.dart';

class Favourites extends StatefulWidget {
  Favourites({Key? key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  User auth = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    Widget lista_preferiti(String tipoRicetta) {
      return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(tipoRicetta)
              .where("preferiti", arrayContains: auth.email)
              .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Preferiti",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: lista_preferiti("alcolico"),
              ),
              Container(
                child: lista_preferiti("analcolico"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
