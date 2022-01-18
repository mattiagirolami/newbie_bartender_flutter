import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newbie_bartender/favourites.dart';
import 'package:newbie_bartender/login.dart';
import 'package:newbie_bartender/modifica_password.dart';
import 'package:newbie_bartender/utils/colors.dart';

class MyProfile extends StatefulWidget {
  MyProfile({Key? key}) : super(key: key);

  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  User? auth;

  DocumentSnapshot? user;

  String username = "";

  String urlImmagine = "";

  File? imageFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance.currentUser;
    setState(() {});
  }

  Future<String> getUsername() async {
    user = await FirebaseFirestore.instance
        .collection("users")
        .doc(auth!.email)
        .get();
    username = user!["username"];
    return username;
  }

  Future<String> getImmagine() async {
    urlImmagine = await FirebaseStorage.instance
        .ref()
        .child("images/${auth!.email}.jpg")
        .getDownloadURL();
    return urlImmagine;
  }

  logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getImmagine(),
        builder: (BuildContext context, AsyncSnapshot<String> text) {
          return FutureBuilder(
              future: getUsername(),
              builder: (BuildContext context, AsyncSnapshot<String> text) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        "Profilo",
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        IconButton(
                            onPressed: logout,
                            icon: Icon(Icons.exit_to_app, color: Colors.white))
                      ],
                    ),
                    body: Center(
                      child: Column(children: [
                        SizedBox(
                          height: 50,
                        ),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Column(children: [
                            SizedBox(
                                height: 200,
                                width: 300,
                                child: (urlImmagine == "")
                                    ? Image.asset("assets/user.png")
                                    : Image.network(urlImmagine)),
                          ]),
                          Column(children: [
                            ElevatedButton(
                              onPressed: () {
                                caricaFoto(ImageSource.camera);
                              },
                              child: Icon(Icons.photo_camera,
                                  size: 20, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                caricaFoto(ImageSource.gallery);
                              },
                              child: Icon(Icons.edit_outlined,
                                  size: 20, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                          ]),
                        ]),
                        SizedBox(
                          height: 40,
                        ),
                        Text("$username", style: TextStyle(fontSize: 30),),
                        SizedBox(
                          height: 30,
                        ),
                        Text("${auth!.email}", style: TextStyle(fontSize: 20)),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Favourites()));
                            },
                            child: Text(
                              "Preferiti",
                              style: TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorsPersonal.verde_button,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ModificaPassword()));
                            },
                            child: Text(
                              "Modifica Password",
                              style: TextStyle(color: Colors.white,fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: ColorsPersonal.verde_button,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ));
              });
        });
  }

  caricaFoto(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      imageFile = File(pickedFile!.path);
    });

    await FirebaseStorage.instance
        .ref()
        .child("images/${auth!.email}.jpg")
        .putFile(imageFile!);

        initState();

    Fluttertoast.showToast(msg: "Immagine caricata");
  }
}
