#include <Servo.h>

 Servo myservo;

 int positionDesired;
 int counter = 0;
 int reps = 5;

 void setup() {
 Serial.begin(9600);
 myservo.attach(3);
 }

 void loop() {
 positionDesired = 0;
 myservo.write(positionDesired);
 delay(1000);
 positionDesired = 90;
 myservo.write(positionDesired);
 delay(1000);
 counter++;
 if(counter == reps)
 {
 exit(0);
 }
 }
