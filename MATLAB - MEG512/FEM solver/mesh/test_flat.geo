//+
Point(1) = {0, 0, 0, 1.0};
//+
Point(2) = {1, 0, 0, 1.0};
//+
Point(3) = {0, 1, 0, 1.0};
//+
Point(4) = {1, 1, 0, 1.0};
//+
Line(1) = {3, 1};
//+
Line(2) = {1, 2};
//+
Line(3) = {2, 2};
//+
Line(4) = {2, 4};
//+
Line(5) = {4, 3};
//+
Curve Loop(1) = {1, 2, 4, 5};
//+
Surface(1) = {1};
//+
Transfinite Curve {1, 2, 4, 5} = 10 Using Progression 1;
//+
Transfinite Surface {1};
//+
Transfinite Surface {1};
//+
Transfinite Curve {2, 4} = 10 Using Progression -1;
