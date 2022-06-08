/* Box for BME680 sensor module by e-radionica
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */

// should be in the same directory
include <mini_solar_common.scad>

// geometry
bme_length = 27.5;
bme_width = 16.5;
bme_pcb_height = 1.6;
bme_mthole_dia = 3.2;
bme_mthole_offset = 2.9;
wall_offset = 7;
box_wall = 2.4;
box_length = bme_length + 4*wall_offset;
box_width = bme_width + 2*wall_offset;
box_height = 16;
box_mh_offset = 4;
corner_radius = wall_offset + 2.8;
mh = mount_holes();
standoff_h = 3;

// entry point
bme680_box();

module bme680_box() {
    bme680_box_bottom();
    // translate([-box_wall, -box_wall, 0]) #bme680_box_top(); // used for construction
    translate([0, 2.25*box_width, box_height]) rotate([180, 0, 0]) bme680_box_top();
}

module bme680_box_top() {
    // top part of the box
    top_length = box_length + 2*box_wall;
    top_width = box_width + 2*box_wall;
    corner_height = box_height - 2*box_wall - standoff_h - 2*bme_pcb_height;
    difference() {
        union() {
            difference() {
                // body
                cube([top_length, top_width, box_height]);
                translate([box_wall, box_wall, -ex]) 
                    cube([box_length, box_width, box_height - box_wall + ex]);
                // vent grid
                translate([top_length/4, top_width/4, box_height - box_wall - ex]) {
                    for (i = [0 : top_length/20 : top_length/2]) {
                        translate([i, 0, 0]) cube([0.75, top_width/2, box_wall + 2*ex]);
                    }
                }
                // wire inlet
                translate([top_length - box_wall - ex, top_width/2 - inlet_width/2, box_wall]) 
                    cube([box_wall + 2*ex, inlet_width, inlet_height]);
            }
            // corners
            translate([box_wall, box_wall, box_height - box_wall - corner_height]) 
                cylinder_quarter(corner_radius, corner_height);
            translate([top_length - box_wall, top_width - box_wall, box_height - box_wall - corner_height]) 
                rotate(180) cylinder_quarter(corner_radius, corner_height);
        }
        // corner screw holes
        translate([box_wall + box_mh_offset, box_wall + box_mh_offset, box_height + ex]) 
            rotate([0, 180, 0]) m3_flathead_screw();
        translate([top_length - box_wall - box_mh_offset, top_width -box_wall - box_mh_offset, box_height + ex]) 
            rotate([0, 180, 0]) m3_flathead_screw();
    }
}

module bme680_box_bottom() {
    // bottom part of the box
    translate([wall_offset, wall_offset, box_wall + standoff_h]) %bme680();
    difference() {
        // body
        union() {
            cube([box_length, box_width, box_wall]);
            translate([0, 0, box_wall]) cylinder_quarter(corner_radius, standoff_h + 2*bme_pcb_height);
            translate([box_length, box_width, box_wall]) 
                rotate(180) cylinder_quarter(corner_radius, standoff_h + 2*bme_pcb_height);
            standoffs();
        }
        // holes for M2.5 screws
        translate([wall_offset, wall_offset, -ex]) {
            translate(mh[1]) cylinder(d = m25_dia, h = box_wall + standoff_h + 2*ex);
            translate(mh[3]) cylinder(d = m25_dia, h = box_wall + standoff_h + 2*ex);
        }
        // bottom nut traps
        translate([box_mh_offset, box_mh_offset, -ex]) nut_trap();
        translate([box_length - box_mh_offset, box_width - box_mh_offset, -ex]) nut_trap();
    }
}

module nut_trap() {
    // M3 nut trap
    cylinder(r = m3_nut_radius, h = 6, $fn = 6); 
    cylinder(d = m3_dia, h = box_wall + standoff_h + 2*bme_pcb_height + 2*ex);
}

module standoffs() {
    // BME680 standoffs
    translate([wall_offset, wall_offset, box_wall]) {
        for(mh = mount_holes()) translate(mh) cylinder(d1 = 8, d2 = 6, h = standoff_h);
        translate([0, 0, standoff_h]) {
            translate(mh[0]) cylinder(d = 2.75, h = 2*bme_pcb_height);
            translate(mh[2]) cylinder(d = 2.75, h = 2*bme_pcb_height);
        }
    }
}

//*************************** BME680 sensor module mockup *******************************

module bme680() {
    difference() {
        cube([bme_length, bme_width, bme_pcb_height]);
        for(mh = mount_holes()) translate(mh) bme_mthole();
    }
    translate([0, bme_width/2, bme_pcb_height]) rotate(-90) bme_connector();
    translate([bme_length, bme_width/2, bme_pcb_height]) rotate(90) bme_connector();
}

module bme_connector() {
    translate([-2.5, 0, 0]) cube([5, 4, 3.1]);
}

module bme_mthole() {
    cylinder(d = bme_mthole_dia, h = bme_pcb_height + 2*ex);
}

function mount_holes() =  [[bme_mthole_offset, bme_mthole_offset, -ex], 
                        [bme_length - bme_mthole_offset, bme_mthole_offset, -ex], 
                        [bme_length - bme_mthole_offset, bme_width - bme_mthole_offset, -ex], 
                        [bme_mthole_offset, bme_width - bme_mthole_offset, -ex]];