startCategory(cfin).
[ty_] :: ([=c1, =ctee, c2],[A,B,Out] >> (Out = '1X+10Y'(B,A))). % A + 10 * B
[ty] :: ([=c1, +tee, c2],[A,Out] >> (Out = '10X'(A))). % A * 10
[teen] :: ([=c1, +tee, c2],[A,Out] >> (Out = '1X+10'(A))). % A + 10
[hundred_and] :: ([=c2, =c1, cfin],[A,B,Out] >> (Out = '1X+100Y'(B,A))). % A + 100 * B
[hundred] :: ([=cnix, =c1, c3],[A,B,Out] >> (Out = '0X+100Y'(B,A))). % 100 * B + epsilon

[one] :: ([c1],1). % 1
[two] :: ([c1],2). % 2
[three] :: ([c1],3). % 3
[four] :: ([c1, -tee],4). % 4
[five] :: ([c1],5). % 5
[six] :: ([c1, -tee],6). % 6
[seven] :: ([c1, -tee],7). % 7
[eight] :: ([c1, -ee],8). % 8
[nine] :: ([c1, -tee],9). % 9
[ten] :: ([c2],10). % 10
[eleven] :: ([c2],11). % 11
[twelve] :: ([c2],12). % 12
[thirteen] :: ([c2],13). % 13
[fifteen] :: ([c2],15). % 15
[een] :: ([=c1, +ee, c2],[A,Out] >> (Out = '0X+18'(A))). % 0 * A + 18
[twenty] :: ([=c1, c2],[A,Out] >> (Out = '1X+20'(A))). % A + 20
[twenty] :: ([c2],20). % 20
[thirty] :: ([c2],30). % 30
[thirty] :: ([=c1, c2],[A,Out] >> (Out = '1X+30'(A))). % A + 30
[fifty] :: ([c2],50). % 50
[fifty] :: ([=c1, c2],[A,Out] >> (Out = '1X+50'(A))). % A + 50
[y] :: ([=c1, +ee, c2],[A,Out] >> (Out = '0X+80'(A))). % 0 * A + 80
[y_] :: ([=c1, =cee, c2],[A,B,Out] >> (Out = '1X+10Y'(B,A))). % A + 0 * B + 80

[] :: ([=c1, cfin],[A,Out] >> (Out = A)). % epsilon
[] :: ([=c1, +tee, ctee],[A,Out] >> (Out = A)).	% epsilon
[] :: ([=c1, +tee, c1],[A,Out] >> (Out = A)). % epsilon
[] :: ([=c1, +tee, c2],[A,Out] >> (Out = A)). % epsilon
[] :: ([=c1, +ee, c1],[A,Out] >> (Out = A)). % epsilon
[] :: ([=c1, c2],[A,Out] >> (Out = A)). % epsilon
[] :: ([=c2, c3],[A,Out] >> (Out = A)). % epsilon
[] :: ([=c2, cfin],[A,Out] >> (Out = A)). % epsilon
[] :: ([=c3, cfin],[A,Out] >> (Out = A)). % epsilon

[] :: ([=c1, +ee, cee],[A,Out] >> (Out = A)). % epsilon
[] :: ([cnix],0). % epsilon
