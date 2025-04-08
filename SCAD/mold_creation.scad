// Star Mold Creator Design
// Creates a design that can be used to make star molds
// All dimensions in millimeters

// Basic parameters
base_width = 40;     // 4 cm in mm
base_length = 40;    // 4 cm in mm
star_depth = 15;     // 3 cm in mm
wall_thickness = 5;  // 5 mm walls

// Star parameters
outer_radius = 18;   // Outer points of the star (increased size)
inner_radius = 9;    // Inner points of the star
num_points = 5;      // Number of points on the star

// Calculated dimensions
outer_width = base_width + 2*wall_thickness;
outer_length = base_length + 2*wall_thickness;
outer_height = star_depth + wall_thickness;

// Create a 2D star polygon
module star_2d(outer_r, inner_r, points) {
    angles = [for (i = [0:2*points-1]) i * 180 / points];
    radii = [for (i = [0:2*points-1]) i % 2 == 0 ? outer_r : inner_r];
    
    polygon([
        for (i = [0:2*points-1])
            [radii[i] * cos(angles[i]), radii[i] * sin(angles[i])]
    ]);
}

// Main design - a star-shaped protrusion on a base with containing walls
union() {
    // Base plate
    cube([outer_width, outer_length, wall_thickness]);
    
    // Star protrusion
    translate([outer_width/2, outer_length/2, wall_thickness])
        linear_extrude(height = star_depth)
            star_2d(outer_radius, inner_radius, num_points);
    
    // Containing walls around the edge of the base
    difference() {
        // Outer wall cube
        cube([outer_width, outer_length, wall_thickness + 15]);
        
        // Inner cutout
        translate([wall_thickness, wall_thickness, wall_thickness])
            cube([base_width, base_length, 20]);
    }
}