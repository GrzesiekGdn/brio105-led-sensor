// ============================================================
// XIAO ESP32-C6 REFERENCE BOARD MODEL
//
// NOT a downloaded mesh. Seeed only publish their 3D model via GrabCAD,
// which needs a login, so this is generated directly from their own
// KiCad design files instead:
//   XIAO_ESP32_C6_v1.0_SCH&PCB_260114.zip -> "XIAO ESP32 C6.kicad_pcb"
//   (linked from wiki.seeedstudio.com/xiao_esp32c6_getting_started)
// For fitting a case that is better than a mesh: it gives the
// authoritative position of every part, so clearances can be checked by
// intersection instead of by eye.
//
// EXACT, straight out of the PCB file:
//   - outline 20.955 x 17.780mm (Edge.Cuts) - so Seeed's wiki figure of
//     17.8 is right and their datasheet's 17.5 is wrong
//   - thickness 1.6mm (board stackup)
//   - X, Y, rotation and pad/courtyard footprint of all 81 parts
//   - every part is on the front. The underside really is flat, which is
//     what lets the tray sit the board on an 0.8mm standoff.
// INFERRED:
//   - part HEIGHTS. KiCad stores no Z. Taken from footprint names that
//     state one (ANT2P-5.2x2x1.1MM -> 1.1) and from package convention
//     otherwise (0402 -> 0.5, QFN -> 0.9, USB-C -> 3.26). Treat Z as
//     indicative and X/Y as measured.
//   - XY extents are the pad + courtyard + fab envelope, so for most
//     parts they are slightly larger than the plastic body. That is the
//     useful direction to err.
//   - USB1 is the exception and is hand-set from its COURTYARD, X
//     15.15..22.55 by Y 4.29..13.49. That courtyard is 7.40 deep against
//     a 7.35mm body, i.e. drawn on the body with no margin, so it is the
//     honest outline. Note what it means: the front face sits at 22.55
//     against a board edge at 20.955, so the receptacle OVERHANGS the
//     board by 1.60mm. Any case that pushes the board up to the wall has
//     to make room for that. Its F.Fab outline is not used - that is the
//     plug keepout, floating 1.2mm off the board edge.
//
// FRAME: origin at the board corner, X 0..20.955 with the USB-C end at
// HIGH X, Y 0..17.780, Z 0 at the underside.
// ============================================================

pcb_len   = 20.955;
pcb_wid   = 17.780;
pcb_thick = 1.600;
pcb_r     = 1.905;   // corner radius, from the four Edge.Cuts arcs:
                     // e.g. start(-10.414,-6.985) mid(-9.856,-8.332)
                     // end(-8.509,-8.89), centre (-8.509,-6.985)

// OPTIONAL REAL MESH
// ------------------
// Seeed's own 3D model exists but is not machine-downloadable: GrabCAD
// and Marathon-OS want a login and Printables returns 403 to anything but
// a browser. If you fetch one yourself, drop the file next to this one and
// put its name here - it is then used instead of the generated body, in
// the same frame. Nothing else needs to change.
//   https://www.printables.com/model/1338408-3d-model-for-seeed-studio-xiao-esp32c6  (Seeed's own)
//   https://grabcad.com/library/seeed-studio-xiao-esp32-c6-1
// A mesh will look better; it will not be more accurate about where the
// parts are, because this file's XY data IS the manufacturer's PCB file.
board_mesh = "";     // e.g. "xiao-esp32c6.stl"
mesh_rot   = [0,0,0];
mesh_off   = [0,0,0];

// Landmarks a case has to care about, board frame.
led_user_xy   = [16.540, 14.700];  // D4, yellow, GPIO15 - the useful one
led_charge_xy = [16.540,  3.020];  // CHG1, red, charge only
ufl_xy        = [ 1.406,  4.594];  // ANT2, U.FL external antenna
antenna_xy    = [ 1.153, 12.014];  // ANT1, onboard ceramic
usb_xy        = [15.148,  8.894];  // USB1, centred on the board width
usb_h         = 3.26;

