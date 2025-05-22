// Jerusalem's Cross (Crusader's Cross) in OpenSCAD
// This design features a large central cross with four smaller crosses

// Parameters
main_cross_width = 60;
main_cross_height = 60;
main_cross_thickness = 8;
small_cross_size = 15;
small_cross_thickness = 6;
serif_length = 12;
serif_thickness = 6;

// Module to create a cross with serifs (terminals)
module create_cross_with_serifs(width, height, thickness) {
    union() {
        // Vertical bar
        cube([thickness, height, thickness], center=true);
        // Horizontal bar
        cube([width, thickness, thickness], center=true);
        
        // Serifs on horizontal arms
        translate([width/2, 0, 0])
            cube([thickness, serif_length, serif_thickness], center=true);
        translate([-width/2, 0, 0])
            cube([thickness, serif_length, serif_thickness], center=true);
        
        // Serifs on vertical arms
        translate([0, height/2, 0])
            cube([serif_length, thickness, serif_thickness], center=true);
        translate([0, -height/2, 0])
            cube([serif_length, thickness, serif_thickness], center=true);
    }
}

// Module to create a simple cross (for small crosses)
module create_cross(width, height, thickness) {
    union() {
        // Vertical bar
        cube([thickness, height, thickness], center=true);
        // Horizontal bar
        cube([width, thickness, thickness], center=true);
    }
}

// Jerusalem's Cross without base
module jerusalems_cross() {
    union() {
        // Main large cross with serifs
        create_cross_with_serifs(main_cross_width, main_cross_height, main_cross_thickness);
        
        // Four small crosses in quadrants
        translate([-main_cross_width/4, main_cross_height/4, 0])
            create_cross(small_cross_size, small_cross_size, small_cross_thickness);
        
        translate([main_cross_width/4, main_cross_height/4, 0])
            create_cross(small_cross_size, small_cross_size, small_cross_thickness);
        
        translate([-main_cross_width/4, -main_cross_height/4, 0])
            create_cross(small_cross_size, small_cross_size, small_cross_thickness);
        
        translate([main_cross_width/4, -main_cross_height/4, 0])
            create_cross(small_cross_size, small_cross_size, small_cross_thickness);
    }
}

// Render the Jerusalem's Cross
jerusalems_cross();
