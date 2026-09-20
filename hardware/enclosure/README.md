# Controller enclosure

The clip or the pod holds the phototransistor on the camera; the other end of the cable has
to live somewhere too. This is a free-standing desk box for that end: a bare XIAO ESP32-C6,
the single 10k load resistor for the TEPT4400, and the junction where the sensor cable is
soldered on. USB-C stays plugged in for power, and the onboard ceramic antenna radiates
through the plastic — so nothing but the sensor cable leaves the box.

| File | What it is |
|---|---|
| `xiao-esp32c6-enclosure-v1.scad` | The enclosure. `part = "tray"`, `"lid"` or `"both"` — `"both"` puts them on one plate |
| `xiao-esp32c6-enclosure-v1-tray.stl` / `-lid.stl` | The two printed parts |
| `xiao-esp32c6-board.scad` | Reference model of the XIAO itself, `include`-ed as a ghost preview — not a printable part |

It is built the same way as the clip: not on a published drawing, but on the real geometry.
Seeed's wiki and their own datasheet disagree about the board size (17.8 vs 17.5 mm), and
neither publishes PCB thickness, component heights or LED positions, so
[`xiao-esp32c6-board.scad`](xiao-esp32c6-board.scad) is generated straight from Seeed's KiCad
PCB file instead. Open the enclosure in OpenSCAD with `show_board = true` and the board sits
in the box in its real position, the same trick as `show_reference` on the clip.

> **Not yet tested.** The tray and lid went to the print shop in the same order as the v1.1
> and v1.2 camera clips, so they arrive together and can be test-fitted in one go.

---

## Printing

Tray open side up, lid top face **down**. Neither needs support. PETG is preferred over PLA:
the snap arms work at about 1.6 % strain, which PLA survives but does not forgive.

They snap together with four full-depth cantilever arms — no glue, opened again with a
fingernail or a spudger at the pry notch. The activity LED shows through a light bar: a blind
pocket that leaves a 0.5 mm skin, so the lid is an unbroken surface until the LED lights up.

After a CGAL render (F6), `Volumes` should be **2** for a tray or lid on its own and **3** for
both parts together — that is the solid(s) plus the outside. A larger number means a feature
has come loose as a separate body. The `.scad` header carries the same treatment for the
snap-arm strain budget: change the wall, floor or plug clearances and re-read the strain
figure it echoes.

---

## Wiring

What goes inside the box — the resistor, the junction and the two-wire cable to the sensor —
is in [hardware/wiring/](../wiring/README.md), together with the tests that check the XIAO
itself before anything is soldered.
