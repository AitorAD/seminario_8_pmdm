import 'package:flutter/material.dart';

BoxDecoration buildBoxDecoration() {
  return BoxDecoration(
    color: Colors.indigo,
    borderRadius: BorderRadius.only(
      bottomLeft: Radius.circular(25),
      topRight: Radius.circular(25),
    ),
  );
}
