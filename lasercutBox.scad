UP = 0;
DOWN = 180;
LEFT = 90;
RIGHT = 270;
MID = 360;
kerf=0.15;// Hacky global for kerf

generate = $generate == undef ? 0: $generate;

cut=true;
bw=1;
//lasercutoutBox4(thickness = 2, x=30, y=40, z=40);
//lasercutoutBox5(thickness = 2, x=30, y=40, z=40);
//lasercutoutBox6(thickness = 2, x=30, y=40, z=40);

module lasercutoutSquare(
    thickness,
    x=0,
    y=0,
    finger_joints = [],
    bumps = false,
    ) {
    points = [[0,0], [x,0], [x,y], [0,y], [0,0]];
    lasercutout(
        thickness = thickness,
        points = points,
        finger_joints = finger_joints,
        bumps = bumps
        );
    }

module lasercutout(
    thickness,
    points= [],
    finger_joints = [],
    bumps = false,
    ){
    path_total = len(points);
    path = [ for (p = [0 : 1 : path_total]) p ];

    function max_y(points) = max([for (a = [0:1:len(points)-1])  points[a][1]]);
    function min_y(points) = min([for (a = [0:1:len(points)-1])  points[a][1]]);
    function max_x(points) = max([for (a = [0:1:len(points)-1])  points[a][0]]);
    function min_x(points) = min([for (a = [0:1:len(points)-1])  points[a][0]]);

    max_y = max_y(points);
    min_y = min_y(points);
    max_x = max_x(points);
    min_x = min_x(points);

    difference() {
        union() {
            linear_extrude(height = thickness , center = false)  
                polygon(points=points, path=path);
            for (t = [0:1:len(finger_joints)-1]) {
                fingerJoint(finger_joints[t][0], finger_joints[t][1], finger_joints[t][2], thickness, max_y, min_y, max_x, min_x, bumps);
                }
          } // end union

    }
   }

module fingerJoint(angle, start_up, fingers, thickness, max_y, min_y, max_x, min_x, bumps = false) {
    if ( angle == UP ) {
        range_min = min_x;
        range_max = max_x;
        t_x = min_x;
        t_y = max_y;
        fingers(angle, start_up, fingers, thickness, range_min, range_max, t_x, t_y, bumps = bumps);
        }
    if ( angle == DOWN ) {
        range_min = min_x;
        range_max = max_x;
        t_x = max_x;
        t_y = min_y;
        fingers(angle, start_up, fingers, thickness, range_min, range_max, t_x, t_y, bumps = bumps);
        }
    if ( angle == LEFT ) {
        range_min = min_y;
        range_max = max_y;
        t_x = min_x;
        t_y = min_y;
        fingers(angle, start_up, fingers, thickness, range_min, range_max, t_x, t_y, bumps = bumps);
        }
    if ( angle == RIGHT ) {
        range_min = min_y;
        range_max = max_y;
        t_x = max_x;
        t_y = max_y;
        fingers(angle, start_up, fingers, thickness, range_min, range_max, t_x, t_y, bumps = bumps);
        }

    }


module fingers(angle, start_up, fingers, thickness, range_min, range_max, t_x, t_y, bumps = false) {

    // The tweaks to y translate([0, -thickness,0]) ... thickness*2 rather than *1
    // Are to avoid edge cases and make the dxf export better.
    // All fun
    translate([t_x, t_y,0]) rotate([0,0,angle]) translate([0, -thickness,0]) {
        for ( p = [ 0 : 1 : fingers-1] ) {

            kerfSize = (p > 0) ? kerf/2 : kerf/2 ;
            kerfMove = (p > 0) ? kerf/4 : 0;

            i=range_min + ((range_max-range_min)/fingers)*p;
            if(start_up == 1) {
                translate([i-kerfMove,0,0]) {
                    cube([ (range_max-range_min)/(fingers*2) + kerfSize, thickness*2, thickness]);
                    if(bumps == true) {
                        translate([(range_max-range_min)/(fingers*2), thickness*1.5, 0])
                            cylinder(h=thickness, r=thickness/10);
                        }
                    }
                }
            else {
                translate([i+(range_max-range_min)/(fingers*2)-kerfMove,0,0]) {
                    cube([ (range_max-range_min)/(fingers*2)+kerfSize, thickness*2, thickness]);
                    if(bumps == true) {
                        if (i < (range_max - (range_max-range_min)/fingers )) {
                            translate([(range_max-range_min)/(fingers*2), thickness*1.5, 0])
                                cylinder(h=thickness, r=thickness/10);
                            }
                        }
                    }
                }
            } //for loop
        } //primary translate
    }

module lasercutoutBox4(thickness, x=0, y=0, z=0 ) {
    fj = [
      [ [UP, 1, 4], [DOWN, 1, 4],    ],
      [ [UP, 0, 4], [DOWN, 1, 4],    ],
      [ [UP, 1, 4], [DOWN, 0, 4],    ],
      [ [UP, 1, 4], [DOWN, 1, 4],    ],
      ];

