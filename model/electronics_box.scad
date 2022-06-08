/* Electronics box (except for BME sensor,
 * we need it outside)
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */

// should be in the same directory
include <mini_solar_common.scad>;

// geometry
pcb_height = 1.6;
component_offset = 7.5;

// battery dimensions
bat_length = 62;
bat_width = 38;
bat_height = 9;

// charger dimensions
chrg_length = 40.5;
chrg_width = 20.5;
chrg_height = 8;

// feather dimensions
fthr_length = 50.8;
fthr_width = 23.0;
fthr_height = 7.2;
fthr_mnt_hole_dia = 2.54;
fthr_standoff_height = 5;

// box dimensions
box_length = bat_length + fthr_width + 3*component_offset;
box_width = chrg_width + bat_width + 3*component_offset;
box_height = fthr_height + 2*fthr_standoff_height + 5;
box_wall = 2.4;
bracket_distance = 95; // center to center!
corner_screw_offset = 6;

// entry point
mini_solar_box();

module mini_solar_box() {
    // comment out part if not needed
    color("Orange") box_top();
    translate([0, box_width*1.25, 0]) box_bottom();
}

module box_top() {
    // top part of the box
    difference() {
        translate([box_wall/2, box_wall/2, 0]) {
            rounded_rect(box_length - box_wall, box_width - box_wall, box_wall, box_wall/2);
        }
        // add corner screw holes
        translate([0, 0, box_wall + ex]) corner_screw_holes();
    }
    // add brackets
    translate([box_length/2 - bracket_distance/2, box_width/2, box_wall]) bracket();
    translate([box_length/2 + bracket_distance/2, box_width/2, box_wall]) bracket();
}

module corner_screw_holes(screw = true) {
    off = corner_screw_offset;
    translate([off, off, -ex]) m3_screw(screw);
    translate([box_length - off, off, -ex]) m3_screw(screw);
    translate([box_length - off, box_width - off, -ex]) m3_screw(screw);
    translate([off, box_width - off, -ex]) m3_screw(screw);
}

module corner() {
    radius = corner_screw_offset + 2.5;
    height = box_height - 2*box_wall;
    insert_height = height - 5;
    difference() {
        cylinder_quarter(r = radius, h = height);
        translate([corner_screw_offset - box_wall, corner_screw_offset - box_wall, insert_height]) 
            rotate(45) m3_screw(false);
        translate([radius/2 + 0.5, radius/2 + 0.5, insert_height]) 
            rotate(45) m3_screw(false);
    }
}

module corners() {
    translate([box_wall, box_wall, box_wall])  corner();
    translate([box_wall, box_width - box_wall, box_wall]) rotate(-90) corner();
    translate([box_length - box_wall, box_width - box_wall, box_wall]) rotate(180) corner();
    translate([box_length - box_wall, box_wall, box_wall]) rotate(90) corner();
}

module box_bottom() {
    // bottom part of the box
    difference() {
        rounded_rect(box_length, box_width, box_height, box_wall);
        translate([box_wall/2, box_wall/2, box_height - box_wall])
            rounded_rect(box_length - box_wall, box_width - box_wall, box_wall + 2*ex, box_wall/2);
        translate([box_wall, box_wall, box_wall])
            rounded_rect(box_length - 2*box_wall, box_width - 2*box_wall, box_height - box_wall, box_wall/2);
        // add power inlet
        translate([0.6*box_length, -ex, box_height/2])
            cube([inlet_width, box_wall + 2*ex, inlet_height]);
        // add-on mounts
        translate([bat_length + 2*component_offset, 4*component_offset, -ex]) bme680_mount(true);
    }
    // add corner screw mounts
    difference() {
        corners();
        translate([0, 0, box_height]) corner_screw_holes();
    }
    // components placement
    translate([0,0, box_wall]) {
        translate([component_offset + 1, chrg_width + 2*component_offset - 1, 0]) {
            battery_mount();
            %battery();    
        }
        translate([component_offset + bat_length/2 - chrg_length/2, component_offset, 0]) {
            translate([-box_wall/2, -box_wall/2, 0]) 
                charger_mount(chrg_length, chrg_width, 3);
            translate([0, 0, pcb_height]) %charger();
        }
        translate([bat_length + fthr_width + 2*component_offset, 2*component_offset, 0]) 
            rotate(90) {
                fthr_mount();
                translate([0, 0, fthr_standoff_height]) %feather();
            }
    }
    // add-on mounts
    translate([bat_length + 2*component_offset, 4*component_offset, box_wall]) bme680_mount();
}

//********************************* Component mounts *********************************************

