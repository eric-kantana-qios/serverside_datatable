import 'package:flutter/material.dart';

class ServerSideColumn<T> {
  String header;
  String field;
  Widget Function(T rowData) renderer;
  bool isNumber;

  ServerSideColumn({required this.header, required this.field, required this.renderer, this.isNumber = false});

  @override
  String toString() {
    return header;
  }
}
