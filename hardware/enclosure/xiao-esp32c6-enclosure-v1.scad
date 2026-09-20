// ============================================================
// XIAO ESP32-C6 ENCLOSURE v2
// Desk unit for the Brio 105 LED-sensor project: holds a bare
// XIAO ESP32-C6, one 10k load resistor for the TEPT4400, and the
// junction where the sensor cable is soldered on.
//
// Free-standing on the desk. USB-C permanently plugged for power.
// Onboard ceramic antenna, with a U.FL port moulded as a break-out
// membrane for later. Snap-together, no glue, opens with a spudger.
//
// WHAT IS MEASURED AND WHAT IS NOT
// --------------------------------
// Seeed publishes the footprint and nothing else, and their own two
// sources disagree about it:
//   wiki.seeedstudio.com               "21 x 17.8mm"
//   XIAO ESP32-C6 datasheet PDF, p.2   "Dimensions: 21 x 17.5 mm"
// Neither gives PCB thickness, component heights, USB-C connector size
// or overhang, or LED and button positions. So this is built NOT to
// depend on them:
//   - The board sits on four standoff pads and is located by ribs, not
//     by a close-fitting pocket, so 17.5 vs 17.8 is absorbed by
//     clearance rather than deciding whether it goes in.
//   - The USB opening is 10.5 x 4.6 against a plug nose of about
//     8.34 x 2.56, so it swallows ~1mm of error in where the connector
//     actually sits in either axis.
//   - The LED is a light BAR, not a light pipe, so it does not have to
//     line up with an LED whose position nobody publishes.
//   - The U.FL port is a membrane in the wall, not a hole aligned to a
//     connector, because a pigtail is flexible.
// Only pcb_t genuinely has to be right, because the lid's hold-down
// posts are derived from it. It and the other three CHECK values are
// at the top.
//
// SNAP DESIGN
// -----------
// Four cantilever tongues hang from the lid, run the full internal
// depth beside the board, and hook outward into grooves in the long
// walls. Peak bending strain in a straight cantilever snap is
//     eps = 1.5 * t * d / L^2
// with t the arm thickness, d the deflection and L the free length.
// Here t=0.9, d = hook_d + 0.1 = 0.65, L = 7.85 (the arm stops 0.5mm
// short of the floor so it stays a free cantilever):
//     eps = 1.5 * 0.9 * 0.65 / 61.6 = 1.4%
// The model echoes both on every render - watch it if you change the
// wall, floor or plug clearances, because they all move L.
// PLA yields around 2.5-3% strain, so there is real margin and the box
// can be opened repeatedly rather than once. That margin is the entire
// reason the arms run the full depth: at half the length the same hook
// would be at 6% and would break off on first assembly. It is also why
// the box is ~2.8mm wider than the board needs. The arms have to live
// somewhere, and beside the board is the only place they get their
// length for free. The alternative - two arms in the component bay and
// two fixed tabs at the USB end, assembled by tilting the lid in - is
// narrower but turns a straight push-together into a knack, which is a
// bad trade on a part that has to work first time.
//
// OPENING IT
// ----------
// Pry notch in the rim at the cable end. Get a fingernail or a plastic
// spudger under the lid edge and lever; the hooks have a 45 degree
// release ramp on the engaging face so they cam out rather than
// resisting until something breaks.
//
// PRINTING
// --------
// Tray open side up, lid top face down. Neither needs support. The cable
// slot is a notch open to the rim; the USB opening is a closed rounded
// hole whose top edge bridges 13.5mm, which needs no support either.
// Every hook underside is 45 degrees.
// The light bar's 0.5mm skin is the lid's first layer.
// PETG preferred over PLA for the snap arms - tougher and much less
// notch sensitive. PLA works at this strain but is the less forgiving
// choice if you over-flex one.
// Set part="both" for a single plate.
// ============================================================

part = "both";   // "tray" | "lid" | "both"
$fn  = 64;

