#include <ESP8266WiFi.h>
#include <MQTT.h>

const int INPUT_PIN1 = 16; //D0
const int INPUT_PIN2 = 5;  //D1
const int INPUT_PIN3 = 4;  //D2

const int SAMPLE_TIME = 5; //Ogni 5 millisecondi effettua la misurazione

unsigned long msCurrent1;     //Tempo corrente in millisecondi
unsigned long msLast1 = 0;    //Tempo dell'ultima misurazione effettuata in millisecondi
unsigned long msElapsed1 = 0; //Differenza tra il tempo corrente e il tempo dell'ultima misurazione effettuata

unsigned long msCurrent2;     //Tempo corrente in millisecondi
unsigned long msLast2 = 0;    //Tempo dell'ultima misurazione effettuata in millisecondi
unsigned long msElapsed2 = 0; //Differenza tra il tempo corrente e il tempo dell'ultima misurazione effettuata

unsigned long msCurrent3;     //Tempo corrente in millisecondi
unsigned long msLast3 = 0;    //Tempo dell'ultima misurazione effettuata in millisecondi
unsigned long msElapsed3 = 0; //Differenza tra il tempo corrente e il tempo dell'ultima misurazione effettuata

int bufferValue1 = 0;
int bufferValue2 = 0;
int bufferValue3 = 0;
boolean valueInput1 = false;
boolean valueInput2 = false;
boolean valueInput3 = false;

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

void setup() {
  Serial.begin(9600);
  delay(1000);
  pinMode(INPUT_PIN1, INPUT);
  pinMode(INPUT_PIN2, INPUT);
  pinMode(INPUT_PIN3, INPUT);
  
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
  
  connect_to_broker();
  
  Serial.print("In ascolto sul topic "); Serial.print(TOPIC); Serial.println("...");
  mqtt_client.publish(TOPIC, String(CLIENT_ID) + " e' entrato nel topic.");
  
}

void loop() {

  mqtt_client.loop();
  if(!mqtt_client.connected())
    connect_to_broker();


  msCurrent1 = millis();
  msElapsed1 = msCurrent1 - msLast1;
  valueInput1 = digitalRead(INPUT_PIN1);
  bufferValue1 = (valueInput1 == LOW) ? bufferValue1 + 1 : bufferValue1;
  
  if(msElapsed1 > SAMPLE_TIME) {
    Serial.println(bufferValue1);
    mqtt_client.publish(TOPIC, "Sound1: " + String(bufferValue1));
    bufferValue1 = 0;
    msLast1 = msCurrent1;
  }

  msCurrent2 = millis();
  msElapsed2 = msCurrent2 - msLast2;
  valueInput2 = digitalRead(INPUT_PIN2);
  bufferValue2 = (valueInput2 == LOW) ? bufferValue2 + 1 : bufferValue2;
  
  if(msElapsed2 > SAMPLE_TIME) {
    Serial.println(bufferValue2);
    mqtt_client.publish(TOPIC, "Sound2: " + String(bufferValue2));
    bufferValue2 = 0;
    msLast2 = msCurrent2;
  }

  msCurrent3 = millis();
  msElapsed3 = msCurrent3 - msLast3;
  valueInput3 = digitalRead(INPUT_PIN3);
  bufferValue3 = (valueInput3 == LOW) ? bufferValue3 + 1 : bufferValue3;
  
  if(msElapsed3 > SAMPLE_TIME) {
    Serial.println(bufferValue3);
    mqtt_client.publish(TOPIC, "Sound3: " + String(bufferValue3));
    bufferValue3 = 0;
    msLast3 = msCurrent3;
  }

}