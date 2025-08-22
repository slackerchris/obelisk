// D&D Initiative Tracker Obelisk
// Functional design for tabletop RPG initiative management

// =============================================================================
// CONFIGURATION - Customize for your table
// =============================================================================

// Main structure
OBELISK_HEIGHT = 100;        // Adjust for your table height
OBELISK_BASE_WIDTH = 18;     
OBELISK_TOP_WIDTH = 10;
BASE_HEIGHT = 12;
BASE_WIDTH = 30;
BASE_DEPTH = 30;

// Initiative tracking
MAX_INITIATIVE_SLOTS = 8;    // Maximum number of participants
SLOT_HEIGHT = 10;            // Height of each initiative slot
SLOT_SPACING = 12;           // Space between slots
SLOT_START_HEIGHT = 8;       // Height of first slot above base

// Plaque system for initiative cards
PLAQUE_WIDTH = 15;           // Wide enough for names/initiative
PLAQUE_HEIGHT = 8;
PLAQUE_DEPTH = 2;
PLAQUE_THICKNESS = 1;

// Card holder dimensions
CARD_SLOT_WIDTH = 16;        // For initiative cards or name tags
CARD_SLOT_DEPTH = 1;
CARD_SLOT_HEIGHT = 2;

// Visual settings
$fn = 40;
ENABLE_CARD_SLOTS = true;    // Card holders vs just plaques
ENABLE_NUMBERS = true;       // Initiative order numbers
ENABLE_BASE_STORAGE = true;  // Storage compartment in base

// Colors for different participant types
COLOR_OBELISK = [0.3, 0.3, 0.4];
COLOR_BASE = [0.25, 0.25, 0.3];
COLOR_PLAYER = [0.2, 0.6, 0.2];      // Green for players
COLOR_ENEMY = [0.7, 0.2, 0.2];       // Red for enemies  
COLOR_NPC = [0.2, 0.4, 0.7];         // Blue for NPCs
COLOR_NEUTRAL = [0.5, 0.5, 0.4];     // Grey for neutral

// =============================================================================
// UTILITY MODULES
// =============================================================================

module rounded_cube(size, radius) {
    hull() {
        for (x = [-size[0]/2+radius, size[0]/2-radius]) {
            for (y = [-size[1]/2+radius, size[1]/2-radius]) {
                translate([x, y, 0])
                    cylinder(h=size[2], r=radius, center=true);
            }
        }
    }
}

// =============================================================================
// PARTICIPANT TYPE SYMBOLS
// =============================================================================

module symbol_player() {
    // Player character symbol - simplified character silhouette
    union() {
        // Head
        translate([0, 0, 2])
            cylinder(h=0.5, r=1, center=true);
        // Body
        translate([0, 0, 0])
            cube([2, 0.5, 3], center=true);
        // Arms
        translate([0, 0, 1])
            cube([4, 0.5, 1], center=true);
        // Legs
        translate([-0.8, 0, -2])
            cube([0.8, 0.5, 2], center=true);
        translate([0.8, 0, -2])
            cube([0.8, 0.5, 2], center=true);
    }
}

module symbol_enemy() {
    // Enemy symbol - monster claw/fang
    union() {
        // Main claw shape
        hull() {
            translate([0, 0, -2])
                cylinder(h=0.5, r=1.5, center=true);
            translate([0, 0, 2])
                cylinder(h=0.5, r=0.5, center=true);
        }
        // Side claws
        translate([-1.5, 0, 0])
            rotate([0, 0, -30])
                cube([0.5, 0.5, 3], center=true);
        translate([1.5, 0, 0])
            rotate([0, 0, 30])
                cube([0.5, 0.5, 3], center=true);
    }
}

module symbol_npc() {
    // NPC symbol - simple house/building
    union() {
        // Base
        cube([3, 0.5, 2], center=true);
        // Roof
        translate([0, 0, 1.5])
            hull() {
                translate([-1.5, 0, 0])
                    cylinder(h=0.5, r=0.3, center=true);
                translate([1.5, 0, 0])
                    cylinder(h=0.5, r=0.3, center=true);
                translate([0, 0, 1.5])
                    cylinder(h=0.5, r=0.3, center=true);
            }
    }
}

