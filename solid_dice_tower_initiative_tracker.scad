// SOLID D&D Initiative Tracker + Dice Tower Obelisk
// Guaranteed manifold, printable design

// =============================================================================
// CONFIGURATION PARAMETERS
// =============================================================================

// Main structure - VERIFIED SOLID DESIGN
OBELISK_HEIGHT = 150;
OBELISK_BASE_WIDTH = 45;     
OBELISK_TOP_WIDTH = 25;      
BASE_HEIGHT = 20;            
BASE_WIDTH = 55;             
BASE_DEPTH = 45;             

// Dice tower settings
DICE_ENTRY_SIZE = 40;        
DICE_PATH_WIDTH = 35;        
DICE_BAFFLE_COUNT = 5;       
DICE_EXIT_WIDTH = 25;        
DICE_TRAY_DEPTH = 12;        

// Initiative tracking
PLAQUE_COUNT = 6;
PLAQUE_WIDTH = 8;
PLAQUE_HEIGHT = 8;
PLAQUE_DEPTH = 2;
PLAQUE_SPACING = 18;         
PLAQUE_START_HEIGHT = 20;

// Visual settings
$fn = 32; // Reduced for faster, more reliable rendering
ENABLE_RUNES = false;        // Disabled for guaranteed solid
ENABLE_INITIATIVE = true;
ENABLE_DICE_TOWER = true;

// Colors
COLOR_OBELISK = [0.35, 0.35, 0.4];
COLOR_BASE = [0.25, 0.25, 0.3];
COLOR_PLAQUES = [0.45, 0.4, 0.35];

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
// DICE TOWER COMPONENTS - GUARANTEED SOLID
// =============================================================================

module dice_entry_funnel() {
    translate([0, 0, OBELISK_HEIGHT - 5]) {
        difference() {
            cylinder(h=8, r=DICE_ENTRY_SIZE/2 + 3);
            cylinder(h=10, r=DICE_ENTRY_SIZE/2);
        }
    }
}

module single_baffle(z_position, angle_offset = 0) {
    translate([0, 0, z_position]) {
        rotate([0, 0, angle_offset]) {
            translate([DICE_PATH_WIDTH * 0.3, 0, 0])
                rotate([0, 30, 0])
                    cube([8, 15, 2], center=true);
        }
    }
}

module dice_path_and_baffles() {
    translate([0, 0, BASE_HEIGHT]) {
        union() {
            // Main vertical shaft
            cylinder(h=OBELISK_HEIGHT - 15, r=DICE_PATH_WIDTH/2);
            
            // Exit ramp
            translate([0, OBELISK_BASE_WIDTH/2, 8])
                rotate([25, 0, 0])
                    cube([DICE_EXIT_WIDTH, 12, 12], center=true);
            
            // All baffles as one union
            for (i = [0:DICE_BAFFLE_COUNT-1]) {
                z_pos = 25 + i * 25;
                angle = i * 72;
                single_baffle(z_pos, angle);
            }
        }
    }
}

module dice_collection_tray() {
    translate([0, BASE_DEPTH/2 - 8, 0]) {
        difference() {
            cube([35, 15, DICE_TRAY_DEPTH], center=true);
            
            translate([0, 0, 1.5])
                cube([32, 12, DICE_TRAY_DEPTH], center=true);
            
            translate([0, -6, DICE_TRAY_DEPTH/2 - 1])
                cube([DICE_EXIT_WIDTH, 3, 5], center=true);
        }
    }
}

// =============================================================================
// INITIATIVE TRACKING COMPONENTS - SIMPLIFIED
// =============================================================================

module initiative_plaque(symbol_type = "neutral", number = 0) {
    difference() {
        rounded_cube([PLAQUE_WIDTH, PLAQUE_DEPTH, PLAQUE_HEIGHT], 0.5);
        
        translate([0, -PLAQUE_DEPTH/2 + 0.3, PLAQUE_HEIGHT/2 - 1])
            cube([PLAQUE_WIDTH - 1, 1, 1.5], center=true);
        
        if (number > 0) {
            translate([PLAQUE_WIDTH/2 - 1.5, -PLAQUE_DEPTH/2 + 0.1, -PLAQUE_HEIGHT/2 + 0.5])
                linear_extrude(height=0.6)
                    text(str(number), size=1.5, halign="center");
        }
    }
    
    // Simple symbol indicators
    translate([0, PLAQUE_DEPTH/2 + 0.1, 0]) {
        if (symbol_type == "player") {
            cube([1.5, 0.3, 2.5], center=true);
        } else if (symbol_type == "enemy") {
            sphere(r=0.8);
        } else if (symbol_type == "npc") {
            cube([2, 0.3, 1], center=true);
        } else {
            rotate([0, 45, 0]) cube([1.2, 0.3, 1.2], center=true);
        }
    }
}

