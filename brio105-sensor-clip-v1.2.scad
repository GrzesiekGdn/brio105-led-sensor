// ============================================================
// END CLIP v1.2 - Logitech Brio 105 status-LED sensor mount
// Sensor: Vishay TEPT4400 phototransistor (3mm package)
//
// WHAT CHANGED vs v1.0 / v1.1, AND WHY
// ------------------------------------
// v1.0 and v1.1 are geometrically the same part (both produce inner_gap =
// 17.3mm; v1.1 only made the jaws 2mm taller and re-labelled the fit
// rationale). Two things in that shared architecture make a first-print
// success unlikely, and both are fixed here:
//
//  (1) THE SPRING WAS NOT A SPRING. In v1.0/v1.1 the back jaw is a
//      contoured shell that wraps the pod's end dome all the way up to
//      Z=46.07, which is only ~1mm short of the front jaw's inner face at
//      Z=47.1. The "bridge" joining them is therefore a 3 x 14 x 6mm
//      block - effectively rigid. All the compliance has to come from a
//      2.5mm-thick, 14mm-long jaw plate cantilevered off it:
//          k = 3EI/L^3 = 3 * 2500MPa * 18.2mm^4 / 14.2^3  ~= 48 N/mm
//      At v1.0's intended 0.6mm interference that is ~29N of clamping
//      force and ~28MPa of bending stress in the jaw root; at 1.5mm it is
//      ~72N and ~70MPa, i.e. past PLA's yield. Meanwhile v1.1's stated
//      +0.30mm clearance would give exactly 0N and no retention at all.
//      The design has no usable middle: a +-0.5mm error in the assumed
//      housing thickness flips it between "cannot be pushed on / cracks"
//      and "falls off". That is the opposite of what you want when the
//      first print has to work.
//      FIX: the back jaw is now a flat plate (it does not need to hug the
//      dome - see CLEARANCE below), so the bridge can be a full-height
//      1.5mm wall standing in the empty space past the pod's tip. The
//      bridge is now the flexure, and the spring rate drops to
//      ~3.3 N/mm at the gap. Same interference now gives a sane force and
//      ~18MPa peak stress, and the force varies gently with thickness
//      instead of switching on and off.
//
//  (2) THE ASSUMED HOUSING THICKNESS WAS PROBABLY A MISREAD. See
//      MEASUREMENT below. 17.0mm (v1.1) does not agree with either the
//      reference mesh or the tape-measure photo; ~18.2mm does. But
//      because of the fix above this part no longer has to be right about
//      it - see FIT WINDOW.
//
// Everything else that v1.0/v1.1 got right is kept: the coordinate frame,
// the LED/lens positions, the TEPT4400 bore sizing rationale, the
// collimating tunnel idea, and v1.1's 14mm jaw height (which turns out to
// match the housing's flat band Y=24..38 almost exactly - measured).
//
// MEASUREMENT (what the housing thickness actually is)
// ----------------------------------------------------
// Three independent numbers:
//   - reference/brio100-camera-head.stl, sampled in the Y=26..36 band:
//     17.86mm, dead constant from X=-27 to X=-18.
//   - photos/20260829_162636.jpg, measured off the image: the tape's 1mm
//     graduations run 19.98 px/mm (fitted over the 30mm..2mm span), the
//     pod's silhouette edges sit at x=460.0 and x=824.5 px, so the pod is
//     364.5px = 18.24mm. Reading the tape scale directly at each edge
//     gives 17.28mm and -1.03mm, i.e. 18.31mm - same answer.
//   - "17.0mm", the value v1.1 designs to.
// The photo also shows why 17.0 is low: the tape's printed zero
// extrapolates to x=804px, but the hook's inner face - the surface
// actually touching the camera - is at x=820. That ~1mm offset is the
// hook's rivet-slot travel. If the hook is not pulled taut against the
// edge it does not slide out to compensate, and the reading comes out
// ~1mm short. 17.3 read off the tape is ~18.3 in reality.
// So: nominal 18.2mm, and treat anything in 17.0..18.6 as possible.
//
// FIT WINDOW (why this part does not need the exact number)
// ---------------------------------------------------------
// Relaxed gap is 16.2mm, so the interference is (housing - 16.2):
//     housing 17.0mm -> 0.8mm -> ~2.6N clamp -> ~1.6N of friction
//     housing 18.2mm -> 2.0mm -> ~6.6N clamp -> ~4.0N of friction
//     housing 18.6mm -> 2.4mm -> ~7.9N clamp, ~18MPa peak stress
// (mu ~0.3, two faces.) The whole range holds, none of it over-stresses
// the part, and the worst case still needs under 1kgf to push on. The
// clip plus a 1m tail of thin wire is well under 10g, so even the
// pessimistic end has ~15x margin against sliding.
//
// CLEARANCE (why a flat back jaw is safe)
// ---------------------------------------
// Sampled from the reference mesh, Y=26..36 band: the back surface sits at
// Z=29.78 flat from X=-27 to X=-18, and only ever moves to HIGHER Z going
// outboard (30.65 at X=-28.5, 32.95 at X=-30.5, 44.71 at X=-34.5) as the
// end dome curls away. A flat jaw at Z<=29.78 is therefore never in the
// way - past X=-27 it simply hangs in free air, which is exactly what you
// want from a spring arm. Same on the front: the front face never exceeds
// Z=47.67 anywhere from the tip to the lens rim.
//
// LENS CLEARANCE (corrected)
// --------------------------
// v1.0/v1.1 put the jaw's near edge at X=-20.9 and called it "~0.4mm
// clear of the lens dip at -20.5 - TIGHT". Re-measured: the flush front
// face runs to X=-21.0 and the rim starts dropping immediately after
// (46.81 at X=-20.75, 46.43 at X=-20.25), so -20.9 is actually just over
// the edge. Near edge moved back to X=-21.5. It costs nothing here
// because contact is at the rib (X=-24.1), not at the jaw tip.
//
// COORDINATE SYSTEM: unchanged from v1.0/v1.1 and from the reference STL,
// so the mesh still import()s with zero transform.
//   X: along the camera bar. Mesh spans -34.76 .. +34.76.
//   Y: vertical on the camera body. Head spans 16.16 .. 46.03.
//   Z: depth. HIGH Z = front (lens side), LOW Z = back (hinge side).
//
// STILL UNVERIFIED - CHECK BEFORE PRINTING
// ----------------------------------------
//  - The reference mesh is Logitech's AR asset for the Brio *100*. No
//    Brio 105 model exists. Housings look identical in product photos;
//    unconfirmed. This is why the fit window above matters more than the
//    nominal.
//  - The LED position (X=-24.1, Y=31.0) comes from your tape reading
//    ("8-10mm from the lens centre, same height"), not from the mesh -
//    the LED is not a geometric feature in it. The funnel below is built
//    to absorb that: its mouth is a 5.0 x 3.0mm slot, so the LED can be
//    anywhere in X=-22.1..-27.1 and Y=29.5..32.5 and still be seen. Your
//    stated range maps to X=-23.8..-25.8, which sits inside that with
//    >1.3mm to spare on each side.
// ============================================================

