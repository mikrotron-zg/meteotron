/* Solar panel frame
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */

// should be in the same directory
include <mini_solar_common.scad>;

// panel dimensions, in order [width, height, width, height, ...]
panel_dimensions = [131, 151, 111, 70, 91, 61];

// select panel type: 0 - big, 1 - medium, 2 - small
panel_type = 0;

// geometry
wall = 2.4;
panel_w = panel_dimensions[panel_type*2];
panel_l = panel_dimensions[panel_type*2 + 1];
panel_h = 2;
panel_distance = 0.1;
frame_w = 10;
frame_h = 2;
frame_overlap = 2;
full_width = panel_w + 2*panel_distance + 2*frame_w;
full_length = panel_l + 2*panel_distance + 2*frame_w;
corner_radius = 5;
top_height = panel_h + frame_h;
grip_width = 0.8;
bottom_height = 2;
power_cutout_w = 40;
power_cutout_l = 50;
power_cutout_h = 7;
bracket_distance = 105; // center to center!

// entry point    
mini_solar_panel_frame();

module mini_solar_panel_frame() {
    // comment out parts if not needed
    color("Aqua") top_part();
    color("Orange") translate([0, full_length + 5, 0]) bottom_part();
    //color("Purple") translate([full_width + 20, 0, 0]) gasket(); // maybe not needed
}

//********************* Bottom part of frame ****************************************

module bottom_part() {
    // all the bottom frame parts
    difference() {
        rounded_rect(full_width, full_length, bottom_height, corner_radius);
        translate([full_width/2, full_length/2, bottom_height/2 - ex])
            cube([power_cutout_l - 2*wall, power_cutout_w - 2*wall, bottom_height + 3*ex], 
                    center = true);
        translate([0, 0, -m3_screw_head_h]) corner_screw_holes();
    }
    // M3 nut traps
    translate([0, 0, bottom_height]) corner_screw_holes(false);
    // power lead inlet
    translate([full_width/2 - power_cutout_l/2, full_length/2 - power_cutout_w/2, bottom_height]) 
        power_inlet();
    // brackets
    translate([full_width/2 - bracket_distance/2, full_length/2, bottom_height]) 
        bracket();
    translate([full_width/2 + bracket_distance/2, full_length/2, bottom_height]) 
        bracket();
}

module power_inlet() {
    // need to let the wires out
    inlet_h = 5;
    inlet_w = 8;
    difference() {
        cube([power_cutout_l, power_cutout_w, inlet_h + wall]);
        translate([wall, wall, -ex])
            cube([power_cutout_l - 2*wall, power_cutout_w - 2*wall, inlet_h + ex]);
        translate([power_cutout_l/2, wall/2, 0])
            cube([inlet_w, 2*wall, 2*inlet_h], center = true);
    }
}

//********************* Top part of frame ****************************************

module top_part() {
    // all the main top frame parts
    union() {
        difference() {
            frame_outer_width = frame_w + panel_distance + frame_overlap;
            rounded_rect(full_width, full_length, top_height, corner_radius);
            translate([frame_outer_width, frame_outer_width, -ex])
                cube([full_width - 2*frame_outer_width, full_length - 2*frame_outer_width, frame_h + 2*ex]);
            translate([frame_w, frame_w, frame_h])
                cube([full_width - 2*frame_w, full_length - 2*frame_w, panel_h + ex]);
            corner_screw_holes();   
        }
        translate([-grip_width, -grip_width, 0]) grip();
    }
}

module grip() {
    // top part should grip the bottom part to make it more compact
    width = full_width + 2*grip_width;
    length = full_length + 2*grip_width;
    height = top_height + bottom_height + 2;
    r = corner_radius + grip_width;
    ledge_width = 0.4;
    difference() {
        rounded_rect(width,  length, height , r);
        translate([grip_width, grip_width, -ex])
            rounded_rect(full_width, full_length, top_height + bottom_height + 0.2 , corner_radius);
        translate([grip_width + ledge_width, grip_width + ledge_width, -ex])
            rounded_rect(full_width - 2*ledge_width, full_length - 2*ledge_width, height + 2*ex , corner_radius - ledge_width);
        translate([grip_width, grip_width, top_height + bottom_height]) {
            // M3 nut traps
            corner_screw_holes(false);
        }
    }
}

module corner_screw_holes(screw = true) {
    // four corner srew holes or nut traps (see m3_screw comment)
    translate([frame_w/2, frame_w/2, -ex]) m3_screw(screw);
    translate([full_width - frame_w/2, frame_w/2, -ex]) m3_screw(screw);
    translate([full_width - frame_w/2, full_length - frame_w/2, -ex]) m3_screw(screw);
    translate([frame_w/2, full_length - frame_w/2, -ex]) m3_screw(screw);
}

module m3_screw(screw = true) {
    // draws screw if true, nut trap if false
    if (screw) {
        m3_flathead_screw();
    } else {
        // M3 nut trap 
        difference() {
            cylinder(d = frame_w, h = 2);
            translate([0, 0, -ex]) cylinder(r = m3_nut_radius, h = 2.1 + 2*ex, $fn = 6);
        }
    }
}

//****************************** Optional ****************************************

module gasket() {
    // might be needed to stop the water to get behind the panel - use flex filament
    thickness = 0.5;
    width = 1.5*frame_w;
    difference() {
        rounded_rect(full_width, full_length, thickness, corner_radius);
        translate([width, width, -ex])
            cube([full_width - 2*width, full_length - 2*width, thickness + 2*ex]);
        translate([0, 0, -frame_h]) corner_screw_holes();
    }
}