// [ref, x0, y0, sx, sy, sz]  - x0,y0 is the low corner
parts = [
  ["ANT1", 0.153, 8.314, 2.000, 7.400, 1.10],
  ["ANT2", 0.126, 2.905, 3.121, 3.378, 1.00],
  ["C1", 6.450, 4.610, 0.813, 1.727, 0.50],
  ["C10", 9.304, 5.660, 0.305, 0.827, 0.30],
  ["C11", 10.874, 7.762, 0.305, 0.827, 0.30],
  ["C12", 8.458, 7.953, 0.305, 0.827, 0.30],
  ["C13", 4.680, 12.990, 0.813, 1.727, 0.50],
  ["C14", 4.882, 11.935, 0.789, 0.317, 0.30],
  ["C15", 4.872, 11.405, 0.789, 0.317, 0.30],
  ["C16", 4.994, 10.330, 0.305, 0.827, 0.30],
  ["C17", 4.882, 12.465, 0.789, 0.317, 0.30],
  ["C18", 4.282, 7.965, 0.789, 0.317, 0.30],
  ["C19", 7.084, 6.650, 0.305, 0.827, 0.30],
  ["C2", 9.962, 4.085, 0.789, 0.317, 0.30],
  ["C20", 11.937, 11.917, 0.789, 0.317, 0.30],
  ["C21", 12.802, 4.655, 0.789, 0.317, 0.30],
  ["C22", 12.822, 13.395, 0.789, 0.317, 0.30],
  ["C23", 4.434, 3.970, 0.305, 0.827, 0.30],
  ["C24", 4.492, 5.475, 0.789, 0.317, 0.30],
  ["C25", 6.544, 7.630, 0.305, 0.827, 0.30],
  ["C27", 1.004, 6.720, 0.305, 0.827, 0.30],
  ["C28", 2.484, 6.710, 0.305, 0.827, 0.30],
  ["C4", 5.153, 3.273, 1.727, 0.813, 0.50],
  ["C5", 7.214, 7.953, 0.305, 0.827, 0.30],
  ["C6", 11.692, 8.380, 0.789, 0.317, 0.30],
  ["C7", 11.692, 9.030, 0.789, 0.317, 0.30],
  ["C8", 12.303, 6.949, 0.305, 0.827, 0.30],
  ["C9", 11.812, 4.605, 0.789, 0.317, 0.30],
  ["CHG1", 15.665, 2.569, 1.775, 0.905, 0.50],
  ["D1", 10.957, 3.070, 0.762, 1.437, 0.60],
  ["D2", 12.837, 5.305, 0.762, 1.524, 0.50],
  ["D3", 11.363, 6.347, 0.762, 1.437, 0.60],
  ["D4", 15.665, 14.253, 1.775, 0.905, 0.50],
  ["K1", 19.072, 0.758, 1.600, 3.100, 0.53],
  ["K2", 19.072, 13.915, 1.600, 3.100, 0.53],
  ["L1", 7.115, 3.184, 2.743, 1.219, 0.85],
  ["L2", 5.494, 10.331, 0.305, 0.827, 0.30],
  ["L3", 4.984, 4.471, 0.305, 0.827, 0.30],
  ["L4", 5.452, 8.085, 0.789, 0.317, 0.30],
  ["L5", 1.502, 7.235, 0.789, 0.317, 0.30],
  ["Q1", 11.927, 3.332, 0.600, 1.000, 0.35],
  ["Q2", 10.050, 5.107, 1.075, 0.600, 0.35],
  ["Q3", 4.626, 8.524, 0.600, 1.000, 0.35],
  ["R1", 7.604, 6.651, 0.305, 0.827, 0.30],
  ["R10", 10.812, 4.605, 0.789, 0.317, 0.30],
  ["R11", 12.792, 3.125, 0.789, 0.317, 0.30],
  ["R12", 8.474, 6.822, 0.305, 0.827, 0.30],
  ["R13", 11.842, 14.405, 0.789, 0.317, 0.30],
  ["R14", 11.937, 11.409, 0.789, 0.317, 0.30],
  ["R15", 12.022, 9.910, 0.789, 0.317, 0.30],
  ["R16", 12.812, 4.135, 0.789, 0.317, 0.30],
  ["R17", 12.822, 13.905, 0.789, 0.317, 0.30],
  ["R18", 11.937, 12.435, 0.789, 0.317, 0.30],
  ["R19", 9.832, 5.835, 0.789, 0.317, 0.30],
  ["R20", 12.812, 3.635, 0.789, 0.317, 0.30],
  ["R21", 4.542, 9.735, 0.789, 0.317, 0.30],
  ["R22", 4.074, 9.301, 0.305, 0.827, 0.30],
  ["R23", 6.064, 6.651, 0.305, 0.827, 0.30],
  ["R24", 6.574, 6.651, 0.305, 0.827, 0.30],
  ["R25", 12.823, 14.415, 0.789, 0.317, 0.30],
  ["R3", 13.134, 9.981, 0.305, 0.827, 0.30],
  ["R6", 12.823, 7.001, 0.789, 0.317, 0.30],
  ["R7", 12.672, 8.380, 0.789, 0.317, 0.30],
  ["R8", 12.697, 9.030, 0.789, 0.317, 0.30],
  ["R9", 9.822, 4.605, 0.789, 0.317, 0.30],
  ["TP1", 10.925, 9.492, 1.143, 1.143, 0.60],
  ["TP10", 3.870, 9.141, 2.032, 1.016, 0.60],
  ["TP2", 10.868, 7.045, 1.143, 1.143, 0.60],
  ["TP3", 15.948, 9.585, 1.143, 1.143, 0.60],
  ["TP4", 13.408, 7.045, 1.143, 1.143, 0.60],
  ["TP5", 18.488, 7.045, 1.143, 1.143, 0.60],
  ["TP6", 13.408, 9.585, 1.143, 1.143, 0.60],
  ["TP7", 18.488, 9.585, 1.143, 1.143, 0.60],
  ["TP8", 15.948, 7.045, 1.143, 1.143, 0.60],
  ["TP9", 3.870, 6.601, 2.032, 1.016, 0.60],
  ["U1", 7.986, 4.994, 0.800, 1.200, 0.40],
  ["U3", 11.424, 5.135, 1.200, 0.900, 0.40],
  ["U4", 6.051, 9.021, 5.600, 5.600, 0.90],
  ["U5", 4.251, 6.030, 1.591, 1.669, 0.45],
  ["USB1", 15.150, 4.290, 7.400, 9.200, 3.26],  // see note - overhangs the edge
  ["X1", 9.078, 6.766, 1.550, 1.650, 1.20],
];

