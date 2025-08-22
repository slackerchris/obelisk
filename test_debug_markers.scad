include <tower.scad>

// Draw shell faintly
color([0.9,0.9,0.6,0.15]) outer_shell();
// Draw inner cavity faintly
color([0.2,0.6,0.9,0.08]) inner_cavity_taper();

// Place large spheres at each baffle center to prove positions
for(i=[0:num_baffles-1]){
  zc   = base_clear_h + baffle_margin + ((tower_h - base_clear_h) - 2*baffle_margin)/max(num_baffles,1)*(i+0.5);
  iw_z = inner_w_at_z(zc);
  // compute len_x as in the main module (simplified)
  safe_d20   = 22.5;
  clearance  = 0.5;
  max_len_allowed = max([0, chute_w - (safe_d20 + clearance)]);
  small_margin = 2.0;
  cap_by_inner = max([0, iw_z - small_margin]);
  len_x = max([0.1, min([chute_w * 0.4, max_len_allowed, baffle_max_width, cap_by_inner])]);
  wall_penetration = max([0, x_overlap]);
  inner_half = iw_z/2;
  left_face  = -inner_half - wall_penetration;
  right_face =  inner_half + wall_penetration;
  x_offset = (i % 2 == 0) ? left_face + len_x/2 : right_face - len_x/2;

  // center marker (red) inside the shell
  translate([x_offset, 0, zc]) color([1,0,0]) sphere(r=4);

  // shifted marker (green) for comparison
  translate([outer_w_top*1.4 + x_offset, 0, zc]) color([0,1,0]) sphere(r=4);
}

// also draw the straight chute outline
color([0.2,0.2,0.2,0.4]) translate([0,0,0]) main_chute();
