use <tower.scad>

// Render only the outer shell + baffles to isolate mesh issues
union(){
  outer_shell();
  baffles_diagonal();
}
