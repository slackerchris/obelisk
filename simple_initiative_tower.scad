// Simple D&D Initiative Tracker Tower
// Practical, easy-to-print design for tabletop use

// =============================================================================
// SIMPLE CONFIGURATION
// =============================================================================

// Main dimensions (adjust for your table)
TOWER_HEIGHT = 80;           // Total height
BASE_SIZE = 25;              // Base diameter
SLOT_COUNT = 6;              // Number of initiative slots

// Slot dimensions
SLOT_WIDTH = 12;
SLOT_HEIGHT = 6;
SLOT_DEPTH = 3;
CARD_SLOT_HEIGHT = 1.5;      // For initiative cards

// Practical settings
$fn = 24; // Lower resolution for faster printing
PRINT_SUPPORTS = false;      // Design to avoid supports

// =============================================================================
// MAIN COMPONENTS
// =============================================================================

module tower_base() {
    difference() {
        // Main base
        cylinder(h=8, r=BASE_SIZE/2);
        
        // Hollow interior for storage
        translate([0, 0, 2])
            cylinder(h=7, r=BASE_SIZE/2 - 3);
        
        // Access slot
        translate([0, BASE_SIZE/2 - 2, 5])
            cube([BASE_SIZE - 8, 4, 4], center=true);
    }
    
    // Label
    translate([0, -BASE_SIZE/2 + 1, 6])
        rotate([90, 0, 0])
            linear_extrude(height=0.8)
                text("INITIATIVE", size=2.5, halign="center");
}

module tower_shaft() {
    difference() {
        // Main tower - slight taper
        hull() {
            translate([0, 0, 0])
                cylinder(h=1, r=BASE_SIZE/2 - 2);
            translate([0, 0, TOWER_HEIGHT])
                cylinder(h=1, r=BASE_SIZE/2 - 5);
        }
        
        // Initiative numbers on tower face
        for (i = [1:SLOT_COUNT]) {
            z_pos = 12 + (i-1) * (TOWER_HEIGHT-20)/(SLOT_COUNT-1);
            translate([BASE_SIZE/2 - 4, 0, z_pos])
                rotate([90, 0, 0])
                    linear_extrude(height=1)
                        text(str(i), size=3, halign="center");
        }
    }
}

module slot_track() {
    for (i = [0:SLOT_COUNT-1]) {
        z_pos = 12 + i * (TOWER_HEIGHT-20)/(SLOT_COUNT-1);
        
        translate([BASE_SIZE/2 - 1, 0, z_pos]) {
            // Horizontal track
            cube([6, SLOT_WIDTH + 4, 1], center=true);
            
            // Side guides
            translate([2, -(SLOT_WIDTH/2 + 1), 0])
                cube([2, 2, SLOT_HEIGHT + 1], center=true);
            translate([2, (SLOT_WIDTH/2 + 1), 0])
                cube([2, 2, SLOT_HEIGHT + 1], center=true);
            
            // Initiative number marker
            translate([0, 0, -1])
                cube([1, 1, 3], center=true);
        }
    }
}

module initiative_token(token_type = "neutral") {
    // Token colors for different types
    token_color = (token_type == "player") ? [0.2, 0.8, 0.2] :
                  (token_type == "enemy") ? [0.8, 0.2, 0.2] :
                  (token_type == "npc") ? [0.2, 0.4, 0.8] : [0.6, 0.6, 0.4];
    