function part_named(n) = [for (p = parts) if (p[0] == n) p][0];

module xiao_parts() {
    for (p = parts)
        color(p[0] == "USB1" ? "#b0b0b0" : p[0] == "D4"   ? "#ffc400" :
              p[0] == "CHG1" ? "#d32f2f" : p[0] == "ANT2" ? "#90a4ae" :
              p[0] == "ANT1" ? "#5d4037" : "#37474f")
            translate([p[1], p[2], pcb_thick]) cube([p[3], p[4], p[5]]);
}

// True board outline: a rounded rectangle, not the plain cube an earlier
// version drew. The corners are radiused 1.905mm, so a square outline
// over-reports the board by up to 0.56mm at each corner.
module xiao_outline() {
    hull()
        for (sx = [0,1], sy = [0,1])
            translate([pcb_r + sx*(pcb_len - 2*pcb_r),
                       pcb_r + sy*(pcb_wid - 2*pcb_r)])
                circle(r = pcb_r);
}

module xiao_board(show_parts = true) {
    if (board_mesh != "") {
        translate(mesh_off) rotate(mesh_rot) import(board_mesh);
    } else {
        color("#1b5e20") linear_extrude(pcb_thick, convexity = 4)
            xiao_outline();
        if (show_parts) xiao_parts();
    }
}
