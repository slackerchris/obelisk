//
// =============================================================
// Obelisk Dice Tower System — THEME-READY MASTER FILE (FIXED)
// Themes: "runes" (fantasy), "sci_fi" (hex/circuit aesthetic)
// Units: millimeters
// =============================================================

// ------------------------ THEME SELECTOR ---------------------
theme = "runes";      // options: "runes", "sci_fi"

// ------------------------ GLOBAL PARAMS ----------------------
$fn = 64;

// Tokens
token_diam        = 15;       // initiative token diameter (runes theme)
token_thick       = 2.0;
cond_token_thick  = 1.0;      // thin condition token (stackable/magnet)
hang_hole_d       = 3.6;
hang_hole_margin  = 2.2;
engrave_depth     = 0.8;

// Boss token
boss_token_diam   = 24;

// Magnet
magnet_diam       = 3.0;      // 3x1 or 4x1 magnets
magnet_thick      = 1.0;
magnet_clearance  = 0.2;
pocket_floor_min  = 0.6;

// Dice Tower geometry
tower_h           = 160;
outer_w_bot       = 52;
outer_w_top       = 40;
wall              = 3;
cap_h             = 18;

base_clear_h      = 22;       // exit window bottom Z
exit_h            = 20;
exit_w            = 34;

chute_w           = 28;       // inner chute cross-section
chute_d           = 28;
baffle_t          = 2.4;
baffle_tilt_deg   = 20;
num_baffles       = 4;
baffle_margin     = 10;

funnel_h          = 22;
funnel_overhang   = 3;

// Base + tray
base_width        = 50;
base_height       = 20;
wall_thickness    = 2;
tray_clearance    = 0.5;
tray_thickness    = 2;

// Insert geometry (sized from base inner cavity)
insert_clear      = 0.4;
insert_floor      = 1.6;
insert_wall       = 1.6;

// Inserts: wells
well_diam         = token_diam + 1.2;
well_depth        = cond_token_thick + 0.6;
cell_gap          = 2.0;
well_diam_3x3     = token_diam + 1.2;
cell_gap_3x3      = 2.0;

// ------------------------ UTILS ------------------------------
module disc(d,h){ cylinder(d=d,h=h); }
module sq(w,h){ square([w,h],center=true); }
module tapered_square_prism(w_bot, w_top, h){
  linear_extrude(height=h, scale=w_top/w_bot) square([w_bot,w_bot],center=true);
}
module hanging_hole_center(diam=token_diam){
  hole_r = (diam/2) - hang_hole_margin - (hang_hole_d/2);
  translate([0,hole_r,0]) children();
}

// Tray helper functions (instead of trying to “return” from a module)
function tray_w() = base_width - 2*wall_thickness - tray_clearance;
function tray_l() = tray_w();
function tray_h() = base_height - tray_clearance;

// Inner tray space (for inserts)
function inner_tray_w() = tray_w() - 2*tray_thickness;
function inner_tray_l() = tray_l() - 2*tray_thickness;
function inner_tray_h() = tray_h() - tray_thickness;

// ------------------------ THEME SWITCH SHAPES ----------------
// TOKEN OUTLINE (runes=circle, sci_fi=hex)
module token_outline_2d(d=token_diam){
  if(theme=="sci_fi") circle_hex(d);
  else circle(d=d,$fn=64);
}
module circle_hex(d){
  // flat-to-flat equals d
  polygon(points=[ for(i=[0:5]) [ (d/2)*cos(60*i), (d/2)*sin(60*i) ] ]);
}
module token_solid(d=token_diam, h=token_thick){
  linear_extrude(height=h) token_outline_2d(d);
}
module token_blank(d=token_diam, h=token_thick){
  difference(){
    token_solid(d,h);
    // hanging hole
    hanging_hole_center(d) cylinder(d=hang_hole_d, h=h+0.2);
  }
}

// THEME PANEL ENGRAVINGS (applied to tower faces later)
module panel_theme_runes(size=10){
  union(){
    translate([0,0]) square([1.0, size*1.2],center=true);
    rotate(25) square([1.0, size*0.9],center=true);
    rotate(-25) square([1.0, size*0.9],center=true);
  }
}
module panel_theme_scifi(size=10){
  union(){
    for(x=[-2:2]) for(y=[-2:2]){
      translate([x*size*0.6, y*size*0.5])
        offset(r=0.3) polygon(points=[
          for(i=[0:5]) [ (size*0.2)*cos(60*i), (size*0.2)*sin(60*i) ]
        ]);
    }
  }
}

