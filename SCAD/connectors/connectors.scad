$fa = 1;
$fs = 0.4;


// M3 threaded insert
THREADED_INSERT_RADIUS = 2.3;
THREADED_INSERT_DEPTH = 5.7;

// M3 bolt
BOLT_RADIUS = 1.7;

// distance between the circumferences of the holes
HOLES_CIRCUMFERENCES_DIST = 8;
// distance between the centers of the holes
HOLES_CENTERS_DIST = HOLES_CIRCUMFERENCES_DIST + 2*THREADED_INSERT_RADIUS;

// thickness of all the planar parts
THICKNESS = 3;

// additional length of each side, with respect to the center of the two extreme holes
ADDITIONAL_SIDE_LENGTH = 2*HOLES_CIRCUMFERENCES_DIST + 4*THREADED_INSERT_RADIUS;


module plane(num_holes_x=1, num_holes_y=5, center=false) {
    
    // ensure that the values are different from 2
    num_holes_x = (num_holes_x==2) ? 1 : num_holes_x;
    num_holes_y = (num_holes_y==2) ? 1 : num_holes_y;

    cube_side_x = (num_holes_x+1) * HOLES_CENTERS_DIST;
    cube_side_y = (num_holes_y+1) * HOLES_CENTERS_DIST;
    
    traslation_value = center ? [-cube_side_x/2, -cube_side_y/2, 0] : [0, 0, 0];
    
    translate(traslation_value)
    
        difference() {
            
            cube([cube_side_x, cube_side_y, THICKNESS], center=false);
            
            for (x=[HOLES_CENTERS_DIST : HOLES_CENTERS_DIST : cube_side_x-HOLES_CENTERS_DIST])
                for (y=[HOLES_CENTERS_DIST : HOLES_CENTERS_DIST : cube_side_y-HOLES_CENTERS_DIST])
                    translate([x, y, -0.01])
                        cylinder(h=THICKNESS + 0.02, r=THREADED_INSERT_RADIUS, center=false);
                
        }

}


module two_planes_joint(length=1) {
    
    // ensure that the value is odd
    length = (length%2)==1 ? length : length-1;
    
    plane(length, 1);
    
    translate([0, THICKNESS, 0])
        rotate([90, 0, 0])
            plane(length, 1);    
}


module three_planes_joint(length=1) {

    // ensure that the value is odd
    length = (length%2)==1 ? length : length-1;

    plane(length, length);
    
    translate([THICKNESS, 0, 0])
        rotate([0, -90, 0])
            plane(length, length);

    rotate([-90, -90, 0])
        plane(length, length);
        
}


module arc_joint(length=1) {
    
    // ensure that the value is odd
    length = (length%2)==1 ? length : length-1;

    plane(1, length);
    
    translate([THICKNESS, 0, 0])
        rotate([0, -90, 0])
            plane(1, length);
    
    translate([ADDITIONAL_SIDE_LENGTH, 0, 0])
        rotate([0, -90, 0])
            plane(1, length);

}


module triangular_joint(length_x=3, length_y=3) {
    
    difference() {
        
        union() {
            plane(length_x, 1);
            translate([ADDITIONAL_SIDE_LENGTH, 0, 0])
                rotate([0, 0, 90])
                    plane(length_y, 1);
        }
        
        // fix the two holes that would get partially covered
        if (length_x > 1) {
            translate([ADDITIONAL_SIDE_LENGTH, ADDITIONAL_SIDE_LENGTH/2, THICKNESS/2])
                cylinder(h=THICKNESS+0.01, r=THREADED_INSERT_RADIUS, center=true);
        }
        if (length_y > 1) {
            translate([ADDITIONAL_SIDE_LENGTH/2, ADDITIONAL_SIDE_LENGTH, THICKNESS/2])
                cylinder(h=THICKNESS+0.01, r=THREADED_INSERT_RADIUS, center=true);
        }
        
    }

}


module cube_single() {

    translate([ADDITIONAL_SIDE_LENGTH/2, ADDITIONAL_SIDE_LENGTH/2, ADDITIONAL_SIDE_LENGTH/2])
    
        difference() {
            
            cube(ADDITIONAL_SIDE_LENGTH, center=true);
            
            hole_displacement = ADDITIONAL_SIDE_LENGTH/2 - THREADED_INSERT_DEPTH + 0.01;

            // three pass-through small holes
            for (rot = [ [0, 0, 0], [90, 0, 0], [0, 90, 0] ])
                rotate(rot)
                    cylinder(h=ADDITIONAL_SIDE_LENGTH+0.02, r=THREADED_INSERT_RADIUS, center=true);

            // 4 big holes
            for (angle = [0:90:270]){
                rotate([angle, 0, 0])
                    translate([0, 0, hole_displacement])
                        cylinder(h=THREADED_INSERT_DEPTH, r=THREADED_INSERT_RADIUS, center=false);
            }
            
            // remaining 2 big holes
            for (angle = [-90:180:90]){
                rotate([0, angle, 0])
                    translate([0, 0, hole_displacement])
                        cylinder(h=THREADED_INSERT_DEPTH, r=THREADED_INSERT_RADIUS, center=false);
            }

        }
            
}


module cube_four() {

    translate([0, 0, 0])
        cube_single();         
    translate([ADDITIONAL_SIDE_LENGTH-0.01, 0, 0])
        cube_single();        
    translate([0, ADDITIONAL_SIDE_LENGTH-0.01, 0])
        cube_single();        
    translate([ADDITIONAL_SIDE_LENGTH-0.01, ADDITIONAL_SIDE_LENGTH-0.01, 0])
        cube_single();        

}


module cube_eight(spacer_height=0) {

    cube_four();

    translate([0, 0, ADDITIONAL_SIDE_LENGTH-0.01])
        cube([ADDITIONAL_SIDE_LENGTH*2-0.01, ADDITIONAL_SIDE_LENGTH*2-0.01, spacer_height], center=false);

    translate([0, 0, ADDITIONAL_SIDE_LENGTH+spacer_height-0.02])
        cube_four();         

}




// Joint connectors
two_planes_joint(3);
translate([60, 0, 0]) three_planes_joint(3);
translate([120, 0, 0]) arc_joint(3);
translate([200, 0, 0]) triangular_joint(3, 5);

// Cube connectors
translate([0, 100, 0]) cube_single();
translate([50, 100, 0]) cube_four();
translate([150, 100, 0]) cube_eight(10);