$fn = 96;

// ---- measured camera geometry (mesh frame, mm) ----
lens_x   = -15.8;
lens_y   = 31.0;
led_x    = -24.1;   // from your tape measurement, not from the mesh
led_y    = 31.0;
front_z  = 47.67;   // flush front face at the LED (mesh)
back_z   = 29.78;   // flat back face (mesh, constant X=-27..-18)

// ---- fit ----
camera_thickness = 18.2;   // see MEASUREMENT. mesh 17.86, photo 18.24-18.31
interference     = 2.0;    // designed spring deflection at nominal
inner_gap        = camera_thickness - interference;   // 16.2mm relaxed

// If the printed clip is too stiff or too loose, change ONLY this:
//   too hard to push on  -> raise inner_gap (lower interference)
//   slides off / no grip -> lower inner_gap (raise interference)
// 0.4mm steps are a sensible increment (~1.3N of clamp force each).

// ---- clip body ----
near_margin  = 2.6;    // led_x -> jaw's lens-side edge, X=-21.5 (rim at -21.0)
far_margin   = 11.0;   // led_x -> jaw's tip-side edge, X=-35.1 (pod tip -34.76)
jaw_thick    = 2.5;    // jaw plate thickness - stiff on purpose, see rib below
jaw_height   = 14;     // along Y, centred on led_y -> Y=24..38, the housing's
                       // full-thickness flat band (>=17.6mm) measured from the
                       // mesh. v1.1's value, now confirmed rather than assumed.
