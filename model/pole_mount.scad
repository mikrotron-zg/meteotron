/* Simple pole mount for solar panel frame
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */

// should be in the same directory
include <mini_solar_common.scad>

// geometry
pole_dia = 85; // pole diameter, change if needed
mount_width = 5;
mount_height = 20;
mount_part_gap = 2;
panel_mount_gap = 70;  // TODO should be calculated
panel_mount_width = 10;
panel_mount_length = 35;
mount_offset = 7.5;
m5_nut_height = 5;
$fn = 400;

// entry point
pole_mount();

module pole_mount() {
    // everything all together at once
    difference() {
        mount_body();
        translate([0, 0, -ex]) cylinder(d = pole_dia, h = mount_height + 2*ex);
        translate([-panel_mount_gap/2 + panel_mount_width, - pole_dia/3 - panel_mount_length, -ex])
                cube([mount_part_gap, pole_dia/2, mount_height + 2*ex]);
        translate([panel_mount_gap/2 - panel_mount_width - mount_part_gap, 
                    - pole_dia/3 - panel_mount_length, -ex])
                cube([mount_part_gap, pole_dia/2, mount_height + 2*ex]);
        translate([-pole_dia/2, -pole_dia/2 - mount_offset, mount_height/2]) rotate([0, 90, 0]) 
            cylinder(d = m5_dia, h = pole_dia);
        translate([-panel_mount_gap/2 + 2*panel_mount_width + mount_part_gap - m5_nut_height, 
            -pole_dia/2 - mount_offset, mount_height/2]) rotate([0, 90, 0])
                cylinder(r = m5_nut_radius, h = bracket_width + 2*ex, $fn = 6);
        translate([panel_mount_gap/2 - 2*panel_mount_width - mount_part_gap + m5_nut_height, 
            -pole_dia/2 - mount_offset, mount_height/2]) rotate([0, -90, 0])
                cylinder(r = m5_nut_radius, h = bracket_width + 2*ex, $fn = 6);
    }
}

module mount_body() {
    // main part to cut out from
    cylinder(d = pole_dia + mount_width, h = mount_height);
    translate([-panel_mount_gap/2, -circle_y(panel_mount_gap/2, pole_dia/2) -panel_mount_length, 0])
        mounting_bracket();
    translate([panel_mount_gap/2 -2*panel_mount_width - mount_part_gap, 
                -circle_y(panel_mount_gap/2, pole_dia/2) -panel_mount_length, 0])
        mounting_bracket();
}

module mounting_bracket() {
    rounded_rect(2*panel_mount_width + mount_part_gap, panel_mount_length, mount_height, 2);
}

// simple circle arithmetics
function circle_y(x, r) = sqrt(r*r - x*x);

