// 1cm to 1foot scale model of the IBM Q System One Quantum Computer

// Andy Stanford-Clark
// andysc@uk.ibm.com / @andysc
// Feb '19


// v4.5 is a tidy-up for publication
// v4 is the redesigned glass idea for the base and lid
// v3 adds the deltas for the exploded view



// print list...

// 1. base 
// 2. base_lid 
// 3. back_box  * print with raft *
// 4. top_box * print with 1mm brim *
//    (then trim off all *except* the hole where the diffuser goes, as we need the lip to sit the diffuser on)
// 5. top_box_lid (inverted) 
// 6. lid (inverted)
// 7. lid_lower (inverted)
// 8. lid plinth (inverted for smoothness)

// 9. reflector in white (inverted)
// 10. reflector_strip in white

// 11. diffuser in clear filament (inverted) 

// cryostat needs to be a 25mm x 44mm silver tube (I used chrome-plated wardrobe rail)

// glass walls in 1mm acrylic
// front and back: 92 x 81 mm
// left and right: 85 x 81 mm 

// --------------------------------------------------------------------------------
// these should be the only bits you need to change (down to next dashed line)

// which bits to print?
// set each of these true in turn, and all the others false, to make each component


base = true;
base_lid = false;
back_box = false;
top_box = false;
top_box_lid = false;

// translucent
diffuser = false;

// white
reflector = false;
reflector_strip = false;

lid = false;
lid_lower = false; // the "lid" of the lid, if you like!
lid_plinth = false; // the thin plate on the very very top of the system


// --------------------------------------------------------------------------------
// optional elements for display purposes

cryostat = false; // we're not going to print this - it's just for display

// master control for walls
walls = false;
// selectively remove some of the walls
left_wall=true;
right_wall=false;
front_wall=false;
back_wall=true;


explode = 0; // set to 1 to explode the view, 0 normally

// --------------------------------------


wiring = true; // put in the cut-outs for a micro-USB cable
// how much extra height do we need on the base to allow for the cable?
extra_base = 1.5;


d = 3;
d1 = explode * d;     // base lid
d2 = explode * d*2; // back box
d3 = explode * d*5; // top box
d4 = explode * d*6.2; // lid lower
d5 = explode * d*7; // lid
d6 = explode * d*7.5; // lid plinth
d7 = explode * d*3; // diffuser 
d8 = explode * d*6; // top box lid
d9 = explode * d*2; // walls
d10 = explode * d*2; // cryostat


black = "white"; 
//black = "black";
white = "red";
//white = "white";

// going with a scale of 1cm to 1ft, so as it's 9ft wide, it's 90mm wide
// this is the INSIDE measurement - the flange for the glass is outside this
width = 90;
height = 90;
depth = 85;



mink_radius = 3;

// things that fit inside each other (e.g. diffuser inside top box)
// i.e. 0.5 mm total if you allow this each side (i.e. 2*)
tolerance = 0.25;

base_height = 6;
// make the back box a little bit lower just to allow for joint tolerances and stuff
back_box_height = 65 - 1; // this should be 65
back_box_depth = 37;   

top_box_height = 10;
// how far inset is the top box?
inside_gap = 3;

cryostat_height = 43;
cryostat_diameter = 25;

lid_height = 5;
// size of hole for wire in top box
wire_hole = 5;

// how thick to make the internal box walls
box_walls = 1.5;

// how thick is the half inch thick plate glass?
glass_thickness = 1;

// how thin to make the little outside lip of the base?
edge_delta = 0.5;
 
 
 
// here we go....  

back_box_width = width - 2*inside_gap;