relief       = 0.6;    // jaw inner faces stand off this far; only the ribs touch
bridge_thick = 1.5;    // THE FLEXURE. this number sets the spring rate.
bridge_flare = 1.5;    // extra thickness blended in at both bridge ends
bridge_flare_len = 5;  // over this much Z at each end
fillet_r     = 2.0;    // inside corners where the jaws meet the bridge

// Rounded contact ribs. The jaw does not stay parallel to the housing: it
// rotates about the bridge by theta = deflection/lever ~= 0.078rad (4.5deg)
// at nominal. A flat jaw face would then touch only along one edge and lift
// the sensor tunnel ~0.3mm off the housing, which both leaks ambient light
// in and changes the sensor-to-LED distance. A crowned rib centred on the
// tunnel makes contact a line that just rolls +-R*theta = 0.3mm along the
// crown instead; the tunnel mouth itself stays within R*(1-cos theta) =
// 0.01mm of the surface at any interference in the fit window.
rib_r        = 4.0;
rib_land     = 0.05;   // see the rib code - keeps CGAL out of a cusp
part_overlap = 0.5;    // every sub-shape overlaps its neighbour by this
                       // much; edge-to-edge contact is what breaks CGAL

// ---- sensor pocket ----
// Bore sizing rationale is v1.0's and still correct: Vishay's headline
// "diameter 3" is only the dome TIP (3.0 +-0.1); the straight body
// shoulder that actually has to pass is 3.2 +-0.15, i.e. 3.35 worst case.
// Small FDM holes come out 0.1-0.3mm undersized, so a nominal 3.95 lands
// around 3.65-3.85 real - a clearance fit on 3.35 in every case. It is
// deliberately NOT a press fit: a press fit that prints tight cannot be
// fixed without a reamer, and this part has to work on the first print.
// Retention is a drop of glue at the open end instead - see RETAINING
// THE SENSOR below.
tept_body_d   = 3.35;   // worst-case body shoulder, 3.2 +-0.15
bore_d        = tept_body_d + 0.6;   // 3.95 nominal
bore_depth    = 4.5;
tunnel_len    = 3.0;   // collimator length, crown -> sensor face
tunnel_d      = 1.8;   // aperture at the sensor end
mouth_x       = 5.0;   // funnel mouth, along X - absorbs LED position error
mouth_y       = 3.0;   // funnel mouth, along Y
pod_wall      = 1.2;

boss_r   = bore_d/2 + pod_wall;      // 3.175, wall thickness around the bore
boss_len = tunnel_len + bore_depth;  // 7.5, measured from the rib crown

// WIRING: the bore is a plain through hole, open at its outer end, and the
// leads come straight out of it - the same single hole v1.1 used. An
// earlier draft of v1.2 added a pair of tie-off holes through a widened
// pedestal; that was more structure than the problem needs. The numbers:
// the clip is held by ~4N of friction at nominal fit, against a clip plus
// a 1m tail of thin wire that together weigh well under 10g. Wire weight
// was never going to move it. The only real risk is a snag yanking the
// solder joints, and the glue drop that retains the sensor already
// encapsulates the first few mm of lead, which handles that. Tie the tail
// to the camera's own USB cable a few cm down and the clip never carries
// a standing load at all.
//
// RETAINING THE SENSOR: the bore is a clearance fit on purpose (see above),
// so the TEPT4400 needs glue. It does not need a port to reach it through.
// The encapsulated body is ~7mm against a 4.5mm bore, so ~2.5mm of it
// stands proud of the block's outer face - glue the joint where it emerges.
// Thin CA wicks straight down the 0.15-0.40mm annulus and locks the whole
// length; a bead of hot glue over the leads does the same job and stays
// reworkable. An earlier draft drilled a second hole through the block for
// this, which bought nothing the open end of the bore did not already give.