// Reference board, generated from Seeed's own KiCad PCB file. Drawn as a
// %-transparent preview only - it is never part of the exported geometry,
// so leaving it on costs nothing. Same idea as show_reference on the
// camera clip, and on by default for the same reason.
// include, not use: this brings in the landmark coordinates as well as
// the modules, so the case is positioned off the real part locations
// rather than off guesses.
include <xiao-esp32c6-board.scad>
show_board = true;

// ---- board: now measured, not guessed ----
// Taken from Seeed's KiCad PCB file rather than from either of their two
// disagreeing spec pages (wiki said 17.8, the datasheet said 17.5). The
// Edge.Cuts layer says 20.955 x 17.780 and the stackup says 1.6mm.
pcb_x      = pcb_len;    // 20.955, Edge.Cuts
pcb_y      = pcb_wid;    // 17.780 - so the wiki was right, the datasheet wrong
pcb_t      = pcb_thick;  // 1.600, board stackup
comp_h     = 3.4;     // USB-C shell, the only part over 1.2mm
usb_ctr_h  = 1.65;    // CHECK: the one number still not in the design files

// Seeed call the board "single-sided mounting", so the underside is
// flat and the standoff only has to clear solder witness.
// Clearance can come down now the outline is known to 3 decimal places;
// what is left is print tolerance and PCB routing tolerance, not
// uncertainty about which spec page to believe.
pcb_clear    = 0.3;
pcb_standoff = 0.8;

// ---- USB-C opening ----
// Sized for the plug's metal NOSE, not for the cable's moulded body.
// USB-C is specified so that the overmould seats against a panel in
// front of a recessed receptacle: the Type-C Cable and Connector
// Specification puts the limit at "a maximum of 6.5 mm" from the
// receptacle mating datum to the surface the overmould seats against,
// "to allow the shortest allowed plug shell to seat against the mating
// datum". Here that distance is wall + usb_gap = 3.3mm, so the plug
// still seats fully with over 3mm to spare - the model echoes the
// figure on every render so it stays honest if you change the wall.
//
// The receptacle's contact opening is 8.34 x 2.56mm and the plug shell
// is about the same outside, so 10.5 x 4.6 clears it with roughly +-1mm
// of slack in both axes. That slack is deliberate: usb_ctr_h is a CHECK
// value, and this is the tolerance that absorbs being wrong about it.
//
// If you would rather the moulded body entered the box - a very chunky
// or angled plug, say - set these to about 13.5 x 7.0 instead. That
// works too, it is just a much larger hole in the end face.
usb_port_w = 10.5;
usb_port_h = 4.6;
usb_r      = 1.5;    // corner radius - a port, not a hacked slot
usb_flare  = 0.6;    // 45 deg chamfered mouth so the plug self-centres
usb_top    = 1.6;    // wall left above the opening - also the bridge

// The receptacle OVERHANGS the board edge. From Seeed's PCB file its
// courtyard runs X 15.15..22.55 against a board edge at 20.955, and its
// depth (7.40) matches the 7.35mm body, so the courtyard is drawn on the
// body and the overhang is 1.60mm. This is why the board cannot simply be
// pushed up to the wall: the apparent gap in the render is not empty, it
// is where the connector lives.
usb_overhang = 1.60;

// So instead the nose is allowed to enter the port opening. The opening is
// 10.5 x 4.6 and the body is 8.94 x 3.26, so it passes through with ~0.8mm
// to spare all round. The only thing that then blocks assembly is the
// solid wall ABOVE the opening, which the nose would hit on the way down -
// hence the drop-in relief: the opening's inner half carried up to the rim
// so the board can be lowered straight in.
usb_relief_d = 0.9;  // pocket depth, leaves 0.9mm of the 1.8mm wall

