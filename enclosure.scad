// BME280 sensor enclosure
// Licensed under the GPLv3, see "COPYING"

// Increase resolution
$fn=50;

// Cover olerance
buff = .5;

// Center compartment
body_x = 25;
body_y = 40;
body_z = 10;
body_t = 2;
cover_t = 2;

// Mounting tabs
wings_x = 60;
wings_dia = 15;
wings_z = 3;
wings_y_margin = 5;

// PCB mount
pcb_post_w = 13;
pcb_post_dia = 5;
pcb_post_z = 6;
pcb_post_y_offset = 16;

// Screw sizes
pcb_dia = 2.5;
cover_dia = 3.1;
cover_cs = 6.6;
mounting_dia = 4;

// Post settings
post_dia = 6;
post_offset = 1.5;

// Grille
grille_x = (body_x / 1.2);
grille_gap = 2;
grille_num = 8;
grille_angle = 25;

// Static math
pcb_z_offset = ((body_t / 2) + (pcb_post_z / 2));

// Modules
module wu_logo()
{
    translate([2, -((body_y / 2) + 3), (body_z / 2)])
        scale([.25, .25, 2])
            import("STL/wu_logo.stl");
}

module rounded_rect(xsize, ysize, zsize)
{
    hull()
    {
        translate([-(xsize / 2), 0, 0])
        {
            translate([0, -(ysize / 2), 0])
                cylinder(h=zsize, r=5, center=true);
        
            translate([0, (ysize / 2), 0])
                cylinder(h=zsize, r=5, center=true); 
        }

        translate([(xsize / 2), 0, 0])
        {
            translate([0, -(ysize / 2), 0])
                cylinder(h=zsize, r=5, center=true);
        
            translate([0, (ysize / 2), 0])
                cylinder(h=zsize, r=5, center=true);         
        }
    }
}

module corner_post(dia)
{   
    translate([-((body_x / 2) + post_offset), 0, (body_z / 2)])
    {
        translate([0, -((body_y / 2) + post_offset), 0])
            cylinder(h=body_z, r=(dia / 2), center=true);
        
        translate([0, ((body_y / 2) + post_offset), 0])
                cylinder(h=body_z, r=(dia / 2), center=true); 
    }

    translate([((body_x / 2) + post_offset), 0, (body_z / 2)])
    {
        translate([0, -((body_y / 2) + post_offset), 0])
            cylinder(h=body_z, r=(dia / 2), center=true);
        
        translate([0, ((body_y / 2) + post_offset), 0])
            cylinder(h=body_z, r=(dia / 2), center=true);         
    }
}

module pcb_post(dia)
{   
    translate([0, pcb_post_y_offset, pcb_z_offset])
    {
        translate([-(pcb_post_w / 2), 0, 0])
            cylinder(h=pcb_post_z, r=(dia / 2), center=true);
        
        translate([(pcb_post_w / 2), 0, 0])
            cylinder(h=pcb_post_z, r=(dia / 2), center=true);
    }        
}

module mounting_holes()
{
    translate([-(wings_x / 2), 0, 0])
        cylinder(h=(wings_z + 2), r=(mounting_dia / 2), center=true);
            
    translate([(wings_x / 2), 0, 0])
        cylinder(h=(wings_z + 2), r=(mounting_dia / 2), center=true);
}

module wing_tips()
{
    translate([-(wings_x / 2), 0, 0])
        cylinder(h=wings_z, r=(wings_dia / 2), center=true);
    
    translate([(wings_x / 2), 0, 0])
        cylinder(h=wings_z, r=(wings_dia / 2), center=true);
}

module backplate()
{
    hull()
    {
        wing_tips();
        rounded_rect(body_x, (body_y + (wings_y_margin * 2)), wings_z);
    }
}

module side_openings()
{
    translate([0, 0, 1])
    {
        // Top/bottom
        cube([(body_x / 2), (body_y * 1.5), body_z], center=true);
        // Left/Right    
        cube([(body_y * 1.5), (body_y / 1.5), body_z], center=true);
    }
}

module body()
{
    translate([0, 0, (body_z / 2)])
        difference()
        {
            // Outside
            rounded_rect(body_x, body_y, body_z);
            // Inside
            rounded_rect((body_x - body_t), (body_y - body_t), (body_z + 1));
            side_openings();
        }
}

module front_grille()
{
	rotate([grille_angle, 0, 0])
        for (i = [-(body_y / 8):grille_gap:(body_y / 2.3)])
            translate([-(grille_x / 2), i, -((body_z / 2) + 2)])
                cube([grille_x, 1, (body_z * 2)]);
}

module side_grille()
{
	rotate([0, 90, 0])
        for (i = [-(body_y / 6):grille_gap:(body_y / 3)])
            translate([-((grille_x / 1.8) - body_z), i, -(body_y / 1.5)])
                cube([(body_z / 1.8), 1, (body_x * 2)]);
}

module cover()
{
    difference()
    {
        // Outside shape
        rounded_rect((body_x + (body_t * 2)), (body_y + (body_t * 2)), (body_z + cover_t));
        
        // Void (translate -Z for top thickness)
        translate([0, 0, -cover_t])
            rounded_rect((body_x + buff), (body_y + buff), body_z);
        
        // Screw hole and countersink
        translate([0, 0, 0])
            corner_post((cover_dia + .5));
        
        translate([0, 0, ((body_z / 2) - .5)])
            corner_post(cover_cs);
        
        // Grille
        front_grille();
        side_grille();
        
        // Opening for wire
        sensor_cable();        
        
        // WU logo
        wu_logo();
    }
}

module sensor_cable()
{
    translate([0, -((body_y / 2) + 5), -4.5])
        rotate([90, 0, 0])
        {
            cylinder(h=5.2, r=3, center=true);
            translate([0, -1.8, 0])
                cube([6, 3, 6], center=true);
        }
}

module pcb_mount()
{
    difference()
    {
        pcb_post(pcb_post_dia);
        translate([0, 0, 1])
            pcb_post(pcb_dia);
    }
    
    translate([0, 5, (body_t + 1)])
        cube([15, 5, pcb_post_z], center=true);
}

module strain_relief()
{
    translate([0, -14, (body_t * 2)])
    {
        difference()
        {
            cube([18, 5, 5], center=true);
            translate([4, 0, 0])
                cube([5, 6, 6], center=true);
            translate([-4, 0, 0])
                cube([5, 6, 6], center=true);            
        }
    }
}

module bottom()
{
    difference()
    {
        backplate();
        mounting_holes();
    }

    difference()
    {
        union()
        {
            body();
            corner_post(post_dia);
        }
        
        translate([0, 0, 2])
            corner_post(cover_dia);
    }
    
    // Mount points for PCB
    pcb_mount();
    
    // Hold wire
    strain_relief();
}

module board_placeholder()
{
    color("blue") cube([19, 19, 3], center=true);
}

// Rendering
bottom();
//translate([0, 0, 8]) cover();
//translate([0, 9, 6]) board_placeholder();

// STL Export
//rotate([0, 180, 0]) cover();

// EOF
