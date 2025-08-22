// Debug scene to visualize baffles and cavity
// Includes the main design and draws baffles in place + shifted aside for inspection
include <tower.scad>

// show shell (semi-transparent)
color([0.9,0.9,0.6,0.2]) outer_shell();
// show inner cavity (semi-transparent blue)
color([0.2,0.6,0.9,0.2]) inner_cavity_taper();

// show baffles in-place (red)
color([1,0.2,0.2,0.9]) baffles_diagonal();

// show baffles shifted aside for clarity (green)
translate([outer_w_top*1.2,0,0]) color([0.2,0.9,0.3,0.9]) baffles_diagonal();

// draw the straight chute too for reference
translate([0,0,0]) color([0.6,0.6,0.6,0.4]) main_chute();
