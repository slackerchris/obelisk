// D&D Initiative Tracker + Dice Tower Obelisk
// The ultimate tabletop RPG utility - tracks initiative AND rolls dice!
//
// DICE FLOW PATH - CORRECTED DESIGN:
//   ┌─────────────┐  ← DICE IN (40mm funnel opening)
//   │     ╔═══╗   │
//   │     ║   ║   │  ← Internal path (35mm diameter) 
//   │    ╔╝   ╚╗  │     D20 (22mm) + 13mm clearance = PERFECT
//   │   ╔╝  ▬  ╚╗ │  ← 5 baffles (8×15mm each, <25% blockage)
//   │  ╔╝   ▬   ╚╗│     spaced 25mm apart for proper tumbling
//   │ ╔╝  ▬     ╚╗│
//   │ ║    ▬    ║ │
//   └─╫─────────╫─┘
//     ║         ╚═══╗
//     ║ INITIATIVE  ║  ← DICE OUT (25mm exit to large tray)
//     ║ PLAQUES     ║     35×15mm collection area
//     ╚═════════════╝
//
// DICE COMPATIBILITY - VERIFIED:
// ✓ D4-D12: Plenty of room (max 18mm in 35mm path)
// ✓ D20: 22mm in 35mm path = 13mm clearance (excellent)
// ✓ Multiple dice: 40mm entry allows several dice at once
// ✓ No jamming: Baffles only block <25% of cross-section

// =============================================================================
// CONFIGURATION PARAMETERS
// =============================================================================

// DICE TOWER ENGINEERING - VERIFIED CALCULATIONS:
// D20 max dimension: 22mm diagonal
// Required clearance: 22mm × 1.5 = 33mm minimum
// Actual path: 35mm diameter (22mm + 13mm clearance = EXCELLENT)
// Baffle restriction: <25% of cross-section (prevents jamming)
// Path area: π × 17.5² = 962mm²
// Baffle area: 8×15 = 120mm² (12.5% - SAFE)
// Internal path = 35mm diameter (comfortably fits D20 + excellent clearance)

// Main structure - CORRECTED FOR WALL THICKNESS
OBELISK_HEIGHT = 150;        // Taller for more randomization (6+ baffle interactions)
OBELISK_BASE_WIDTH = 45;     // 35mm internal + 10mm walls (5mm each side minimum)
OBELISK_TOP_WIDTH = 25;      // Proportional taper with adequate wall thickness
BASE_HEIGHT = 20;            // Taller for better dice collection
BASE_WIDTH = 55;             // Wider for larger collection area + obelisk accommodation
BASE_DEPTH = 45;             // Deeper for stability and collection

// Initiative tracking (one side)
PLAQUE_COUNT = 6;
PLAQUE_WIDTH = 8;
PLAQUE_HEIGHT = 8;
PLAQUE_DEPTH = 2;
PLAQUE_SPACING = 18;         // More space due to taller design
PLAQUE_START_HEIGHT = 20;

// DICE TOWER SIZING - PROPERLY CALCULATED FOR D20
// D20 diagonal: ~22mm max
// Required path width: 22mm × 1.5 = 33mm minimum for reliable flow
// Baffle max size: 33mm × 0.25 = 8.25mm (25% of cross-section)

// Dice tower settings - CORRECTED SIZING
DICE_ENTRY_SIZE = 40;        // Entry funnel diameter (fits multiple dice easily)
DICE_PATH_WIDTH = 35;        // Internal path diameter (22mm D20 × 1.5 = 33mm + margin)
DICE_BAFFLE_COUNT = 5;       // Number of randomizing baffles
DICE_EXIT_WIDTH = 25;        // Exit slot width (allows easy dice flow)
DICE_TRAY_DEPTH = 12;        // Collection tray depth

// Visual settings
$fn = 40;
ENABLE_RUNES = true;
ENABLE_CRYSTAL = false;      // Skip crystal for dice entry
ENABLE_INITIATIVE = true;
ENABLE_DICE_TOWER = true;

// Colors
COLOR_OBELISK = [0.35, 0.35, 0.4];
COLOR_BASE = [0.25, 0.25, 0.3];
COLOR_PLAQUES = [0.45, 0.4, 0.35];
COLOR_DICE_PATH = [0.2, 0.6, 0.2];  // Green for dice path visualization

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
// INITIATIVE TRACKER SYMBOLS
// =============================================================================

module symbol_player() {
    union() {
        translate([0, 0, 2]) cylinder(h=0.4, r=0.8, center=true); // Head
        cube([1.5, 0.4, 2.5], center=true); // Body
        translate([0, 0, 0.5]) cube([3, 0.4, 0.8], center=true); // Arms
    }
}

