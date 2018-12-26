import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request =
    "https://api.hgbrasil.com/finance/quotations?format=json&key=9c746ead";

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

void main() => runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.amber),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realControler = TextEditingController();
  final dolaControler = TextEditingController();
  final euroControler = TextEditingController();

  double dola;
  double euro;

  void _realChange(String text) {
    double real = double.parse(text);
    dolaControler.text = (real / dola).toStringAsFixed(2);
    euroControler.text = (real / euro).toStringAsFixed(2);
  }

  void _dolaChange(String text) {
    double dola = double.parse(text);
    realControler.text = (dola * this.dola).toStringAsFixed(2);
    euroControler.text = (dola * this.dola / euro).toStringAsFixed(2);
  }

  void _euroChange(String text) {
    double euro = double.parse(text);
    realControler.text = (euro * this.euro).toStringAsFixed(2);
    dolaControler.text = (euro * this.euro / dola).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("\$ Conversor \$"),
          backgroundColor: Colors.amber,
          centerTitle: true,
        ),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando Dados",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    dola = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(Icons.monetization_on,
                              size: 150, color: Colors.amber),
                          BuildTextFild(
                              "Reais", "\$", realControler, _realChange),
                          Divider(),
                          BuildTextFild(
                              "Dolares", "US", dolaControler, _dolaChange),
                          Divider(),
                          BuildTextFild("Euro", "€", euroControler, _euroChange)
                        ],
                      ),
                    );
                  }
              }
            }));
  }
}

//Função de textos
Widget BuildTextFild(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
      controller: c,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber, fontSize: 25),
      keyboardType: TextInputType.number,
      onChanged: f);
}