module charger_mount(length, width, height) {
    // solar charger mount
    difference() {
        cube([length + box_wall, width + box_wall, height]);
        translate([box_wall/2, box_wall/2, height - pcb_height])
            cube([length, width, height + 2*ex]);
        translate([box_wall, box_wall, -ex])
            cube([length - box_wall, width - box_wall, height]);
        translate([-ex, width/2 - box_wall, 0])
            cube([length + 2*box_wall + 2*ex, 2*box_wall, height + ex]);
    }
    // hooks
    translate([length/4, 0, height]) hook();
    translate([3*length/4, 0, height]) hook();
    translate([length/4, width + box_wall, height]) rotate(180) hook();
    translate([3*length/4, width + box_wall, height]) rotate(180) hook();
}

module hook() {
    translate([-1, 0, 0]) cube([2, box_wall/2 + 0.4, box_wall/2]);
}

module fthr_mount() {
    // Adafruit Feather board mount
    translate([fthr_mnt_hole_dia, fthr_mnt_hole_dia, 0]) fthr_standoff();
    translate([fthr_mnt_hole_dia, fthr_width - fthr_mnt_hole_dia, 0]) fthr_standoff();
    ledge = 5;
    translate([fthr_length - ledge, -box_wall, 0]) difference() {
        cube([ledge + box_wall , fthr_width + 2*box_wall, fthr_standoff_height + 2*pcb_height]);
        translate([0, box_wall, fthr_standoff_height])
            cube([ledge, fthr_width, 1.5*pcb_height]);
        translate([0, box_wall + 1, fthr_standoff_height + 1.5*pcb_height])
            cube([ledge, fthr_width - 2, pcb_height]);
    }
}

module fthr_standoff() {
    difference() {
        screw_dia = m25_dia - 0.25; // m25_dia is for holes, we need this to be tight!
        cylinder(d1 = fthr_mnt_hole_dia + 6, d2 = fthr_mnt_hole_dia + 2, h = fthr_standoff_height);
        cylinder(d = screw_dia, h = fthr_standoff_height + ex);
    }
}

module battery_mount() {
    // lipo battery mount
    translate([bat_length/2, 0, 0]) rotate(90) battery_mount_clip(bat_length/2);
    translate([bat_length/2, bat_width, 0]) rotate(-90) battery_mount_clip(bat_length/2);
    translate([0, bat_width/2, 0]) battery_mount_clip();
    translate([bat_length, bat_width/2, 0]) rotate(180) battery_mount_clip();
}

module battery_mount_clip(clip_length = 3*box_wall) {
    clip_extension = 2;
    clip_xy = [[0, 0], [-clip_extension, clip_extension], 
                [-clip_extension, bat_height - clip_extension], [0, bat_height]];
    translate([-box_wall, clip_length/2, 0]) rotate([90, 0, 0]) {
        difference() {
            cube([box_wall + clip_extension, bat_height, clip_length]);
            translate([box_wall + clip_extension + ex, 0, -ex])
                linear_extrude(height = clip_length + 2*ex) polygon(clip_xy);
        }
        translate([box_wall, bat_height, 0]) {
            cylinder_quarter(r = box_wall, h = clip_length);
            rotate(90) cylinder_quarter(r = box_wall, h = clip_length);
        }
    }
}

//************************************* Add-on mounts *********************************************

module bme680_mount(nut_trap = false) {
    // BME680 box mount
    bme_length = 27.5;
    bme_width = 16.5;
    bme_mthole_offset = 2.9;
    translate([bme_width - bme_mthole_offset, bme_mthole_offset, 0]) bme680_nut_trap(nut_trap);
    translate([bme_mthole_offset, bme_length - bme_mthole_offset, 0]) bme680_nut_trap(nut_trap);
}

module bme680_nut_trap(full = false) {
    if (full) {
        cylinder(d = m25_dia, h = 2);
        translate([0, 0, 2]) cylinder(r = m25_nut_radius, h = 2.5 + ex, $fn = 6);
    } else {
        difference() {
            cylinder(d = 7.5, h = 2.5);
            cylinder(r = m25_nut_radius, h = 2.5 + ex, $fn = 6);
        }
    }
}

//************************************* Components mock up ****************************************

module battery() {
    cube([bat_length, bat_width, bat_height]);
}

module charger() {
    cube([chrg_length, chrg_width, pcb_height]);
}

module feather() {
    cube([fthr_length, fthr_width, pcb_height]);
}

//**************************************** Common modules ******************************************

module m3_screw(screw = true) {
    if (screw) {
        rotate([180, 0, 0]) m3_flathead_screw();
    } else {
        // M3 nut trap 
        cylinder(r = m3_nut_radius, h = 2.5, $fn = 6);
    }
}
