import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:oscilloscope/oscilloscope.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  final String _title = 'QQNao App Demo';
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex;
  void _onItemTapped(int index) => setState(() => _currentIndex = index);
  String _broker;
  String _port;
  String _clientID;
  String _root;
  List<String> _topics;
  MqttServerClient _client;
  bool _mqttConnected = false;
  void _onConnected() => print('Log: Client Connected');
  void _onDisconnected() => print('Log: Client Disconnected');
  void _onMessage(List<MqttReceivedMessage<MqttMessage>> msg) {
    MqttPublishMessage message = msg[0].payload;
    String payload = MqttPublishPayload.bytesToStringAsString(message.payload.message);
    if(payload.startsWith('Sound Value: ')) {
      for(int i=0; i< _soundValue.length; i++)
        if(msg[0].topic == _topics[i])
          setState(() =>_soundValue[i].add(double.parse(payload.substring(13))));
    }
  }
  void _publish(String msg, String topic) {
    MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(msg);
    _client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload);
  }
  List<List<double>> _soundValue;
  _HomepageState() {
    _currentIndex = 0;
    _broker = 'test.mosquitto.org';
    _port = '1883';
    _clientID = 'QQNao App';
    _root = '';
    _topics = [
        '$_root/czn15e/Sensor1',
        '$_root/czn15e/Sensor2',
        '$_root/czn15e/Sensor3',
        '$_root/ServoMotor',
    ];
    _client = MqttServerClient.withPort(_broker, _clientID, int.parse(_port));
    _client.onConnected = _onConnected;
    _client.onDisconnected = _onDisconnected;
    _soundValue = [[],[],[]];
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> _widgets = [
      Column(
        children: [
          Container(
            color: (_mqttConnected) ? Colors.green : Colors.grey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text((_mqttConnected) ? 'Connected' : 'Disconnected'),
              ],
            ),
          ),
          Padding(
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
                          if(_mqttConnected) {
                            print('Log: Disconnetto al broker...');
                            for(String _topic in _topics) {
                              _publish('$_clientID e\' uscito dal topic', _topic);
                              _client.unsubscribe(_topic);
                            }
                            _client.disconnect();
                            _mqttConnected = false;
                            setState(() {});
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
                          if(!_mqttConnected) {
                            print('Log: Connetto al broker...');
                            await _client.connect();
                            _client.updates.listen(_onMessage);
                            for(String _topic in _topics) {
                              _client.subscribe(_topic, MqttQos.atLeastOnce);
                              _publish('$_clientID e\' entrato nel topic', _topic);
                            }
                            _mqttConnected = true;
                            setState((){});
                          }
                        },
                        child: Text('Connect'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            child: Icon(
              Icons.pause,
              size: 50.0,
            ),
            shape: CircleBorder(),
            fillColor: Colors.blue,
            padding: EdgeInsets.all(15.0),
            onPressed: () => (_mqttConnected) ?
              _publish('!start', '$_root/ServoMotor') : 
              print('Log: Non connesso al broker MQTT'),
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
            onPressed: () => (_mqttConnected) ? 
              _publish('!stop', '$_root/ServoMotor') :
              print('Log: Non connesso al broker MQTT'),
          ),
        ],
      ),
      Column(
        children: [
          for(int i=0; i< _soundValue.length; i++)
            Expanded(
              child: Oscilloscope(
                showYAxis: true,
                padding: 0,
                backgroundColor: Colors.black,
                traceColor: Colors.white,
                yAxisMax: 1500,
                yAxisMin: 0,
                dataSet: _soundValue[i],
              ),
            )
        ],
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget._title),
      ),
      body: Center(
        child: _widgets[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud),
            label: 'MQTT',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_circle_down),
            label: 'ServoMotor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.multitrack_audio),
            label: 'CZN15E',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}