// ------------------------ ICON LIBRARIES ---------------------
// FANTASY CLASSES (minimal silhouettes)
module ic_fighter(s=8){ union(){ translate([0,-s*0.15]) sq(s*0.12,s*0.9);
  translate([0,-s*0.55]) sq(s*0.5,s*0.12); translate([0,-s*0.72]) sq(s*0.14,s*0.25);} }
module ic_wizard(s=9){ union(){ polygon(points=[[-s*0.5,-s*0.2],[ s*0.5,-s*0.2],[0,s*0.7]]);
  translate([s*0.28,-s*0.1]) sq(s*0.1,s*0.6);} }
module ic_rogue(s=8){ union(){ sq(s*0.18,s*0.8); translate([0,-s*0.4]) sq(s*0.5,s*0.12);
  translate([0,-s*0.6]) sq(s*0.16,s*0.3);} }
module ic_ranger(s=9){ difference(){ offset(r=0.9) circle(d=s*1.2,$fn=48);
  circle(d=s*1.2-2.2,$fn=48); translate([-s*0.6,0]) sq(s*1.2,s*0.2);} }
module ic_bard(s=9){ union(){ circle(d=s*0.9,$fn=40);
  translate([0,s*0.3]) circle(d=s*0.6,$fn=36); translate([0,s*0.8]) sq(s*0.15,s*0.6);} }
module ic_cleric(s=9){ union(){ sq(s*0.22,s*1.0); sq(s*1.0,s*0.22);} }
module ic_paladin(s=9){ union(){ offset(r=0.8) square([s*0.9,s*1.1],center=true);
  sq(s*0.18,s*0.9); sq(s*0.9,s*0.18);} }
module ic_warlock(s=9){ union(){ for(a=[0,45,90,135]) rotate(a) sq(s*0.18,s*1.1);} }
module ic_sorcerer(s=9){ union(){ circle(d=s*0.9,$fn=48);
  translate([s*0.15,s*0.2]) scale([0.6,1.2]) circle(d=s*0.6,$fn=42);
  difference(){ square([s*2,s*2],center=true); translate([0,s*0.9]) circle(d=s*1.6,$fn=60);} } }
module ic_druid(s=9){ difference(){ scale([1.6,1]) circle(d=s*0.9,$fn=48);
  rotate(40) translate([s*0.15,0]) sq(s*1.2,s*0.18);} }
module ic_barbarian(s=9){ union(){ sq(s*0.18,s*0.9); translate([0,s*0.2]) sq(s*0.8,s*0.3);} }
module ic_monk(s=9){ union(){ circle(d=s*0.9,$fn=48); rotate(45) sq(s*0.18,s*1.0);} }
module ic_artificer(s=9){ union(){ circle(d=s*0.9,$fn=24);
  for(a=[0:60:300]) rotate(a) translate([s*0.45,0]) sq(s*0.18,s*0.3);
  circle(d=s*0.35,$fn=24);} }

// CONDITIONS
module ic_poison(s=8){ union(){ offset(r=0.6) polygon(points=[[0,s/2],[s/3,0],[0,-s/2],[-s/3,0]]);
  for(a=[45,135]) rotate(a) square([s*0.08,s*0.9],center=true);} }
module ic_stun(s=9){ polygon(points=[[-s*0.20, s*0.50],[ s*0.10, s*0.10],[-s*0.05, s*0.10],
                                     [ s*0.20,-s*0.50],[-s*0.15,-0.10],[0,-0.10]]); }
module ic_fire(s=9){ union(){ circle(d=s*0.9,$fn=48); translate([s*0.15,s*0.2]) scale([0.6,1.2]) circle(d=s*0.6,$fn=42);
  difference(){ square([s*2,s*2],center=true); translate([0,s*0.9]) circle(d=s*1.6,$fn=60);} } }
module ic_frost(s=9){ union(){ sq(s*0.15,s*1.2); sq(s*1.2,s*0.15);
  rotate(45) sq(s*0.15,s*1.2); rotate(-45) sq(s*0.15,s*1.2);} }