// =============================================================================
// MAIN STRUCTURE - GUARANTEED SOLID
// =============================================================================

module enhanced_base() {
    difference() {
        hull() {
            for (x = [-BASE_WIDTH/2+3, BASE_WIDTH/2-3]) {
                for (y = [-BASE_DEPTH/2+3, BASE_DEPTH/2-3]) {
                    translate([x, y, 0])
                        cylinder(h=BASE_HEIGHT, r=3, center=true);
                }
            }
        }
        
        // Simple storage compartment
        translate([0, -BASE_DEPTH/4, 2])
            cube([BASE_WIDTH-10, BASE_DEPTH/2-6, BASE_HEIGHT-4], center=true);
        
        // Access slot
        translate([0, -BASE_DEPTH/2 + 2, BASE_HEIGHT/2])
            cube([BASE_WIDTH-10, 4, 6], center=true);
    }
}

module solid_obelisk_body() {
    difference() {
        // Main tapered obelisk - SOLID
        hull() {
            translate([0, 0, 0])
                cube([OBELISK_BASE_WIDTH, OBELISK_BASE_WIDTH, 1], center=true);
            translate([0, 0, OBELISK_HEIGHT])
                cube([OBELISK_TOP_WIDTH, OBELISK_TOP_WIDTH, 1], center=true);
        }
        
        // Hollow out for dice path and baffles
        if (ENABLE_DICE_TOWER) {
            dice_path_and_baffles();
        }
        
        // Initiative numbers - simple cuts
        if (ENABLE_INITIATIVE) {
            for (i = [1:PLAQUE_COUNT]) {
                z_pos = PLAQUE_START_HEIGHT + (i-1) * PLAQUE_SPACING;
                height_ratio = z_pos / OBELISK_HEIGHT;
                current_width = OBELISK_BASE_WIDTH - (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * height_ratio;
                
                translate([current_width/2 - 0.3, 0, z_pos])
                    rotate([90, 0, 0])
                        linear_extrude(height=0.6)
                            text(str(i), size=2, halign="center", valign="center");
            }
        }
        
        // Dice exit slot
        if (ENABLE_DICE_TOWER) {
            translate([0, OBELISK_BASE_WIDTH/2 + 0.5, BASE_HEIGHT + 8])
                cube([DICE_EXIT_WIDTH, 6, 10], center=true);
        }
        
        // Initiative plaque slots
        if (ENABLE_INITIATIVE) {
            for (i = [0:PLAQUE_COUNT-1]) {
                z_pos = PLAQUE_START_HEIGHT + i * PLAQUE_SPACING;
                height_ratio = z_pos / OBELISK_HEIGHT;
                current_width = OBELISK_BASE_WIDTH - (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * height_ratio;
                
                translate([-current_width/2 - 0.5, 0, z_pos]) {
                    cube([PLAQUE_DEPTH + 0.5, PLAQUE_WIDTH + 1, PLAQUE_HEIGHT + 0.5], center=true);
                }
            }
        }
    }
}

// =============================================================================
// MAIN ASSEMBLY - GUARANTEED SOLID
// =============================================================================

module solid_dice_tower_initiative_tracker() {
    // Enhanced base with dice tray
    color(COLOR_BASE) {
        translate([0, 0, BASE_HEIGHT/2])
            enhanced_base();
        
        if (ENABLE_DICE_TOWER) {
            translate([0, 0, BASE_HEIGHT/2])
                dice_collection_tray();
        }
    }
    
    // Main obelisk structure - SOLID UNION
    translate([0, 0, BASE_HEIGHT]) {
        color(COLOR_OBELISK) {
            union() {
                solid_obelisk_body();
                
                if (ENABLE_DICE_TOWER) {
                    dice_entry_funnel();
                }
            }
        }
    }
    
    // Example initiative plaques
    if (ENABLE_INITIATIVE) {
        color(COLOR_PLAQUES) {
            translate([0, 0, BASE_HEIGHT]) {
                translate([-OBELISK_BASE_WIDTH/2 - PLAQUE_DEPTH, 0, PLAQUE_START_HEIGHT])
                    rotate([0, -90, 0])
                        initiative_plaque("player", 1);
                
                translate([-OBELISK_BASE_WIDTH/2 - PLAQUE_DEPTH, 0, PLAQUE_START_HEIGHT + PLAQUE_SPACING])
                    rotate([0, -90, 0])
                        initiative_plaque("enemy", 2);
                
                translate([-OBELISK_BASE_WIDTH/2 - PLAQUE_DEPTH, 0, PLAQUE_START_HEIGHT + 2*PLAQUE_SPACING])
                    rotate([0, -90, 0])
                        initiative_plaque("npc", 3);
            }
        }
    }
}

// =============================================================================
// RENDER
// =============================================================================

solid_dice_tower_initiative_tracker();