module symbol_neutral() {
    // Neutral symbol - diamond/crystal
    hull() {
        translate([0, 0, 1.5])
            cylinder(h=0.5, r=0.5, center=true);
        translate([0, 0, -1.5])
            cylinder(h=0.5, r=0.5, center=true);
        translate([1.5, 0, 0])
            cylinder(h=0.5, r=0.5, center=true);
        translate([-1.5, 0, 0])
            cylinder(h=0.5, r=0.5, center=true);
    }
}

// =============================================================================
// INITIATIVE TRACKING COMPONENTS
// =============================================================================

module initiative_slot(slot_number, participant_type = "neutral") {
    // Slot colors based on participant type
    slot_color = (participant_type == "player") ? COLOR_PLAYER :
                 (participant_type == "enemy") ? COLOR_ENEMY :
                 (participant_type == "npc") ? COLOR_NPC : COLOR_NEUTRAL;
    
    color(slot_color) {
        difference() {
            // Main plaque body
            rounded_cube([PLAQUE_WIDTH, PLAQUE_DEPTH, PLAQUE_HEIGHT], 0.5);
            
            if (ENABLE_CARD_SLOTS) {
                // Card slot for initiative cards or name tags
                translate([0, -PLAQUE_DEPTH/2 + 0.2, 1])
                    cube([CARD_SLOT_WIDTH, CARD_SLOT_DEPTH, CARD_SLOT_HEIGHT], center=true);
            }
            
            if (ENABLE_NUMBERS) {
                // Initiative order number (embossed)
                translate([PLAQUE_WIDTH/2 - 2, PLAQUE_DEPTH/2 - 0.2, -PLAQUE_HEIGHT/2 + 1])
                    linear_extrude(height=1)
                        text(str(slot_number), size=2, halign="center", valign="center");
            }
        }
        
        // Participant type symbol
        translate([0, PLAQUE_DEPTH/2 + 0.3, 0]) {
            if (participant_type == "player") symbol_player();
            else if (participant_type == "enemy") symbol_enemy();
            else if (participant_type == "npc") symbol_npc();
            else symbol_neutral();
        }
    }
}

module initiative_mounting_system() {
    // Mounting track for initiative slots
    color(COLOR_OBELISK) {
        for (i = [0:MAX_INITIATIVE_SLOTS-1]) {
            z_pos = SLOT_START_HEIGHT + i * SLOT_SPACING;
            
            // Calculate obelisk width at this height
            height_ratio = z_pos / OBELISK_HEIGHT;
            current_width = OBELISK_BASE_WIDTH - (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * height_ratio;
            
            translate([current_width/2 + 0.5, -2, z_pos]) {
                // Horizontal mounting rail
                cube([1, 6, 1], center=true);
                
                // Slot guides
                translate([PLAQUE_DEPTH/2, -2, 0])
                    cube([PLAQUE_DEPTH + 0.5, 1, PLAQUE_HEIGHT + 1], center=true);
                translate([PLAQUE_DEPTH/2, 2, 0])
                    cube([PLAQUE_DEPTH + 0.5, 1, PLAQUE_HEIGHT + 1], center=true);
            }
        }
    }
}

module obelisk_body() {
    difference() {
        // Main tapered obelisk
        hull() {
            translate([0, 0, 0])
                rounded_cube([OBELISK_BASE_WIDTH, OBELISK_BASE_WIDTH, 1], 1);
            translate([0, 0, OBELISK_HEIGHT])
                rounded_cube([OBELISK_TOP_WIDTH, OBELISK_TOP_WIDTH, 1], 1);
        }
        
        // Initiative order numbers on the obelisk face
        if (ENABLE_NUMBERS) {
            for (i = [1:MAX_INITIATIVE_SLOTS]) {
                z_pos = SLOT_START_HEIGHT + (i-1) * SLOT_SPACING;
                height_ratio = z_pos / OBELISK_HEIGHT;
                current_width = OBELISK_BASE_WIDTH - (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * height_ratio;
                
                translate([-current_width/2 + 1, 0, z_pos])
                    rotate([90, 0, 0])
                        linear_extrude(height=1)
                            text(str(i), size=3, halign="center", valign="center");
            }
        }
    }
}

module storage_base() {
    difference() {
        // Main base
        rounded_cube([BASE_WIDTH, BASE_DEPTH, BASE_HEIGHT], 2);
        
        if (ENABLE_BASE_STORAGE) {
            // Storage compartment for dice, extra plaques, etc.
            translate([0, 0, 2])
                rounded_cube([BASE_WIDTH-4, BASE_DEPTH-4, BASE_HEIGHT-2], 1);
            
            // Access slot
            translate([0, BASE_DEPTH/2 - 1, BASE_HEIGHT/2])
                cube([BASE_WIDTH-8, 2, 3], center=true);
        }
        
        // Corner recesses for stability
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * (BASE_WIDTH/2 - 3), y * (BASE_DEPTH/2 - 3), BASE_HEIGHT/2 - 1])
                    cylinder(h=2, r=2, center=true);
            }
        }
    }
    
    // Initiative tracker label
    translate([0, -BASE_DEPTH/2 + 2, BASE_HEIGHT/2 - 0.5])
        rotate([90, 0, 0])
            linear_extrude(height=0.5)
                text("INITIATIVE", size=3, halign="center", valign="center");
}

