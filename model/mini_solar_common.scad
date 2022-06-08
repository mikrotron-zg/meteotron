/* Common module used by other *.scad files
 * by Mikrotron d.o.o. 2022
 * see the project root for license
 */

// Dimensions of screws used in this project
m25_dia = 2.75; // used for holes, so we need them to be bigger
m25_nut_radius = nut2radius(5);
m3_dia = 3.4; // used for holes, so we need them to be bigger
m3_screw_head_h = 2;
m3_nut_radius = nut2radius(5.5);
m5_dia = 5.3; // used for holes, so we need them to be bigger
m5_nut_radius = nut2radius(8);

// Bracket dimensions
bracket_width = 5;
bracket_length = 15;

// Wire inlet dimensions
inlet_width = 8;
inlet_height = 5;

// Other common variables
$fn = 200; // needed for smoother curved surfaces
ex = 0.001; // needed for cleaner preview

//********************* Common parts ************************************************

module rounded_rect(x, y, z, radius = 1) {
    // Draws a rounded rectangle
    translate([radius,radius,0]) //move origin to outer limits
	linear_extrude(height=z)
		minkowski() {
			square([x-2*radius,y-2*radius]); //keep outer dimensions given by x and y
			circle(r = radius, $fn=200);
		}
}

module cylinder_quarter(r, h){
    // Draws quarter of a cylinder
    difference(){
        cylinder(r=r, h=h);
        translate ([-r-ex, -r-ex, -ex]) cube([2*r + 2*ex, r + ex, h + 2*ex]);
        translate ([-r-ex, -ex, -ex]) cube([r + ex, r + ex, h + 2*ex]);
    }
}

module m3_flathead_screw() {
    // Draws flathead M3x10 screw
    cylinder(d1 = 5.8, d2 = m3_dia, h = m3_screw_head_h);
    translate([0, 0, m3_screw_head_h]) cylinder(d = m3_dia, h = 10 - m3_screw_head_h);
}

module bracket(width = bracket_width, length = bracket_length) {
    // Draws mounting bracket
    $fn = 200;
    difference() {
        union() {
            translate([-width/2, 0, length/2]) rotate([0, 90, 0])
                cylinder(d = length, h = width);
            translate([-width/2, -length/2, 0])
                cube([width, length, length/2]);
        }
        translate([-width/2-ex, 0, length/2]) rotate([0, 90, 0]) 
            cylinder(d = m5_dia, h = width + 2*ex);
    }
    // Add reinforcements
    translate([-width/2, length/2, 0]) reinforcement_radius(width);
    translate([width/2, -length/2, 0]) rotate(180) reinforcement_radius(width);
}

module reinforcement_radius(width) {
    // Needed for mounting bracket
    translate([0, width, width]) rotate([0, 90, 0]) difference() {
        translate([0, - width, 0]) cube([width, width, width]);
        translate([0, 0, -ex]) cylinder(d = width*2, h = width + 2*ex);
    }
}

//********************* Small parts ************************************************

module inlet_plug(small = true) {
    // Should be printed in TPU
    rim = 1;
    wall = 2.75;
    gap = 0.5;
    difference() {
        union() {
            cube([inlet_width + rim, inlet_height + rim, rim]);
            translate([rim/2, rim/2, rim]) cube([inlet_width, inlet_height, wall]);
        }
        translate([inlet_width/2 - gap/2 + rim/2, -ex, -ex]) 
            cube([gap, inlet_height/2, wall + 2*rim + 2*ex]);
        if (small) {
        translate([inlet_width/4 + rim/2, inlet_height/3 + rim/2, -ex]) 
            cube([inlet_width/2, inlet_height/3, wall + 2*rim + 2*ex]);
        } else {
        translate([inlet_width/6 + rim/2, inlet_height/4 + rim/2, -ex]) 
            cube([2*inlet_width/3, inlet_height/2, wall + 2*rim + 2*ex]);
        }
    }
}

// Uncomment to generate inlet plug
//inlet_plug();  // small opening
//inlet_plug(false);  // big opening

module distancer(wall = 2.4, height = 1) {
    difference() {
        cylinder(d = m25_dia + 2*wall, h = height);
        translate([0, 0, -ex]) cylinder(d = m25_dia, h = height + 2*ex);
    }
}

// Uncomment to generate
//distancer();

//********************* Functions ************************************************

// Calculates nut radius from metric nut size (wrench size)
function nut2radius(m) = m/2/cos(180/6);