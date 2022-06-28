#include <Servo.h>                                               // Afegir la llibreria Servo

 Servo myservo;                                                  // Inicialitza el Servomotor
 int forceAnalogInPin = A3;                                      // Inicialitza els pins del servo
 const int forceOffset = 439;                                    // Inicialitza un offset per a la galga
 int forceIs;                                                    // S'inicialitzen les variables de la força (quina és actualment i quina és la força desitjada
 int forceDesired = 0;                                   
 int positionDesired = 40;                                       // Posició desitjada
 float gain = 0.2;                                               // guany del sistema

 void setup(){
 myservo.attach(3);                                              // Definició del pin del Servomotor
 delay(1000);                                                    // Retard d'1 segon
 }

 void loop(){
 forceIs = analogRead(forceAnalogInPin)-forceOffset;             // Força actual (força mesurada menys l'offset)
 delay(10);                                                      // Retard de 10 milesimes de segon
 positionDesired -= gain*(forceIs-forceDesired);                 // Posició desitjada: posició anterior - guany*(força actual - força desitjada)
 myservo.write(positionDesired);                                 // Col·locar el servo a la posició nova
 }
