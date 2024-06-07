import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const request = "https://api.hgbrasil.com/finance?key=d18b57f7";



void main() {
  runApp(const MaterialApp(
    home: Conversor(),
  ));
}

class Conversor extends StatefulWidget {
  const Conversor({super.key});

  @override
  State<Conversor> createState() => _ConverterState();
}

class _ConverterState extends State<Conversor> {

  var realController = TextEditingController();
  var dolarController = TextEditingController();
  var euroController = TextEditingController();
  late double dolar;
  late double euro;


  void _realChanged(String text) {
    double real = double.parse(text);
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanged(String text) {
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanged(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("\$ Conversor de moeda \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: getdata(),
        builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              return Center(
                child: Text("Carregando ...", textAlign: TextAlign.center,),
              );
            default:
            if(snapshot.hasError){
              return Center(
                child: Text("Erro ao carregar os dados: ", textAlign: TextAlign.center,),
              );
            } else{
              dolar = snapshot.data!["results"]["curriencies"]["USD"]["Buy"];
              euro = snapshot.data!["results"]["curriencies"]["USD"]["Buy"];
              return
              SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "Reais",
                labelStyle: TextStyle(
                color:  Colors.amber,
              
                ),
                border: OutlineInputBorder(),
                prefixText: "R\$"
              ),
              style: TextStyle(color: Colors.amber, fontSize: 25),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              controller: realController,
              onChanged: (value){
                _realChanged(value);
              },
            ),

            SizedBox(height: 20,),

            TextField(
              decoration: InputDecoration(
                labelText: "Dolares",
                labelStyle: TextStyle(
                color:  Colors.amber,
              
                ),
                border: OutlineInputBorder(),
                prefixText: "US\$"
              ),
               style: TextStyle(color: Colors.amber, fontSize: 25),
               keyboardType: TextInputType.numberWithOptions(decimal: true),
               controller: dolarController,
               onChanged: (value){
                _dolarChanged(value);
               },
            ),

             SizedBox(height: 20,),

            TextField(
              decoration: InputDecoration(
                labelText: "Euros",
                labelStyle: TextStyle(
                color:  Colors.amber,
              
                ),
                border: OutlineInputBorder(),
                prefixText: "€"
              ),
               style: TextStyle(color: Colors.amber, fontSize: 25),
               keyboardType: TextInputType.numberWithOptions(decimal: true),
               controller: euroController,
               onChanged: (value){
                _euroChanged(value);
               },
            ),

             SizedBox(height: 20,),

          ],
        ),

      );
            }
            }
        })
      
      
      
    );
  }
  Future<Map> getdata() async{
    var url = Uri.parse(request);
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }
}
