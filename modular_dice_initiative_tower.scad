// Modular Dice Tower + Initiative Tracker System
// Print components separately or as one unit

// =============================================================================
// WHAT TO RENDER - Change these to true/false
// =============================================================================

RENDER_COMPLETE_UNIT = true;     // Full combined unit
RENDER_DICE_TOWER_ONLY = false;  // Just the dice tower
RENDER_INITIATIVE_ONLY = false;  // Just initiative tracker
RENDER_EXTRA_PLAQUES = false;    // Extra initiative plaques
RENDER_DICE_TRAY = false;        // Separate dice collection tray

// =============================================================================
// CONFIGURATION
// =============================================================================

// Sizing
TOWER_HEIGHT = 120;
BASE_SIZE = 35;
BASE_HEIGHT = 15;

// Dice tower specs
DICE_ENTRY_DIAMETER = 18;    // Size of top opening
DICE_PATH_WIDTH = 15;        // Internal path width
BAFFLE_COUNT = 4;            // Number of randomizing baffles
DICE_EXIT_WIDTH = 12;        // Exit slot width

// Initiative tracker specs
INITIATIVE_SLOTS = 6;        // Number of initiative positions
SLOT_SPACING = 16;           // Space between slots
PLAQUE_SIZE = [12, 8, 6];    // [width, height, depth]

// Print settings
$fn = 32; // Circle resolution (lower for preview, higher for final)

// Colors (for visualization)
COLOR_STRUCTURE = [0.3, 0.3, 0.4];
COLOR_DICE_ELEMENTS = [0.2, 0.6, 0.2];
COLOR_INITIATIVE = [0.6, 0.3, 0.2];
COLOR_BASE = [0.25, 0.25, 0.3];

// =============================================================================
// UTILITY FUNCTIONS
// =============================================================================

module rounded_box(size, radius) {
    hull() {
        for (x = [radius-size[0]/2, size[0]/2-radius]) {
            for (y = [radius-size[1]/2, size[1]/2-radius]) {
                translate([x, y, 0])
                    cylinder(h=size[2], r=radius);
            }
        }
    }
}

// =============================================================================
// DICE TOWER COMPONENTS
// =============================================================================

module dice_entry_top() {
    // Funnel entrance at top
    difference() {
        // Outer funnel
        hull() {
            cylinder(h=6, r=DICE_ENTRY_DIAMETER/2 + 3);
            translate([0, 0, -2])
                cylinder(h=1, r=DICE_PATH_WIDTH/2 + 2);
        }
        
        // Inner cavity
        hull() {
            translate([0, 0, -1])
                cylinder(h=8, r=DICE_ENTRY_DIAMETER/2);
            translate([0, 0, -3])
                cylinder(h=1, r=DICE_PATH_WIDTH/2);
        }
    }
    
    // Entry label
    translate([0, DICE_ENTRY_DIAMETER/2 + 2, 3])
        rotate([90, 0, 0])
            linear_extrude(height=0.8)
                text("DICE", size=3, halign="center", valign="center");
}

module dice_baffle_set() {
    // Internal baffles to randomize dice
    for (i = [0:BAFFLE_COUNT-1]) {
        z_pos = 20 + i * 20;
        angle = i * 72 + 36; // Offset each baffle
        
        translate([0, 0, z_pos]) {
            rotate([0, 0, angle]) {
                // Angled deflector plate
                translate([DICE_PATH_WIDTH/3, 0, 0])
                    rotate([0, 15, 0])
                        cube([DICE_PATH_WIDTH/2, DICE_PATH_WIDTH-2, 1.5], center=true);
            }
        }
    }
}

module dice_tower_body() {
    difference() {
        // Main tower structure
        hull() {
            // Base
            translate([0, 0, 0])
                cylinder(h=2, r=BASE_SIZE/2 - 2);
            // Top  
            translate([0, 0, TOWER_HEIGHT])
                cylinder(h=2, r=BASE_SIZE/2 - 8);
        }
        
        // Internal dice path
        translate([0, 0, -1])
            cylinder(h=TOWER_HEIGHT - 5, r=DICE_PATH_WIDTH/2);
        
        // Exit ramp
        translate([0, BASE_SIZE/2 - 3, 8])
            rotate([25, 0, 0])
                cube([DICE_EXIT_WIDTH, 12, 8], center=true);
        
        // Exit slot
        translate([0, BASE_SIZE/2 + 1, 6])
            cube([DICE_EXIT_WIDTH, 4, 6], center=true);
    }
}

module dice_collection_tray() {
    translate([0, BASE_SIZE/2 + 8, 0]) {
        difference() {
            // Tray body
            rounded_box([20, 12, 6], 1);
            
            // Tray interior
            translate([0, 0, 1])
                rounded_box([18, 10, 6], 1);
        }
        
        // Tray label
        translate([0, -5, 5])
            rotate([90, 0, 0])
                linear_extrude(height=0.6)
                    text("DICE", size=2, halign="center");
    }
    
