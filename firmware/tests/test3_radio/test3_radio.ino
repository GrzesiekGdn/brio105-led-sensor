// Test 3 - does the radio work?
// Lists the Wi-Fi networks around you. It only listens -
// it does not connect to anything.
#include <WiFi.h>

void setup() {
  Serial.begin(115200);
  WiFi.mode(WIFI_STA);
}

void loop() {
  Serial.println("scanning...");
  int n = WiFi.scanNetworks();
  Serial.printf("%d networks found\n", n);
  for (int i = 0; i < n; i++) {
    Serial.printf("  %-32s %4d dBm  channel %d\n",
                  WiFi.SSID(i).c_str(), WiFi.RSSI(i), WiFi.channel(i));
  }
  WiFi.scanDelete();
  delay(5000);
}