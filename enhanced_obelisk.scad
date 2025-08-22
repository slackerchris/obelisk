// Advanced Fantasy Obelisk with Enhanced Details
// This version includes more detailed textures and symbols

$fn = 60;

// Enhanced parameters
obelisk_height = 120;
obelisk_base_width = 20;
obelisk_top_width = 12;
base_height = 15;
base_width = 35;
base_depth = 25;

// Advanced plaque system
plaque_width = 8;
plaque_height = 8;
plaque_depth = 1.5;
plaque_spacing = 12;
plaque_count = 5;

module textured_obelisk() {
    difference() {
        // Main tapered obelisk
        hull() {
            translate([0, 0, 0])
                cube([obelisk_base_width, obelisk_base_width, 1], center=true);
            translate([0, 0, obelisk_height])
                cube([obelisk_top_width, obelisk_top_width, 1], center=true);
        }
        
        // Add subtle panel lines
        for (z = [10 : 20 : obelisk_height-10]) {
            translate([0, obelisk_base_width/2 + 0.2, z])
                cube([obelisk_base_width-2, 1, 2], center=true);
        }
    }
}

module enhanced_runes() {
    // More complex rune patterns
    for (face = [0:3]) {
        rotate([0, 0, face * 90]) {
            translate([obelisk_base_width/2 + 0.2, 0, 0]) {
                // Vertical rune line
                for (z = [15 : 25 : obelisk_height-15]) {
                    // Main vertical element
                    translate([0, 0, z])
                        cube([0.8, 1.5, 12], center=true);
                    
                    // Cross elements
                    translate([0, 0, z + 4])
                        cube([0.8, 4, 1], center=true);
                    translate([0, 0, z - 4])
                        cube([0.8, 3, 1], center=true);
                    
                    // Diagonal accents
                    translate([0, 1, z + 2])
                        rotate([0, 0, 45])
                            cube([0.8, 2, 1], center=true);
                    translate([0, -1, z - 2])
                        rotate([0, 0, -45])
                            cube([0.8, 2, 1], center=true);
                }
            }
        }
    }
}

module detailed_plaque(symbol_id) {
    difference() {
        union() {
            // Main plaque body with beveled edges
            hull() {
                cube([plaque_width-0.5, plaque_depth-0.5, plaque_height-0.5], center=true);
                translate([0, 0.2, 0])
                    cube([plaque_width, plaque_depth, plaque_height], center=true);
            }
            
            // Border rim
            difference() {
                cube([plaque_width, plaque_depth, plaque_height], center=true);
                translate([0, -0.3, 0])
                    cube([plaque_width-1, plaque_depth, plaque_height-1], center=true);
            }
        }
        
        // Recessed area for symbol
        translate([0, -0.2, 0])
            cube([plaque_width-1.5, plaque_depth-0.5, plaque_height-1.5], center=true);
    }
    