    // Connection ramp
    translate([0, BASE_SIZE/2 + 2, 3])
        rotate([20, 0, 0])
            cube([DICE_EXIT_WIDTH, 6, 2], center=true);
}

// =============================================================================
// INITIATIVE TRACKER COMPONENTS
// =============================================================================

module initiative_slot_track() {
    // Mounting system for initiative plaques
    for (i = [0:INITIATIVE_SLOTS-1]) {
        z_pos = 15 + i * SLOT_SPACING;
        
        // Position on side opposite dice exit
        translate([-BASE_SIZE/2, 0, z_pos]) {
            // Horizontal rail
            cube([4, 15, 1.5], center=true);
            
            // Side guides
            translate([-1.5, -6, 0])
                cube([1, 3, PLAQUE_SIZE[2] + 2], center=true);
            translate([-1.5, 6, 0])
                cube([1, 3, PLAQUE_SIZE[2] + 2], center=true);
            
            // Initiative number
            translate([2, 0, -2])
                rotate([90, 0, 0])
                    linear_extrude(height=1)
                        text(str(i+1), size=2.5, halign="center", valign="center");
        }
    }
}

module initiative_plaque(participant_type = "neutral", init_number = 1) {
    // Color based on type
    plaque_color = (participant_type == "player") ? [0.2, 0.7, 0.2] :
                   (participant_type == "enemy") ? [0.7, 0.2, 0.2] :
                   (participant_type == "npc") ? [0.2, 0.4, 0.7] : [0.5, 0.5, 0.4];
    
    color(plaque_color) {
        difference() {
            // Main plaque
            rounded_box(PLAQUE_SIZE, 0.5);
            
            // Card/name slot
            translate([0, -PLAQUE_SIZE[1]/2 + 0.5, PLAQUE_SIZE[2]/2 - 0.8])
                cube([PLAQUE_SIZE[0] - 2, 1.5, 1.2], center=true);
            
            // Initiative number recess
            translate([PLAQUE_SIZE[0]/2 - 2, PLAQUE_SIZE[1]/2 - 0.3, -PLAQUE_SIZE[2]/2 + 0.8])
                linear_extrude(height=0.6)
                    text(str(init_number), size=1.8, halign="center");
        }
        
        // Type symbol
        translate([0, PLAQUE_SIZE[1]/2 + 0.3, 0]) {
            if (participant_type == "player") {
                // Player figure
                union() {
                    translate([0, 0, 1.5]) cylinder(h=0.4, r=0.7); // Head
                    cube([1.2, 0.4, 2], center=true); // Body
                    translate([0, 0, 0.3]) cube([2.5, 0.4, 0.6], center=true); // Arms
                }
            } else if (participant_type == "enemy") {
                // Monster claw
                union() {
                    hull() {
                        translate([0, 0, -1]) cylinder(h=0.4, r=1);
                        translate([0, 0, 1.5]) cylinder(h=0.4, r=0.3);
                    }
                    translate([-0.8, 0, 0]) rotate([0, 0, -30]) cube([0.4, 0.4, 2], center=true);
                    translate([0.8, 0, 0]) rotate([0, 0, 30]) cube([0.4, 0.4, 2], center=true);
                }
            } else if (participant_type == "npc") {
                // Building/town symbol
                union() {
                    cube([2, 0.4, 1.2], center=true);
                    translate([0, 0, 0.8]) hull() {
                        translate([-0.8, 0, 0]) cylinder(h=0.4, r=0.2);
                        translate([0.8, 0, 0]) cylinder(h=0.4, r=0.2);
                        translate([0, 0, 0.8]) cylinder(h=0.4, r=0.2);
                    }
                }
            } else {
                // Neutral diamond
                rotate([0, 45, 0]) cube([1.5, 0.4, 1.5], center=true);
            }
        }
    }
}

// =============================================================================
// BASE AND STRUCTURE
// =============================================================================

module main_base() {
    difference() {
        // Main base platform
        cylinder(h=BASE_HEIGHT, r=BASE_SIZE/2);
        
        // Storage compartment (back half)
        translate([0, -BASE_SIZE/4, 2])
            cylinder(h=BASE_HEIGHT, r=BASE_SIZE/2 - 4);
        
        // Storage access
        translate([0, -BASE_SIZE/2 + 2, BASE_HEIGHT/2 + 1])
            cube([BASE_SIZE - 12, 4, BASE_HEIGHT], center=true);
    }
    
    // Base labels
    translate([0, -BASE_SIZE/2 + 1, BASE_HEIGHT - 1])
        rotate([90, 0, 0])
            linear_extrude(height=0.8)
                text("D&D TRACKER", size=2.5, halign="center");
}