module ic_bless(s=8){ union(){ sq(s*0.22,s*1.0); sq(s*1.0,s*0.22); rotate(45) sq(s*0.18,s*0.18);} }
module ic_fright(s=9){ difference(){ scale([1.6,1]) circle(d=s*0.9,$fn=48); circle(d=s*0.35,$fn=32);} }

// SCI-FI ICONS (energy, shield, hazard, nano, power, radar)
module ic_energy(s=9){ difference(){ circle(d=s*0.9,$fn=48);
  for(r=[0.3,0.55]) circle(d=s*r,$fn=40);} }
module ic_shield(s=9){ union(){ offset(r=0.8) square([s*0.9,s*1.1],center=true);
  circle(d=s*0.5,$fn=40);} }
module ic_hazard(s=9){ union(){ for(a=[0:120:360]) rotate(a) translate([s*0.32,0]) circle(d=s*0.35,$fn=24);
  circle(d=s*0.3,$fn=24);} }
module ic_nano(s=9){ union(){ for(a=[0:60:300]) rotate(a) translate([s*0.4,0]) circle(d=s*0.16,$fn=20);
  circle(d=s*0.28,$fn=28);} }
module ic_power(s=9){ polygon(points=[[-s*0.20, s*0.50],[ s*0.10, s*0.10],[-s*0.05, s*0.10],
  [ s*0.20,-s*0.50],[-s*0.15,-0.10],[0,-0.10]]); } // lightning
module ic_radar(s=9){ union(){ circle(d=s*0.9,$fn=48); for(r=[0.2,0.45,0.7]) circle(d=s*r,$fn=48);
  rotate(30) translate([0,0]) square([s*0.12,s*0.9],center=true);} }

// ------------------------ ENGRAVE WRAPPER -------------------
module engrave(depth=engrave_depth){ linear_extrude(height=depth) children(); }

// ------------------------ TOKENS ----------------------------
// Stackable initiative (recess on top)
module token_initiative_stackable(){
  recess_d     = (theme=="sci_fi") ? (token_diam-1.0) : (token_diam-0.6);
  recess_depth = min(0.35, token_thick - 0.8);
  difference(){
    token_blank(token_diam, token_thick);
    translate([0,0,token_thick - recess_depth]) linear_extrude(height=recess_depth+0.2)
      token_outline_2d(recess_d);
  }
}
module token_condition_stackable(){
  cond_d = (theme=="sci_fi") ? (token_diam-1.0) : (token_diam-0.6);
  token_blank(cond_d, cond_token_thick);
}
// Magnet initiative & condition
module token_initiative_magnet(){
  pocket_depth = min(magnet_thick+0.2, token_thick - pocket_floor_min);
  difference(){
    token_blank(token_diam, token_thick);
    translate([0,0,token_thick - pocket_depth])
      cylinder(d=magnet_diam + 2*magnet_clearance, h=pocket_depth+0.2);
  }
}
module token_condition_magnet(){
  cond_d = (theme=="sci_fi") ? (token_diam-1.0) : (token_diam-0.6);
  difference(){
    token_blank(cond_d, cond_token_thick);
    translate([0,0,0]) cylinder(d=magnet_diam + 2*magnet_clearance, h=cond_token_thick*0.8);
  }
}
// Generic token with icon (child-module pattern)
module token_with_icon(d=token_diam, h=token_thick){
  difference(){
    token_blank(d,h);
    translate([0,0,h/2 - engrave_depth/2]) engrave() children();
  }
}
// Numbers 0–9 (stroke-based mini digits)
module token_numbered(n){
  module seg(w=6,t=1.6){ square([t,w],center=true); }
  module digit(d){
    if(d==1) rotate(90) seg(8);
    else if(d==2) union(){ translate([0,3]) seg(); translate([0,0]) rotate(90) seg(6);
      translate([0,-3]) seg(); translate([1.5,1.5]) rotate(90) seg(3); translate([-1.5,-1.5]) rotate(90) seg(3); }
    else if(d==3) union(){ translate([0,3]) seg(); translate([0,0]) seg(); translate([0,-3]) seg();
      translate([1.5,1.5]) rotate(90) seg(3); translate([1.5,-1.5]) rotate(90) seg(3); }
    else if(d==4) union(){ translate([-1.6,0]) rotate(90) seg(6); translate([1.6,0]) rotate(90) seg(6); translate([0,0]) seg(); }
    else if(d==5) union(){ translate([0,3]) seg(); translate([0,0]) seg(); translate([0,-3]) seg();
      translate([-1.5,1.5]) rotate(90) seg(3); translate([1.5,-1.5]) rotate(90) seg(3); }
    else if(d==6) union(){ translate([0,3]) seg(); translate([0,0]) seg(); translate([0,-3]) seg();
      translate([-1.5,1.5]) rotate(90) seg(3); translate([-1.5,-1.5]) rotate(90) seg(3); }
    else if(d==7) union(){ translate([0,3]) seg(); translate([1.6,0]) rotate(90) seg(6); }
    else if(d==8) union(){ translate([0,3]) seg(); translate([0,0]) seg(); translate([0,-3]) seg();
      translate([-1.6,0]) rotate(90) seg(6); translate([1.6,0]) rotate(90) seg(6); }
    else if(d==9) union(){ translate([0,3]) seg(); translate([0,0]) seg(); translate([0,-3]) seg();
      translate([1.6,0]) rotate(90) seg(6); translate([-1.5,1.5]) rotate(90) seg(3); }
    else union(){ translate([0,3]) seg(); translate([0,-3]) seg();
      translate([-1.6,0]) rotate(90) seg(6); translate([1.6,0]) rotate(90) seg(6); } // 0
  }
  difference(){
    token_initiative_stackable();
    translate([0,0,token_thick/2 - engrave_depth/2]) linear_extrude(height=engrave_depth) digit(n);
  }
}
// Boss token
module token_boss(){
  if (theme=="sci_fi")
    token_with_icon(d=boss_token_diam) ic_radar();
  else
    token_with_icon(d=boss_token_diam) ic_warlock();
}

