// ============================================================
// CORNER CLIP V1.1, rebuilt around REAL measured geometry
// For: Logitech Brio 105, TEPT4400 phototransistor
//
// This replaces the earlier version of this file, which assumed a sharp
// box-style top-front edge. Photos of the real camera disproved that: the
// head is a rounded pill/pod shape, not a box. This version is built from
// actual coordinates extracted from Logitech's own AR ("try in your room")
// 3D model of the camera, cross-checked against the user's own tape-measure
// readings of the physical unit. See ../reference/brio100-camera-head.stl
// - that file is the source mesh these numbers came from, and can be
// import()-ed below (see show_reference) to visually check the fit in
// OpenSCAD before printing.
//
// NOTE ON THE REFERENCE MESH: it was extracted from Logitech's AR asset for
// the "Brio 100", not the "105" - no Brio 105 AR/CAD model could be found.
// Product photos suggest the two share the same housing/mold, but this is
// UNVERIFIED - check the printed part against the real Brio 105 before
// relying on it.
//
// COORDINATE SYSTEM: identical to the reference STL's own coordinate frame
// (chosen deliberately, so that file can be imported below with zero
// transform):
//   X: left-right along the camera bar (mesh spans roughly -34.8 .. +34.8)
//   Y: vertical, up/down on the camera body
//   Z: front-to-back depth - HIGH Z = front face (lens side, facing the
//      user), LOW Z = back face (cable/hinge side)
//
// HOW THE REAL NUMBERS BELOW WERE DERIVED:
//   The reference mesh was rasterized into depth-map slices (custom
//   Z-buffer renderer, since no CAD libraries were available) and scanned
//   for the lens's circular recess and for flat front/back regions:
//     - Lens: a ~10mm-diameter circular dip in an otherwise flat front
//       face, centered at (X=-15.8, Y=31.0), recessed to Z~45.5 vs. the
//       surrounding flush front face at Z~47.6-47.7. Matches the user's
//       own measurement of a 10mm bezel that "doesn't raise in any way".
//     - LED: NOT visible as a distinct feature in the mesh (it's likely
//       just a small light pipe / paint dot, too subtle to show up as
//       geometry). Its position is taken from the user's own tape-measure
//       reading: "8-10mm from the lens center, same height (symmetric
//       horizontally)", on the side AWAY from the mic grille / hinge.
//       That places it at X=-24.1, Y=31.0.
//     - Front/back are genuinely FLAT and parallel in the LED's
//       neighbourhood: sampling X=-20 to X=-27 (Y band 26-36) gives a
//       constant front Z~47.6-47.7 and back Z~29.78 - i.e. ~17.9mm
//       thickness, not tapering at all through that whole span.
//     - That flat region ends around X=-28/-29: by X=-30 the back surface
//       has already moved from 29.78 to 32.2, and by X=-32 the thickness
//       has dropped to ~8.6mm - this is the pod's rounded end cap starting.
//     - The lens's own recess starts around X=-20.5 on the near side.
//     - So the genuinely flat, both-sides-known-flush window this clip can
//       safely grip is only about X=-28 to X=-20.5 (~7.5mm) - tighter than
//       initially assumed. The clip below is sized to fit inside that
//       window with the LED roughly centered.
//
// MECHANISM (different from the old box-corner design): since front and
// back are flat and PARALLEL here (not a sharp corner), this is a simple
// spring clip - like a large hairpin/binder clip - not a hooked corner
// clamp. Two jaw plates (front + back) are joined by a flexible bridge at
// the tip-ward end. The bridge is the only flex point; you pry the two
// free jaw tips apart, slip it over the housing, and let go. The inner gap
// is based on the physical Brio 105 thickness plus a small installation
// clearance. The bridge still provides the spring force when the clip is
// opened by hand. No sliding-on motion is required.
//
// STILL UNVERIFIED - CHECK BEFORE PRINTING:
//   - Confirm the Brio 100 housing really matches the Brio 105 (see note
//     above).
//   - Confirm the jaw's near edge (toward the lens) lands on the flush
//     bezel rim and not on the recessed glass itself - the boundary
//     between "flush rim" and "recessed glass" could only be pinned down
//     to roughly X=-20.5 to -22 from the mesh data, and the jaw's near edge
//     sits right at that boundary.
//   - `fit_clearance` below is a starting value for the relaxed jaw gap.
//     The first print should be treated as a fit test, especially because
//     the reference mesh is Brio 100 rather than Brio 105.
//
// V1.1 FIT BASIS:
//   The Brio 100 reference mesh reports ~17.9mm in this region, but the
//   physical Brio 105 was measured at ~17.0mm. Because the reference mesh
//   is Brio 100 (not 105), the physical 17.0mm value is used for the clip
//   gap; the reference mesh remains a shape/position reference only.
// ============================================================
$fn = 64;