module round_counter() {
    // Simple round counter at the top
    translate([0, 0, BASE_HEIGHT + OBELISK_HEIGHT + 5]) {
        color([0.8, 0.7, 0.2]) {
            difference() {
                cylinder(h=3, r=4, center=true);
                cylinder(h=4, r=3, center=true);
                
                // Numbers around the edge for round tracking
                for (i = [1:10]) {
                    rotate([0, 0, i * 36])
                        translate([3.5, 0, 0])
                            rotate([90, 0, 0])
                                linear_extrude(height=0.5)
                                    text(str(i), size=1.5, halign="center", valign="center");
                }
            }
            
            // Center pointer/marker
            translate([0, 0, 2])
                cylinder(h=1, r=0.5, center=true);
        }
    }
}

// =============================================================================
// MAIN ASSEMBLY
// =============================================================================

module dnd_initiative_tracker() {
    // Base with storage
    color(COLOR_BASE)
        translate([0, 0, BASE_HEIGHT/2])
            storage_base();
    
    // Main obelisk structure
    translate([0, 0, BASE_HEIGHT]) {
        color(COLOR_OBELISK)
            obelisk_body();
        
        // Initiative slot mounting system
        initiative_mounting_system();
    }
    
    // Round counter
    round_counter();
    
    // Example initiative slots (remove in production, add as needed)
    translate([0, 0, BASE_HEIGHT]) {
        // Example: Player in slot 1
        translate([OBELISK_BASE_WIDTH/2 + PLAQUE_DEPTH, -2, SLOT_START_HEIGHT])
            rotate([0, 90, 0])
                initiative_slot(1, "player");
        
        // Example: Enemy in slot 2  
        translate([OBELISK_BASE_WIDTH/2 + PLAQUE_DEPTH, -2, SLOT_START_HEIGHT + SLOT_SPACING])
            rotate([0, 90, 0])
                initiative_slot(2, "enemy");
                
        // Example: NPC in slot 3
        translate([OBELISK_BASE_WIDTH/2 + PLAQUE_DEPTH, -2, SLOT_START_HEIGHT + 2*SLOT_SPACING])
            rotate([0, 90, 0])
                initiative_slot(3, "npc");
    }
}

// =============================================================================
// SEPARATE COMPONENTS FOR PRINTING
// =============================================================================

// Uncomment these for printing individual components:

// Main tracker
dnd_initiative_tracker();

// Additional initiative slots (print multiples as needed)
// translate([40, 0, 0]) initiative_slot(1, "player");
// translate([60, 0, 0]) initiative_slot(2, "enemy");
// translate([80, 0, 0]) initiative_slot(3, "npc");
// translate([100, 0, 0]) initiative_slot(4, "neutral");
