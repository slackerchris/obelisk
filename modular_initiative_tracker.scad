// Modular D&D Initiative Tracker Components
// Print components separately for easy replacement and customization

// =============================================================================
// WHAT TO RENDER - Uncomment the section you want to print
// =============================================================================

// MAIN_TRACKER = true;        // The base obelisk structure
// PLAYER_SLOTS = true;         // Player character slots
// ENEMY_SLOTS = true;          // Enemy/monster slots  
// NPC_SLOTS = true;            // NPC slots
// NEUTRAL_SLOTS = true;        // Neutral/environmental slots
// ROUND_COUNTER = true;        // Round tracking ring
// STORAGE_TRAY = true;         // Extra storage tray

// =============================================================================
// CONFIGURATION
// =============================================================================

// Sizing for your table
SCALE_FACTOR = 1.0;          // Adjust overall size (1.0 = normal)
SLOTS_PER_TYPE = 4;          // How many of each slot type to print

// Initiative slot sizing
SLOT_WIDTH = 15;
SLOT_HEIGHT = 8; 
SLOT_DEPTH = 2;

// Text options
INCLUDE_NUMBERS = true;      // Print initiative numbers on slots
INCLUDE_SYMBOLS = true;      // Print type symbols on slots
TEXT_SIZE = 2;

// Colors (for visualization - actual colors depend on your filament)
COLOR_PLAYER = [0.2, 0.8, 0.2];    // Green
COLOR_ENEMY = [0.8, 0.2, 0.2];     // Red
COLOR_NPC = [0.2, 0.4, 0.8];       // Blue  
COLOR_NEUTRAL = [0.6, 0.6, 0.4];   // Tan
COLOR_STRUCTURE = [0.3, 0.3, 0.4]; // Grey

$fn = 30; // Reduce for faster preview, increase for final print

// =============================================================================
// CORE MODULES
// =============================================================================

module initiative_slot_base() {
    // Basic slot shape that all types inherit
    difference() {
        // Main body
        hull() {
            translate([-SLOT_WIDTH/2+1, -SLOT_DEPTH/2+0.5, 0])
                cylinder(h=SLOT_HEIGHT, r=0.5);
            translate([SLOT_WIDTH/2-1, -SLOT_DEPTH/2+0.5, 0])
                cylinder(h=SLOT_HEIGHT, r=0.5);
            translate([-SLOT_WIDTH/2+1, SLOT_DEPTH/2-0.5, 0])
                cylinder(h=SLOT_HEIGHT, r=0.5);
            translate([SLOT_WIDTH/2-1, SLOT_DEPTH/2-0.5, 0])
                cylinder(h=SLOT_HEIGHT, r=0.5);
        }
        
        // Card/name slot
        translate([0, -SLOT_DEPTH/2 + 0.3, SLOT_HEIGHT - 1.5])
            cube([SLOT_WIDTH - 2, 1, 2], center=true);
        
        // Mounting slots for the track
        translate([-SLOT_WIDTH/2 + 2, 0, SLOT_HEIGHT/2])
            rotate([90, 0, 0])
                cylinder(h=SLOT_DEPTH + 2, r=1, center=true);
        translate([SLOT_WIDTH/2 - 2, 0, SLOT_HEIGHT/2])
            rotate([90, 0, 0])
                cylinder(h=SLOT_DEPTH + 2, r=1, center=true);
    }
}

module type_symbol(type) {
    translate([0, SLOT_DEPTH/2 + 0.2, SLOT_HEIGHT/2]) {
        if (type == "player") {
            // Simplified character
            union() {
                translate([0, 0, 2]) cylinder(h=0.3, r=0.8, center=true);
                cube([1.5, 0.3, 2.5], center=true);
                translate([0, 0, 0.5]) cube([3, 0.3, 0.8], center=true);
            }
        } else if (type == "enemy") {
            // Claw/fang
            union() {
                hull() {
                    translate([0, 0, -1]) cylinder(h=0.3, r=1.2, center=true);
                    translate([0, 0, 1.5]) cylinder(h=0.3, r=0.4, center=true);
                }
                translate([-1, 0, 0]) rotate([0, 0, -25]) cube([0.4, 0.3, 2], center=true);
                translate([1, 0, 0]) rotate([0, 0, 25]) cube([0.4, 0.3, 2], center=true);
            }
        } else if (type == "npc") {
            // Simple house
            union() {
                cube([2.5, 0.3, 1.5], center=true);
                translate([0, 0, 1]) hull() {
                    translate([-1, 0, 0]) cylinder(h=0.3, r=0.3, center=true);
                    translate([1, 0, 0]) cylinder(h=0.3, r=0.3, center=true);
                    translate([0, 0, 1]) cylinder(h=0.3, r=0.3, center=true);
                }
            }
        } else if (type == "neutral") {
            // Diamond
            hull() {
                translate([0, 0, 1]) cylinder(h=0.3, r=0.4, center=true);
                translate([0, 0, -1]) cylinder(h=0.3, r=0.4, center=true);
                translate([1, 0, 0]) cylinder(h=0.3, r=0.4, center=true);
                translate([-1, 0, 0]) cylinder(h=0.3, r=0.4, center=true);
            }
        }
    }
}

module initiative_slot(type, number = 0) {
    slot_color = (type == "player") ? COLOR_PLAYER :
                 (type == "enemy") ? COLOR_ENEMY :
                 (type == "npc") ? COLOR_NPC : COLOR_NEUTRAL;
    
