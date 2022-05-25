/*******************************************************************
 * IMPORTANT! Please follow the instructions in this file before
 * you try to compile the project for the first time. This file
 * is just a template, don't change the contents of this file.
 * 
 * You need to do the following:
 * 1. Save this file as Credentials.h in include/ directory and
 *    than close this file
 * 2. Open Credentials.h file and enter your WiFi credentials and
 *    ThingsBoard device token (you have to create one first on
 *    https://demo.thingsboard.io/ - if you don't have the account,
 *    create one, it's free)
 * 3. Save this file and compile and upload the project in debug
 *    mode to check if everything works as it should
 * 
 * Credentials.h is ignored by Git (check the contents of .gitignore
 * file to confirm), so this way your credentials will be kept in
 * your local version of the project. This way you can change the 
 * project and publish your changes on Github, Gitlab, Bitbucket or
 * your own Git server without leaking sensitive information.
 *******************************************************************/

#ifndef CREDENTIALS_H
    #define CREDENTIALS_H
    // Add your WiFi credentials
    #define WIFI_SSID "Your WiFi SSID"
    #define WIFI_PASSWORD "Your WiFi password"
    // Add your ThingsBoard device token
    #define TOKEN "Your device token"
    #define THINGSBOARD_SERVER  "demo.thingsboard.io" // change only if using another server
#endif