import paho.mqtt.client as mqtt
#pip install paho-mqtt

clientID = 'MQTT Listener'
broker = 'test.mosquitto.org'
root = ''
topics = [
    f'{root}/czn15e/Sensor1',
    f'{root}/czn15e/Sensor2',
    f'{root}/czn15e/Sensor3',
    f'{root}/ServoMotor',
    #...
]
port = 1883

def on_connect(client, userdata, flags, rc):
    print(f'Connesso con il codice: {rc}')
    for topic in topics:
        client.publish(topic, f'{clientID} e\' entrato nel topic', qos=1)

def on_message(client, userdata, msg):
    print(f'Messaggio dal topic {msg.topic}: {msg.payload.decode()}')

cli = mqtt.Client(client_id=clientID)

cli.on_connect = on_connect
cli.on_message = on_message

print('Connessione al broker...')
cli.connect(host=broker, port=port)
print('Connessione effettuata')
for topic in topics:
    cli.subscribe(topic=topic, qos=1)

cli.loop_forever()
