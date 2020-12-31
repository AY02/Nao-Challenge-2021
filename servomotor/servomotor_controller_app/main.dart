import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controller Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'ServoMotor HomePage'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void sendMsg(String msg) async {
    final client = MqttServerClient('URL MQTT', 'Client ID');
    await client.connect();
    client.subscribe('Topic', MqttQos.atLeastOnce);
    final builder1 = MqttClientPayloadBuilder();
    builder1.addString(msg);
    client.publishMessage('Topic', MqttQos.atLeastOnce, builder1.payload);
    client.disconnect();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
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
                sendMsg('start');
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
                sendMsg('stop');
              },
            ),
          ],
        ),
      ),
    );
  }
}