color(black) {
    
// base
if (base) {
    difference() {
        translate([-glass_thickness, -glass_thickness, -extra_base])
            cube([width + 2*glass_thickness, depth + 2*glass_thickness, 
            base_height-1+extra_base]);
        // hollow out the insides
        translate([1, 1,-extra_base+box_walls])
            cube([width - 2, depth - 2, base_height-box_walls-1+extra_base]);
        // make a lip 1mm down for the lid to rest on
        translate([0, 0, base_height-1-1])
            cube([width, depth, 1]);
        
        // make the hole for the cable to come in
        if (wiring)
            translate([width - 7, depth -1, box_walls-extra_base])
                #cube([4.5,1+glass_thickness,base_height-box_walls-1+extra_base]);
        
    }  
}


// base lid
if (base_lid) {    
        difference() {
            union() {
                // lid panel
                translate([0,0,base_height-1-1 + d1])
                    cube([width-2*tolerance, depth-2*tolerance, 2]);
        
                // make a stub for the back box to sit over
                translate([inside_gap+mink_radius, inside_gap + (25+15) + mink_radius, base_height])
                // 1.5 * tolerance cos that's half of 3
                   translate([box_walls+1.5*tolerance, box_walls+1.5*tolerance, 0])
                        difference() {
                            minkowski() {
                                // make it 3*tolerance for a bit of extra wiggle room
                                cube([back_box_width-2*mink_radius - 2*box_walls - 3*tolerance, 
                                    back_box_depth-2*mink_radius - 2*box_walls - 3*tolerance, 
                                    2]);
                                // where '2' is the height of the stub
                                cylinder(r=mink_radius, h=0.0001, $fn=100);
                            }
                            // hollow out the inside
                            translate([box_walls, box_walls, 0])
                                minkowski() {
                                    cube([back_box_width-2*mink_radius - 2*box_walls - 2*tolerance - 2*box_walls, 
                                        back_box_depth-2*mink_radius - 2*box_walls - 2*tolerance - 2*box_walls, 
                                        2]);
                                    // where '2' is the height of the stub
                                    cylinder(r=mink_radius, h=0.0001, $fn=100);
                                }
                       } // difference
                   } // union
                   
        // make the hole for a cable to come in
        if (wiring) {
            // hole right through the base for micro USB plug to go through
            translate([inside_gap+mink_radius + back_box_width - 15, 
                        inside_gap + (25+15) + mink_radius + back_box_depth - 15,
                        0]) 
                cylinder(d=15, h=base_height, $fn=100);
 
        } // wiring
        
    }  // difference
}
    

// back box
if (back_box) {

  translate([inside_gap+mink_radius, inside_gap + 25+15 + mink_radius, base_height + d2]) {
 
    difference() {
        minkowski() {
            cube([back_box_width-2*mink_radius, back_box_depth-2*mink_radius, back_box_height]);
            cylinder(r=mink_radius, h=0.0001, $fn=100);
        }
        translate([box_walls, box_walls, 0])
            minkowski() {
                cube([back_box_width-2*mink_radius - 2*box_walls, 
                    back_box_depth-2*mink_radius - 2*box_walls, 
                    back_box_height+0.1]);
                cylinder(r=mink_radius, h=0.0001, $fn=100);
        }
    }
    
    // add a little lip for the top box to register onto
    translate([box_walls,back_box_depth - 2*mink_radius - wire_hole - box_walls,
        back_box_height - 5])
        difference() {    
            minkowski() {
                cube([width - 2*inside_gap - 2*mink_radius - 2*box_walls, 
                        wire_hole,
                    box_walls + 5]);
                cylinder(r=mink_radius, h=0.0001, $fn=100);
            }
            // take out the "inside"
                translate([box_walls,-box_walls,0])
                minkowski() {
                    cube([width - 2*inside_gap - 2*mink_radius - 2* 2*box_walls, 
                            wire_hole,
                        box_walls + 5]);
                    cylinder(r=mink_radius, h=0.0001, $fn=100);
                }
        // don't cut out a block the size of the minkowski radius added on top and bottom, 
        // so the hole is actually wire_holes mm across    
        translate([-mink_radius,-mink_radius,0])
            cube([width - 2*inside_gap - 0*2*mink_radius - 2*box_walls, 
            2*mink_radius + tolerance, box_walls + 5+0.1]);
        }
    }

}

// top box
if (top_box) {
translate([inside_gap+mink_radius, inside_gap + mink_radius, base_height + back_box_height + d3])
    difference() {
        minkowski() {
            cube([width - 2*inside_gap - 2*mink_radius, 77 - 2*mink_radius,              top_box_height - box_walls]);
            cylinder(r=mink_radius, h=0.0001, $fn=100);
        }
        // hollow out the inside
        translate([box_walls, box_walls, box_walls]) {
            minkowski() {
                cube([width - 2*inside_gap - 2*mink_radius - 2*box_walls, 
                        77 - 2*mink_radius - 2*box_walls,
                    top_box_height+0.1]);
                cylinder(r=mink_radius, h=0.0001, $fn=100);
            }
            
            // hole for the diffuser
            translate([0,0,-box_walls])
                minkowski() {
                    cube([width - 2*inside_gap - 2*mink_radius - 2*box_walls, 
                            5/8* 77 - 2*mink_radius - 2*box_walls,
                        top_box_height+0.1]);
                    cylinder(r=mink_radius, h=0.0001, $fn=100);
                }
             
            // a hole for the wires
            translate([0,77 - 2*mink_radius - 2*box_walls - wire_hole,-box_walls])         
                difference() {    
                    minkowski() {
                        cube([width - 2*inside_gap - 2*mink_radius - 2*box_walls, 
                                wire_hole,
                            box_walls+0.1]);
                        cylinder(r=mink_radius, h=0.0001, $fn=100);
                    }
                    // leave a block the size of the minkowski radius added on top and bottom, 
                    // so the hole is actually wire_holes mm across    
                    translate([-mink_radius,-mink_radius,0])
                        cube([width - 2*inside_gap - 2*box_walls, 
                        2*mink_radius, box_walls]);
            }
        }
    }
}


if (top_box_lid)
    translate([inside_gap+mink_radius, inside_gap + mink_radius, base_height + back_box_height+top_box_height - box_walls + d8]) {
         minkowski() {
            cube([width - 2*inside_gap - 2*mink_radius, 77 - 2*mink_radius,              box_walls]);
            cylinder(r=mink_radius, h=0.0001, $fn=100);
        }      
        translate([box_walls+tolerance, box_walls+tolerance, -box_walls/2]) {
        minkowski() {
            cube([width - 2*inside_gap - 2*mink_radius - 2*box_walls - 2*tolerance, 
                    77 - 2*mink_radius - 2*box_walls - 2*tolerance,
                box_walls/2]);
            cylinder(r=mink_radius, h=0.0001, $fn=100);
        }   
    }
}


// lid
if (lid) {
    
    translate([0,0, height - lid_height + 1 + d5]) 
    
    difference() {
        translate([-glass_thickness, -glass_thickness, 0])
            cube([width + 2*glass_thickness, depth + 2*glass_thickness, lid_height-1]);
        // remove the insides
        translate([1, 1, 0])
            cube([width - 2, depth - 2, lid_height - 1 - box_walls]);
        // make a lip 1mm down for the lid to rest on
        translate([0, 0, 0])
            cube([width, depth, 1]);
    }
}


// lid lower
if (lid_lower) {
    translate([tolerance,tolerance,height - lid_height + d4]) 
        cube([width - 2*tolerance, depth - 2*tolerance, 1 + 1]);
}


// lid plinth
// the thin plate on top of the lid (which is hard to print in place)
if (lid_plinth)
    translate([0,0,height - lid_height + d6]) 
       translate([inside_gap/2, inside_gap/2, lid_height])
            cube([width - inside_gap, depth - inside_gap, 1]);
    

} // end of black