// ---- REAL measured geometry (mesh frame, mm - see notes above) ----
lens_x  = -15.8;
lens_y  = 31.0;
led_x   = -24.1;   // ~8.3mm left of lens center, same height - per user's tape measurements
led_y   = 31.0;
front_z = 47.7;    // flat front face at the LED (NOT the lens - lens itself is recessed ~2mm)
back_z  = 29.8;    // flat back face - constant over the whole flat window

reference_thickness = front_z - back_z;  // ~17.9mm in the Brio 100 reference mesh

// Physical Brio 105 fit:
// The photo measurement is approximately 17.0mm across the housing at the
// LED area. This is deliberately kept separate from reference_thickness:
// the reference mesh is Brio 100 and must not dictate the Brio 105 fit.
camera_thickness = 17.0;
fit_clearance    = 0.30;  // relaxed diametral clearance; tune after first print

// Relaxed distance between the two inner jaw faces.
// The clearance is positive: the clip is NOT intended to be preloaded while
// sitting on the camera. Opening the jaws by hand creates the spring force.
inner_gap = camera_thickness + fit_clearance;

// ---- clip geometry (design choices, sized to the flat window above) ----
// The flat window is NOT symmetric around the LED: the lens's recessed
// glass starts around X=-20.5 (hard limit - must stay clear, or the clip
// blocks the camera). On the tip side, the jaw PLATE is fine resting close
// to the housing all the way past the taper (it stays a thin flat plate
// that just follows the surface loosely, confirmed by sampling: real
// front Z stays <=47.64 all the way to the tip at X=-34.76, vs. our flat
// contact at 47.7 - always a hair clear, never colliding).
//
// The BRIDGE is a different story: it is a SOLID block spanning the full
// front-to-back thickness, not a thin plate - so it must not be placed
// anywhere the pod still has real material in that thickness range, or it
// bulldozes straight through the housing (this was the "clip cuts the
// camera" bug in an earlier version, caught by looking at the top view: the
// bridge was placed at X=-28, but the pod is still ~12-17mm thick there).
// The pod's mesh has ZERO vertices beyond X=-34.76 (confirmed empirically),
// so the bridge is pushed out past that point, into genuinely empty space.
near_margin    = 3.2;   // led_x -> jaw's lens-side edge (X=-20.9, ~0.4mm
                         // clear of the lens dip at -20.5 - TIGHT, verify
                         // against the imported reference mesh before print)
far_margin     = 11.0;  // led_x -> jaw's tip-side edge (X=-35.1), ~0.34mm
                         // past the pod's true tip at X=-34.76 - the jaw
                         // plate rides the taper the whole way, the bridge
                         // only starts once the pod has actually ended
jaw_thick      = 2.5;  // material thickness of each jaw plate
jaw_height     = 14;   // along Y, centered on led_y - slightly larger grip area
bridge_thick   = 3;    // along X, the flex/spring wall at the tip-ward end
corner_overlap = 0.4;  // forces real volumetric overlap where parts meet, so the CSG
                        // union is a single valid manifold solid. Kept small (and within
                        // the flat 46.07 cap of back_profile, X=-35.10..-34.70) so the
                        // bridge's overlap zone doesn't reach into the fast-dropping part
                        // of the taper, which is what caused the notch/step - see bridge()

x_near = led_x + near_margin;  // toward the lens (open end)
x_far  = led_x - far_margin;   // toward the tapered tip (bridge/closed end)
engagement_len = x_near - x_far;
y_lo   = led_y - jaw_height/2;
y_hi   = led_y + jaw_height/2;

