//#define DEBUG_MODE // please read the instructions in include/Debug.h file

#include <Arduino.h>
#include <WiFi.h>
#include <SPI.h>
#include <Adafruit_LC709203F.h>
#include "BME680-SOLDERED.h"
#include "ThingsBoard.h"
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
// turn on the I2C power by setting pin to LOW
  pinMode(PIN_I2C_POWER, OUTPUT);
  digitalWrite(PIN_I2C_POWER, LOW);
}

void checkBattery() {
  // Get battery readings
  Adafruit_LC709203F lc;
  if (!lc.begin()) {
    DEBUGLN("Could not find Adafruit LC709203F or battery not plugged in!");
    return;
  }
  delay(DELAY_STANDARD);
  sensorData.batteryVoltage = lc.cellVoltage();
  delay(DELAY_STANDARD);
  sensorData.batteryPercentage = lc.cellPercent();
  DEBUG("Batt Voltage: "); DEBUGLN(sensorData.batteryVoltage);
  DEBUG("Batt Percent: "); DEBUGLN(sensorData.batteryPercentage);
}

void readBME() {
  // Read and save BME680 data
  BME680 bme680;
  bme680.begin();
  bme680.setGas(0, 0); // turn the gas sensor heater off
  delay(DELAY_LONG);
  sensorData.temperature = bme680.readTemperature();
  delay(DELAY_LONG);
  sensorData.humidity = bme680.readHumidity();
  delay(DELAY_LONG);
  sensorData.pressure = bme680.readPressure() + PA_PER_METER*ALTITUDE;
  DEBUG("Temperature: "); DEBUGLN(sensorData.temperature);
  DEBUG("Humidity: "); DEBUGLN(sensorData.humidity);
  DEBUG("Atm. pressure: "); DEBUGLN(sensorData.pressure);
}

bool readSensors(const byte max_retry) {
  for (byte i = 0; i < max_retry; i++) {
    powerOn(); // power on the I2C bus
    delay(DELAY_LONG);
    checkBattery();
    delay(DELAY_LONG);
    readBME();
    delay(DELAY_LONG);
    // if BME680 reads anything but defaults: RH: 100% & temp 34.17
    if (sensorData.humidity < 99.9 && 
        (sensorData.temperature < 34.16 || sensorData.temperature > 34.18)) {
          DEBUGLN("Sensor data successfully read.");
          return true;
        }
  }
  // failed to read data
  DEBUGLN("Sensor read not successful!");
  return false;
}

void uploadData() {
  // Initialize ThingsBoard client
  WiFiClient espClient;
  // Initialize ThingsBoard instance
  ThingsBoardSized<128> tb(espClient); // we need more than default 64 bytes to send data
  if (!tb.connect(THINGSBOARD_SERVER, TOKEN)) {
      DEBUG("Failed to connect to "); DEBUGLN(THINGSBOARD_SERVER);
      return;
  }
  DEBUGLN("Sending data to server");
  const int data_items = 4;
  Telemetry data[data_items] = {
    {"temperature", sensorData.temperature},
    {"humidity", sensorData.humidity},
    {"pressure", sensorData.pressure},
    {"battery", sensorData.batteryVoltage}
  };
  tb.sendTelemetry(data, data_items);
  delay(1000);
  tb.disconnect();
}

void gotoSleep() {
  // Go to deep sleep
  DEBUGLN("Going to sleep for 10 minutes");
  WiFi.disconnect();
  delay(1000);
  WiFi.mode(WIFI_OFF);
  pinMode(PIN_I2C_POWER, OUTPUT);
  digitalWrite(PIN_I2C_POWER, HIGH);
  delay(1000);
  esp_sleep_enable_timer_wakeup(600000000L); // 10 minutes in microseconds
  esp_deep_sleep_start();
}

void setup() {
  // Program entry point
  #ifdef DEBUG_MODE // if in debug mode, start the serial connection
    Serial.begin(115200); // preffered baud rate for ESP32's
    while(!Serial); // wait for serial connection to be ready
    delay(5000); // give us time to open serial monitor if closed
  #endif
  DEBUGLN("Debug mode on"); // let us know you're ready
  delay(DELAY_SHORT);
  if (!connectToWiFi()) gotoSleep();
  if (readSensors(3)) {
    // upload data only upon successful sensor read
    uploadData();
  }
  delay(DELAY_LONG);
  gotoSleep();
}

void loop() {
  // nothing to do here
}