    translate([0,thickness,0])
        lasercutoutSquare(thickness=thickness,x=x, y=y-thickness*2, finger_joints = fj[0] );

    translate([cut?x+bw:0, thickness, cut?0:z-thickness])
        lasercutoutSquare(thickness=thickness,x=x, y=y-thickness*2, finger_joints = fj[1] );

    translate([0,cut?y+thickness+bw:thickness,thickness]) rotate([cut?0:90,0,0])
        lasercutoutSquare(thickness=thickness,x=x, y=z-thickness*2, finger_joints = fj[2] );

    translate([cut?x+bw:0,cut?y+thickness+bw:y,thickness]) rotate([cut?0:90,0,0])
        lasercutoutSquare(thickness=thickness,x=x, y=z-thickness*2, finger_joints = fj[3] );

    }

module lasercutoutBox5(thickness, x=0, y=0, z=0 ) {
    fj = [
        [ [UP, 1, 4], [DOWN, 1, 4], [LEFT, 1, 4],   ],
        [ [UP, 0, 4], [DOWN, 1, 4], [LEFT, 1, 4],   ],
        [ [UP, 1, 4], [DOWN, 0, 4], [LEFT, 1, 4],   ],
        [ [UP, 1, 4], [DOWN, 1, 4], [LEFT, 1, 4],   ],
        [ [UP, 0, 4], [DOWN, 1, 4], [LEFT, 0, 4], [RIGHT, 1, 4]  ],
        ];
    translate([0,thickness,0])
        lasercutoutSquare(thickness=thickness,x=x, y=y-thickness*2, finger_joints = fj[0] );

    translate(cut?[x+thickness+bw,thickness,0]:[0, thickness, z-thickness])
        lasercutoutSquare(thickness=thickness,x=x, y=y-thickness*2, finger_joints = fj[1] );

    translate([0,cut?y+thickness+bw:thickness,thickness]) rotate([cut?0:90,0,0])
        lasercutoutSquare(thickness=thickness,x=x, y=z-thickness*2, finger_joints = fj[2] );

    translate(cut?[x+thickness+bw,y+thickness+bw,thickness]:[0,y,thickness]) rotate([cut?0:90,0,0])
        lasercutoutSquare(thickness=thickness,x=x, y=z-thickness*2, finger_joints = fj[3] );

    translate([0,cut?y+z+thickness+bw*2:thickness,thickness]) rotate([0,cut?0:-90,0]) 
        lasercutoutSquare(thickness=thickness,x=z-thickness*2, y=y-thickness*2, finger_joints = fj[4]);
    }

module lasercutoutBox6(thickness, x=0, y=0, z=0 ) {
    fj = [
      [ [UP, 1, 4], [DOWN, 1, 4], [LEFT, 1, 4], [RIGHT, 0, 4]  ],
      [ [UP, 0, 4], [DOWN, 1, 4], [LEFT, 1, 4], [RIGHT, 0, 4]  ],
      [ [UP, 1, 4], [DOWN, 0, 4], [LEFT, 1, 4], [RIGHT, 0, 4]  ],
      [ [UP, 1, 4], [DOWN, 1, 4], [LEFT, 1, 4], [RIGHT, 0, 4]  ],
      [ [UP, 0, 4], [DOWN, 1, 4], [LEFT, 0, 4], [RIGHT, 1, 4]  ],
      [ [UP, 0, 4], [DOWN, 1, 4], [LEFT, 0, 4], [RIGHT, 1, 4]  ],
      ];
    translate([0,thickness,0])
        lasercutoutSquare(thickness=thickness,x=x, y=y-thickness*2, finger_joints = fj[0] );

    translate(cut?[x+thickness*2+bw, thickness, 0]:[0,thickness,z-thickness])
        lasercutoutSquare(thickness=thickness,x=x, y=y-thickness*2, finger_joints = fj[1] );


    translate([0,cut?y+thickness+bw:thickness,thickness]) rotate([cut?0:90,0,0])
        lasercutoutSquare(thickness=thickness,x=x, y=z-thickness*2, finger_joints = fj[2] );

    translate([cut?x+thickness*2+bw:0,cut?y+thickness+bw:y,thickness]) rotate([cut?0:90,0,0])
        lasercutoutSquare(thickness=thickness,x=x, y=z-thickness*2, finger_joints = fj[3] );


    translate([cut?0:x+thickness, cut?y+z+thickness+bw*2:thickness, thickness]) 
        rotate([0,cut?0:-90,0]) 
            lasercutoutSquare(thickness=thickness,x=z-thickness*2, y=y-thickness*2, finger_joints = fj[4]);

    translate([cut?z+bw:0, cut?y+z+thickness+bw*2:thickness, thickness]) 
        rotate([0,cut?0:-90,0])
            lasercutoutSquare(thickness=thickness,x=z-thickness*2, y=y-thickness*2, finger_joints = fj[5]);
    }

