#define DEBUG_MODE // please read the instructions in include/Debug.h file

#include <Arduino.h>
#include <WiFi.h>
#include <SPI.h>
#include <Adafruit_LC709203F.h>
#include "BME680-SOLDERED.h"
#include "Configuration.h" // please read the instructions in include/Configuration.h file
#include "Credentials.h" // please read the instructions in include/CredentialsTemplate.h file
#include "Debug.h"

bool connectToWiFi() {
  // Connect to WiFi network
  DEBUG("Connecting to WiFi network: ");DEBUGLN(WIFI_SSID);
  WiFi.mode(WIFI_STA);
  if (WiFi.status() != WL_CONNECTED) {
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  }
  if (WiFi.waitForConnectResult() == WL_CONNECTED) {
    DEBUGLN("WiFi connected!");
    return true;
  } 
  DEBUGLN("WiFi not connected, check your credentials");
  return false;
}

void powerOn() {
// turn on the I2C power by setting pin to opposite of 'rest state'
  pinMode(PIN_I2C_POWER, INPUT);
  delay(1);
  bool polarity = digitalRead(PIN_I2C_POWER);
  pinMode(PIN_I2C_POWER, OUTPUT);
  digitalWrite(PIN_I2C_POWER, !polarity);
}

void checkBattery() {
  // Get battery readings
  Adafruit_LC709203F lc;
  if (!lc.begin()) {
    DEBUGLN("Could not find Adafruit LC709203F or battery not pluged in!");
    return;
  }
  sensorData.batteryVoltage = lc.cellVoltage();
  delay(25);
  sensorData.batteryPercentage = lc.cellPercent();
  DEBUG("Batt Voltage: "); DEBUGLN(sensorData.batteryVoltage);
  DEBUG("Batt Percent: "); DEBUGLN(sensorData.batteryPercentage);
}

void readBME() {
  // Read and save BME680 data
  BME680 bme680;
  bme680.begin();
  delay(500);
  sensorData.temperature = bme680.readTemperature();
  delay(25);
  sensorData.humidity = bme680.readHumidity();
  delay(25);
  sensorData.pressure = bme680.readPressure() + PA_PER_METER*ALTITUDE;
  DEBUG("Temperature: "); DEBUGLN(sensorData.temperature);
  DEBUG("Humidity: "); DEBUGLN(sensorData.humidity);
  DEBUG("Atm. pressure: "); DEBUGLN(sensorData.pressure);
}

void gotoSleep() {
  // TODO implement deep sleep
}

void setup() {
  // Program entry point
  #ifdef DEBUG_MODE // if in debug mode, start the serial connection
    Serial.begin(115200); // preffered baud rate for ESP32's
    while(!Serial); // wait for serial connection to be ready
    delay(5000); // give us time to open serial monitor if closed
  #endif
  DEBUGLN("Debug mode on"); // let us know you're ready
  if (!connectToWiFi()) gotoSleep();
  powerOn(); // power on the I2C bus
  delay(250);
  checkBattery();
  readBME();
}

void loop() {
  // put your main code here, to run repeatedly:
  delay(10000);
  readBME();
}