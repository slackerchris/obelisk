// Modular Fantasy Obelisk System
// Highly customizable version with separate modules

// =============================================================================
// CONFIGURATION PARAMETERS
// =============================================================================

// Main structure
OBELISK_HEIGHT = 120;
OBELISK_BASE_WIDTH = 20;
OBELISK_TOP_WIDTH = 12;
BASE_HEIGHT = 15;
BASE_WIDTH = 35;
BASE_DEPTH = 25;

// Plaques
PLAQUE_COUNT = 5;
PLAQUE_WIDTH = 8;
PLAQUE_HEIGHT = 8;
PLAQUE_DEPTH = 1.5;
PLAQUE_SPACING = 12;

// Visual settings
$fn = 50;
ENABLE_RUNES = true;
ENABLE_CRYSTAL = true;
ENABLE_PLATFORM = true;

// Colors
COLOR_OBELISK = [0.35, 0.35, 0.4];
COLOR_BASE = [0.25, 0.25, 0.3];
COLOR_PLAQUES = [0.45, 0.4, 0.35];
COLOR_CRYSTAL = [0.1, 0.3, 0.8, 0.8];
COLOR_PLATFORM = [0.15, 0.15, 0.2];

// =============================================================================
// UTILITY MODULES
// =============================================================================

module rounded_cube(size, radius) {
    hull() {
        for (x = [-size[0]/2+radius, size[0]/2-radius]) {
            for (y = [-size[1]/2+radius, size[1]/2-radius]) {
                for (z = [-size[2]/2+radius, size[2]/2-radius]) {
                    translate([x, y, z])
                        sphere(r=radius);
                }
            }
        }
    }
}

// =============================================================================
// SYMBOL LIBRARY
// =============================================================================

module symbol_sword() {
    union() {
        cube([0.8, 0.6, 5], center=true); // Blade
        translate([0, 0, 2.5])
            cube([2.5, 0.6, 0.8], center=true); // Crossguard
        translate([0, 0, 3.2])
            cube([0.6, 0.6, 1.5], center=true); // Handle
        translate([0, 0, 4])
            sphere(r=0.4); // Pommel
    }
}

module symbol_shield() {
    difference() {
        hull() {
            translate([0, 0, 1.5])
                cube([3.5, 0.6, 1], center=true);
            translate([0, 0, -1.5])
                cylinder(h=0.6, r=1.5, center=true);
        }
        translate([0, 0, 0])
            cube([1, 1, 4], center=true);
        translate([0, 0, 0])
            cube([4, 1, 1], center=true);
    }
}

module symbol_skull() {
    union() {
        translate([0, 0, 0.5])
            sphere(r=1.5);
        translate([-0.5, 0.3, 0.8])
            cylinder(h=0.6, r=0.3, center=true);
        translate([0.5, 0.3, 0.8])
            cylinder(h=0.6, r=0.3, center=true);
        translate([0, 0.3, 0])
            cube([0.3, 0.6, 1], center=true);
    }
}

module symbol_hammer() {
    union() {
        translate([0, 0, -1])
            cube([0.6, 0.6, 4], center=true);
        translate([0, 0, 1.5]) {
            cube([3, 0.8, 1.2], center=true);
            translate([1.2, 0, 0])
                cube([0.8, 0.8, 2], center=true);
        }
    }
}

module symbol_wizard_hat() {
    difference() {
        hull() {
            cylinder(h=0.6, r=1.8, center=true);
            translate([0, 0, 3.5])
                sphere(r=0.4);
        }
        translate([0, 0, 1])
            rotate([0, 0, 45])
                cube([0.3, 3, 0.6], center=true);
        translate([0, 0, 1])
            rotate([0, 0, -45])
                cube([0.3, 3, 0.6], center=true);
    }
}

module symbol_dragon() {
    // Simplified dragon silhouette
    union() {
        // Body
        hull() {
            translate([-1, 0, 0])
                cylinder(h=0.6, r=1, center=true);
            translate([1, 0, 1])
                cylinder(h=0.6, r=0.7, center=true);
        }
        // Wings
        translate([0, 0, 0.5]) {
            rotate([0, 0, 30])
                cube([0.3, 3, 0.6], center=true);
            rotate([0, 0, -30])
                cube([0.3, 3, 0.6], center=true);
        }
        // Head
        translate([1.5, 0, 1.5])
            sphere(r=0.5);
    }
}

// =============================================================================
// MAIN COMPONENTS
// =============================================================================

module obelisk_body() {
    difference() {
        // Main tapered shape
        hull() {
            translate([0, 0, 0])
                cube([OBELISK_BASE_WIDTH, OBELISK_BASE_WIDTH, 1], center=true);
            translate([0, 0, OBELISK_HEIGHT])
                cube([OBELISK_TOP_WIDTH, OBELISK_TOP_WIDTH, 1], center=true);
        }
        
        // Panel lines for detail
        for (z = [10 : 20 : OBELISK_HEIGHT-10]) {
            for (face = [0:3]) {
                rotate([0, 0, face * 90]) {
                    translate([0, OBELISK_BASE_WIDTH/2 + 0.1, z]) {
                        current_width = OBELISK_BASE_WIDTH - 
                            (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * (z / OBELISK_HEIGHT);
                        cube([current_width-2, 1, 2], center=true);
                    }
                }
            }
        }
    }
}

module rune_system() {
    if (ENABLE_RUNES) {
        for (face = [0:3]) {
            rotate([0, 0, face * 90]) {
                translate([OBELISK_BASE_WIDTH/2 + 0.15, 0, 0]) {
                    for (z = [15 : 25 : OBELISK_HEIGHT-15]) {
                        // Calculate width at this height
                        current_width = OBELISK_BASE_WIDTH - 
                            (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * (z / OBELISK_HEIGHT);
                        
                        translate([-OBELISK_BASE_WIDTH/2 + current_width/2, 0, z]) {
                            // Main rune elements
                            cube([0.8, 1.5, 12], center=true);
                            translate([0, 0, 4])
                                cube([0.8, 4, 1], center=true);
                            translate([0, 0, -4])
                                cube([0.8, 3, 1], center=true);
                            
                            // Diagonal accents
                            translate([0, 1, 2])
                                rotate([0, 0, 45])
                                    cube([0.8, 2, 1], center=true);
                            translate([0, -1, -2])
                                rotate([0, 0, -45])
                                    cube([0.8, 2, 1], center=true);
                        }
                    }
                }
            }
        }
    }
}

module plaque(symbol_id = 0) {
    difference() {
        // Main plaque body
        rounded_cube([PLAQUE_WIDTH, PLAQUE_DEPTH, PLAQUE_HEIGHT], 0.5);
        
        // Recessed symbol area
        translate([0, -0.2, 0])
            cube([PLAQUE_WIDTH-1.5, PLAQUE_DEPTH-0.5, PLAQUE_HEIGHT-1.5], center=true);
    }
    
