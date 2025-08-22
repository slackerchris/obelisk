// Fantasy Obelisk with Decorative Plaques
// Recreated from reference image

// Global parameters
$fn = 50; // Circle resolution

// Main dimensions
obelisk_height = 120;
obelisk_base_width = 20;
obelisk_top_width = 12;
base_height = 15;
base_width = 35;
base_depth = 25;

// Plaque dimensions
plaque_width = 8;
plaque_height = 8;
plaque_depth = 1.5;
plaque_spacing = 12;

// Colors
obelisk_color = [0.4, 0.4, 0.5]; // Dark grey
base_color = [0.3, 0.3, 0.35]; // Darker grey
plaque_color = [0.5, 0.5, 0.4]; // Lighter grey/bronze

module obelisk_main() {
    // Main obelisk body - tapered from base to top
    hull() {
        // Bottom
        translate([0, 0, 0])
            cube([obelisk_base_width, obelisk_base_width, 1], center=true);
        
        // Top
        translate([0, 0, obelisk_height])
            cube([obelisk_top_width, obelisk_top_width, 1], center=true);
    }
}

module decorative_plaque(symbol_type = 0) {
    difference() {
        // Main plaque body
        cube([plaque_width, plaque_depth, plaque_height], center=true);
        
        // Decorative inset
        translate([0, -0.5, 0])
            cube([plaque_width-1, plaque_depth, plaque_height-1], center=true);
    }
    
    // Symbol on plaque (simplified representations)
    translate([0, plaque_depth/2 + 0.2, 0]) {
        if (symbol_type == 0) {
            // Sword symbol
            cube([1, 0.5, 6], center=true);
            translate([0, 0, 2])
                cube([3, 0.5, 1], center=true);
        } else if (symbol_type == 1) {
            // Shield symbol
            hull() {
                translate([0, 0, 1])
                    cube([4, 0.5, 1], center=true);
                translate([0, 0, -1])
                    cylinder(h=0.5, r=1.5, center=true);
            }
        } else if (symbol_type == 2) {
            // Skull symbol (simplified)
            translate([0, 0, 1])
                cube([3, 0.5, 2], center=true);
            translate([0, 0, -1])
                cube([2, 0.5, 1], center=true);
        } else if (symbol_type == 3) {
            // Hammer/Tool symbol
            cube([4, 0.5, 1], center=true);
            translate([0, 0, 1.5])
                cube([1, 0.5, 2], center=true);
        } else if (symbol_type == 4) {
            // Wizard hat symbol
            hull() {
                cylinder(h=0.5, r=2, center=true);
                translate([0, 0, 3])
                    cylinder(h=0.5, r=0.5, center=true);
            }
        }
    }
}

module stone_base() {
    difference() {
        // Main base
        cube([base_width, base_depth, base_height], center=true);
        
        // Create cobblestone texture effect
        for (x = [-base_width/2+2 : 4 : base_width/2-2]) {
            for (y = [-base_depth/2+2 : 4 : base_depth/2-2]) {
                for (z = [0 : 3 : base_height-2]) {
                    translate([x + (rands(-1, 1, 1)[0]), 
                              y + (rands(-1, 1, 1)[0]), 
                              z - base_height/2])
                        cube([2.5, 2.5, 1], center=true);
                }
            }
        }
    }
}

module rune_pattern() {
    // Simplified rune patterns on obelisk faces
    for (z = [20 : 15 : obelisk_height-20]) {
        translate([obelisk_base_width/2 + 0.1, 0, z]) {
            // Vertical line
            cube([0.5, 1, 8], center=true);
            // Horizontal accents
            translate([0, 0, 3])
                cube([0.5, 3, 1], center=true);
            translate([0, 0, -3])
                cube([0.5, 2, 1], center=true);
        }
        
        // Mirror on opposite side
        translate([-obelisk_base_width/2 - 0.1, 0, z]) {
            cube([0.5, 1, 8], center=true);
            translate([0, 0, 3])
                cube([0.5, 3, 1], center=true);
            translate([0, 0, -3])
                cube([0.5, 2, 1], center=true);
        }
    }
}

module plaque_mounting_posts() {
    // Small posts/connectors for plaques
    for (i = [0:4]) {
        translate([obelisk_base_width/2 + plaque_depth/2, -3, 15 + i * plaque_spacing]) {
            rotate([0, 90, 0])
                cylinder(h=2, r=0.5, center=true);
        }
    }
}

// Main assembly
module fantasy_obelisk() {
    // Stone base
    color(base_color)
        translate([0, 0, base_height/2])
            stone_base();
    
    // Main obelisk
    color(obelisk_color) {
        translate([0, 0, base_height])
            obelisk_main();
        
        // Rune patterns
        translate([0, 0, base_height])
            rune_pattern();
        
        // Plaque mounting posts
        translate([0, 0, base_height])
            plaque_mounting_posts();
    }
    
    // Decorative plaques
    color(plaque_color) {
        for (i = [0:4]) {
            translate([obelisk_base_width/2 + plaque_depth, -3, base_height + 15 + i * plaque_spacing]) {
                rotate([0, 90, 0])
                    decorative_plaque(i);
            }
        }
    }
    
    // Top ornament/crystal (simplified)
    color([0.2, 0.4, 0.8, 0.7]) // Semi-transparent blue
        translate([0, 0, base_height + obelisk_height + 3])
            hull() {
                cylinder(h=1, r=3, center=true);
                translate([0, 0, 8])
                    cylinder(h=1, r=1, center=true);
            }
}

// Render the complete obelisk
fantasy_obelisk();

// Optional: Add a platform/ground plane
color([0.2, 0.2, 0.2])
    translate([0, 0, -2])
        cube([60, 50, 2], center=true);
