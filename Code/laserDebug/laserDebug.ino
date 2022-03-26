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
//store the value of the array index
int index = 0;
 
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
  //start the serial monitor
  Serial.begin(9600);
}
void loop() {
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

  index = dig_0 + dig_1 * 2 + dig_2 * 4 + dig_3 * 8 + dig_4 * 16 + dig_5 * 32 + dig_6 * 64 + dig_7 * 128 + dig_8 * 256 + dig_9 * 512 + dig_12 * 1024 + dig_13 * 2048;
  
  Serial.print(index);
  Serial.print("\n");
}