// ---- sensor bore (same part/logic as the earlier design) ----
// Vishay's datasheet lists "Ø 3" as the headline dimension, but that is only
// the dome TIP diameter (Ø3 +/-0.1). The package drawing (6.544-5054.01-4)
// shows a wider shoulder ~2.5mm down from the tip at Ø3.2 +/-0.15 (max
// 3.35mm), which spans most of the ~7mm encapsulated body length - a bore
// sized off the 3mm tip spec alone left only ~0.05mm worst-case diametral
// clearance against that shoulder, too tight for FDM printing (small round
// holes commonly print 0.1-0.3mm undersized).
tept_dome_d      = 3.0;
tept_body_d      = 3.35;  // worst-case max diameter of the straight-walled
                          // body shoulder (Ø3.2 +/-0.15), not just the tip
tept_bore_d      = tept_body_d + 0.45;  // 3.8mm - real FDM-printable clearance
tept_bore_depth  = 5.0;  // NOTE: the wide bore is a THROUGH hole, open at the
                          // outer/tip end (see the boss cut below) - it does
                          // not need to swallow the whole ~7mm rigid body, just
                          // enough of the straight shoulder to grip it (5mm is
                          // plenty). Bumping this to fully enclose the body was
                          // tried first, but it pushes the whole boss further
                          // forward by the same amount, which ate directly into
                          // the lens-FOV clearance margin checked earlier
                          // (alpha dropped from ~30 to ~25deg, below the
                          // camera's own ~25.8deg half-FOV) - so depth is left
                          // as-is and only the diameter is widened.
tunnel_d         = 1.6;
tunnel_len       = 2.5;
pod_wall         = 1.2;  // thin - keeps the boss inside near_margin, see caveat below
boss_r   = tept_bore_d/2 + pod_wall;
boss_len = tept_bore_depth + tunnel_len;

// set true to overlay the reference camera mesh (as a transparent %-preview
// only - it is never part of the actual solid/exported geometry) for a
// visual fit check in the OpenSCAD viewer
show_reference = true;

// ============================================================
// The real back wall is only flat right at the LED - it curves away
// steadily toward the tip (see samples below). Rather than assume a flat
// plane, this builds the back jaw's contact face as an actual profile
// curve fitted to the real surface, so it touches the housing along its
// whole length instead of floating in a growing gap.
//
// (Originally this carved the reference mesh directly via difference(),
// which is the more "automatic" approach - but that mesh turned out not
// to be watertight/manifold (1181 open boundary edges, likely from the AR
// export process), so CGAL can't boolean against it reliably. Sampling the
// same mesh's raw vertex data in Python and hand-deriving a profile curve
// sidesteps that, at the cost of needing to keep this table in sync if the
// reference mesh is ever replaced.)
//
// Samples: min Z (= back surface) in the Y=25..37 band, every 1mm of X,
// from ../reference/brio100-camera-head.stl:
back_profile = [
    [-35.10, 46.07],  // flat cap - no mesh exists past the true tip at X=-34.76,
    [-34.70, 46.07],  // so this just continues the last real sample
    [-33.90, 42.22],
    [-32.90, 39.05],
    [-31.90, 36.04],
    [-30.90, 33.80],
    [-29.90, 32.22],
    [-28.90, 31.11],
    [-27.90, 30.63],
    [-26.90, 29.79],
    [-25.90, 29.78],
    [-24.90, 29.78],
    [-23.90, 29.78],
    [-22.90, 29.78],
    [-21.90, 29.78],
    [-20.90, 29.78],  // = x_near
];

// Perpendicular (normal) direction of a single profile segment, pointing
// away from the housing (down/left in this X-Z cross-section). NOT the same
// as a pure vertical shift - see offset_profile_bevel() below for why that
// distinction matters.
function seg_normal(p0, p1) =
    let(d = p1 - p0, l = norm(d))
    l > 0 ? [d[1] / l, -d[0] / l] : [0, -1];