// ------------------------ DICE TOWER -------------------------
function inner_w_bot() = outer_w_bot - 2*wall;
function inner_w_top() = outer_w_top - 2*wall;
assert(inner_w_bot() >= chute_w && inner_w_top() >= chute_w, "Increase outer widths or reduce chute_w.");
assert(inner_w_bot() >= chute_d && inner_w_top() >= chute_d, "Increase outer widths or reduce chute_d.");

module obelisk_shell(){
  difference(){
    union(){ tapered_square_prism(outer_w_bot, outer_w_top, tower_h);
      // pyramid cap
      translate([0,0,tower_h])
        polyhedron(points=[[0,0,cap_h],
          [ outer_w_top/2,  outer_w_top/2, 0],
          [-outer_w_top/2,  outer_w_top/2, 0],
          [-outer_w_top/2, -outer_w_top/2, 0],
          [ outer_w_top/2, -outer_w_top/2, 0]],
          faces=[[0,1,2],[0,2,3],[0,3,4],[0,4,1],[1,2,3,4]]); }
    tapered_square_prism(inner_w_bot(), inner_w_top(), tower_h);
  }
}

module cavity_block(){ linear_extrude(height=tower_h) square([chute_w, chute_d],center=true); }
module exit_window(){ translate([0,0,base_clear_h + exit_h/2]) rotate([90,0,0])
  cube([exit_w, wall*2+0.2, exit_h], center=true); }
module top_funnel(){
  funnel_w_top = chute_w + 2*funnel_overhang;
  funnel_w_bot = inner_w_top() - 2;
  funnel_h_clamped = min(funnel_h, tower_h*0.35);
  translate([0,0,tower_h - funnel_h_clamped])
    tapered_square_prism(funnel_w_bot, funnel_w_top, funnel_h_clamped);
}
module baffles(){
  step_h = (tower_h - baffle_margin*2 - base_clear_h);
  spacing = step_h / max(num_baffles,1);
  for(i=[0:num_baffles-1]){
    zc = base_clear_h + baffle_margin + spacing*(i+0.5);
    side = (i%2==0) ? -1 : 1;
    x_off = side*((chute_w/2) - (baffle_t/2) - 0.6);
    translate([x_off,0,zc]) rotate([baffle_tilt_deg,0,0])
      cube([baffle_t, chute_d*0.95, baffle_t], center=true);
  }
}

