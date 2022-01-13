import 'package:flutter/material.dart';
import 'package:newbie_bartender/utils/colors.dart';

class AggiungiCocktail extends StatefulWidget {
  AggiungiCocktail({Key? key}) : super(key: key);

  @override
  _AggiungiCocktailState createState() => _AggiungiCocktailState();
}

class _AggiungiCocktailState extends State<AggiungiCocktail> {
  List<String> listaIngredienti = [];

  @override
  Widget build(BuildContext context) {
    TextEditingController nomeController = TextEditingController();
    TextEditingController ingredienteController = TextEditingController();
    TextEditingController procedimentoController = TextEditingController();

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
        child: Column(
          children: [
            TextField(
              controller: nomeController,
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
                      onTap: () {},
                      child: Image.asset(
                        "assets/glass_image.jpg",
                        width: 120,
                        height: 120,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 40,
                ),
                Column(
                  children: [Text("Tipologia:"), Text("Difficoltà:")],
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: TextField(
                    controller: ingredienteController,
                    decoration: InputDecoration(
                      hintText: "Ingredienti",
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(primary: Colors.grey[800]),
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
              controller: nomeController,
              decoration: InputDecoration(
                hintText: "Procedimento",
              ),
            ),
             SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(primary: Colors.grey[800]),
                    child: Text(
                      "SALVA",
                      style: TextStyle(color: Colors.white),
                    ))
          ],
        ),
      ),
    );
  }
}
