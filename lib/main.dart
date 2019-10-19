import 'package:conversor_de_moeda/view/conversor.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Colors.amber[900],
        primaryColor: Colors.amber[900],
      ),
      home: Home(),
    );
  }
}
