# Meteotron

A simple weather station project based on [Adafruit](https://www.adafruit.com/) Feather ESP32-S2 and BME680. Basic version reads temperature, relative humidity and atmospheric pressure, connects to local Wi-Fi and sends data to [ThingsBoard](https://demo.thingsboard.io/) demo server.

## Hardware

Hardware needed for this project:
* [Adafruit ESP32-S2 Feather](https://www.diykits.eu/products/wireless/p_12015) - great microcontroller board by [Adafruit](https://www.adafruit.com/), with some nice sleep/low power functions we're gonna need
* [BME680 Sensor Breakout](https://www.diykits.eu/products/sensors/p_11997) - reads temperature, relative humidity, atmospheric pressure and VOC (we won't be using this, so will probably switch to some other sensor once the chip shortage is over)
* [easyC cable - 10 cm](https://www.diykits.eu/products/connectorsandwires/p_11733) - eascyC or Stemma QT or Qwiic, it's all the same, easy way to connect I2C (IIC) devices
* [Li-ion battery 2100mAh 3.7V](https://www.diykits.eu/products/power/p_12004) - should be enough for what we need

Also, we can go solar by using:
* [Mini Solar Panel 5V 500mA](https://www.diykits.eu/products/power/p_10668) and
* [CN3065 Solar Lithium Charger Board](https://www.diykits.eu/products/power/p_11930) 

## Software

Project software is written in [VS Code](https://code.visualstudio.com/) with [PlatformIO](https://platformio.org/) plugin, but it can be compiled using [Arduino IDE](https://www.arduino.cc/en/software) (you might need to change a few things here and there, and manually download the libraries used in the project, but it should work). At the moment, you have to install the latest version (currently 4.3.0) of Espressif32 platform (or update if you're using the older one). Also, be sure to have the latest PlatformIO version installed (currently Core 6.0.1, Home 3.4.1).

Before compiling, you must add your credentials (WiFi, ThingsBoard, etc), so please follow the instructions in _include/CredentialsTemplate.h_ file.