// Miter-offset a single profile vertex: the intersection of the two offset
// lines belonging to its two adjacent segments. This gives ONE outer vertex
// per input vertex - i.e. the offset polyline has the same shape and vertex
// count as the input polyline, just shifted out perpendicular-ish. Miter
// distance is thick/cos(bend/2), which can blow up on very sharp bends;
// the sharpest bend in back_profile is ~78deg at the tip-cap-to-dome joint,
// which gives a modest miter distance of ~3.2mm vs the base 2.5mm, so no
// clamping/spike-guarding is needed here.
function miter_offset(pprev, pcur, pnext, thick) =
    let(
        na = seg_normal(pprev, pcur),
        nb = seg_normal(pcur, pnext),
        b  = na + nb,
        blen = norm(b)
    )
    blen < 1e-6
        ? pcur + thick * na
        : let(bn = b / blen, cos_half = na * bn)
            pcur + (thick / cos_half) * bn;

function outer_offsets(pts, thick) =
    let(n = len(pts))
    concat(
        [pts[0] + thick * seg_normal(pts[0], pts[1])],
        [for (i = [1 : n - 2]) miter_offset(pts[i-1], pts[i], pts[i+1], thick)],
        [pts[n-1] + thick * seg_normal(pts[n-2], pts[n-1])]
    );

module back_jaw_contoured() {
    outer = outer_offsets(back_profile, jaw_thick);
    poly_pts = concat(
        back_profile,
        [for (i = [len(outer) - 1 : -1 : 0]) outer[i]]
    );
    translate([0, y_hi, 0])
        rotate([90, 0, 0])
            linear_extrude(height = jaw_height)
                polygon(poly_pts);
}

// The bridge connects the front jaw's top face down to the back jaw's
// contoured shell at the tip end. Its bottom face used to sit at the old
// flat-back-jaw baseline (back_z - jaw_thick = 27.3) - a leftover from
// before back_jaw_contoured() became a thin contour-following shell. That
// left the bridge ~22mm tall while the shell it meets is only ~2.5mm thick, so
// the union had a ~10mm cliff at the seam (visible as the notch/step that
// cuts across the real housing curve instead of following it).
// Fix: size the bridge's bottom face to match the shell's outer face
// right at x_far (the first back_profile sample), so the two meet flush.
bridge_chamfer = 1.2;
module bridge() {
    x0 = x_far - bridge_thick;
    x1 = x_far + corner_overlap;
    z0 = back_profile[0][1] - jaw_thick;
    z1 = back_z + inner_gap + jaw_thick;
    difference() {
        translate([x0, y_lo, z0])
            cube([x1 - x0, jaw_height, z1 - z0]);
        translate([x0 - 1, y_lo - 1, z1 - bridge_chamfer])
            rotate([0, 45, 0])
                translate([-bridge_chamfer, 0, -bridge_chamfer])
                    cube([bridge_chamfer * 2, jaw_height + 2, bridge_chamfer * 2]);
        translate([x0 - 1, y_lo - 1, z0 + bridge_chamfer])
            rotate([0, 45, 0])
                translate([-bridge_chamfer, 0, -bridge_chamfer])
                    cube([bridge_chamfer * 2, jaw_height + 2, bridge_chamfer * 2]);
    }
}

module end_clip() {
    difference() {
        union() {
            // front jaw - clamps the flat front face near the LED
            translate([x_far, y_lo, back_z + inner_gap])
                cube([engagement_len, jaw_height, jaw_thick]);

            // back jaw - CONTOURED to the real back wall
            back_jaw_contoured();

            // bridge - the flex/spring point
            bridge();

            // sensor boss - extra material at the LED position
            translate([led_x, led_y, back_z + inner_gap])
                cylinder(r = boss_r, h = boss_len);
        }

        // wide bore for the phototransistor body, open at the outside face
        translate([led_x, led_y, back_z + inner_gap + tunnel_len])
            cylinder(d = tept_bore_d, h = boss_len - tunnel_len + 1);

        // narrow shroud tunnel, the last bit before the LED
        translate([led_x, led_y, back_z + inner_gap - 0.5])
            cylinder(d = tunnel_d, h = tunnel_len + 0.5);
    }
}

end_clip();

if (show_reference)
    %import("../reference/brio100-camera-head.stl");
