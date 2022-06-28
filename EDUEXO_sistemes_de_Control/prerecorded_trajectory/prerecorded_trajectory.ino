 #include <Servo.h>                    // Aquestes dues comandes serveixen per inicialitzar les llibreries del Servomotor i del EEPROM de l'arduino
 #include <EEPROM.h>                   

 #define SAMPLE_DELAY 25               // Declaració de les variables que no han de variar en cap moment
 #define SAMPLES 200

 Servo myservo;                        // Definició i inicialització del servo i dels seus pins
 int servoPin = 3;                     
 int servoAnalogInPin = A0;

 void setup() {         
 Serial.begin(9600);                   // Inicialitza el Serial de l'Arduino en arrencar el programa
 }

 void loop() { 
 Serial.println("Trajectory recording starts in 3 seconds");  // Al port serial, apareix el missatge per tal que l'usuari pugui interactuar.
 delay(3000);                                                 // Retard de 3 segons
 recordTrajectory();                                          // Crida la funció per realitzar una gravació
 delay(3000);                                                 // Retard de 3 segons
 replayTrajectory();                                          // Crida la funció per reproduir la gravació
 }

 void recordTrajectory() {                                    // Funció de gravació
 Serial.println("Recording");                                 // Al port serial s'indica que s'està gravant el moviment
 for (int addr=0; addr<SAMPLES; addr++){                      // Es crea un bucle que pasa per totes les mostres
 int posIs = analogRead(servoAnalogInPin);                    // A cada mostra es registra la posició del servo
 byte posIsServo = map(posIs, 119, 332, 0, 100);              // i es registren en una variable nova, per tal de no perdre la informació.
 EEPROM.write(addr, posIsServo);                              // Es guarda la informació del moviment a la memòria EEPROM de l'arduino 
 delay(SAMPLE_DELAY);                                         // Un cop finalitzat, fa un retard de 25 milisegons
 }
 Serial.println("Done recording");                            // Al port Serial s'indica que la gravació ja ha finalitzat.
 }

 void replayTrajectory() {                                    // Funció de reproduir
 myservo.attach(servoPin);                                    // Connecta el servo al pin assignat
 Serial.println("Playing");                                   // Al port Serial s'indica que el moviment s'està reproduint
 for (int addr=0; addr<SAMPLES; addr++){                      // Es crea un bucle que pasa per totes les mostres
 byte positionDesired = EEPROM.read(addr);                    // Es carregan els arxius de la memòria EEPROM i es guarden a una variable  
 myservo.write(positionDesired);                              // El servo es mou cap a la posició indicada
 delay(SAMPLE_DELAY);                                         // Retard de 25 milisegons
 }
 Serial.println("Done replaying");                            // Al port Serial s'indica que ja ha finalitzat la gravació.
 myservo.detach();                                            // Desconnecta el servo del pin indicat.
 }