module mystical_details() {
    // Decorative elements that don't interfere with function
    for (angle = [45, 135, 225, 315]) {
        rotate([0, 0, angle]) {
            translate([BASE_SIZE/2 - 1, 0, 0]) {
                for (z = [20:25:TOWER_HEIGHT-20]) {
                    translate([0, 0, z]) {
                        // Simple geometric runes
                        cube([0.8, 1.5, 8], center=true);
                        translate([0, 0, 3]) cube([0.8, 3, 1], center=true);
                        translate([0, 0, -3]) cube([0.8, 2.5, 1], center=true);
                    }
                }
            }
        }
    }
}

// =============================================================================
// ASSEMBLY MODULES
// =============================================================================

module complete_dice_initiative_tower() {
    // Base platform
    color(COLOR_BASE)
        translate([0, 0, BASE_HEIGHT/2])
            main_base();
    
    // Main tower structure
    translate([0, 0, BASE_HEIGHT]) {
        color(COLOR_STRUCTURE) {
            dice_tower_body();
            initiative_slot_track();
            mystical_details();
        }
        
        // Dice tower components
        color(COLOR_DICE_ELEMENTS) {
            translate([0, 0, TOWER_HEIGHT - 3])
                dice_entry_top();
            dice_baffle_set();
        }
    }
    
    // Dice collection tray
    color(COLOR_BASE)
        translate([0, 0, BASE_HEIGHT/2])
            dice_collection_tray();
    
    // Example initiative plaques
    color(COLOR_INITIATIVE) {
        translate([0, 0, BASE_HEIGHT]) {
            translate([-BASE_SIZE/2 - PLAQUE_SIZE[1]/2, 0, 20])
                rotate([0, -90, 0])
                    initiative_plaque("player", 1);
            
            translate([-BASE_SIZE/2 - PLAQUE_SIZE[1]/2, 0, 36])
                rotate([0, -90, 0])
                    initiative_plaque("enemy", 2);
            
            translate([-BASE_SIZE/2 - PLAQUE_SIZE[1]/2, 0, 52])
                rotate([0, -90, 0])
                    initiative_plaque("npc", 3);
        }
    }
}

module dice_tower_only() {
    // Just the dice tower without initiative tracking
    color(COLOR_BASE)
        translate([0, 0, BASE_HEIGHT/2])
            main_base();
    
    translate([0, 0, BASE_HEIGHT]) {
        color(COLOR_STRUCTURE) {
            dice_tower_body();
            mystical_details();
        }
        
        color(COLOR_DICE_ELEMENTS) {
            translate([0, 0, TOWER_HEIGHT - 3])
                dice_entry_top();
            dice_baffle_set();
        }
    }
    
    color(COLOR_BASE)
        translate([0, 0, BASE_HEIGHT/2])
            dice_collection_tray();
}

module initiative_tracker_only() {
    // Just initiative tracking without dice tower
    translate([0, 0, BASE_HEIGHT/2])
        main_base();
    
    translate([0, 0, BASE_HEIGHT]) {
        // Solid tower (no dice path)
        difference() {
            hull() {
                cylinder(h=2, r=BASE_SIZE/2 - 2);
                translate([0, 0, TOWER_HEIGHT])
                    cylinder(h=2, r=BASE_SIZE/2 - 8);
            }
        }
        
        initiative_slot_track();
        mystical_details();
    }
}

module extra_plaques_set() {
    // Set of additional plaques to print
    for (i = [0:7]) {
        translate([i * 15, 0, PLAQUE_SIZE[2]/2]) {
            if (i < 2) initiative_plaque("player", i + 4);
            else if (i < 4) initiative_plaque("enemy", i + 2);
            else if (i < 6) initiative_plaque("npc", i);
            else initiative_plaque("neutral", i - 2);
        }
    }
}

// =============================================================================
// RENDER SELECTION
// =============================================================================

if (RENDER_COMPLETE_UNIT) {
    complete_dice_initiative_tower();
}

if (RENDER_DICE_TOWER_ONLY) {
    dice_tower_only();
}

if (RENDER_INITIATIVE_ONLY) {
    initiative_tracker_only();
}

if (RENDER_EXTRA_PLAQUES) {
    extra_plaques_set();
}

if (RENDER_DICE_TRAY) {
    dice_collection_tray();
}

// =============================================================================
// USAGE NOTES (as comments)
// =============================================================================

/*
PRINTING GUIDE:
1. Set ONE render option to true at the top
2. For best results, print the complete unit upright
3. No supports needed if designed correctly
4. Print extra plaques flat for multi-color effects

ASSEMBLY & USE:
1. Drop dice in top funnel - they roll through baffles and exit to tray
2. Slide initiative plaques into side slots in initiative order
3. Use storage compartment for dice, tokens, or extra plaques
4. Work through initiative from top to bottom each round

CUSTOMIZATION:
- Adjust INITIATIVE_SLOTS for larger/smaller groups
- Modify TOWER_HEIGHT for your table
- Change colors for different participant types
- Scale entire model if needed
*/