// ---- sensor cable, 2 x 0.20 ----
// Sized for two 0.20mm2 conductors. 0.20mm2 is 0.50mm of bare copper,
// which in thin PVC hookup wire comes out around 1.0-1.4mm outside
// diameter, so the pair lying side by side is roughly 2.6 x 1.3mm.
// An earlier draft used 3.6 x 2.2 - 2.3x the cable's area, and worse, the
// pinch gap is derived as cable_h - cable_grip, so 2.2 gave a 1.65mm gap
// around a 1.3mm cable: the strain relief gripped nothing whatsoever.
// Both the slot and the pinch follow these two numbers, so if your cable
// is different (a jacketed round twin is nearer 2.6mm across), measure it
// and set cable_h to the real height - the grip corrects itself.
cable_w    = 2.8;    // across the pair
cable_h    = 1.5;
cable_grip = 0.55;   // squeeze: pinch gap = cable_h - cable_grip = 0.95mm
cable_rib_w = 1.4;   // ridge/rib width along X - narrow, the bay is short

// ---- shell ----
wall     = 1.8;
floor_t  = 1.4;
lid_t    = 1.4;
corner_c = 3.0;      // 45 deg cut on the four vertical corners
edge_c   = 0.8;      // chamfer along the top and bottom rims
gap      = 0.15;

// ---- snap ----
tongue_t = 0.9;
tongue_w = 5.0;
hook_d   = 0.55;
hook_h   = 1.3;
arm_free = 0.35;     // clearance inboard of a relaxed arm

// ---- bay / features ----
// Component bay at the cable end, shortened by 5mm from the 9.0 an
// earlier draft used. At floor level the end stop and the cable ridge now
// take almost all of it, but the bay is 4.5mm tall above the end stop and
// that is where the resistor actually goes - a 10k load for a
// phototransistor passes microamps, so an 1/8W part (3.5 x 1.8mm) is
// ample and a 1/4W (6.5 x 2.4mm) still fits lying across the width.
// The strain-relief ridge and rib are narrowed to suit.
bay_len        = 4.0;
rib_w          = 1.2;   // board locating ribs
// Light window over the USER LED. Its position is no longer a guess:
// D4 (yellow, GPIO15) is at board (16.540, 14.700) in Seeed's PCB file,
// which lands at case (8.02, 7.78). The window is deliberately NOT put
// over CHG1 as well - that one only reports charging, and with no
// battery fitted it is noise.
// The window is a blind pocket from the INSIDE, leaving lightbar_floor
// of skin on the outside. That is why you cannot see a hole: closed, it
// is a flush unbroken surface, and it only shows when the LED is lit.
// Set lightbar_floor = 0 if you would rather have an open hole.
lightbar_w     = 3.0;   // along X
lightbar_len   = 2.6;   // along Y
lightbar_floor = 0.5;   // outer skin; set 0 for an open slot

ant_port_w     = 5.0;   // along Y on the end wall
ant_port_h     = 3.5;
ant_memb       = 0.5;
pry_w          = 7.0;
pry_d          = 1.4;

// ============================================================
// derived
// ============================================================
pcb_pocket_x = pcb_x + 2*pcb_clear;
pcb_pocket_y = pcb_y + 2*pcb_clear;

// Lane down each long wall for a snap arm, then the locating rib, then
// the board. Getting this stack-up wrong is how the arms end up inside
// the ribs.
lane   = gap + tongue_t + arm_free;          // wall face -> rib face
usb_gap = 0.6;                               // PCB end face -> inner wall

in_x = usb_gap + pcb_pocket_x + bay_len;

// SQUARE FOOTPRINT.
// What the board and the arm lanes actually need across the width is
// in_y_min; the length is set by the board plus the component bay and
// comes out larger. Squaring it up therefore means growing the width, not
// trimming the length - taking 2.6mm off X would mean a 1.4mm component
// bay, which is no bay at all. The extra width lands in the arm lanes as
// clearance and the board stays centred.
// Written as a max() so it stays square by construction: change bay_len
// or usb_gap and the width follows.
in_y_min = 2*(lane + rib_w) + pcb_pocket_y;
in_y = max(in_y_min, in_x);
out_x = in_x + 2*wall;
out_y = in_y + 2*wall;

pcb_z0 = floor_t + pcb_standoff;
pcb_z1 = pcb_z0 + pcb_t;
usb_ctr_z = pcb_z1 + usb_ctr_h;