    // Symbol
    translate([0, PLAQUE_DEPTH/2 + 0.3, 0]) {
        if (symbol_id == 0) symbol_sword();
        else if (symbol_id == 1) symbol_shield();
        else if (symbol_id == 2) symbol_skull();
        else if (symbol_id == 3) symbol_hammer();
        else if (symbol_id == 4) symbol_wizard_hat();
        else if (symbol_id == 5) symbol_dragon();
    }
}

module plaque_system() {
    // Mounting posts
    for (i = [0:PLAQUE_COUNT-1]) {
        translate([OBELISK_BASE_WIDTH/2 + 0.5, -3, 15 + i * PLAQUE_SPACING]) {
            rotate([0, 90, 0])
                cylinder(h=PLAQUE_DEPTH + 1, r=0.4, center=true);
            
            translate([PLAQUE_DEPTH/2, 0, 0])
                cube([0.5, 2, 2], center=true);
        }
    }
    
    // Plaques
    color(COLOR_PLAQUES) {
        for (i = [0:PLAQUE_COUNT-1]) {
            translate([OBELISK_BASE_WIDTH/2 + PLAQUE_DEPTH, -3, 15 + i * PLAQUE_SPACING]) {
                rotate([0, 90, 0])
                    plaque(i % 6); // Cycle through available symbols
            }
        }
    }
}

module stone_base() {
    difference() {
        // Main base shape
        hull() {
            for (x = [-BASE_WIDTH/2+2, BASE_WIDTH/2-2]) {
                for (y = [-BASE_DEPTH/2+2, BASE_DEPTH/2-2]) {
                    translate([x, y, 0])
                        cylinder(h=BASE_HEIGHT, r=2, center=true);
                }
            }
        }
        
        // Stone block pattern
        for (layer = [0:2]) {
            z_offset = layer * 5 - BASE_HEIGHT/2 + 2;
            offset_x = (layer % 2) * 3;
            
            for (x = [-BASE_WIDTH/2+3 : 6 : BASE_WIDTH/2-3]) {
                for (y = [-BASE_DEPTH/2+3 : 6 : BASE_DEPTH/2-3]) {
                    translate([x + offset_x, y, z_offset]) {
                        // Stone block with mortar gaps
                        difference() {
                            cube([5.5, 5.5, 4.5], center=true);
                            
                            // Mortar lines
                            translate([2.8, 0, 0])
                                cube([0.4, 6, 5], center=true);
                            translate([-2.8, 0, 0])
                                cube([0.4, 6, 5], center=true);
                            translate([0, 2.8, 0])
                                cube([6, 0.4, 5], center=true);
                            translate([0, -2.8, 0])
                                cube([6, 0.4, 5], center=true);
                        }
                    }
                }
            }
        }
    }
}

module crystal_top() {
    if (ENABLE_CRYSTAL) {
        translate([0, 0, BASE_HEIGHT + OBELISK_HEIGHT]) {
            color(COLOR_CRYSTAL) {
                intersection() {
                    // Main crystal shape
                    hull() {
                        cylinder(h=2, r=4, center=true);
                        translate([0, 0, 8])
                            cylinder(h=2, r=1, center=true);
                    }
                    
                    // Faceting cuts
                    for (angle = [0:45:315]) {
                        rotate([0, 0, angle])
                            translate([6, 0, 4])
                                rotate([0, 25, 0])
                                    cube([12, 12, 16], center=true);
                    }
                }
                
                // Inner glow
                translate([0, 0, 4])
                    sphere(r=2);
            }
        }
    }
}

module ground_platform() {
    if (ENABLE_PLATFORM) {
        color(COLOR_PLATFORM)
            translate([0, 0, -2])
                cylinder(h=2, r=30, center=true);
    }
}

// =============================================================================
// MAIN ASSEMBLY
// =============================================================================

module complete_obelisk() {
    // Ground platform
    ground_platform();
    
    // Stone base
    color(COLOR_BASE)
        translate([0, 0, BASE_HEIGHT/2])
            stone_base();
    
    // Main obelisk structure
    translate([0, 0, BASE_HEIGHT]) {
        color(COLOR_OBELISK) {
            obelisk_body();
            rune_system();
        }
        
        // Plaque system
        plaque_system();
    }
    
    // Crystal top
    crystal_top();
}

// =============================================================================
// RENDER
// =============================================================================

complete_obelisk();

// Optional: Show individual components for testing
// translate([50, 0, 0]) plaque(0);
// translate([60, 0, 0]) plaque(1);
// translate([70, 0, 0]) plaque(2);
