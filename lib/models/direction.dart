import 'package:flutter/material.dart';

class Direction {
  String asset;
  String label;
  Color color;
  Function callback;

  Direction({this.label, this.asset, this.color, this.callback});
}