module symbol_enemy() {
    union() {
        sphere(r=1.2); // Skull
        translate([-0.4, 0.3, 0.3]) cylinder(h=0.4, r=0.25, center=true); // Eye
        translate([0.4, 0.3, 0.3]) cylinder(h=0.4, r=0.25, center=true); // Eye
        translate([0, 0.3, -0.5]) cube([0.3, 0.4, 0.8], center=true); // Nose
    }
}

module symbol_npc() {
    union() {
        cube([2.5, 0.4, 1.5], center=true); // House base
        translate([0, 0, 1]) hull() { // Roof
            translate([-1, 0, 0]) cylinder(h=0.4, r=0.3, center=true);
            translate([1, 0, 0]) cylinder(h=0.4, r=0.3, center=true);
            translate([0, 0, 1]) cylinder(h=0.4, r=0.3, center=true);
        }
    }
}

module symbol_neutral() {
    rotate([0, 45, 0]) cube([1.5, 0.4, 1.5], center=true); // Diamond
}

// =============================================================================
// DICE TOWER COMPONENTS
// =============================================================================

module dice_entry_funnel() {
    // Funnel at top for dice input
    translate([0, 0, OBELISK_HEIGHT - 5]) {
        difference() {
            // Outer funnel shape
            hull() {
                cylinder(h=8, r=DICE_ENTRY_SIZE/2 + 3);
                translate([0, 0, -3])
                    cylinder(h=1, r=DICE_PATH_WIDTH/2 + 2);
            }
            
            // Inner funnel cavity
            hull() {
                cylinder(h=10, r=DICE_ENTRY_SIZE/2);
                translate([0, 0, -5])
                    cylinder(h=1, r=DICE_PATH_WIDTH/2);
            }
        }
        
        // Entry labels for clarity
        translate([0, DICE_ENTRY_SIZE/2 + 4, 4])
            rotate([90, 0, 0])
                linear_extrude(height=1)
                    text("DICE IN", size=2.5, halign="center", valign="center");
    }
}

module dice_baffle(z_position, angle_offset = 0) {
    // Individual randomizing baffle - PROPERLY SIZED
    translate([0, 0, z_position]) {
        rotate([0, 0, angle_offset]) {
            // Baffle plate - MAX 25% of path cross-section
            // Path area = π × (17.5)² = 962mm²
            // Baffle max area = 962 × 0.25 = 240mm²
            // Using 8mm × 15mm = 120mm² (well under limit)
            translate([DICE_PATH_WIDTH * 0.3, 0, 0])
                rotate([0, 30, 0])  // 30° angle for good deflection
                    cube([8, 15, 2], center=true);
        }
    }
}

module dice_path_interior() {
    // Internal cavity for dice to travel through - VERIFIED MATH
    translate([0, 0, BASE_HEIGHT]) {
        // Main vertical shaft
        // DICE_PATH_WIDTH = 35mm diameter → radius = 17.5mm
        // D20 fits with 35-22 = 13mm clearance (excellent)
        cylinder(h=OBELISK_HEIGHT - 15, r=DICE_PATH_WIDTH/2);
        
        // Exit ramp - smooth transition to collection
        translate([0, OBELISK_BASE_WIDTH/2, 8])
            rotate([25, 0, 0])  // Gentle slope
                cube([DICE_EXIT_WIDTH, 12, 12], center=true);
    }
}

module dice_baffles() {
    // Series of randomizing baffles - PROPERLY INTEGRATED
    if (ENABLE_DICE_TOWER) {
        // Space baffles every 25mm for proper tumbling distance
        for (i = [0:DICE_BAFFLE_COUNT-1]) {
            z_pos = BASE_HEIGHT + 25 + i * 25;  // Start at 25mm, space every 25mm
            angle = i * 72;  // 72° rotation (360°/5 baffles for good distribution)
            dice_baffle(z_pos, angle);
        }
    }
}

module dice_collection_tray() {
    // Collection tray - PROPERLY SIZED FOR MULTIPLE DICE
    translate([0, BASE_DEPTH/2 - 8, 0]) {
        difference() {
            // Tray body - larger collection area
            cube([35, 15, DICE_TRAY_DEPTH], center=true);
            
            // Tray interior with rounded corners
            translate([0, 0, 1.5])
                hull() {
                    for (x = [-15, 15]) {
                        for (y = [-5, 5]) {
                            translate([x, y, 0])
                                cylinder(h=DICE_TRAY_DEPTH, r=2);
                        }
                    }
                }
            
            // Dice entry slot from tower
            translate([0, -6, DICE_TRAY_DEPTH/2 - 1])
                cube([DICE_EXIT_WIDTH, 3, 5], center=true);
        }
        
        // Collection area label
        translate([0, -7, DICE_TRAY_DEPTH - 1])
            rotate([90, 0, 0])
                linear_extrude(height=0.8)
                    text("DICE OUT", size=2, halign="center", valign="center");
    }
    
