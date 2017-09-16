include <lasercutBox.scad>;
cut=true;
home=[0,0,0];
bw=1;
echo (cut? "yes": " no");
if (cut) {
    projection() testboxes();
} else {
    testboxes();
}

module arrangeCut(space) {
      for ( i= [0:1:$children-1])   // step needed in case $children < 2  
      translate([cut?i*space:0,0,0]) {
          children(i);
          //translate([0,i*space,0]) text(str(i));
          }

    }

module testboxes() {
  arrangeCut(85) {
    translate(cut?home:[0,0,0]) 
        lasercutoutBox4(thickness = 2, x=40, y=50, z=60);
    translate(cut?[0,0,0]:[0,0,60]) 
        lasercutoutBox5(thickness = 2, x=40, y=50, z=60);
    translate(cut?[5,0,0]:[10,50,0]) 
        lasercutoutBox6(thickness = 2, x=40, y=50, z=60);
    }
  }