color(white) {
    // reflector
    if (reflector)
        translate([inside_gap+ mink_radius, 
                inside_gap, 
                base_height + back_box_height + top_box_height - box_walls - box_walls/2+0*15]) {
         
            translate([box_walls+tolerance, box_walls+tolerance, -0.5]) {
                          
                cube([width - 2*inside_gap - 2*box_walls - 2*tolerance - mink_radius*2, 
                        77 - 2*box_walls - 2*tolerance -5,
                    0.5]);
                
                difference() {
                               
                translate([0,0,- (top_box_height - box_walls/2 - 2*box_walls) + box_walls/2])
                    cube([width - 2*inside_gap - 2*box_walls - 2*tolerance - mink_radius*2,
                           5.5/8* 77 - 2*mink_radius - 2*box_walls - 2*tolerance,
                            top_box_height - box_walls/2 - 2*box_walls - box_walls/2]);
                               
                translate([0.5, 0, -(top_box_height - box_walls/2 - 2*box_walls)])
                  rotate([-7,0,180])
                    translate([-(width - 2*inside_gap - 2*box_walls - 2*tolerance - mink_radius*2),
                            -(5.5/8* 77 - 2*mink_radius - 2*box_walls - 2*tolerance)-0.5,-6-0.3])
                       cube([width - 2*inside_gap - 2*box_walls - 2*tolerance - mink_radius*2 + 1,
                           5.5/8* 77 - 2*mink_radius - 2*box_walls - 2*tolerance + 1,
                            top_box_height - box_walls/2 - 2*box_walls +1]);
                }
                    
        }
    }


    // reflector strip
    // small rectangle of white for the bottom of the top_box
    if (reflector_strip) 
       translate([inside_gap+ mink_radius, inside_gap + 0*mink_radius, base_height + back_box_height+0*top_box_height - box_walls+5]) 
            translate([0, 5/8* 77 - 0*2*mink_radius - 2*box_walls, 0]) {
         
            translate([box_walls+tolerance, box_walls+tolerance, -0.5]) {
     
                cube([width - 2*inside_gap - 2*box_walls - 2*tolerance - mink_radius*2, 
                        3/8* 77 - 2*box_walls - 2*tolerance -3 ,
                    0.5]);
                    
        }
    }

}


 // diffuser
 if (diffuser) {
    color(white) {
    difference() {
        
        translate([inside_gap+mink_radius+box_walls+tolerance, 
                inside_gap + mink_radius + box_walls+tolerance, 
                base_height + back_box_height + d7]) {
            minkowski() {
            cube([width - 2*inside_gap - 2*mink_radius - 2*box_walls - 2*tolerance, 
                    5/8* 77 - 2*mink_radius - 2*box_walls - 2*tolerance,
                    box_walls*1 + 0*1.5]);
                // add 1.5mm to see if it diffuses better
             cylinder(r=mink_radius, h=0.0001, $fn=100);
            }
        }
        // make a little hole for the cryostat to sit in
        translate([width/2, inside_gap + 7.5 + cryostat_diameter/2, 
            base_height + back_box_height + d7])
            cylinder(d=cryostat_diameter+ 2*tolerance, h=box_walls/2, $fn=200);
    }  
    // make a little mound for the chrome tube to sit over
    translate([width/2, inside_gap + 7.5 + cryostat_diameter/2, 
            base_height + back_box_height - 5 + box_walls + d7])
            cylinder(d=cryostat_diameter - 1 - 2*tolerance, h=5, $fn=200);
            // where "1" is 2 x the wall thickness of the chrome tube
            // and where "5" (in the translate and the cylinder) are the height of the mound
  }
}

    

