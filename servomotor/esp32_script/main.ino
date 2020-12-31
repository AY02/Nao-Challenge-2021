#include <ESP8266WiFi.h>
#include <MQTT.h>
#include <Servo.h>

//Credenziali della rete
const char SSID_WIFI[] = "";
const char PASSWORD_WIFI[] = "";

//Credenziali per il protocollo MQTT
const char BROKER[] = "";
const int PORT = 1883;
const char CLIENT_ID[] = "";
const char TOPIC[] = "";

WiFiClient wifi_client;
MQTTClient mqtt_client;

Servo myServo;
const int START_VALUE = 0;  //0 significa "full-speed in one direction"
const int STOP_VALUE = 90; // 90 significa "no movement"

//Definizione dei pin digitali dell'esp al servo motore
const int SERVO_PIN = 16; //D0


//Funzione di connessione dell'esp al broker con successiva iscrizione al topic
void connect_to_broker() {
  Serial.print("Connessione al broker "); Serial.print(BROKER); Serial.print(" con ID client: "); Serial.print(CLIENT_ID);
  while(!mqtt_client.connect(CLIENT_ID)) {
    Serial.print(".");
    delay(500);
  }

  Serial.println("\nConnessione effettuata");
  Serial.print("Iscrizione al topic "); Serial.print(TOPIC); Serial.println("...");
  mqtt_client.subscribe(TOPIC);
  Serial.println("Iscrizione effettuata");
}


//Funzioni di movimento, intuitive dal nome della funzione
void startRotation() {
  myServo.write(START_VALUE);
}

void stopRotation() {
  myServo.write(STOP_VALUE);
}


//Funzione di callback che esegue una determinata funzione di movimento a seconda del messaggio ricevuto
void messageReceived(String &topicChoised, String &payload) {
  Serial.print("Messaggio ricevuto: "); Serial.println(payload);
  if(payload == "!start") {
    Serial.println("Rotazione in corso..."); 
    startRotation();
  }
  if(payload == "!stop") {
    Serial.println("Movimento fermato...");
    stopRotation();
  }
}

void setup() {
  Serial.begin(9600);
  delay(1000);

  //Setup ServoMotore
  myServo.attach(SERVO_PIN);

  //Connessione alla rete wifi
  Serial.print("\n\nConnessione al Wi-Fi "); Serial.print(SSID_WIFI); Serial.println(" in corso");
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID_WIFI, PASSWORD_WIFI);
  
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConnessione effettuata");
  Serial.print("Indirizzo IP: "); Serial.println(WiFi.localIP());
  
  //Settaggio del protocollo MQTT, con connessione e invio di successo al topic
  mqtt_client.begin(BROKER, PORT, wifi_client);
  mqtt_client.onMessage(messageReceived);

  connect_to_broker();
  Serial.print("In ascolto sul topic "); Serial.print(TOPIC); Serial.println("...");
  mqtt_client.publish(TOPIC, String(CLIENT_ID) + " e' entrato nel topic.");

}

void loop() {
  //Loop infinito per riconnettere il client al broker in caso di anomale disconnessioni.
  mqtt_client.loop();
  delay(10);
  if(!mqtt_client.connected())
    connect_to_broker();
}