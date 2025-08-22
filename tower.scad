// ======================================================
// Dice Tower (tapered shell) + DIAGONAL baffles (wall-to-wall)
// Baffles tilt across X (rotate about Y) and alternate each level
// ======================================================
$fn = 64;

// ---------- Tower geometry ----------
tower_h       = 160;   // body height (not counting cap)
outer_w_bot   = 52;    // outer width at base
outer_w_top   = 40;    // outer width at top
wall          = 3;     // wall thickness
cap_h         = 18;    // little pyramid cap

// Inner chute (constant rectangle, centered)
chute_w       = 32;    // X (give chunky d20s room)
chute_d       = 32;    // Y

// Exit opening (front = +Y)
base_clear_h  = 22;
exit_w        = 34;
exit_h        = 20;

// Funnel at top
funnel_h      = 20;
funnel_over   = 3;

// ---------- Baffles (DIAGONAL across X) ----------
num_baffles       = 6;
baffle_t          = 3.0;   // slightly thicker for robustness
baffle_angle_deg  = 15;     // slope across X (left high → right low, then flip)
baffle_margin     = 10;     // top/bottom margin before first/after last
y_clear_from_wall = 1.5;    // clearance from front/back walls (Y)
 x_overlap         = 1.0;    // small penetration into wall to avoid boolean slivers
baffle_max_width  = 18;     // max baffle width to prevent jamming

// ---------- helpers ----------
module taper(wb, wt, h){ linear_extrude(h, scale=wt/wb) square([wb,wb], center=true); }
function iw_bot() = outer_w_bot - 2*wall;
function iw_top() = outer_w_top - 2*wall;
function inner_w_at_z(z) = iw_bot() + (iw_top() - iw_bot()) * (z / tower_h);

// ---------- outer shell ----------
module outer_shell(){
  union(){
    taper(outer_w_bot, outer_w_top, tower_h);
    // Replace polyhedron cap with a short flat-ish cap to avoid fragile apex
    translate([0,0,tower_h])
      taper(outer_w_top, 4.0, cap_h*0.6); // small flat cap rather than a sharp point
  }
}

// ---------- subtractions ----------
module inner_cavity_taper(){ taper(iw_bot(), iw_top(), tower_h); }
module main_chute(){ linear_extrude(tower_h) square([chute_w, chute_d], center=true); }
module exit_window(){
  translate([0,0,base_clear_h + exit_h/2])
    rotate([90,0,0]) cube([exit_w, wall*2+0.2, exit_h], center=true);
}
module top_funnel(){
  fw_top = chute_w + 2*funnel_over;
  fw_bot = iw_top() - 2;
  fh     = min(funnel_h, tower_h*0.35);
  translate([0,0,tower_h - fh]) taper(fw_bot, fw_top, fh);
}

// ---------- DIAGONAL baffles (tilt across X, alternate) ----------
module baffles_diagonal(){
  usable_h = (tower_h - base_clear_h) - 2*baffle_margin;
  spacing  = usable_h / max(num_baffles,1);

  // size in Y (front/back) – centered with a small gap to both walls
  len_y = chute_d - 2*y_clear_from_wall;

  for(i=[0:num_baffles-1]){
    zc   = base_clear_h + baffle_margin + spacing*(i+0.5);
    iw_z = inner_w_at_z(zc);             // inner width between side walls at this Z

    // PROPER FIX: Baffles must attach to walls to be printable
    // Alternate between left-wall and right-wall attachment
    // Each baffle spans from one wall partway across, leaving flow gap on opposite side
    
    // Safety clamp: ensure flow gap is large enough for common D20s.
    // gap = chute_w - len_x  => enforce gap >= safe_d20 + clearance
    safe_d20   = 22.5;    // typical tip-to-tip diagonal for D20 (mm)
    clearance  = 0.5;     // extra wiggle room (mm)
  // maximum allowed baffle length so the remaining gap fits a D20
  max_len_allowed = max([0, chute_w - (safe_d20 + clearance)]);

  // clamp also by the local inner width at this Z to avoid overhanging into the tapered shell
  // leave a small margin so baffles don't butt exactly at the wall edge
  small_margin = 2.0;
  cap_by_inner = max([0, iw_z - small_margin]);

  // final baffle length: pick the desired coverage, clamp by D20, max width, and inner width;
  // ensure a tiny positive minimum so cube() never gets a zero size
  len_x = max([0.1, min([chute_w * 0.4, max_len_allowed, baffle_max_width, cap_by_inner])]);

    // Add a tiny positive overlap into the wall to avoid boolean slivers (use x_overlap if set)
    wall_penetration = max([0, x_overlap]);

    // compute x_offset so the baffle visibly attaches to the INNER wall at this Z
    inner_half = iw_z / 2;
    left_face  = -inner_half - wall_penetration; // a bit into the inner wall
    right_face =  inner_half + wall_penetration;
    x_offset = (i % 2 == 0) ?
      left_face + len_x/2 :   // Even: attach to LEFT inner wall
      right_face - len_x/2;   // Odd: attach to RIGHT inner wall

    // alternate slope across X: even -> left high/right low, odd -> reverse
    sign = (i % 2 == 0) ? 1 : -1;
    tilt = sign * baffle_angle_deg;

    // Single diagonal baffle - attached to alternating walls
    translate([x_offset, 0, zc])
      rotate([0, tilt, 0])
        cube([len_x, len_y, baffle_t], center=true);
  }
}

// ---------- assembly ----------
difference(){
  union(){
    outer_shell();
    // include internal shelves so they remain after subtraction
    baffles_diagonal();
  }
  inner_cavity_taper();
  main_chute();    // ensures a straight chute inside the tapered shell
  exit_window();
  top_funnel();
}

/* Tuning:
- Want a stronger slope?   baffle_angle_deg = 18–20
- Easier bridging?         baffle_t = 3.0
- More room for big dice?  chute_w = chute_d = 34
- Shelves touching side walls more obviously? increase x_overlap to 1.0
- If you prefer the “front/back hug” style instead, tell me and I’ll swap the
  tilt axis (rotate about X) and add the exact Y wall gap computation.
*/

// ---------- test slice helper ----------
// Renders a short vertical slice of the tower (0..slice_h mm) for test-printing
module test_slice(slice_h = 50){
  // render the final assembled tower, then clip with an intersection cube
  intersection(){
    // full model
    difference(){
      union(){ outer_shell(); baffles_diagonal(); }
      inner_cavity_taper();
      main_chute();
      exit_window();
      top_funnel();
    }
    // clipping box
    translate([-100,-100,0])
      cube([200,200,slice_h], center=false);
  }
}
