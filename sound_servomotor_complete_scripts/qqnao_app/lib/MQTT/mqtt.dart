import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

Future<MqttServerClient> connect(String _broker, int _port, String _clientID) async {
  MqttServerClient _client = MqttServerClient.withPort(_broker, _clientID, _port);
  void onConnected() => print('Log: Client Connected');
  void onDisconnected() => print('Log: Client Disconnected');
  _client.onConnected = onConnected;
  _client.onDisconnected = onDisconnected;
  await _client.connect();
  _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> _msg) {
    MqttPublishMessage _message = _msg[0].payload;
    String _payload = MqttPublishPayload.bytesToStringAsString(_message.payload.message);
    print('Log: Received message:$_payload from topic: ${_msg[0].topic}');
  });
  return _client;
}

void publish(String _msg, String _topic) {
  MqttClientPayloadBuilder _builder = MqttClientPayloadBuilder();
  _builder.addString(_msg);
  mqttClient.publishMessage(_topic, MqttQos.atLeastOnce, _builder.payload);
}

void subscribe(MqttServerClient _client, String _topic) => _client.subscribe(_topic, MqttQos.atLeastOnce);

MqttServerClient mqttClient;
bool mqttConnected = false;
String root = '';
