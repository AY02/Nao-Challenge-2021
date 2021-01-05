import 'package:flutter/material.dart';
import 'package:qqnao_app/MQTT/connected.dart';
import 'package:qqnao_app/MQTT/disconnected.dart';
import 'package:qqnao_app/MQTT/mqtt.dart';

Widget mqttPage(BuildContext context) {
  String _broker = 'test.mosquitto.org';
  String _port = '1883';
  String _clientID = 'QQNao App';
  List<String> _topics = [
    '$root/czn15e/Sensor1',
    '$root/czn15e/Sensor2',
    '$root/czn15e/Sensor3',
    '$root/ServoMotor',
  ];

  return Padding(
    padding: EdgeInsets.all(10),
    child: Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Broker',
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          initialValue: _broker,
          enabled: false,
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Port',
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                initialValue: _port,
                enabled: false,
              ),
            ),
            SizedBox(width: 10),
            Flexible(
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Client ID',
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                initialValue: _clientID,
                enabled: false,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.blue),
          ),
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              for(int _i=0; _i<_topics.length; _i++)
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Topic $_i',
                  ),
                  initialValue: _topics[_i],
                  enabled: false,
                ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ButtonTheme(
              minWidth: 100,
              height: 50,
              buttonColor: Colors.red,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue),
                ),
                onPressed: () {
                  if(mqttConnected) {
                    print('Log: Disconnetto al broker...');
                    for(String _topic in _topics) {
                      publish('$_clientID e\' uscito dal topic', _topic);
                      mqttClient.unsubscribe(_topic);
                    }
                    mqttClient.disconnect();
                    mqttConnected = false;
                    disconnectSuccess(context);
                  }
                },
                child: Text('Disconnect'),
              ),
            ),
            SizedBox(width: 10),
            ButtonTheme(
              minWidth: 100,
              height: 50,
              buttonColor: Colors.green,
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(color: Colors.blue),
                ),
                onPressed: () async {
                  if(!mqttConnected) {
                    print('Log: Connetto al broker...');
                    mqttClient = await connect(_broker, int.parse(_port), _clientID);
                    for(String _topic in _topics) {
                      subscribe(mqttClient, _topic);
                      publish('$_clientID e\' entrato nel topic', _topic);
                    }
                    mqttConnected = true;
                    connectSuccess(context);
                  }
                },
                child: Text('Connect'),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
