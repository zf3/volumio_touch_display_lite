
W=95;
D=75;
H=17;

// OpenSCAD trigonometry is in degrees
alpha = 10;     // 面 [0,1,9,8] 与垂直之间的夹角度数
beta = 3;       // 其它三个接近垂直的面与垂直之间的夹角度数

module cover() {

/*

  0-__---------------__-1   
  |4__---------------__5|     8---------------------9
  ||                   ||     |12-----------------13|
  ||                   ||     ||                   ||
  ||>                 <||     ||                   ||
  |7-------------------6|     |15-----------------14|
  3----^^--^^^----------2     11-------------------10
         Bottom                        Top

*/

oa = H*tan(alpha); // Alpha角到顶部的偏移
ob = H*tan(beta);  // Beta角到顶部的偏移

oa2 = (H-2)*tan(alpha); // 顶部里面的偏移
ob2 = (H-2)*tan(beta);

points = [ [0,D,0], // 0
           [W,D,0], // 1
           [W,0,0], // 2
           [0,0,0],  // 3
           [2,D-2,0], // 4
           [W-2,D-2,0], // 5
           [W-2,2,0],   // 6
           [2,2,0],     // 7
           [ob,D-oa,H], // 8
           [W-ob,D-oa,H],   // 9
           [W-ob,ob,H],  // 10
           [ob,ob,H],    // 11
           [2+ob2,D-2-oa2,H-2],  // 12
           [W-2-ob2,D-2-oa2,H-2],         // 13
           [W-2-ob2,2+ob2,H-2],     // 14
           [2+ob2,2+ob2,H-2]];     // 15

faces = [  [8,9,10,11],      // top-out
           [12,15,14,13],       // top-in
           [0,3,7,4],   // bottom-left
           [0,4,5,1],   // bottom-top
           [1,5,6,2],   // bottom-right
           [2,6,7,3],   // bottom-bottom
           [0,8,11,3],  // leftside-out
           [4,7,15,12], // leftside-in
           [0,1,9,8],   // topside-out
           [4,12,13,5], // topside-in
           [1,2,10,9],  // rightside-out
           [5,13,14,6], // rightside-in
           [3,11,10,2], // bottomside-out
           [7,6,14,15]];

difference() {
    union() {
        polyhedron(points, faces, 10);
        translate([1,2,0]) cube([W-2,1,2]);
    }
    
    translate([17,0,-5]) cube(11);
    translate([43,0,0]) rotate([-90,0,0]) cylinder(h=4,r=7);
    translate([2,D-3,0]) cube([13,4,2]);
    translate([W-2-13,D-3,0]) cube([13,4,2]);
}

//translate([1,20,0]) cube([6,3,3]);  // 左侧下方卡子

//translate([W-1-6,20,0]) cube([6,3,3]);  // 右侧下方卡子

translate([1,D-2-3,0]) cube([15,3,3]);    // 左侧上方卡子

translate([W-1-15,D-2-3,0]) cube([15,3,3]);    // 右侧上方卡子

}

cover();

/*
minkowski()
{
    translate([0,D,H]) rotate([180,0,0]) cover();
    sphere(.25);
}*/
