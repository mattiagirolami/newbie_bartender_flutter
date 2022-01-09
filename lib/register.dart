import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newbie_bartender/login.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  static Future<User?> register(
      {required String username,
      required String email,
      required String password,
      required String confermaPassword,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    RegExp regexpEmail = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");

    Map<String, dynamic> newUser = {};

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseException catch (e) {
      if (e.code == "email-already-in-use") {
        Fluttertoast.showToast(msg: "Esiste già un utente con questa email");
      }
    }
    if (username.isEmpty) {
      Fluttertoast.showToast(msg: "Username richiesto");
      return null;
    }
    if (username.length < 5) {
      Fluttertoast.showToast(msg: "Username minimo 6 caratteri");
      return null;
    }
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Email richiesta");
      return null;
    }
    if (!regexpEmail.hasMatch(email)) {
      Fluttertoast.showToast(msg: "Inserire formato email valido");
      return null;
    }
    if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Password richiesta");
      return null;
    }
    if (password.length < 6) {
      Fluttertoast.showToast(msg: "Password minimo 6 caratteri");
      return null;
    }
    if (confermaPassword.isEmpty) {
      Fluttertoast.showToast(msg: "Conferma Password richiesta");
      return null;
    }
    if (password != confermaPassword) {
      Fluttertoast.showToast(msg: "Le password non coincidono");
      return null;
    }

    Fluttertoast.showToast(msg: "Nuovo utente registrato");

    newUser["username"] = username;

    FirebaseFirestore.instance.collection("users").doc(email).set(newUser);

    return user;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confermaPasswordController = TextEditingController();

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("My App Title",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              Text("Login to your App",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 44,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 44,
              ),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                    hintText: "Username",
                    prefixIcon: Icon(
                      Icons.account_box,
                      color: Colors.black,
                    )),
              ),
              SizedBox(
                height: 26,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: "Email",
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    )),
              ),
              SizedBox(
                height: 26,
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Password",
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.black,
                    )),
              ),
              SizedBox(
                height: 26,
              ),
              TextField(
                controller: confermaPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: "Conferma Password",
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.black,
                    )),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: double.infinity,
                child: RawMaterialButton(
                  fillColor: Colors.orange,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onPressed: () async {
                    User? user = await register(
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                        confermaPassword: confermaPasswordController.text,
                        context: context);
                    if (user != null) {
                      FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => Login()));
                    }
                  },
                  child: Text("Registrazione"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