// Optional: theme panel engravings lightly etched on front face
module tower_panels(){
  depth=0.6;
  translate([0, (outer_w_bot/2)-0.5, tower_h*0.45])
    rotate([90,0,0])
      linear_extrude(height=1.2)
        if (theme=="sci_fi") panel_theme_scifi(10); else panel_theme_runes(10);
}

module dice_tower(){
  difference(){
    obelisk_shell();
    cavity_block();
    top_funnel();
    exit_window();
    // panel etch
    tower_panels();
  }
  baffles();
}

// ------------------------ BASE + TRAY ------------------------
module base_block(){ translate([-base_width/2, -base_width/2, 0]) cube([base_width, base_width, base_height]); }
module base_with_hollow(){
  difference(){
    base_block();
    translate([-base_width/2 + wall_thickness, -base_width/2 + wall_thickness, 0])
      cube([base_width-2*wall_thickness, base_width-2*wall_thickness, base_height], center=false);
  }
}
module tray(){
  // Outer box
  difference(){
    cube([tray_w(), tray_l(), tray_h()], center=false);
    // hollow
    translate([tray_thickness,tray_thickness,tray_thickness])
      cube([tray_w()-2*tray_thickness, tray_l()-2*tray_thickness, tray_h()], center=false);
  }
  // handle notch
  translate([tray_w()/2, -2, tray_h()/2]) cube([10,4,4], center=true);
}

// ------------------------ INSERTS ----------------------------
module insert_body(iw, il, ih){
  difference(){
    cube([iw - insert_clear, il - insert_clear, ih - insert_clear], center=false);
    translate([insert_wall, insert_wall, insert_floor])
      cube([iw - insert_clear - 2*insert_wall, il - insert_clear - 2*insert_wall, ih], center=false);
    // pull notch
    translate([((iw-insert_clear)-14)/2, -0.01, 0]) minkowski(){ cube([14,6,3],center=false); cylinder(r=1.0,h=0.01); }
  }
}
module wells_grid(iw, il, rows, cols, diam, gap, depth, z0){
  cell = diam; grid_w = cols*cell + (cols-1)*gap; grid_l = rows*cell + (rows-1)*gap;
  ox = (iw - insert_clear - grid_w)/2 + cell/2; oy = (il - insert_clear - grid_l)/2 + cell/2;
  for(r=[0:rows-1]) for(c=[0:cols-1]){
    translate([ox + c*(cell+gap), oy + r*(cell+gap), z0]) cylinder(d=diam, h=depth+0.2);
  }
}
module insert_3x2(){
  iw=inner_tray_w(); il=inner_tray_l(); ih=inner_tray_h();
  difference(){ insert_body(iw,il,ih); wells_grid(iw,il,2,3, well_diam, cell_gap, well_depth, insert_floor); }
  // Engrave icons
  cell=well_diam; gap=cell_gap;
  grid_w=3*cell+2*gap; grid_l=2*cell+1*gap; ox=(iw - insert_clear - grid_w)/2 + cell/2; oy=(il - insert_clear - grid_l)/2 + cell/2;
  // Front row
  translate([ox + 0*(cell+gap), oy + 0*(cell+gap), insert_floor+0.2]) linear_extrude(0.6) (theme=="sci_fi"? ic_energy() : ic_poison());
  translate([ox + 1*(cell+gap), oy + 0*(cell+gap), insert_floor+0.2]) linear_extrude(0.6) (theme=="sci_fi"? ic_shield() : ic_stun());
  translate([ox + 2*(cell+gap), oy + 0*(cell+gap), insert_floor+0.2]) linear_extrude(0.6) (theme=="sci_fi"? ic_hazard() : ic_fire());
  // Back row
  translate([ox + 0*(cell+gap), oy + 1*(cell+gap), insert_floor+0.2]) linear_extrude(0.6) (theme=="sci_fi"? ic_nano() : ic_frost());
  translate([ox + 1*(cell+gap), oy + 1*(cell+gap), insert_floor+0.2]) linear_extrude(0.6) (theme=="sci_fi"? ic_power() : ic_bless());
  translate([ox + 2*(cell+gap), oy + 1*(cell+gap), insert_floor+0.2]) linear_extrude(0.6) (theme=="sci_fi"? ic_radar() : ic_fright());
}
module insert_3x3(){
  iw=inner_tray_w(); il=inner_tray_l(); ih=inner_tray_h();
  difference(){ insert_body(iw,il,ih); wells_grid(iw,il,3,3, well_diam_3x3, cell_gap_3x3, well_depth, insert_floor); }
}

