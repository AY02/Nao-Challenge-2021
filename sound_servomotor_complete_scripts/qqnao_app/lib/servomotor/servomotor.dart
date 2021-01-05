import 'package:flutter/material.dart';
import 'package:qqnao_app/MQTT/mqtt.dart';

Widget servomotorPage() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RawMaterialButton(
          child: Icon(
            Icons.pause,
            size: 50.0,
          ),
          shape: CircleBorder(),
          fillColor: Colors.blue,
          padding: EdgeInsets.all(15.0),
          onPressed: () {
            if(mqttConnected)
              publish('!start', 'root/ServoMotor');
          },
        ),
        SizedBox(height: 50.0),
        RawMaterialButton(
          child: Icon(
            Icons.stop,
            size: 50.0,
          ),
          shape: CircleBorder(),
          fillColor: Colors.blue,
          padding: EdgeInsets.all(15.0),
          onPressed: () {
            if(mqttConnected)
              publish('!stop', 'root/ServoMotor');
          },
        ),
      ],
    ),
  );
}
