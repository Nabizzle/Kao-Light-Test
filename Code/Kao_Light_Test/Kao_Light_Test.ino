#include <Servo.h>
//create the variables to store the digital output values
int dig_0 = 0;
int dig_1 = 0;
int dig_2 = 0;
int dig_3 = 0;
int dig_4 = 0;
int dig_5 = 0;
int dig_6 = 0;
int dig_7 = 0;
int dig_8 = 0;
int dig_9 = 0;
int dig_12 = 0;
int dig_13 = 0;

int pan_angle = 27; // variable to store the pan servo position (goes between 27-154 degrees)
int tilt_angle = 27; // variable to store the tilt servo position (goes between 27-154 degrees)
 
Servo pan; //create servo object to control the pan servo
Servo tilt; //create servo object to control the tilt servo

void setup() {
  //set digial pins 0-9 and 12-13 to input
  pinMode(0, INPUT);
  pinMode(1, INPUT);
  pinMode(2, INPUT);
  pinMode(3, INPUT);
  pinMode(4, INPUT);
  pinMode(5, INPUT);
  pinMode(6, INPUT);
  pinMode(7, INPUT);
  pinMode(8, INPUT);
  pinMode(9, INPUT);
  pinMode(12, INPUT);
  pinMode(13, INPUT);
  pinMode(14, INPUT);
  pinMode(15, INPUT);
  
  pan.attach(10); // attaches the pan servo on pin 10 to the servo object
  tilt.attach(11);  // attaches the titl servo on pin 11 to the servo object
}

void loop() {
  //Read from all of the digital inputs
  dig_0 = digitalRead(0);
  dig_1 = digitalRead(1);
  dig_2 = digitalRead(2);
  dig_3 = digitalRead(3);
  dig_4 = digitalRead(4);
  dig_5 = digitalRead(5);
  dig_6 = digitalRead(6);
  dig_7 = digitalRead(7);
  dig_8 = digitalRead(8);
  dig_9 = digitalRead(9);
  dig_12 = digitalRead(12);
  dig_13 = digitalRead(13);
  dig_14 = digitalRead(14);
  dig_15 = digitalRead(15);

  //convert the digital inputs to pan and tilt angles
  pan_angle = 27 + dig_0 + dig_1 * 2 + dig_2 * 4 + dig_3 * 8 + dig_4 * 16 + dig_5 * 32 + dig_6 * 64;
  tilt_angle = 27 + dig_7 + dig_8 * 2 + dig_9 * 4 + dig_12 * 8 + dig_13 * 16 + dig_14 * 32 + dig_15 * 64;

  //command the servos to their approviate angles
  pan.write(pan_angle);
  tilt.write(tilt_angle);
}
