// Test 2 - is the board alive?
// Blinks the small yellow LED beside the USB socket and
// prints what the chip reports about itself, once a second.

const int LED_PIN = 15;   // the yellow "user" LED
bool ledOn = false;

void setup() {
  Serial.begin(115200);
  pinMode(LED_PIN, OUTPUT);
}

void loop() {
  ledOn = !ledOn;
  digitalWrite(LED_PIN, ledOn ? HIGH : LOW);   // on, off, on, off...

  Serial.printf("alive | %s rev %d | %lu MHz | flash %lu MB | uptime %lu s\n",
                ESP.getChipModel(), ESP.getChipRevision(),
                (unsigned long)ESP.getCpuFreqMHz(),
                (unsigned long)(ESP.getFlashChipSize() / (1024 * 1024)),
                millis() / 1000);
  delay(1000);
}