rim_z = max(usb_ctr_z + usb_port_h/2 + usb_top, pcb_z1 + comp_h + 1.4);
out_z = rim_z + lid_t;

pcb_x0 = wall + usb_gap;
pcb_y0 = wall + (in_y - pcb_pocket_y)/2;   // board centred in the width

// The arm hangs free: it must not touch the tray floor, or it becomes a
// fixed-fixed beam and the strain calculation above stops being true.
tongue_bot = floor_t + 0.5;
tongue_len = rim_z - tongue_bot;
// Hook profile up the arm: 45 deg lead-in, flat land, 45 deg release.
// The release ramp is what lets the lid be prised off instead of having
// to be broken off - a square top face would retain far harder but only
// come apart one way.
hook_z0 = tongue_bot + hook_d;              // bottom of the flat land
hook_z1 = hook_z0 + hook_h;                 // top of the flat land
tongue_x   = [wall + in_x*0.20, wall + in_x*0.62];

// Board frame -> case frame. The board goes in USB-first, which is a
// 180 degree turn about Z, so both axes reverse.
function b2c_x(kx) = pcb_x0 + pcb_clear + pcb_x - kx;
function b2c_y(ky) = pcb_y0 + pcb_clear + pcb_y - ky;

// ---- board hold-down ----
// The first draft pressed the board with four rigid 4x4 posts near its
// corners. Checked against the real part positions that was wrong in two
// ways at once: the posts crushed ten components including BOTH LEDs, and
// being rigid they turned the floor/standoff/board/post/lid tolerance
// stack into a hard stop - 0.2mm of print error and the lid will not
// close far enough for the snaps to engage.
//
// Both are fixed by pressing on the board's edges with a sprung bar, as
// you suggested. Rasterising the part positions with a 0.35mm keep-out
// shows a clear 2mm-wide lane down each long edge - x 3.0..18.5 on one
// side and 0..18.5 on the other - and nothing usable at either end
// (USB1's envelope blocks one, ANT1 and ANT2 the other). So the bars run
// down the long edges, which is the only place they fit anyway.
//
// Each bar is carried on two legs and spans between them, so it is a
// simply-supported beam rather than a column:
//     k = 48EI/L^3,  I = b*t^3/12 = 2.0*1.0^3/12 = 0.167 mm^4
//     k = 48*2000*0.167/13^3 = 7.3 N/mm
// At the nominal 0.15mm interference that is ~1.1N per bar, and it still
// only asks ~3.3N of the snaps if the print comes out 0.3mm long. A rigid
// post at the same 0.3mm error asks the snaps for infinity.
hold_t      = 1.0;    // bar thickness, sets the spring rate
hold_w      = 1.6;    // bar width across the board edge
hold_press  = 0.15;   // interference on the board top
hold_x0_b   = 4.0;    // leg positions, board frame
hold_x1_b   = 17.0;
hold_lane_b = [16.55, 1.25];  // bar centreline on each edge, board frame

// Every feature hanging off the lid is grown this far UP into the plate.
// Stopping them exactly on the plate's underside looks identical on
// screen but is a zero-overlap coincident-plane contact: CGAL leaves the
// snap arms as separate solids and the STL exports a lid plus loose
// sticks. Check with Volumes in the render log - a good lid is 2 (the
// solid plus the outside), not 12.
feat_merge = 0.4;

cable_y0    = out_y/2 - cable_w/2;
// U.FL port, on the bay end wall clear of the cable slot and pry notch,
// and on the ANT2 side of the box
ant_port_y  = out_y - wall - corner_c - ant_port_w - 0.5;
cable_pinch = floor_t + 1.6;                 // top of the tray ridge
in_corner   = max(corner_c - wall, 0.8);

echo(str("outer ", out_x, " x ", out_y, " x ", out_z, " mm"));

// Distance from the outer face to the connector's mating datum, which is
// what the USB-C spec's 6.5mm limit actually applies to - not the distance
// to the board edge, which an earlier version echoed by mistake.
echo(str("USB port recess ", wall + usb_gap + pcb_clear - usb_overhang,
         " mm  (spec allows 6.5 max)"));
