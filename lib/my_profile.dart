import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:newbie_bartender/login.dart';

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
                              onPressed: () {},
                              child: Icon(Icons.photo_camera,
                                  size: 20, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
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
                          height: 30,
                        ),
                        Text("$username"),
                        SizedBox(
                          height: 30,
                        ),
                        Text("${auth!.email}"),
                        SizedBox(
                          height: 30,
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Modifica Password",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.lightGreenAccent, elevation: 0),
                        ),
                      ]),
                    ));
              });
        });
  }
}