// The boss is one block rather than a cylinder on a pedestal. In the
// recommended print orientation (model Y vertical - see PRINTING) a
// round boss is a horizontal cylinder whose lower half overhangs, so it
// needed a pedestal underneath anyway. Squaring it off and running it
// down to y_lo does the same job as one primitive: it stands on the bed,
// prints without support, and leaves a uniform wall around the bore.
boss_x = boss_r;              // half-width in X, either side of led_x
boss_y_hi = led_y + boss_r;   // top; the bottom is y_lo, i.e. the bed

// ---- preview options (never leave preview_on_camera on for export) ----
show_reference    = true;
preview_on_camera = false;  // true: draw the clip sprung open onto the real
                            // mesh surface, for checking lens FOV and dome
                            // clearance in the installed state.
                            // false (REQUIRED FOR EXPORT): relaxed shape.
                            // In the relaxed state the front jaw sits
                            // 1.69mm inside the reference mesh - that is the
                            // interference, not a collision.

// ============================================================
// derived
// ============================================================
x_near = led_x + near_margin;   // -21.5
x_far  = led_x - far_margin;    // -35.1
y_lo   = led_y - jaw_height/2;  // 24
y_hi   = led_y + jaw_height/2;  // 38

// front-jaw datum: the rib crown plane
fz = preview_on_camera ? front_z : back_z + inner_gap;

front_in  = fz + relief;              // relieved inner face
front_out = front_in + jaw_thick;
back_in   = back_z - relief;
back_out  = back_in - jaw_thick;

x_bridge_out = x_far - bridge_thick;
x_bridge_far = x_bridge_out - bridge_flare;

pod_z0 = fz + relief + 0.3;   // safely inside the front jaw plate
pod_z1 = fz + boss_len;       // outer end of the sensor bore

// ============================================================
// 2D profile in (X, Z), extruded along Y.
// The whole clip except the sensor pod is a constant section in Y, which
// is what makes the recommended print orientation work.
// ============================================================

// Material added back into a concave corner at (cx, cz), filling the
// quadrant that opens toward (sx, sz) in sign.
// The square is extended by part_overlap back into BOTH pieces it bridges:
// -sx in X (into the flexure wall) and -sz in Z (into the jaw plate).
// Without that overlap the fillet meets them along zero-area edges, which
// unions to a degenerate polygon that CGAL later rejects. Note the sign on
// the Z pair: extending the wrong way leaves a 0.5mm slot between the
// fillet and the jaw - a stress raiser at the single highest-stress point
// on the spring, and the exact opposite of what the fillet is for. Probe
// it with an intersection against a fillet_r cube at the corner: a correct
// fillet leaves (1 - pi/4) * fillet_r^2 * jaw_height = 12.0mm^3 there.
module inner_fillet(cx, cz, sx, sz) {
    translate([cx, cz])
        difference() {
            polygon([[-sx*part_overlap, -sz*part_overlap],
                     [ sx*fillet_r,      -sz*part_overlap],
                     [ sx*fillet_r,       sz*fillet_r],
                     [-sx*part_overlap,   sz*fillet_r]]);
            translate([sx*fillet_r, sz*fillet_r]) circle(r = fillet_r);
        }
}