echo(str("connector nose enters the wall by ",
         usb_overhang - usb_gap - pcb_clear, " mm, relief is ",
         usb_relief_d, " mm deep"));
echo(str("snap arm L=", tongue_len,
         "  strain=", 1.5*tongue_t*(hook_d+0.1)/(tongue_len*tongue_len)*100, "%"));

// ============================================================
// shell
// ============================================================
module cut_corner_rect(sx, sy, c) {
    polygon([[c,0],[sx-c,0],[sx,c],[sx,sy-c],
             [sx-c,sy],[c,sy],[0,sy-c],[0,c]]);
}

// One body for the whole outside, cut into tray and lid afterwards, so
// their outer faces cannot disagree at the parting line.
module shell_solid() {
    hull() {
        translate([0,0,edge_c])
            linear_extrude(out_z - 2*edge_c, convexity = 6)
                cut_corner_rect(out_x, out_y, corner_c);
        translate([edge_c, edge_c, 0])
            linear_extrude(0.01, convexity = 6)
                cut_corner_rect(out_x - 2*edge_c, out_y - 2*edge_c, corner_c);
        translate([edge_c, edge_c, out_z - 0.01])
            linear_extrude(0.01, convexity = 6)
                cut_corner_rect(out_x - 2*edge_c, out_y - 2*edge_c, corner_c);
    }
}

// The USB void, used twice: subtracted from the tray, and intersected
// with the shell to make the lid's lintel. Defining it once is what keeps
// the two halves of the opening the same shape.
module usb_profile(w, h, r) {
    hull()
        for (sy = [-1, 1], sz = [-1, 1])
            translate([sz*(h/2 - r), sy*(w/2 - r)]) circle(r = r);
}

module usb_void() {
    // straight bore through the wall
    translate([-1, out_y/2, usb_ctr_z])
        rotate([0, 90, 0])
            linear_extrude(wall + 1.01, convexity = 4)
                usb_profile(usb_port_w, usb_port_h, usb_r);
    // chamfered mouth: a taper rather than the stepped rebate an earlier
    // draft used, which read as a second, larger hole around the first
    translate([0, out_y/2, usb_ctr_z])
        rotate([0, 90, 0])
            linear_extrude(usb_flare, convexity = 4,
                           scale = [usb_port_h/(usb_port_h + 2*usb_flare),
                                    usb_port_w/(usb_port_w + 2*usb_flare)])
                usb_profile(usb_port_w + 2*usb_flare,
                            usb_port_h + 2*usb_flare, usb_r + usb_flare);
}

module cavity_solid() {
    translate([wall, wall, floor_t])
        linear_extrude(out_z, convexity = 6)
            cut_corner_rect(in_x, in_y, in_corner);
}