// ------------------------ EXPORT TOGGLES ---------------------
show_tower            = true;   // Obelisk dice tower
show_base             = false;  // Base block (hollow shell)
show_tray             = false;  // Pull-out tray
show_insert_3x2       = false;  // Sorting insert (6 wells)
show_insert_3x3       = false;  // Sorting insert (9 wells)

show_tokens_stackable = false;  // demo plate of stackable tokens (classes + conditions)
show_tokens_magnet    = false;  // magnet initiative + blank magnet condition
show_numbered_set     = false;  // 1–10 demo
show_boss_token       = false;  // XL boss token

// ------------------------ LAYOUT / RENDER --------------------
x=0;
if(show_tower){ translate([x,0,base_height]) dice_tower(); x+=90; }
if(show_base){ translate([x,0,0]) base_with_hollow(); x+=70; }
if(show_tray){ translate([x,0,0]) tray(); x+=70; }
if(show_insert_3x2){ translate([x,0,0]) insert_3x2(); x+=70; }
if(show_insert_3x3){ translate([x,0,0]) insert_3x3(); x+=70; }

if(show_tokens_stackable){
  let(sh = (theme=="sci_fi")){
    translate([0,80,0]) token_initiative_stackable();
    if (sh) {
      translate([20,80,0]) token_with_icon() ic_energy();
      translate([40,80,0]) token_with_icon() ic_shield();
      translate([60,80,0]) token_with_icon() ic_hazard();
      translate([80,80,0]) token_with_icon() ic_nano();
      translate([100,80,0]) token_with_icon() ic_power();
      translate([120,80,0]) token_with_icon() ic_radar();
    } else {
      translate([20,80,0]) token_with_icon() ic_fighter();
      translate([40,80,0]) token_with_icon() ic_wizard();
      translate([60,80,0]) token_with_icon() ic_rogue();
      translate([80,80,0]) token_with_icon() ic_ranger();
      translate([100,80,0]) token_with_icon() ic_bard();
      translate([120,80,0]) token_with_icon() ic_cleric();
      translate([140,80,0]) token_with_icon() ic_paladin();
      translate([160,80,0]) token_with_icon() ic_warlock();
      translate([180,80,0]) token_with_icon() ic_sorcerer();
      translate([200,80,0]) token_with_icon() ic_druid();
      translate([220,80,0]) token_with_icon() ic_barbarian();
      translate([240,80,0]) token_with_icon() ic_monk();
      translate([260,80,0]) token_with_icon() ic_artificer();
    }
    // Conditions row
    if (sh) {
      translate([0,60,0])  token_with_icon() ic_energy();
      translate([20,60,0]) token_with_icon() ic_shield();
      translate([40,60,0]) token_with_icon() ic_hazard();
      translate([60,60,0]) token_with_icon() ic_nano();
      translate([80,60,0]) token_with_icon() ic_power();
      translate([100,60,0])token_with_icon() ic_radar();
    } else {
      translate([0,60,0])  token_with_icon() ic_poison();
      translate([20,60,0]) token_with_icon() ic_stun();
      translate([40,60,0]) token_with_icon() ic_fire();
      translate([60,60,0]) token_with_icon() ic_frost();
      translate([80,60,0]) token_with_icon() ic_bless();
      translate([100,60,0])token_with_icon() ic_fright();
    }
  }
}

if(show_tokens_magnet){
  translate([0,40,0]) token_initiative_magnet();
  translate([20,40,0]) token_condition_magnet(); // engrave your icon similarly
}

if(show_numbered_set){
  translate([0,0,0])   token_numbered(1);
  translate([20,0,0])  token_numbered(2);
  translate([40,0,0])  token_numbered(3);
  translate([60,0,0])  token_numbered(4);
  translate([80,0,0])  token_numbered(5);
  translate([100,0,0]) token_numbered(6);
  translate([120,0,0]) token_numbered(7);
  translate([140,0,0]) token_numbered(8);
  translate([160,0,0]) token_numbered(9);
  translate([180,0,0]) token_numbered(0); // use with another to denote 10, 20, etc.
}

if(show_boss_token){
  translate([0,-20,0]) token_boss();
}