module clip_profile() {
    difference() {
        union() {
            // bridge: full-height wall in the empty space past the pod tip,
            // waisted in the middle so the flex happens there and the ends
            // (where the moment is highest) are thicker
            polygon([
                [x_far,        back_out],
                [x_far,        front_out],
                [x_bridge_out, front_out],
                [x_bridge_far, front_out - bridge_flare_len],
                [x_bridge_far, back_out  + bridge_flare_len],
                [x_bridge_out, back_out],
            ]);

            // jaw plates
            polygon([[x_bridge_out, front_in],  [x_near, front_in],
                     [x_near, front_out],       [x_bridge_out, front_out]]);
            polygon([[x_bridge_out, back_in],   [x_near, back_in],
                     [x_near, back_out],        [x_bridge_out, back_out]]);

            // Crowned contact ribs, crest on the housing surface at led_x.
            // The circle is sunk rib_land past the crown and then trimmed
            // flat at the crown plane. Sitting it exactly tangent instead
            // looks equivalent but leaves a mathematical cusp, which CGAL
            // rejects as a non-closed mesh once anything is unioned to it -
            // and OpenSCAD's fast preview path renders it anyway, so the
            // part looks fine right up until the STL comes out empty.
            // The 1.3mm land it leaves is harmless: the jaw's ~4.5deg
            // working tilt only moves contact ~0.3mm along the crown.
            intersection() {
                translate([led_x, fz + rib_r - rib_land]) circle(r = rib_r);
                polygon([[x_bridge_out, fz], [x_near, fz],
                         [x_near, front_in + part_overlap],
                         [x_bridge_out, front_in + part_overlap]]);
            }
            intersection() {
                translate([led_x, back_z - rib_r + rib_land]) circle(r = rib_r);
                polygon([[x_bridge_out, back_z], [x_near, back_z],
                         [x_near, back_in - part_overlap],
                         [x_bridge_out, back_in - part_overlap]]);
            }

            // stress relief where the jaws root into the flexure
            inner_fillet(x_far, front_in,  1, -1);
            inner_fillet(x_far, back_in,   1,  1);
        }

        // Lead-in ramps: let the clip be pushed on rather than pried open.
        // Each cut runs well past the jaw into free space so it leaves a
        // real chamfer edge and not a zero-thickness sliver.
        // These also make the clip self-starting: the mouth measures
        // (front_in - back_in) + 2*ramp_h = 17.4 + 2.0 = 19.4mm at the very
        // tip, i.e. wider than the housing anywhere in the fit window, so it
        // hooks on by hand with no force and the ramps wedge it the rest of
        // the way. Nothing has to be pried open to install it.
        ramp_l = 2.0;
        ramp_h = 1.0;
        polygon([[x_near - ramp_l, front_in], [x_near + 1, front_in + ramp_h],
                 [x_near + 1, front_in - 4],  [x_near - ramp_l, front_in - 4]]);
        polygon([[x_near - ramp_l, back_in],  [x_near + 1, back_in - ramp_h],
                 [x_near + 1, back_in + 4],   [x_near - ramp_l, back_in + 4]]);
    }
}

module clip_body() {
    translate([0, y_hi, 0])
        rotate([90, 0, 0])
            linear_extrude(height = jaw_height, convexity = 10)
                clip_profile();
}

// ============================================================
// sensor pod
// ============================================================

// ============================================================

module end_clip() {
    difference() {
        union() {
            clip_body();
            // The pod starts inside the jaw's material rather than on the
            // rib crown plane: the crown is tangent to z=fz, and a face
            // landing exactly on that tangent line is a degenerate contact
            // that CGAL will not union.
            translate([led_x - boss_x, y_lo, pod_z0])
                cube([2*boss_x, boss_y_hi - y_lo, pod_z1 - pod_z0]);
        }

        // Optical path: a rectangular funnel, wide slot against the
        // housing narrowing to the collimated aperture at the sensor.
        // One tapered extrusion rather than a hull() of two thin plates -
        // identical geometry, one CSG primitive instead of three, which
        // keeps the F5 preview's depth-peeling budget down (see PREVIEW).
        translate([led_x, led_y, fz - 0.8])
            linear_extrude(height = tunnel_len + 0.8, convexity = 4,
                           scale = [tunnel_d/mouth_x, tunnel_d/mouth_y])
                square([mouth_x, mouth_y], center = true);
        // sensor bore, open at the outer end, self-supporting roof
        translate([led_x, led_y, fz + tunnel_len])
            linear_extrude(height = bore_depth + 1, convexity = 4)
                hull() {
                    circle(d = bore_d);
                    translate([0, bore_d * 0.62]) circle(d = 0.4);
                }
    }
}

