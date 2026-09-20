# Firmware

Nothing final lives here yet. The sketches in [`tests/`](tests/) exist to prove the XIAO
ESP32-C6 works — and that it isn't faulty — before anything gets soldered. The real firmware
(read the sensor, debounce it, report to Home Assistant over Zigbee) is roadmap step 4.

The wiring and what each test proves are in
[hardware/wiring/](../hardware/wiring/README.md). This page is about the toolchain: what to
install, how to run the sketches, and where the functions in them come from.

---

## What to install

Either route installs the same package. The sketches here were compiled and run against
**esp32 core 3.3.12**.

### Arduino IDE 2

1. Install the IDE from [arduino.cc](https://www.arduino.cc/en/software).
2. **Tools → Board → Boards Manager**, search `esp32`, install **esp32 by Espressif
   Systems**, version **3.0 or newer**. Version 2.x does not know the C6. If it isn't listed,
   add this under **File → Preferences → Additional boards manager URLs**:
   ```
   https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
   ```
3. **Tools → Board → esp32 → XIAO_ESP32C6**
4. **Tools → Port → /dev/ttyACM0**
5. Open a sketch, click **Upload**, then **Tools → Serial Monitor** at **115200**.

On Linux your user must be in the `dialout` group to open the port:

```sh
sudo usermod -aG dialout $USER     # then log out and back in
```

### arduino-cli

Same package, no IDE:

```sh
arduino-cli core update-index \
  --additional-urls https://raw.githubusercontent.com/espressif/arduino-esp32/gh-pages/package_esp32_index.json
arduino-cli core install esp32:esp32@3.3.12

# compile only - needs no board attached
arduino-cli compile -b esp32:esp32:XIAO_ESP32C6 firmware/tests/test2_alive

# compile and upload
arduino-cli compile -u -p /dev/ttyACM0 -b esp32:esp32:XIAO_ESP32C6 firmware/tests/test2_alive

# watch the output
arduino-cli monitor -p /dev/ttyACM0 -c baudrate=115200
```

---

## Running the tests

Upload one, watch the serial output, move on. Full procedure, expected results and the
keep-or-return table are in [hardware/wiring/](../hardware/wiring/README.md).

| Sketch | What it proves | What a working board printed |
|---|---|---|
| [`tests/test2_alive`](tests/test2_alive/test2_alive.ino) | Uploading works; processor, flash and USB messages work | `alive \| ESP32-C6 rev 2 \| 160 MHz \| flash 4 MB \| uptime 7 s`, and the yellow LED blinks |
| [`tests/test3_radio`](tests/test3_radio/test3_radio.ino) | The 2.4 GHz radio and antenna work — the same ones Zigbee uses | `3 networks found`, nearest at `-62 dBm` |
| [`tests/test4_adc`](tests/test4_adc/test4_adc.ino) | The analogue input the sensor will use (A0) works | `raw 676   586 mV` floating; ≈0 wired to GND, ≈4095 wired to 3V3 |

If an upload fails, put the board in download mode: hold **B** (BOOT), tap **R** (RESET),
release **B**, upload again, then tap **R** to run.

---

## Where do these functions come from?

A fair question, because an `.ino` file has almost no `#include` lines and still calls
`pinMode` and `Serial`. Three things are happening.

**1. The `.ino` is not quite C++ yet.** Before compiling, the IDE (or arduino-cli)
concatenates the sketch, adds `#include <Arduino.h>` at the top, and generates forward
declarations for your functions — which is why `loop()` can call a function defined below it.
The result is an ordinary `.cpp`.

**2. There is a `main()`, you just don't write it.** The core provides it. Simplified, it
calls `setup()` once and then `loop()` forever. On the ESP32 that loop runs inside a FreeRTOS
task, so `delay()` yields to the scheduler rather than burning cycles — which matters later,
when Wi-Fi or Zigbee needs time of its own.

**3. `Arduino.h` pulls in the rest.** On this core it includes `esp32-hal.h`,
`HardwareSerial.h` and `Esp.h`, and those bring everything the sketches use except `WiFi`:

| What the sketch calls | Where it is declared | `#include` needed? |
|---|---|---|
| `pinMode`, `digitalWrite`, `HIGH`, `LOW`, `OUTPUT` | `cores/esp32/esp32-hal-gpio.h` | no |
| `delay`, `millis` | `cores/esp32/esp32-hal.h` | no |
| `analogRead`, `analogReadMilliVolts` | `cores/esp32/esp32-hal-adc.h` | no |
| `Serial`, `Serial.begin`, `.println`, `.printf` | `cores/esp32/HardwareSerial.h` | no |
| `ESP.getChipModel()`, `.getFlashChipSize()` … | `cores/esp32/Esp.h` | no |
| `WiFi.scanNetworks()`, `WiFi.SSID(i)` … | `libraries/WiFi/src/WiFi.h` | **yes** — `#include <WiFi.h>` |

On this machine that is
`~/.arduino15/packages/esp32/hardware/esp32/3.3.12/…` — worth opening if you want to see how
thin most of these wrappers are.

### Two details specific to this board

**`Serial` is not a serial port here.** `HardwareSerial.h` contains:

```cpp
#define Serial HWCDCSerial    // when the board is built with cdc_on_boot=1
```

`XIAO_ESP32C6` sets `build.cdc_on_boot=1` by default, so `Serial` is the USB connection built
into the chip, not a UART on pins D6/D7. That is why the messages arrive over the same cable
that powers and flashes the board, and why the baud rate you pick is irrelevant — USB has no
baud rate. The Serial Monitor still asks for one; anything works.

**Arduino here is a layer, not the bottom.** `arduino-esp32` 3.x sits on top of Espressif's
own SDK, ESP-IDF 5.x. `analogRead` is a wrapper around the IDF ADC driver, `WiFi` around
`esp_wifi`. When Arduino doesn't expose something — precise ADC calibration, or Zigbee — you
can call IDF functions directly from the same sketch, because it is all one binary.

### Which of these are "libraries"?

Only one, strictly. `WiFi` is a library: a folder under `libraries/` in the core, with its own
`src/`, and it needs an `#include`. Everything else — `pinMode`, `delay`, `Serial`, `ESP` — is
the **core** itself, compiled into every sketch whether you use it or not. Nothing here comes
from the Library Manager, and these three sketches install no third-party dependencies at all.
