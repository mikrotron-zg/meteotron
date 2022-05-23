/*******************************************************************
 * This files contains global constants and variables used in project. 
 * Review and change (if needed) values where comment starts with CHANGEME
 *******************************************************************/

// Constants
#define PIN_I2C_POWER 7 // needed for I2C power management
#define PA_PER_METER 0.113 // approx. pressure change in hPa per meter of altitude (up to 1000m)
#define ALTITUDE 120.0 // CHANGEME meteo station altitude above sea level (in meters)

// Variables
typedef struct SensorData { // we'll group all the data we collect in a single struct
    float temperature = 0.0;
    float humidity = 0.0;
    float pressure = 0.0;
    float batteryVoltage = 0.0;
    float batteryPercentage = 0.0;
} SensorData;
SensorData sensorData;