    color(token_color) {
        difference() {
            // Main token body
            cube([SLOT_WIDTH, SLOT_DEPTH, SLOT_HEIGHT], center=true);
            
            // Card holder slot
            translate([0, -SLOT_DEPTH/2 + 0.3, SLOT_HEIGHT/2 - 0.5])
                cube([SLOT_WIDTH - 1, 1, CARD_SLOT_HEIGHT], center=true);
            
            // Type indicator recess
            translate([0, SLOT_DEPTH/2 - 0.2, 0])
                cube([4, 0.6, 4], center=true);
        }
        
        // Type symbol (raised)
        translate([0, SLOT_DEPTH/2 + 0.1, 0]) {
            if (token_type == "player") {
                // Player symbol (person)
                union() {
                    translate([0, 0, 1]) cylinder(h=0.3, r=0.6);
                    cube([1, 0.3, 2], center=true);
                    translate([0, 0, 0.3]) cube([2.5, 0.3, 0.6], center=true);
                }
            } else if (token_type == "enemy") {
                // Enemy symbol (skull)
                union() {
                    cylinder(h=0.3, r=1);
                    translate([-0.4, 0.2, 0]) cylinder(h=0.4, r=0.2);
                    translate([0.4, 0.2, 0]) cylinder(h=0.4, r=0.2);
                }
            } else if (token_type == "npc") {
                // NPC symbol (house)
                union() {
                    cube([2, 0.3, 1], center=true);
                    translate([0, 0, 0.7]) 
                        rotate([0, 45, 0]) 
                            cube([1.4, 0.3, 1.4], center=true);
                }
            } else {
                // Neutral symbol (diamond)
                rotate([0, 45, 0]) 
                    cube([1.5, 0.3, 1.5], center=true);
            }
        }
    }
}

module round_tracker() {
    translate([0, 0, TOWER_HEIGHT + 5]) {
        difference() {
            cylinder(h=3, r=6);
            cylinder(h=4, r=4.5);
            
            // Round numbers
            for (i = [1:10]) {
                rotate([0, 0, i * 36])
                    translate([5.5, 0, 1.5])
                        rotate([90, 0, 0])
                            linear_extrude(height=0.6)
                                text(str(i), size=1.2, halign="center");
            }
        }
        
        // Center post for marker
        cylinder(h=5, r=0.5);
    }
}

module round_marker() {
    translate([0, 0, TOWER_HEIGHT + 10]) {
        color([1, 0.8, 0]) {
            difference() {
                cylinder(h=1.5, r=1.5);
                cylinder(h=2, r=0.6);
            }
            // Pointer
            translate([1.5, 0, 0.75])
                cube([2, 0.5, 1.5], center=true);
        }
    }
}

// =============================================================================
// PRINT LAYOUTS
// =============================================================================

module print_main_tower() {
    // Main tower structure - print upright
    tower_base();
    translate([0, 0, 8])
        tower_shaft();
    translate([0, 0, 8])
        slot_track();
}

module print_tokens_set() {
    // Set of initiative tokens - print flat
    for (i = [0:3]) {
        for (j = [0:1]) {
            translate([i * (SLOT_WIDTH + 2), j * (SLOT_DEPTH + 2), SLOT_HEIGHT/2]) {
                if (i == 0) initiative_token("player");
                else if (i == 1) initiative_token("enemy");
                else if (i == 2) initiative_token("npc");
                else initiative_token("neutral");
            }
        }
    }
}

module print_round_tracker() {
    // Round tracker components - print flat
    round_tracker();
    translate([15, 0, 1.5])
        round_marker();
}

// =============================================================================
// WHAT TO RENDER
// =============================================================================

// Choose what to print by uncommenting:

// Complete assembly (for preview)
if (true) {
    print_main_tower();
    
    // Example tokens in position
    translate([BASE_SIZE/2 + 2, 0, 15])
        rotate([0, 90, 0])
            initiative_token("player");
    
    translate([BASE_SIZE/2 + 2, 0, 25])
        rotate([0, 90, 0])
            initiative_token("enemy");
    
    print_round_tracker();
}

// Individual print files:
// print_main_tower();        // Main tower structure
// print_tokens_set();        // Initiative tokens (8 total)
// print_round_tracker();     // Round counter and marker

// =============================================================================
// USAGE INSTRUCTIONS (as comments)
// =============================================================================

/*
PRINTING INSTRUCTIONS:
1. Print main_tower upright (no supports needed if designed well)
2. Print tokens flat on bed (8 tokens per set)
3. Print round_tracker flat

ASSEMBLY:
1. Insert round tracker ring over top of tower
2. Place round marker on center post
3. Slide initiative tokens into slots as needed

USAGE:
1. Roll initiative for all participants
2. Assign tokens by type (player/enemy/npc/neutral)
3. Insert tokens in initiative order (top = highest)
4. Use round tracker to mark current round
5. Move through tokens from top to bottom each round

STORAGE:
- Dice and extra tokens fit in hollow base
- Access through slot in base
- Tokens stack for compact storage
*/