// ============================================================
// tray
// ============================================================
module tray() {
    difference() {
        union() {
            difference() {
                intersection() {
                    shell_solid();
                    translate([-1,-1,-1]) cube([out_x+2, out_y+2, rim_z+1]);
                }
                cavity_solid();
            }

            // Standoff rails directly under the hold-down bars, so the
            // board is pinched edge-to-edge and never bent. The
            // underside is flat - every part is on the front - so a rail
            // anywhere under the board is safe.
            for (lane = hold_lane_b)
                translate([b2c_x(hold_x1_b) - 1, b2c_y(lane) - hold_w/2 - 0.5,
                           floor_t])
                    cube([hold_x1_b - hold_x0_b + 2, hold_w + 1.0,
                          pcb_standoff]);

            // locating ribs down both long edges. They set where the
            // board sits without gripping it, so 17.5 and 17.8 both drop
            // straight in.
            for (s = [0,1])
                translate([pcb_x0, pcb_y0 - rib_w + s*(pcb_pocket_y + rib_w),
                           floor_t])
                    cube([pcb_pocket_x, rib_w, pcb_standoff + pcb_t + 1.0]);

            // end stop at the bay end. The USB end is deliberately left
            // open so the connector may overhang the board edge.
            translate([pcb_x0 + pcb_pocket_x, pcb_y0 - rib_w, floor_t])
                cube([rib_w, pcb_pocket_y + 2*rib_w,
                      pcb_standoff + pcb_t + 1.0]);

            // cable strain relief: ridge the lid rib pinches against,
            // narrowed and pushed against the wall to free bay length
            translate([out_x - wall - cable_rib_w, cable_y0 - 1.5, floor_t])
                cube([cable_rib_w, cable_w + 3.0, cable_pinch - floor_t]);
        }

        // USB-C opening. Rounding it closed the hole, so unlike the
        // cable slot it no longer runs out to the rim and the top edge
        // is a 13.5mm bridge when the tray prints open side up. That is
        // routine, and a rounded top bridges better than a square one
        // because it starts narrow and widens onto supported material.
        usb_void();

        // Sensor cable slot. Rounded like the USB port rather than a bare
        // rectangle - it reads as a deliberate exit, and a rounded top
        // bridges better on a tray printed open side up.
        translate([out_x - wall - 0.01, out_y/2, cable_pinch + cable_h/2])
            rotate([0, 90, 0])
                linear_extrude(wall + 1.02, convexity = 4)
                    hull()
                        for (sy = [-1, 1])
                            translate([0, sy*(cable_w - cable_h)/2])
                                circle(d = cable_h);

        // Drop-in relief: the port opening's inner half carried up to
        // the rim, so the overhanging connector nose can be lowered past
        // the wall instead of colliding with it on the way down. Without
        // this the board simply cannot be fitted - the nose clears the
        // wall in its seated position but not above it.
        translate([wall - usb_relief_d, out_y/2 - usb_port_w/2,
                   usb_ctr_z + usb_port_h/2 - 0.4])
            cube([usb_relief_d + 0.01, usb_port_w,
                  rim_z - usb_ctr_z - usb_port_h/2 + 0.5]);

        // Snap grooves in both long walls. Height is set from the hook's
        // flat land plus 0.15mm, so the lid is pulled down onto the rim
        // rather than floating with the hooks rattling in oversize slots.
        // Depth leaves 1.0mm of the 1.8mm wall standing.
        // The groove has to swallow the WHOLE trapezoid, ramps included,
        // not just the flat land - otherwise the hook is still pressed
        // against the wall when the lid is home, the arm never relaxes,
        // and it sits permanently pre-stressed.
        gz0 = tongue_bot - 0.2;
        gz1 = tongue_bot + 2*hook_d + hook_h + 0.15;
        for (x = tongue_x) {
            translate([x - 0.5, out_y - wall - 0.01, gz0])
                cube([tongue_w + 1.0, hook_d + 0.26, gz1 - gz0]);
            translate([x - 0.5, wall - hook_d - 0.25, gz0])
                cube([tongue_w + 1.0, hook_d + 0.26, gz1 - gz0]);
        }

        // U.FL port, blanked: a blind pocket from inside leaving an outer
        // membrane you cut through if you ever fit a pigtail. Moved to the
        // bay END wall: on the long wall it now overlaps a snap groove,
        // which would leave 0.5mm of wall carrying a hook. Here it is also
        // as close as it gets to ANT2 itself, and both cables leave the
        // same face.
        translate([out_x - wall - 0.01, ant_port_y, floor_t + 1.2])
            cube([wall - ant_memb + 0.01, ant_port_w, ant_port_h]);

        // pry notch under the lid edge
        translate([out_x - wall/2, out_y/2, rim_z])
            scale([1, pry_w/pry_d, 1])
                rotate([0, 90, 0])
                    cylinder(d = pry_d, h = wall + 2, center = true);
    }
}