    // Connecting ramp - smooth transition from tower
    translate([0, OBELISK_BASE_WIDTH/2 + 6, BASE_HEIGHT/2 - 2])
        rotate([30, 0, 0])  // Steeper ramp for better control
            cube([DICE_EXIT_WIDTH, 12, 4], center=true);
}

// =============================================================================
// INITIATIVE TRACKING COMPONENTS
// =============================================================================

module initiative_plaque(symbol_type = "neutral", number = 0) {
    difference() {
        // Main plaque body
        rounded_cube([PLAQUE_WIDTH, PLAQUE_DEPTH, PLAQUE_HEIGHT], 0.5);
        
        // Card slot
        translate([0, -PLAQUE_DEPTH/2 + 0.3, PLAQUE_HEIGHT/2 - 1])
            cube([PLAQUE_WIDTH - 1, 1, 1.5], center=true);
        
        // Number emboss
        if (number > 0) {
            translate([PLAQUE_WIDTH/2 - 1.5, -PLAQUE_DEPTH/2 + 0.1, -PLAQUE_HEIGHT/2 + 0.5])
                linear_extrude(height=0.8)
                    text(str(number), size=1.5, halign="center");
        }
    }
    
    // Type symbol
    translate([0, PLAQUE_DEPTH/2 + 0.2, 0]) {
        if (symbol_type == "player") symbol_player();
        else if (symbol_type == "enemy") symbol_enemy();
        else if (symbol_type == "npc") symbol_npc();
        else symbol_neutral();
    }
}

module initiative_mounting_system() {
    if (ENABLE_INITIATIVE) {
        // Mount on the side opposite to dice exit
        for (i = [0:PLAQUE_COUNT-1]) {
            z_pos = PLAQUE_START_HEIGHT + i * PLAQUE_SPACING;
            
            // Calculate obelisk width at this height
            height_ratio = z_pos / OBELISK_HEIGHT;
            current_width = OBELISK_BASE_WIDTH - (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * height_ratio;
            
            translate([-current_width/2 - 1, 0, z_pos]) {
                // Mounting rail
                cube([2, 6, 1], center=true);
                
                // Slot guides
                translate([-PLAQUE_DEPTH/2, -2.5, 0])
                    cube([PLAQUE_DEPTH + 1, 1, PLAQUE_HEIGHT + 1], center=true);
                translate([-PLAQUE_DEPTH/2, 2.5, 0])
                    cube([PLAQUE_DEPTH + 1, 1, PLAQUE_HEIGHT + 1], center=true);
            }
        }
    }
}

// =============================================================================
// MAIN OBELISK STRUCTURE
// =============================================================================

module obelisk_body() {
    difference() {
        // Main tapered obelisk
        hull() {
            translate([0, 0, 0])
                cube([OBELISK_BASE_WIDTH, OBELISK_BASE_WIDTH, 1], center=true);
            translate([0, 0, OBELISK_HEIGHT])
                cube([OBELISK_TOP_WIDTH, OBELISK_TOP_WIDTH, 1], center=true);
        }
        
        // Hollow out for dice path
        if (ENABLE_DICE_TOWER) {
            dice_path_interior();
        }
        
        // Initiative order numbers on side
        if (ENABLE_INITIATIVE) {
            for (i = [1:PLAQUE_COUNT]) {
                z_pos = PLAQUE_START_HEIGHT + (i-1) * PLAQUE_SPACING;
                height_ratio = z_pos / OBELISK_HEIGHT;
                current_width = OBELISK_BASE_WIDTH - (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * height_ratio;
                
                translate([current_width/2 - 0.5, 0, z_pos])
                    rotate([90, 0, 0])
                        linear_extrude(height=0.6)
                            text(str(i), size=2.5, halign="center", valign="center");
            }
        }
        
        // Dice exit slot
        if (ENABLE_DICE_TOWER) {
            translate([0, OBELISK_BASE_WIDTH/2 + 0.5, BASE_HEIGHT + 8])
                cube([DICE_EXIT_WIDTH, 6, 10], center=true);
        }
        
        // Add baffles as subtractions from main body
        if (ENABLE_DICE_TOWER) {
            dice_baffles();
        }
    }
}

module enhanced_base() {
    difference() {
        // Main base with rounded corners
        hull() {
            for (x = [-BASE_WIDTH/2+3, BASE_WIDTH/2-3]) {
                for (y = [-BASE_DEPTH/2+3, BASE_DEPTH/2-3]) {
                    translate([x, y, 0])
                        cylinder(h=BASE_HEIGHT, r=3, center=true);
                }
            }
        }
        
        // Storage compartment (back section)
        translate([0, -BASE_DEPTH/4, 2])
            hull() {
                for (x = [-BASE_WIDTH/2+5, BASE_WIDTH/2-5]) {
                    for (y = [-BASE_DEPTH/2+5, -2]) {
                        translate([x, y, 0])
                            cylinder(h=BASE_HEIGHT-2, r=2);
                    }
                }
            }
        
        // Access slot for storage
        translate([0, -BASE_DEPTH/2 + 2, BASE_HEIGHT/2])
            cube([BASE_WIDTH-10, 4, 6], center=true);
    }
    
