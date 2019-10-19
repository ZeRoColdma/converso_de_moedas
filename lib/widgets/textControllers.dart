import 'package:flutter/material.dart';

//Função de textos
Widget BuildTextFild(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
      controller: c,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.amber[900]),
          border: OutlineInputBorder(),
          prefixText: prefix),
      style: TextStyle(color: Colors.amber[900], fontSize: 25),
      keyboardType: TextInputType.number,
      onChanged: f);
}