// cryostat - this is just for show
if (cryostat) 
    color("white")
        translate([width/2, inside_gap + 7.5 + cryostat_diameter/2, 
            base_height + back_box_height - cryostat_height + d10])
            cylinder(d=cryostat_diameter, h=cryostat_height, $fn=200);


// walls - just for show
if (walls) 
    translate([0,0,d9])
    color("blue") {
        echo("front/back", width + 2*glass_thickness, height-base_height - lid_height + 2);
        echo("left/right", depth, height-base_height - lid_height + 2);
        
        // front
        if (front_wall)
        translate([-glass_thickness, -glass_thickness - d9, base_height - 1])
            #cube([width + 2*glass_thickness, glass_thickness, 
                height-base_height - lid_height + 2]);
        // back
        if (back_wall)
        translate([-glass_thickness, depth + d9, base_height - 1])
            #cube([width + 2*glass_thickness, glass_thickness, 
                height-base_height - lid_height + 2]);
        // left
        if (left_wall)
        translate([-glass_thickness - d9, 0, base_height-1])
            #cube([glass_thickness, depth, 
                height-base_height - lid_height + 2]);
        // right
        if (right_wall)
        translate([width + d9, 0, base_height-1])
            #cube([glass_thickness, depth, 
                height-base_height - lid_height + 2]);
            
    }

// END
