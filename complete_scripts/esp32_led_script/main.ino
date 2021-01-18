#include <ESP8266WiFi.h>
#include <MQTT.h>

//WIFI CONFIGURATION******************************************************************************************

WiFiClient wifi_client;

const String SSID_WIFI = "";
const String PASSWORD_WIFI = "";

void connect_to_wifi() {
  Serial.print("\n\nConnessione al Wi-Fi "); Serial.print(SSID_WIFI); Serial.println(" in corso");
  WiFi.mode(WIFI_STA);
  WiFi.begin(SSID_WIFI, PASSWORD_WIFI);
  
  while(WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  Serial.println("\nConnessione effettuata");
  Serial.print("Indirizzo IP: "); Serial.println(WiFi.localIP());
}

//LEDS CONFIGURATION******************************************************************************************

const int INPUT_PIN[] = {16, 5, 4}; //D0 D1 D2
const int N_LED = sizeof(INPUT_PIN)/sizeof(INPUT_PIN[0]);

void onLed() {
  for(int i=0; i<N_LED; i++)
    digitalWrite(INPUT_PIN[i], HIGH);
}

void offLed() {
  for(int i=0; i<N_LED; i++)
    digitalWrite(INPUT_PIN[i], LOW);
}

//MQTT CONFIGURATION******************************************************************************************

MQTTClient mqtt_client;

const char BROKER[] = "test.mosquitto.org";
const int PORT = 1883;
const String CLIENT_ID = "Lolin NodeMCU v3 - Led";
const String ROOT = "";
const String TOPIC = ROOT+"/Led";

void mqtt_setup() {
  mqtt_client.begin(BROKER, PORT, wifi_client);
  mqtt_client.onMessage(messageReceived);
}

void connect_to_broker() {
  Serial.print("Connessione al broker "); Serial.print(BROKER); Serial.print(" con ID client: "); Serial.println(CLIENT_ID);
  while(!mqtt_client.connect(CLIENT_ID.c_str())) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nConnessione effettuata");
}

void connect_to_topic() {
  Serial.print("Iscrizione al topic "); Serial.print(TOPIC); Serial.print("...");
  mqtt_client.subscribe(TOPIC);
  Serial.println("Fatto!");
  mqtt_client.publish(TOPIC, CLIENT_ID + ": e' entrato nel topic");
}

void messageReceived(String &topicChoised, String &payload) {
  if(payload == "!on") {
    Serial.println("Accendo i led...");
    onLed();
  }
  if(payload == "!off") {
    Serial.println("Spengo i led...");
    offLed();
  }
}

//************************************************************************************************************

void setup() {
  for(int i=0; i<N_LED; i++) 
    pinMode(INPUT_PIN[i], OUTPUT);
  Serial.begin(9600);
  delay(1000);
  connect_to_wifi();
  mqtt_setup();
  connect_to_broker();
  connect_to_topic();
}

void loop() {
  mqtt_client.loop();
  if(!mqtt_client.connected()) {
    connect_to_broker();
    connect_to_topic();
  }
}
