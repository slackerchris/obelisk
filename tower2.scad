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
baffle_t          = 2.8;
baffle_angle_deg  = 15;     // slope across X (left high → right low, then flip)
baffle_margin     = 10;     // top/bottom margin before first/after last
y_clear_from_wall = 1.5;    // clearance from front/back walls (Y)
x_overlap         = 0.6;    // bite into side walls so shelves fuse

// ---------- helpers ----------
module taper(wb, wt, h){ linear_extrude(h, scale=wt/wb) square([wb,wb], center=true); }
function iw_bot() = outer_w_bot - 2*wall;
function iw_top() = outer_w_top - 2*wall;
function inner_w_at_z(z) = iw_bot() + (iw_top() - iw_bot()) * (z / tower_h);

// ---------- outer shell ----------
module outer_shell(){
  union(){
    taper(outer_w_bot, outer_w_top, tower_h);
    translate([0,0,tower_h])
      polyhedron(
        points=[[0,0,cap_h],
                [ outer_w_top/2,  outer_w_top/2, 0],
                [-outer_w_top/2,  outer_w_top/2, 0],
                [-outer_w_top/2, -outer_w_top/2, 0],
                [ outer_w_top/2, -outer_w_top/2, 0]],
        faces=[[0,1,2],[0,2,3],[0,3,4],[0,4,1],[1,2,3,4]]);
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

    // span left→right with a little bite into both side walls so it fuses
    len_x = iw_z + 2*x_overlap;

    // alternate slope across X: even -> left high/right low, odd -> reverse
    sign = (i % 2 == 0) ? 1 : -1;
    tilt = sign * baffle_angle_deg;

    // place shelf centered in X and Y, then tilt around Y so one side is lower
    translate([0, 0, zc])
      rotate([0, tilt, 0])       // <— rotate about Y to make a LEFT↔RIGHT slope
        cube([len_x, len_y, baffle_t], center=true);
  }
}

// ---------- assembly ----------
difference(){
  outer_shell();
  inner_cavity_taper();
  main_chute();    // ensures a straight chute inside the tapered shell
  exit_window();
  top_funnel();
}
baffles_diagonal();

/* Tuning:
- Want a stronger slope?   baffle_angle_deg = 18–20
- Easier bridging?         baffle_t = 3.0
- More room for big dice?  chute_w = chute_d = 34
- Shelves touching side walls more obviously? increase x_overlap to 1.0
- If you prefer the “front/back hug” style instead, tell me and I’ll swap the
  tilt axis (rotate about X) and add the exact Y wall gap computation.
*/
