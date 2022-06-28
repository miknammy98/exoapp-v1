#include <Servo.h>

 Servo myservo;        /* Inicialitza el Servomotor

 int positionDesired;  /* Inicialitza les variables (posició final, contador i les repeticions totals)
 int counter = 0;
 int reps = 5;

 void setup() {        /* Programa Inicial (instrucció d'inici)
 Serial.begin(9600);   /* Inicialització del port Serial d'Arduino
 myservo.attach(3);    /* Inicialització del pin digital del Servomotor
 }

 void loop() {         /* Programa que es va repetint
 positionDesired = 0;  /* Selecciona la posició a la que es moura a 0
 myservo.write(positionDesired);    /* Mou el Servo a la posició 0
 delay(1000);                       /* Retard d'1 segon
 positionDesired = 90;              /* Selecciona la posició a la que es moura a 90
 myservo.write(positionDesired);    /* Mou el Servo a la posició 90
 delay(1000);                       /* Retard d'1 segon
 counter++;                         /* Afegeix una unitat al contador
 if(counter == reps)                /* Si el contador és igual a les repeticions
 {
 exit(0);                           /* Surt de l'aplicació
 }
 }
 
 
 /* Aquest programa fa que el servomotor es mogui de la posició 0 a la posició 90, tot això, 5 cops.
