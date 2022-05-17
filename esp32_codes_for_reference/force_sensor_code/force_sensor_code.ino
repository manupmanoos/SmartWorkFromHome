/*
 * This ESP32 code is created by esp32io.com
 *
 * This ESP32 code is released in the public domain
 *
 * For more detail (instruction and wiring diagram), visit https://esp32io.com/tutorials/esp32-force-sensor
 */
#include <WiFi.h>
#include <Firebase_ESP_Client.h>

//Provide the token generation process info.
#include "addons/TokenHelper.h"
#define FORCE_SENSOR_PIN 36 // ESP32 pin GIOP36 (ADC0): the FSR and 10K pulldown are connected to A0
#define WIFI_SSID "loki"
#define WIFI_PASSWORD "loki1234"
#define API_KEY "AIzaSyC8rx-SjrOH63Q0htxWBu-v_xWLJrbjiC8"
#define FIREBASE_PROJECT_ID "iotproject-a9f1b"
#define USER_EMAIL "selvakul@tcd.ie"
#define USER_PASSWORD "selvakul@tcd.ie"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig configF;
FirebaseJson content;
int previousReading = 0;

void setup() {
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
 
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Establishing connection to WiFi..");
  }

  configF.api_key = API_KEY;

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  //configF.token_status_callback = FirestoreTokenStatusCallback;

  Firebase.begin(&configF, &auth);
}

void loop() {
  int analogReading = analogRead(FORCE_SENSOR_PIN);

  Serial.print("The force sensor value = ");
  Serial.print(analogReading); // print the raw analog reading

  if (analogReading < 10)       // from 0 to 9
    Serial.println(" -> no pressure");
  else if (analogReading < 200) // from 10 to 199
    Serial.println(" -> light touch");
  else if (analogReading < 500) // from 200 to 499
    Serial.println(" -> light squeeze");
  else if (analogReading < 800) // from 500 to 799
    Serial.println(" -> medium squeeze");
  else // from 800 to 1023
    Serial.println(" -> big squeeze");

  delay(1000);

  if(WiFi.status() == WL_CONNECTED && Firebase.ready() && previousReading != analogReading){
    String documentPath = "iot/iotrix";
    previousReading = analogReading;
    content.set("fields/waterPressure/doubleValue", String(analogReading).c_str());

    if(Firebase.Firestore.patchDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw(), "waterPressure")){
      Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
      return;
    }else{
      Serial.println(fbdo.errorReason());
    }

    if(Firebase.Firestore.createDocument(&fbdo, FIREBASE_PROJECT_ID, "", documentPath.c_str(), content.raw())){
      Serial.printf("ok\n%s\n\n", fbdo.payload().c_str());
      return;
    }else{
      Serial.println(fbdo.errorReason());
    }
}
}
