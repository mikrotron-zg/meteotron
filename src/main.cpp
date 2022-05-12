#define DEBUG_MODE // please read the instructions in include/Debug.h file

#include <Arduino.h>
#include "Credentials.h" // please read the instructions in include/CredentialsTemplate.h file
#include "Debug.h"

void setup() {
  // if in debug mode, start the serial connection
  #ifdef DEBUG_MODE
    Serial.begin(115200); // preffered baud rate for ESP32's
    while(!Serial); // wait for serial connection to be ready
    delay(5000); // give us time to open serial monitor if closed
  #endif
  DEBUGLN("Debug mode on"); // let us know you're ready
}

void loop() {
  // put your main code here, to run repeatedly:
}