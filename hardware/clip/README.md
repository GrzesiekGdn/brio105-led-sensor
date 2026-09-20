# Camera clip

A spring clip ("hairpin" style) that grips the flat front and back faces beside the Brio 105's
activity LED and holds the TEPT4400 against it. Front and back are parallel there, so it
clamps by flexing, not by hooking a corner.

| File | What it is |
|---|---|
| `brio105-sensor-clip-v1.2.scad` / `.stl` | **Latest.** |
| `brio105-sensor-clip-v1.1.scad` / `.stl` | Earlier version, to be test-fitted against v1.2 |
| `brio105-sensor-clip-v1.0.scad` / `.stl` | First version, kept for comparison |
| `photos/` | Tape-measure photo of the housing depth that v1.2's fit is based on |

Open any version in OpenSCAD with `show_reference = true` and the camera mesh from
[`../reference/`](../reference/) is `import()`-ed in ghost mode, in the same coordinate frame,
with the clip sitting on it.

---

## Versions

All three share the same coordinate frame, lens and LED positions, and TEPT4400 bore, so
they are directly comparable in OpenSCAD.

> **Not yet tested.** Prints of v1.1 and v1.2 have been ordered for a test fit on the real
> Brio 105. Until they arrive and have been tried, neither is confirmed — this section will
> name the one that fits best.

| Version | Relaxed jaw gap | What changed |
|---|---|---|
| **v1.0** — proposed by Claude | 17.3 mm | First design, built on the reference mesh: 17.9 mm housing minus 0.6 mm interference. 12 mm tall jaws. |
| **v1.1** — revised with ChatGPT | 17.3 mm | Jaws raised to 14 mm. Fit rebased on a tape measurement of the real camera: 17.0 mm plus 0.3 mm clearance. Same gap as v1.0, opposite reasoning — v1.0 meant it to grip, v1.1 to slide on freely. |
| **v1.2** — also by Claude | 16.2 mm | Spring redesigned so the fit no longer depends on the exact housing thickness. |

**Why v1.2 exists.** v1.0 and v1.1 are geometrically nearly the same part, and share two
problems:

- **The spring was not a spring.** The back jaw wrapped the camera's rounded end, which left
  the "bridge" as a solid block and put all the flex in a stiff 2.5 mm jaw (~48 N/mm). A
  ±0.5 mm error in housing thickness flipped it between *cracks on fitting* and *falls off*.
  v1.2 uses a flat back jaw and makes a thin 1.5 mm bridge the flexure (~3.3 N/mm), so it
  holds across the whole plausible range of 17.0–18.6 mm without over-stressing.
- **The 17.0 mm reading was probably ~1 mm short.** The tape's end hook has about 1 mm of
  slide in its rivet slot. Measured off the photo in [`photos/`](photos/), the housing is
  ~18.2 mm — consistent with the reference mesh's 17.86 mm.

v1.2 also moves the jaw's near edge 0.6 mm back from the lens rim (v1.0/v1.1 sat just over
it), lets only contact ribs touch the housing, and adds a 5 × 3 mm funnel in front of the
sensor, so the LED can be off its assumed position by ±2 mm along the bar and ±1.5 mm
vertically and still be seen.

---

## Printing

**Orientation matters more than material here.** Lay the C-shape flat on the bed as a
17 × 27 mm footprint and build 14 mm upward — that is the model's **Y axis vertical**. The
whole flexure is then one constant cross-section: no supports, no bridging, and the bending
stress runs along the extrusion paths instead of across layer boundaries. The obvious
alternative, bore pointing up, puts the bridge's tensile stress normal to the layers, which
is how a spring like this fails months later.

Suggested: 4 perimeters, 40%+ infill, and a brim for the thin first-layer outline. Use matte
black filament — glossy reflects stray light down the tunnel and defeats the shroud. v1.2's
header argues for PLA here, as the stiffest common option; PETG works but creeps more under
sustained load.

The full rationale, the measurements behind every number, and a batch of test prints for the
two remaining unknowns are in the `.scad` headers.