    // Detailed symbols
    translate([0, plaque_depth/2 + 0.3, 0]) {
        if (symbol_id == 0) {
            // Detailed sword
            cube([0.8, 0.6, 5], center=true); // Blade
            translate([0, 0, 2.5])
                cube([2.5, 0.6, 0.8], center=true); // Crossguard
            translate([0, 0, 3.2])
                cube([0.6, 0.6, 1.5], center=true); // Handle
            translate([0, 0, 4])
                sphere(r=0.4); // Pommel
        } else if (symbol_id == 1) {
            // Detailed shield
            difference() {
                hull() {
                    translate([0, 0, 1.5])
                        cube([3.5, 0.6, 1], center=true);
                    translate([0, 0, -1.5])
                        cylinder(h=0.6, r=1.5, center=true);
                }
                translate([0, 0, 0])
                    cube([1, 1, 4], center=true); // Cross pattern
                translate([0, 0, 0])
                    cube([4, 1, 1], center=true);
            }
        } else if (symbol_id == 2) {
            // Detailed skull
            translate([0, 0, 0.5])
                sphere(r=1.5); // Main skull
            translate([-0.5, 0.3, 0.8])
                cylinder(h=0.6, r=0.3, center=true); // Eye socket
            translate([0.5, 0.3, 0.8])
                cylinder(h=0.6, r=0.3, center=true); // Eye socket
            translate([0, 0.3, 0])
                cube([0.3, 0.6, 1], center=true); // Nasal cavity
        } else if (symbol_id == 3) {
            // War hammer
            translate([0, 0, -1])
                cube([0.6, 0.6, 4], center=true); // Handle
            translate([0, 0, 1.5]) {
                cube([3, 0.8, 1.2], center=true); // Hammer head
                translate([1.2, 0, 0])
                    cube([0.8, 0.8, 2], center=true); // Spike
            }
        } else if (symbol_id == 4) {
            // Wizard hat
            difference() {
                hull() {
                    cylinder(h=0.6, r=1.8, center=true);
                    translate([0, 0, 3.5])
                        sphere(r=0.4);
                }
                translate([0, 0, 1])
                    rotate([0, 0, 45])
                        cube([0.3, 3, 0.6], center=true); // Star pattern
                translate([0, 0, 1])
                    rotate([0, 0, -45])
                        cube([0.3, 3, 0.6], center=true);
            }
        }
    }
}

module enhanced_stone_base() {
    difference() {
        // Main base with rounded corners
        hull() {
            for (x = [-base_width/2+2, base_width/2-2]) {
                for (y = [-base_depth/2+2, base_depth/2-2]) {
                    translate([x, y, 0])
                        cylinder(h=base_height, r=2, center=true);
                }
            }
        }
        
        // Detailed stone block pattern
        for (layer = [0:2]) {
            z_offset = layer * 5 - base_height/2 + 2;
            for (x = [-base_width/2+3 : 6 : base_width/2-3]) {
                for (y = [-base_depth/2+3 : 6 : base_depth/2-3]) {
                    translate([x + (layer % 2) * 3, y, z_offset]) {
                        // Individual stone block
                        difference() {
                            cube([5.5, 5.5, 4.5], center=true);
                            // Mortar gaps
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

module plaque_connector_system() {
    for (i = [0:plaque_count-1]) {
        translate([obelisk_base_width/2 + 0.5, -3, 15 + i * plaque_spacing]) {
            // Connection post
            rotate([0, 90, 0])
                cylinder(h=plaque_depth + 1, r=0.4, center=true);
            
            // Decorative mounting bracket
            translate([plaque_depth/2, 0, 0])
                cube([0.5, 2, 2], center=true);
        }
    }
}

module crystal_top() {
    translate([0, 0, base_height + obelisk_height]) {
        // Multi-faceted crystal
        color([0.1, 0.3, 0.8, 0.8]) {
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
            
            // Inner glow effect (simplified)
            translate([0, 0, 4])
                sphere(r=2);
        }
    }
}

// Main assembly with enhanced details
module complete_fantasy_obelisk() {
    // Enhanced stone base
    color([0.25, 0.25, 0.3])
        translate([0, 0, base_height/2])
            enhanced_stone_base();
    
    // Main obelisk with textures
    color([0.35, 0.35, 0.4]) {
        translate([0, 0, base_height])
            textured_obelisk();
        
        // Enhanced rune system
        translate([0, 0, base_height])
            enhanced_runes();
        
        // Plaque mounting system
        translate([0, 0, base_height])
            plaque_connector_system();
    }
    
    // Detailed plaques
    color([0.45, 0.4, 0.35]) {
        for (i = [0:plaque_count-1]) {
            translate([obelisk_base_width/2 + plaque_depth, -3, base_height + 15 + i * plaque_spacing]) {
                rotate([0, 90, 0])
                    detailed_plaque(i);
            }
        }
    }
    
    // Crystal top
    crystal_top();
    
    // Optional ground platform
    color([0.15, 0.15, 0.2])
        translate([0, 0, -2])
            cylinder(h=2, r=30, center=true);
}

// Render the complete enhanced obelisk
complete_fantasy_obelisk();
