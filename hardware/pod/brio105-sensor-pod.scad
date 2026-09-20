// ============================================================
// Camera-in-use LED sensor pod + magnetic anchor
// For: Logitech Brio 105, TEPT4400 phototransistor, 3x1mm magnets
//
// Two parts on one plate:
//   1) sensor_pod()     - holds the TEPT4400 + acts as the light shroud
//   2) magnet_anchor()  - sticks to the camera next to the LED
//
// MEASURED FROM THE ACTUAL CAMERA (tape measure + photos):
//   - LED is a thin arc, ~10-11mm from the camera's left edge (~1mm wide)
//   - Top of the LED arc is ~12mm from the camera's top edge
//   - Camera housing (front capsule) thickness/depth: 17mm
// These numbers are for placing the anchor by hand - they are NOT baked
// into the model, since the pod attaches via magnet, not a fixed clamp.
// Before printing: cut a ~14mm x 11mm rectangle out of paper/cardboard
// and hold it at that spot on the real camera to confirm it clears the
// lens and the housing's curved edge - cheap sanity check against a
// camera curvature I'm guessing at, not measuring directly.
//
// ROTATION KEYING
// A single round magnet-to-magnet joint has no rotational preference -
// the pod could spin on re-attachment and drift the tunnel off the LED.
// To prevent that, the pod/anchor footprint is deliberately asymmetric
// (a "fat end" toward the sensor bore, "thin end" toward the magnet) so
// the two parts can only mate in the correct orientation.
//
// PRINT NOTES
// - Material: matte black PETG or ABS. Glossy filament reflects stray
//   light down the tunnel and defeats the shroud.
// - Orientation: print both parts sitting on their front/adhesive face,
//   holes opening upward - no supports needed either part.
// - FDM holes print undersized - test-fit the TEPT4400 and the magnet
//   after printing; ream out by hand with a 3mm/3.2mm drill bit if tight.
// - The front rim is flat/rigid and won't perfectly match the camera's
//   slight curve. Stick a thin ring of adhesive foam weatherstrip tape
//   to the front rim before final placement - it conforms to the curve
//   and completes the light seal far better than bare plastic-on-plastic.
// - Mark the magnet's polarity with a marker dot before gluing into each
//   part, so pod and anchor always attract (not repel).
// ============================================================

$fn = 64; // smooth circles

// ---- measure-and-adjust before printing ----
tept_dome_d      = 3.0;   // TEPT4400 dome diameter (datasheet nominal)
tept_bore_d      = tept_dome_d + 0.4;   // add clearance
tept_bore_depth  = 5.0;   // dome + a bit of the leaded body

tunnel_d         = 1.6;   // narrowed from an earlier 2.0mm - the measured
                          // LED arc is only ~1mm wide, so a tighter
                          // tunnel improves contrast (trade-off: needs
                          // more careful alignment when placing the pod)
tunnel_len       = 2.5;   // longer = better ambient-light rejection,
                          // but must stay clear of the lens - keep short

magnet_d         = 3.2;   // 3mm magnet + clearance
magnet_len       = 1.3;   // 1mm magnet + a little glue gap

pod_wall         = 1.8;   // wall thickness around each hole
hole_gap         = 1.5;   // minimum plastic wall between the two holes
key_bump         = 2.0;   // extra radius on the sensor end only - this is
                          // what makes the footprint asymmetric

pod_len          = tept_bore_depth + tunnel_len;

// hole centers, offset along X so the two blind holes never intersect
hole_offset = tept_bore_d/2 + magnet_d/2 + hole_gap;
sensor_x = -hole_offset/2;
magnet_x =  hole_offset/2;

r_sensor_end = tept_bore_d/2 + pod_wall + key_bump; // "fat end"
r_magnet_end = magnet_d/2 + pod_wall;               // "thin end"

// ============================================================
module pod_footprint(r1, r2) {
    hull() {
        translate([sensor_x, 0]) circle(r = r1);
        translate([magnet_x, 0]) circle(r = r2);
    }
}

module sensor_pod() {
    difference() {
        linear_extrude(height = pod_len)
            pod_footprint(r_sensor_end, r_magnet_end);

        // sensor bore: wide dome pocket, opens at the BACK face (top)
        translate([sensor_x, 0, tunnel_len])
            cylinder(d = tept_bore_d, h = tept_bore_depth + 1);

        // narrow shroud tunnel, opens at the FRONT face (presses on camera)
        translate([sensor_x, 0, 0])
            cylinder(d = tunnel_d, h = tunnel_len + 0.5);

        // magnet pocket, opens at the BACK face, same side as the bore
        translate([magnet_x, 0, pod_len - magnet_len])
            cylinder(d = magnet_d, h = magnet_len + 0.5);
    }
}

module magnet_anchor() {
    anchor_thick = magnet_len + 1.2;
    difference() {
        linear_extrude(height = anchor_thick)
            pod_footprint(r_sensor_end, r_magnet_end);

        // magnet pocket at the same X position as the pod's magnet hole,
        // so the two parts only line up magnet-to-magnet when the fat
        // end (sensor side) of both point the same way
        translate([magnet_x, 0, anchor_thick - magnet_len])
            cylinder(d = magnet_d, h = magnet_len + 0.5);
    }
}

// ---- layout for printing ----
pod_total_len = hole_offset/2 + r_sensor_end + hole_offset/2 + r_magnet_end;

sensor_pod();
translate([pod_total_len + 5, 0, 0])
    magnet_anchor();
