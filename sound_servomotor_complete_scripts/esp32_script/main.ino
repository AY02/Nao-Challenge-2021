#include <ESP8266WiFi.h>
#include <MQTT.h>
#include <Servo.h>

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

//BUZZER CONFIGURATION****************************************************************************************

const int BUZZER_PIN = 14;    //D5

void doSound() {
  tone(BUZZER_PIN, 1000);     //Invia 1KHz segnale di suono...
  delay(1000);                //...per 1 secondo
  noTone(BUZZER_PIN);         //Fermo il suono...
}

//SERVOMOTOR CONFIGURATION************************************************************************************

Servo myServo;
const int START_VALUE = 0;    //0 significa "full-speed in one direction"
const int STOP_VALUE = 90;    //90 significa "no movement"

//Definizione dei pin digitali dell'esp al servo motore
const int SERVO_PIN = 0;      //D3

//Funzioni di movimento, intuitive dal nome della funzione
void startRotation() {
  myServo.write(START_VALUE);
}

void stopRotation() {
  myServo.write(STOP_VALUE);
}

//MQTT CONFIGURATION******************************************************************************************

MQTTClient mqtt_client;

const char BROKER[] = "test.mosquitto.org";
const int PORT = 1883;
const String CLIENT_ID = "Lolin NodeMCU v3";
const String ROOT = "";
const String TOPICS[] = {
  ROOT+"/czn15e/Sensor1",
  ROOT+"/czn15e/Sensor2",
  ROOT+"/czn15e/Sensor3",
  ROOT+"/ServoMotor",
};
const int N_TOPICS = sizeof(TOPICS)/sizeof(TOPICS[0]);

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

void connect_to_topics() {
  for(int i=0; i<N_TOPICS; i++) {
    Serial.print("Iscrizione al topic "); Serial.print(TOPICS[i]); Serial.print("...");
    mqtt_client.subscribe(TOPICS[i]);
    Serial.println("Fatto!");
    mqtt_client.publish(TOPICS[i], CLIENT_ID + ": e' entrato nel topic");
  }
}

void messageReceived(String &topicChoised, String &payload) {
  if(topicChoised == ROOT+"/ServoMotor") {
    if(payload == "!start") {
      Serial.println("Rotazione in corso..."); 
      startRotation();
    }
    if(payload == "!stop") {
      Serial.println("Fermo movimento...");
      stopRotation();
    }
    doSound();
  }
}

//CZN15E CONFIGURATION****************************************************************************************

const int INPUT_PIN[] = {16, 5, 4}; //D0 D1 D2

const int N_CZN15E = sizeof(INPUT_PIN)/sizeof(INPUT_PIN[0]);

const int SAMPLE_TIME = 20;         //Ogni 20 millisecondi effettua la misurazione

unsigned long msCurrent[3];         //Tempo corrente in millisecondi
unsigned long msLast[] = {0, 0, 0}; //Tempo dell'ultima misurazione effettuata in millisecondi
unsigned long msElapsed[3];         //Differenza tra il tempo corrente e il tempo dell'ultima misurazione effettuata

int bufferValue[] = {0, 0, 0};

boolean valueInput[3];

//************************************************************************************************************

void setup() {
  for(int i=0;i<N_CZN15E; i++)
    pinMode(INPUT_PIN[i], INPUT);
  myServo.attach(SERVO_PIN);
  pinMode(BUZZER_PIN, OUTPUT);
  Serial.begin(9600);
  delay(1000);
  connect_to_wifi();
  mqtt_setup();
  connect_to_broker();
  connect_to_topics();
}

void loop() {
  mqtt_client.loop();
  if(!mqtt_client.connected()) {
    connect_to_broker();
    connect_to_topics();
  }
  for(int i=0; i<N_CZN15E; i++) {
    msCurrent[i] = millis();
    msElapsed[i] = msCurrent[i] - msLast[i];
    valueInput[i] = digitalRead(INPUT_PIN[i]);
    bufferValue[i] = (valueInput[i] == LOW) ? bufferValue[i] + 1 : bufferValue[i];
    if(msElapsed[i] > SAMPLE_TIME) {
      mqtt_client.publish(TOPICS[i], "Sound Value: " + String(bufferValue[i]));
      bufferValue[i] = 0;
      msLast[i] = msCurrent[i];
    }
  }
}
