// Test polyhedron cap from tower.scad
polyhedron(
  points=[[0,0,18],
          [ 20, 20, 0],
          [-20, 20, 0],
          [-20,-20, 0],
          [ 20,-20, 0]],
  faces=[[0,1,2],[0,2,3],[0,3,4],[0,4,1],[1,2,3,4]]);
