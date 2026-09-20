// Test 4 - can it measure a voltage?  (also used for test 5)
const int SENSOR_PIN = 0;   // pin D0 = A0 - the one the sensor will use

void setup() {
  Serial.begin(115200);
}

void loop() {
  int raw = analogRead(SENSOR_PIN);             // 0 ... 4095
  int mv  = analogReadMilliVolts(SENSOR_PIN);   // the same, in millivolts
  Serial.printf("raw %4d   %4d mV\n", raw, mv);
  delay(250);
}