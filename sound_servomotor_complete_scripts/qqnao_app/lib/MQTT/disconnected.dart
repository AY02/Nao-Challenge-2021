import 'package:flutter/material.dart';

Future<Widget> disconnectSuccess(BuildContext context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Client Disconnected', textAlign: TextAlign.center),
      );
    },
  );
}