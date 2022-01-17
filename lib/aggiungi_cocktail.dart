import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newbie_bartender/navigation.dart';
import 'package:newbie_bartender/utils/colors.dart';

class AggiungiCocktail extends StatefulWidget {
  AggiungiCocktail({Key? key}) : super(key: key);

  @override
  _AggiungiCocktailState createState() => _AggiungiCocktailState();
}

class _AggiungiCocktailState extends State<AggiungiCocktail> {
  List<String> listaIngredienti = [];

  final List<String> tipologiePossibili = ["Analcolico", "Alcolico"];

  final List<String> difficoltaPossibili = ["Bassa", "Media", "Alta"];

  String? tipologia;

  String? difficolta;

  String username = "";

  User? auth = FirebaseAuth.instance.currentUser;
  DocumentSnapshot? user;

  File? imageFile;
  final picker = ImagePicker();

  Future<String> getUsername() async {
    user = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth!.email)
        .get();
    username = user!["username"];
    return username;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController titoloController = TextEditingController();
    TextEditingController ingredienteController = TextEditingController();
    TextEditingController procedimentoController = TextEditingController();

    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item,
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20)));

    final spinnerTipologia = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1)),
      child: DropdownButtonFormField<String>(
        hint: Text("Tipologia"),
        value: tipologia,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 20,
        isExpanded: true,
        items: tipologiePossibili.map(buildMenuItem).toList(),
        onChanged: (value) => tipologia = value,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Inserire la tipologia del cocktail");
          }
        },
      ),
    );

    final spinnerDifficolta = Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1)),
      child: DropdownButtonFormField<String>(
        hint: Text("Difficoltà"),
        value: difficolta,
        icon: Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 20,
        isExpanded: true,
        items: difficoltaPossibili.map(buildMenuItem).toList(),
        onChanged: (value) => difficolta = value,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Inserire la difficoltà del cocktail");
          }
        },
      ),
    );

    return FutureBuilder(
        future: getUsername(),
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return Scaffold(
            backgroundColor: ColorsPersonal.arancione_bello,
            appBar: AppBar(
              title: Text("Inserisci nuova ricetta",
                  style: TextStyle(
                    color: Colors.white,
                  )),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(40, 20, 40, 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: titoloController,
                      decoration: InputDecoration(
                        hintText: "Nome",
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(children: [
                      Text("Immagine:"),
                    ]),
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: 15,
                            ),
                            GestureDetector(
                              onTap: () {
                                caricaFoto(ImageSource.gallery);
                              },
                              child: (imageFile == null)
                                  ? Image.asset(
                                      "assets/glass_image.jpg",
                                      width: 120,
                                      height: 120,
                                    )
                                  : Image.file(
                                      imageFile!,
                                      width: 120,
                                      height: 120,
                                    ),
                            )
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 70,
                              child: spinnerTipologia,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: 150,
                              height: 70,
                              child: spinnerDifficolta,
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 160,
                          child: TextField(
                            controller: ingredienteController,
                            decoration: InputDecoration(
                              hintText: "Ingredienti",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            onPressed: () {
                              addIngrediente(ingredienteController.text);
                              ingredienteController.clear();
                            },
                            style: ElevatedButton.styleFrom(
                                primary: Colors.grey[800]),
                            child: Text(
                              "AGGIUNGI",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextField(
                      controller: procedimentoController,
                      decoration: InputDecoration(
                        hintText: "Procedimento",
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          aggiungiCocktail(titoloController.text,
                              procedimentoController.text);
                        },
                        style:
                            ElevatedButton.styleFrom(primary: Colors.grey[800]),
                        child: Text(
                          "SALVA",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  aggiungiCocktail(String titolo, String descrizione) async {

    if (titolo == "") {
      Fluttertoast.showToast(msg: "Inserire il nome del cocktail");
      return;
    }
    if (tipologia == null) {
      Fluttertoast.showToast(msg: "Inserire la tipologia del cocktail");
      return;
    }
    if (descrizione == "") {
      Fluttertoast.showToast(msg: "Inserire la descrizione");
      return;
    }
    if (difficolta == null) {
      Fluttertoast.showToast(msg: "Inserire la difficoltà");
      return;
    }
    if (listaIngredienti.isEmpty) {
      Fluttertoast.showToast(msg: "Inserire almeno un ingrediente");
      return;
    }

    Fluttertoast.showToast(msg: "Salvataggio in corso...");

    Map<String, dynamic> cocktail = HashMap();

    cocktail["id"] = getRandom(20);
    cocktail["tipoRicetta"] = tipologia!.toLowerCase();
    cocktail["difficoltà"] = difficolta;
    cocktail["preferiti"] = [];
    cocktail["mediaValutazioni"] = 0.0;
    cocktail["valutazioni"] = [];
    cocktail["descrizione"] = descrizione;
    cocktail["autore"] = username;
    cocktail["titolo"] = titolo;
    cocktail["ingredienti"] = listaIngredienti;

    await FirebaseFirestore.instance.collection("cocktail").doc().set(cocktail);

    if(imageFile != null)  {

    await FirebaseStorage.instance
        .ref()
        .child(
            "${cocktail["tipoRicetta"].toString()}/${cocktail["id"].toString()}.jpg")
        .putFile(imageFile!);

    }

    Fluttertoast.showToast(msg: "Ricetta salvata correttamente");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Navigation()),
        (route) => false);
  }

  addIngrediente(String? ingrediente) {
    if (ingrediente != "") {
      listaIngredienti.add(ingrediente!);
      Fluttertoast.showToast(msg: "$ingrediente aggiunto");
    }
  }

  String getRandom(int length) {
    const ch = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random r = Random();
    return String.fromCharCodes(
        Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
  }

  caricaFoto(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }
}
