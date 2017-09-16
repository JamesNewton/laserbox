# laserbox
An OpenSCAD script for making 3D boxes and then laying them flat for laser cutting.

This script shows how to build a 3D object from multiple shapes including boxes, and then with one variable change, lay all the flat sides out for laser cutting. 

The variable is 
cut=true; //true= lay flat, false= 3D

The layout is assisted by a box making script which responds to the same global variable. 

This is based on the work of 
https://github.com/bmsleight/lasercut
but without the post processing from comments and re-importing. This script directly switches between the two modes.

Positioning of the parts for cutting is assisted by the arrangeCut module which spaces out the children on a regular interval. This can be adjusted by contintional translation in the design. 

While not ideal, the script may be of value, especially where parametric design of a lasercutable object is desired.
