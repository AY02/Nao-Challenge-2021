import 'package:flutter/material.dart';

Future<Widget> connectSuccess(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Client Connected', textAlign: TextAlign.center),
      );
    },
  );
}