// ============================================================
// lid
// ============================================================
module snap_tongue(x, y_face, sign) {
    // y_face is the arm's outboard face; sign points at the wall.
    yb = (sign > 0) ? y_face - tongue_t : y_face;
    translate([x, yb, tongue_bot]) {
        // tongue_len is the FREE length the strain figure is based on;
        // the extra feat_merge is buried in the plate above it
        cube([tongue_w, tongue_t, tongue_len + feat_merge]);
        // hook, as one trapezoid in the (y,z) plane extruded along x:
        // lead-in, land, release. Both sloped faces are 45 deg, so the
        // arm prints with no overhang whichever way up the lid goes.
        translate([0, (sign > 0) ? tongue_t : 0, 0])
            rotate([90, 0, 90])
                linear_extrude(tongue_w)
                    polygon([[0, 0],
                             [sign*hook_d, hook_d],
                             [sign*hook_d, hook_d + hook_h],
                             [0, 2*hook_d + hook_h]]);
    }
}

module lid_body() {
    difference() {
        union() {
            intersection() {
                shell_solid();
                translate([-1,-1,rim_z]) cube([out_x+2, out_y+2, lid_t+1]);
            }

            // Locating lips at the two short ends only. The long sides are
            // where the arms live, and a lip there would stiffen their
            // roots and wreck the strain budget.
            // The USB end is split into two segments clear of the plug:
            // a full-width lip there sits exactly where the overmould has
            // to pass between the wall and the connector.
            lip_z = rim_z - 1.4;
            usb_lo = out_y/2 - usb_port_w/2 - 0.6;
            usb_hi = out_y/2 + usb_port_w/2 + 0.6;
            translate([wall + gap, wall + gap + 2, lip_z])
                cube([1.0, usb_lo - wall - gap - 2, 1.4 + feat_merge]);
            translate([wall + gap, usb_hi, lip_z])
                cube([1.0, in_y + wall - gap - 2 - usb_hi, 1.4 + feat_merge]);
            translate([wall + in_x - gap - 1.0, wall + gap + 2, lip_z])
                cube([1.0, in_y - 2*gap - 4, 1.4 + feat_merge]);

            // snap arms
            for (x = tongue_x) {
                snap_tongue(x, out_y - wall - gap, +1);
                snap_tongue(x, wall + gap,         -1);
            }

            // Hold-down posts directly over the four standoff pads, so the
            // board is pinched at its corners and never bent. They land
            // 0.1mm clear of the nominal board top: if pcb_t is set right
            // the board cannot rattle, and if it is set a little large the
            // lid still closes.
            for (lane = hold_lane_b) {
                yb = b2c_y(lane) - hold_w/2;
                xa = b2c_x(hold_x1_b);
                xb = b2c_x(hold_x0_b);
                // the sprung bar itself
                translate([xa, yb, pcb_z1 - hold_press])
                    cube([xb - xa, hold_w, hold_t]);
                // and the two legs carrying it up to the lid
                for (lx = [xa, xb - 1.6])
                    translate([lx, yb, pcb_z1 - hold_press + hold_t])
                        cube([1.6, hold_w,
                              rim_z - pcb_z1 + hold_press - hold_t + feat_merge]);
            }

            // cable pinch rib
            translate([out_x - wall - cable_rib_w, cable_y0 - 1.5,
                       cable_pinch + cable_h - cable_grip])
                cube([cable_rib_w, cable_w + 3.0,
                      rim_z - cable_pinch - cable_h + cable_grip + feat_merge]);
        }

        // Light bar. A window, not a pipe: nobody publishes where the
        // C6's LEDs are, and a 3mm bar across the lid will sit over them
        // wherever they turn out to be. The 0.5mm outer skin glows
        // clearly in plain PLA - print it as the first layer.
        translate([b2c_x(led_user_xy[0]) - lightbar_w/2,
                   b2c_y(led_user_xy[1]) - lightbar_len/2,
                   rim_z - 0.01])
            cube([lightbar_w, lightbar_len, lid_t - lightbar_floor + 0.01]);
    }
}

// ============================================================
if (show_board)
    %translate([pcb_x0 + pcb_clear + pcb_x, pcb_y0 + pcb_clear + pcb_y, pcb_z0])
        rotate([0, 0, 180]) xiao_board();

if (part == "tray" || part == "both") tray();
if (part == "lid"  || part == "both")
    translate([part == "both" ? out_x + 6 : 0, 0, 0]) lid_body();
