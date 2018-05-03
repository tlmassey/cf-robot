#include <Adafruit_MotorShield.h>

/* 
This controls the arduino and associated motor shield v2 to feed carbon fibers in the assembly robot.
Matlab sends this program serial commands, and the program advances the carbon fiber accordingly.
*/


#include <Wire.h>
#include <Adafruit_MotorShield.h>
#include "utility/Adafruit_MS_PWMServoDriver.h"

// Create the motor shield object with the default I2C address
Adafruit_MotorShield AFMS = Adafruit_MotorShield(); 

// Connect a stepper motor object with 20 full steps per revolution (18 degree) to motor port #2 (M3 and M4)
Adafruit_StepperMotor *myMotor = AFMS.getStepper(20, 2);

//MICROMO GEARHEAD: 51.2 => ~1000 counts/rev with SINGLE; 2000 counts/rev with INTERLEAVE

long steps;                 // user-given number of half-steps motor should rotate, read from serial

// Initialize serial port and set motor parameters
void setup() {
  Serial.begin(9600);      // set up Serial library at 9600 bps
  AFMS.begin();            // create with the default frequency 1.6KHz
  myMotor->setSpeed(800);  // units: rpm   
  Serial.setTimeout(100);  // Serial.readString times out after N ms}
}

//Main loop
void loop() {
  delay(300);                      //check for bytes every 50 ms
  Serial.println(Serial.read());
  if(Serial.available())       // returns true if there are unread characters in the serial port
  {
    Serial.println("bytes are available at arduino.\n");
    steps = Serial.parseInt();    // read chars from serial until queue empty (timeout); format as int
    Serial.println(String(steps));
    if (steps < 0)                // parseInt() reads negative values correctly
    {
      //myMotor->step(steps, FORWARD, INTERLEAVE);  // retract fiber, taking half steps
      while(steps++) {
        myMotor->onestep(FORWARD, INTERLEAVE);    // retract fiber one half step
        Serial.println(steps);
        Serial.println(" ");
        delay(0.1);                               // delay 0.1 ms
      }
    }
    else
    {
      //myMotor->step(steps, BACKWARD, INTERLEAVE);  // advance fiber, taking half steps
      while(steps--) {
        myMotor->onestep(BACKWARD, INTERLEAVE);    // advance fiber one half step
        Serial.println(steps);
        Serial.println(" ");
        delay(0.1);                               // delay 0.1 ms
      }
    }
    Serial.println("Done stepping.\n");
  }
}
