/* Simple arm which connects panel frame,
 * electronics box and pole mount
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */

// should be in the same directory
include <mini_solar_common.scad>;

// geometry
holder_length_panel = 80;
holder_length_mount = 100;
holder_angle = 60;
radius = bracket_length/2;

// this is just one holder, the other one shuld be added in slicer using 'mirror' option
mini_solar_panel_holder();

module mini_solar_panel_holder() {
    translate([-radius, -radius, 0]) arm(holder_length_mount, false);
    rotate(holder_angle) translate([-radius, -radius, 0]) arm();
}

module arm(length = holder_length_panel, nut_trap = true) {
    difference() {
        rounded_rect(length, bracket_length, bracket_width*2, radius - ex);
        translate([length - radius, bracket_length/2, -ex])
            cylinder(d = m5_dia, h = bracket_width*2 + 2*ex);
        if (nut_trap) {
        translate([length - radius, bracket_length/2, bracket_width]) 
                cylinder(r = m5_nut_radius, h = bracket_width + 2*ex, $fn = 6);
        }
    }
}