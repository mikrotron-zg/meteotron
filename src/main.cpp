#define DEBUG_MODE // please read the instructions in include/Debug.h file

#include <Arduino.h>
#include <WiFi.h>
#include "Credentials.h" // please read the instructions in include/CredentialsTemplate.h file
#include "Debug.h"

void connectToWiFi() {
  // Connect to WiFi network
  DEBUG("Connecting to WiFi network: ");DEBUGLN(WIFI_SSID);
  WiFi.mode(WIFI_STA);
  if (WiFi.status() != WL_CONNECTED) {
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  }
  if (WiFi.waitForConnectResult() == WL_CONNECTED) {
    DEBUGLN("WiFi connected!");
  } 
    else {
    DEBUGLN("WiFi not connected, check your credentials");
    // TODO production code should go to deep sleep immediately
  }
}

void setup() {
  // if in debug mode, start the serial connection
  #ifdef DEBUG_MODE
    Serial.begin(115200); // preffered baud rate for ESP32's
    while(!Serial); // wait for serial connection to be ready
    delay(5000); // give us time to open serial monitor if closed
  #endif
  DEBUGLN("Debug mode on"); // let us know you're ready
  connectToWiFi();
}

void loop() {
  // put your main code here, to run repeatedly:
}