import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newbie_bartender/utils/colors.dart';

class ModificaPassword extends StatefulWidget {
  ModificaPassword({Key? key}) : super(key: key);

  @override
  _ModificaPasswordState createState() => _ModificaPasswordState();
}

class _ModificaPasswordState extends State<ModificaPassword> {
  static Future updatePassword(
      {required String nuovaPassword, required BuildContext context}) async {
    User? auth = FirebaseAuth.instance.currentUser;

    try {
      await auth!.updatePassword(nuovaPassword);
    } on FirebaseException catch (e) {
      if (e.toString().contains("recent authentication")) {
        Fluttertoast.showToast(
            msg: e.toString(), toastLength: Toast.LENGTH_LONG);
        return;
      }
    }
    if (nuovaPassword.isEmpty) {
      Fluttertoast.showToast(msg: "Password richiesta");
      return;
    }
    if (nuovaPassword.length < 6) {
      Fluttertoast.showToast(msg: "Password minimo 6 caratteri");
      return;
    }

    Fluttertoast.showToast(msg: "Password modificata correttamente");

    return;
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController nuovaPasswordController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Text(
            "Modifica password",
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0,
        ),
        body: Padding(
            padding: EdgeInsets.all(28),
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  SizedBox(
                    height: 50,
                  ),
                  TextField(
                    controller: nuovaPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: "Modifica password",
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
                    child: ElevatedButton(
                      onPressed: () async {
                        updatePassword(
                            nuovaPassword: nuovaPasswordController.text,
                            context: context);
                      },
                      child: Text(
                        "MODIFICA PASSWORD",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: ColorsPersonal.arancione_bello,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                ]))));
  }
}
