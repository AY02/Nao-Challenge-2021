import paho.mqtt.client as mqtt

clientID = 'MQTT Test Python'
broker = 'test.mosquitto.org'
topics = ['/root/ServoMotor', '/root/czn15e']
port = 1883

def on_connect(client, userdata, flags, rc):
    print(f'Connesso con il codice: {rc}')

def on_disconnect(client, userdata, rc):
    print(f'Disconnect, reason: {rc}')
    print(f'Disconnect, reason: {client}')

def on_log(client, userdata, level, buf):
    print(f'log: {buf}')

def on_message(client, userdata, msg):
    print(f'Messaggio dal topic {msg.topic}: {msg.payload}')

cli = mqtt.Client(client_id=clientID, clean_session=True, protocol=mqtt.MQTTv311, transport='tcp')

cli.on_connect = on_connect
cli.on_disconnect = on_disconnect
cli.on_message = on_message
cli.on_log = on_log

print('Connessione al broker...')
cli.connect(host=broker, port=port, keepalive=60)
print('Connessione effettuata')
cli.subscribe(topic=topics, qos=1)

cli.loop_forever()