end_clip();

if (show_reference)
    %import("reference/brio100-camera-head.stl");

// ============================================================
// PREVIEW (F5) vs RENDER (F6)
// ------------------------------------------------------------
// F6/CGAL is the authority; F5 is a z-buffer approximation and will lie
// to you about this part if you let it. Two things were needed to make
// the two agree, and both are worth keeping if you edit the geometry:
//
//  - convexity on every linear_extrude. The clip profile is a deep C: a
//    ray can enter and leave its surface several times, and OpenCSG's
//    depth-peeling only budgets for what convexity declares (default 1).
//    Under-declare it and F5 renders a see-through slit along the jaw/
//    flexure corner - a corner which F6 shows as completely solid. The
//    slit moves as you orbit, which is the tell that it is a rendering
//    artifact and not geometry.
//
//  - real volumetric overlap between every sub-shape (part_overlap).
//    Shapes that meet along an edge or a tangent point union to
//    degenerate polygons. CGAL either rejects those outright or, worse,
//    silently drops the geometry from the STL while the preview still
//    looks correct.
//
// But do not assume every corner complaint is the renderer. The fillets
// here were genuinely 0.5mm short of the jaw for exactly one sign error,
// which F5 and F6 both drew as a plausible-looking corner. Measure it:
//
//   intersection() {
//       end_clip();
//       translate([x_far, y_lo, front_in - fillet_r])
//           cube([fillet_r, jaw_height, fillet_r]);
//   }
//
// Export that and check its volume. A correct quarter-round fillet leaves
// (1 - pi/4) * fillet_r^2 * jaw_height = 12.0mm^3 in that cube. The
// broken version left 4.4.
//
// ============================================================
// PRINTING
// ------------------------------------------------------------
// ORIENTATION MATTERS MORE THAN MATERIAL HERE. Print with the model's Y
// axis vertical, i.e. lay the C-shape flat on the bed as a 17 x 27mm
// footprint and build 14mm upward. Then:
//   - the whole flexure is one constant cross-section - no supports, no
//     bridging anywhere on the spring;
//   - bending stress in the bridge and jaws runs along the extrusion
//     paths, inside layers, instead of across layer boundaries.
// The other obvious orientation (bore pointing up) puts the bridge's
// tensile bending stress normal to the layers, where PLA has roughly half
// its strength and creeps at the interfaces - that is how a spring like
// this fails months later.
// Suggested: 4 perimeters (the bridge is 1.5mm - it should be near-solid
// perimeter), 40%+ infill, brim for the thin first-layer outline.
// Material: PLA is fine and is the stiffest common option. PETG works but
// creeps more under sustained load - if you use it, expect to re-seat the
// clip occasionally. Avoid anything flexible.
//
// PRINT A SET, NOT A PART
// ------------------------------------------------------------
// At 1.40zl a part against a 50zl minimum you are paying for ~35 parts
// whatever you do. Spend some of that on removing the two remaining
// unknowns instead of hoping:
//
//   for g in 15.8 16.2 16.6 17.0; do
//     openscad -D inner_gap=$g -D show_reference=false \
//              -o clip-gap-$g.stl brio105-sensor-clip-v1.2.scad
//   done
//   for lx in -22.6 -24.1 -25.6; do
//     openscad -D led_x=$lx -D show_reference=false \
//              -o clip-led$lx.stl brio105-sensor-clip-v1.2.scad
//   done
//
// 16.2 is the design point and should be the one that works. The gap
// variants cover the housing-thickness question; the led_x variants cover
// the LED-position question if the 5mm funnel mouth somehow misses. Send
// all of them, plus a couple of spares of the nominal, in the one order.
// ============================================================
