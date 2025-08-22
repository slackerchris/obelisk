// SIMPLE WORKING DICE TOWER + INITIATIVE TRACKER
// Basic, guaranteed-to-work design

// Basic dimensions
TOWER_HEIGHT = 120;
BASE_SIZE = 40;
BASE_HEIGHT = 15;
DICE_PATH = 30;  // Internal diameter for dice

$fn = 24; // Low resolution for fast preview

module simple_base() {
    difference() {
        // Simple rectangular base
        cube([50, 40, BASE_HEIGHT], center=true);
        
        // Storage cavity
        translate([0, -8, 2])
            cube([44, 20, BASE_HEIGHT], center=true);
    }
}

module simple_tower() {
    difference() {
        // Simple tapered tower - NO HULL, just basic shapes
        translate([0, 0, 0])
            linear_extrude(height=TOWER_HEIGHT, scale=0.7)
                square([BASE_SIZE, BASE_SIZE], center=true);
        
        // Simple cylindrical dice path
        translate([0, 0, -1])
            cylinder(h=TOWER_HEIGHT + 2, r=DICE_PATH/2);
        
        // Simple exit hole
        translate([0, BASE_SIZE/2, 15])
            cube([20, 10, 10], center=true);
        
        // Initiative number cuts - SIMPLE
        for (i = [1:4]) {
            translate([BASE_SIZE/2 - 1, 0, 15 + i*20])
                rotate([90, 0, 0])
                    linear_extrude(height=2)
                        text(str(i), size=4, halign="center");
        }
    }
}

module simple_dice_tray() {
    translate([0, 25, 0]) {
        difference() {
            cube([25, 12, 8], center=true);
            cube([22, 9, 6], center=true);
        }
    }
}

module simple_baffle(z, angle) {
    translate([0, 0, z]) {
        rotate([0, 0, angle]) {
            translate([8, 0, 0])
                cube([6, 12, 1.5], center=true);
        }
    }
}

// MAIN ASSEMBLY - KEEP IT SIMPLE
difference() {
    union() {
        // Base
        translate([0, 0, BASE_HEIGHT/2])
            simple_base();
        
        // Tower
        translate([0, 0, BASE_HEIGHT])
            simple_tower();
        
        // Dice tray
        translate([0, 0, BASE_HEIGHT/2])
            simple_dice_tray();
    }
    
    // Subtract baffles from the whole thing
    translate([0, 0, BASE_HEIGHT]) {
        for (i = [0:3]) {
            simple_baffle(20 + i*20, i*60);
        }
    }
}

// Simple initiative plaques
for (i = [0:2]) {
    translate([-25, 0, BASE_HEIGHT + 20 + i*20]) {
        difference() {
            cube([6, 15, 6], center=true);
            cube([4, 13, 4], center=true);
        }
    }
}