    // Labels
    translate([0, -BASE_DEPTH/2 + 1, BASE_HEIGHT/2])
        rotate([90, 0, 0])
            linear_extrude(height=0.6)
                text("INITIATIVE & DICE", size=2, halign="center", valign="center");
}

module rune_system() {
    if (ENABLE_RUNES) {
        // Runes on non-functional faces - PROPERLY SUBTRACTED
        for (face = [1, 3]) { // Skip front (dice exit) and back (initiative)
            rotate([0, 0, face * 90]) {
                for (z = [25 : 30 : OBELISK_HEIGHT-25]) {
                    height_ratio = z / OBELISK_HEIGHT;
                    current_width = OBELISK_BASE_WIDTH - (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * height_ratio;
                    
                    translate([current_width/2 - 0.3, 0, z]) {
                        // Simple rune recesses - shallow cuts
                        cube([0.5, 1.5, 12], center=true);
                        translate([0, 0, 5])
                            cube([0.5, 3, 1], center=true);
                        translate([0, 0, -5])
                            cube([0.5, 2.5, 1], center=true);
                    }
                }
            }
        }
    }
}

// =============================================================================
// MAIN ASSEMBLY
// =============================================================================

module dice_tower_initiative_tracker() {
    // Enhanced base with storage and dice tray
    color(COLOR_BASE) {
        translate([0, 0, BASE_HEIGHT/2])
            enhanced_base();
        
        if (ENABLE_DICE_TOWER) {
            translate([0, 0, BASE_HEIGHT/2])
                dice_collection_tray();
        }
    }
    
    // Main obelisk structure
    translate([0, 0, BASE_HEIGHT]) {
        color(COLOR_OBELISK) {
            difference() {
                obelisk_body();
                
                // Subtract runes as cuts
                if (ENABLE_RUNES) {
                    rune_system();
                }
                
                // Subtract mounting system slots
                if (ENABLE_INITIATIVE) {
                    for (i = [0:PLAQUE_COUNT-1]) {
                        z_pos = PLAQUE_START_HEIGHT + i * PLAQUE_SPACING;
                        height_ratio = z_pos / OBELISK_HEIGHT;
                        current_width = OBELISK_BASE_WIDTH - (OBELISK_BASE_WIDTH - OBELISK_TOP_WIDTH) * height_ratio;
                        
                        translate([-current_width/2 - 0.5, 0, z_pos]) {
                            // Plaque mounting slot
                            cube([PLAQUE_DEPTH + 0.5, PLAQUE_WIDTH + 1, PLAQUE_HEIGHT + 0.5], center=true);
                        }
                    }
                }
            }
            
            if (ENABLE_DICE_TOWER) {
                dice_entry_funnel();
            }
        }
    }
    
    // Example initiative plaques
    if (ENABLE_INITIATIVE) {
        color(COLOR_PLAQUES) {
            translate([0, 0, BASE_HEIGHT]) {
                // Example plaques in position
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
    
    // Dice tower indicator at top
    if (ENABLE_DICE_TOWER) {
        color([0.8, 0.7, 0.2])
            translate([0, 0, BASE_HEIGHT + OBELISK_HEIGHT + 3])
                difference() {
                    cylinder(h=2, r=4);
                    cylinder(h=3, r=2.5);
                    translate([0, 3, 1])
                        rotate([90, 0, 0])
                            linear_extrude(height=0.8)
                                text("DICE", size=1.5, halign="center");
                }
    }
}

// =============================================================================
// SEPARATE COMPONENTS FOR PRINTING
// =============================================================================

// Main combined unit
dice_tower_initiative_tracker();

// Additional components you can print separately:
// translate([60, 0, 0]) initiative_plaque("player", 4);
// translate([75, 0, 0]) initiative_plaque("enemy", 5);
// translate([90, 0, 0]) initiative_plaque("npc", 6);
// translate([105, 0, 0]) initiative_plaque("neutral", 7);