    color(slot_color) {
        difference() {
            initiative_slot_base();
            
            // Initiative number
            if (INCLUDE_NUMBERS && number > 0) {
                translate([SLOT_WIDTH/2 - 2, -SLOT_DEPTH/2 + 0.1, SLOT_HEIGHT - 1])
                    rotate([90, 0, 0])
                        linear_extrude(height=0.5)
                            text(str(number), size=TEXT_SIZE, halign="center");
            }
        }
        
        // Type symbol
        if (INCLUDE_SYMBOLS) {
            type_symbol(type);
        }
    }
}

module main_tracker_structure() {
    color(COLOR_STRUCTURE) {
        // Base platform
        difference() {
            hull() {
                for (x = [-12, 12]) {
                    for (y = [-12, 12]) {
                        translate([x, y, 0])
                            cylinder(h=8, r=3);
                    }
                }
            }
            
            // Storage compartment
            translate([0, 0, 2])
                hull() {
                    for (x = [-8, 8]) {
                        for (y = [-8, 8]) {
                            translate([x, y, 0])
                                cylinder(h=7, r=2);
                        }
                    }
                }
        }
        
        // Central obelisk
        translate([0, 0, 8]) {
            hull() {
                cylinder(h=2, r=8);
                translate([0, 0, 60])
                    cylinder(h=2, r=4);
            }
        }
        
        // Initiative tracks
        for (side = [0, 1]) {
            mirror([side, 0, 0]) {
                translate([10, 0, 8]) {
                    for (i = [0:7]) {
                        z_pos = 8 + i * 8;
                        translate([0, 0, z_pos]) {
                            // Track rail
                            cube([4, 20, 1], center=true);
                            
                            // Side guides
                            translate([0, -8, 0])
                                cube([4, 2, SLOT_HEIGHT + 2], center=true);
                            translate([0, 8, 0])
                                cube([4, 2, SLOT_HEIGHT + 2], center=true);
                        }
                    }
                }
            }
        }
    }
}

module round_counter_ring() {
    color([0.8, 0.7, 0.2]) {
        difference() {
            cylinder(h=4, r=6);
            cylinder(h=5, r=4);
            
            // Round numbers
            for (i = [1:12]) {
                rotate([0, 0, i * 30])
                    translate([5, 0, 2])
                        rotate([90, 0, 0])
                            linear_extrude(height=0.8)
                                text(str(i), size=1.5, halign="center");
            }
        }
        
        // Pointer
        translate([0, 0, 4.5])
            cylinder(h=2, r=1);
    }
}

module storage_tray() {
    color(COLOR_STRUCTURE) {
        difference() {
            // Outer shell
            cube([40, 25, 6], center=true);
            
            // Main compartment
            translate([0, 0, 1])
                cube([36, 21, 6], center=true);
            
            // Dividers
            translate([0, 6, 1])
                cube([36, 1, 4], center=true);
            translate([0, -6, 1])
                cube([36, 1, 4], center=true);
            translate([10, 0, 1])
                cube([1, 21, 4], center=true);
            translate([-10, 0, 1])
                cube([1, 21, 4], center=true);
        }
        
        // Labels (embossed)
        translate([-15, 8, -2.5])
            linear_extrude(height=0.5)
                text("DICE", size=2, halign="center");
        translate([0, 8, -2.5])
            linear_extrude(height=0.5)
                text("TOKENS", size=2, halign="center");
        translate([15, 8, -2.5])
            linear_extrude(height=0.5)
                text("EXTRA", size=2, halign="center");
    }
}

// =============================================================================
// RENDER SELECTION
// =============================================================================

// Uncomment what you want to print:

// Main structure
if (false) main_tracker_structure(); // Set to true to render

// Player slots (green)
if (false) {
    for (i = [0:SLOTS_PER_TYPE-1]) {
        translate([i * (SLOT_WIDTH + 2), 0, 0])
            initiative_slot("player", i+1);
    }
}

// Enemy slots (red)  
if (false) {
    for (i = [0:SLOTS_PER_TYPE-1]) {
        translate([i * (SLOT_WIDTH + 2), 0, 0])
            initiative_slot("enemy", i+1);
    }
}

// NPC slots (blue)
if (false) {
    for (i = [0:SLOTS_PER_TYPE-1]) {
        translate([i * (SLOT_WIDTH + 2), 0, 0])
            initiative_slot("npc", i+1);
    }
}

// Neutral slots (tan)
if (false) {
    for (i = [0:SLOTS_PER_TYPE-1]) {
        translate([i * (SLOT_WIDTH + 2), 0, 0])
            initiative_slot("neutral", i+1);
    }
}

// Round counter
if (false) round_counter_ring();

// Storage tray
if (false) storage_tray();

// Example assembly (for visualization)
if (true) {
    main_tracker_structure();
    
    translate([0, 0, 80])
        round_counter_ring();
    
    // Example slots in position
    translate([12, 0, 24])
        rotate([0, 90, 0])
            initiative_slot("player", 1);
    
    translate([12, 0, 32])
        rotate([0, 90, 0])
            initiative_slot("enemy", 2);
            
    translate([-12, 0, 24])
        rotate([0, -90, 0])
            initiative_slot("npc", 3);
    
    translate([0, 20, 0])
        storage_tray();
}
