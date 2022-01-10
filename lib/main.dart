import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newbie_bartender/utils/colors.dart';
import 'package:newbie_bartender/login.dart';
import 'package:newbie_bartender/navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Newbie Bartender',
      theme: ThemeData(
        primarySwatch: ColorsPersonal.buildMaterialColor(Color(0xFFFA7E0A)),
      ),
      debugShowCheckedModeBanner: false,
      home: StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Navigation()));
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsPersonal.arancione_bello,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo_transparent.png'),
          ],
        ),
      ),
    );
  }
}
