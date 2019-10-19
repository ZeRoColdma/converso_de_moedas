import 'package:conversor_de_moeda/widgets/textControllers.dart';
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

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final realController = TextEditingController();
  final dolaController = TextEditingController();
  final euroController = TextEditingController();
  final libraController = TextEditingController();
  final bitController = TextEditingController();

  double dola;
  double euro;
  double libra;
  double btc;

  void _realChange(String text) {
    double real = double.parse(text);
    dolaController.text = (real / dola).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    libraController.text = (real / libra).toStringAsFixed(2);
    bitController.text = (real / btc).toStringAsFixed(2);
  }

  void _dolaChange(String text) {
    double dola = double.parse(text);
    realController.text = (dola * this.dola).toStringAsFixed(2);
    euroController.text = (dola * this.dola / euro).toStringAsFixed(2);
    libraController.text = (dola * this.dola / libra).toStringAsFixed(2);
    bitController.text = (dola * this.dola / btc).toStringAsPrecision(2);
  }

  void _euroChange(String text) {
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolaController.text = (euro * this.euro / dola).toStringAsFixed(2);
    libraController.text = (euro * this.euro / libra).toStringAsFixed(2);
    bitController.text = (euro * this.euro / btc).toStringAsPrecision(2);
  }

  void _libraChange(String text) {
    double libra = double.parse(text);
    realController.text = (libra * this.libra).toStringAsFixed(2);
    dolaController.text = (libra * this.libra / dola).toStringAsFixed(2);
    euroController.text = (libra * this.libra / euro).toStringAsFixed(2);
    bitController.text = (libra * this.libra / btc).toStringAsPrecision(2);
  }

  void _bitChange(String text) {
    double btc = double.parse(text);
    realController.text = (btc * this.btc).toStringAsFixed(2);
    dolaController.text = (btc * this.btc / dola).toStringAsFixed(2);
    euroController.text = (btc * this.btc / euro).toStringAsFixed(2);
    libraController.text = (btc * this.btc / libra).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("\$ Conversor de Moedas \$"),
          backgroundColor: Colors.amber[300],
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
                    style: TextStyle(color: Colors.amber[300], fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Sem conexão com rede",
                      style:
                          TextStyle(color: Colors.amber[300], fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dola = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  libra = snapshot.data["results"]["currencies"]["GBP"]["buy"];
                  btc = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Icon(Icons.monetization_on,
                            size: 100, color: Colors.amber[300]),
                        BuildTextFild(
                            "Reais", "\$  ", realController, _realChange),
                        Divider(),
                        BuildTextFild(
                            "Dolares", "US  ", dolaController, _dolaChange),
                        Divider(),
                        BuildTextFild(
                            "Euro", "€  ", euroController, _euroChange),
                        Divider(),
                        BuildTextFild("Libra Esterlina", "£  ", libraController,
                            _libraChange),
                        Divider(),
                        BuildTextFild(
                            "BitCoin", "BTC  ", bitController, _bitChange),
                      ],
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

