startCategory(cfin).
[een] :: [=c1,+b,c3].
[een] :: [=c1,+b,c2].
[een] :: [=c1,+b,c2,-s1].
[een] :: [=c1,+b,cfin].
[eight] :: [c2b].
[eight] :: [c1].
[eight] :: [c1,-b].
[eight] :: [c2].
[eight] :: [c3].
[eight] :: [cfin].
[eleven] :: [c3].
[eleven] :: [c2].
[eleven] :: [c2,-s1].
[eleven] :: [cfin].
[fifteen] :: [c3].
[fifteen] :: [c2].
[fifteen] :: [c2,-s1].
[fifteen] :: [cfin].
[fifty] :: [c3].
[fifty] :: [c2].
[fifty] :: [c2,-s1].
[fifty] :: [cfin].
[fifty_] :: [=c1,c3].
[fifty_] :: [=c1,c2].
[fifty_] :: [=c1,c2,-s1].
[fifty_] :: [=c1,cfin].
[five] :: [c2].
[five] :: [c3].
[five] :: [c1].
[five] :: [cfin].
[forty] :: [c3].
[forty] :: [c2].
[forty] :: [c2,-s1].
[forty] :: [cfin].
[forty_] :: [=c1,c3].
[forty_] :: [=c1,c2].
[forty_] :: [=c1,c2,-s1].
[forty_] :: [=c1,cfin].
[four] :: [c1].
[four] :: [c1,-a].
[four] :: [c2].
[four] :: [c3].
[four] :: [cfin].
[hundred] :: [=cnix,=c1,cfin].
[hundred] :: [=cnix,=c1,c3].
[hundred_and] :: [=c2,=c1,cfin].
[hundred_and] :: [=c2,=c1,c3].
[nine] :: [c1,-a].
[nine] :: [c1,-a,-d].
[nine] :: [c1].
[nine] :: [c2].
[nine] :: [c3].
[nine] :: [cfin].
[one] :: [c2].
[one] :: [c3].
[one] :: [c1].
[one] :: [cfin].
[seven] :: [c1,-a].
[seven] :: [c1,-a,-d].
[seven] :: [c1].
[seven] :: [c2].
[seven] :: [c3].
[seven] :: [cfin].
[six] :: [c1,-a].
[six] :: [c1,-a,-d].
[six] :: [c1].
[six] :: [c2].
[six] :: [c3].
[six] :: [cfin].
[teen] :: [=c1,+a,c3].
[teen] :: [=c1,+a,c2].
[teen] :: [=c1,+a,c2,-s1].
[teen] :: [=c1,+a,cfin].
[ten] :: [c3].
[ten] :: [c2].
[ten] :: [c2,-s1].
[ten] :: [cfin].
[thirteen] :: [c3].
[thirteen] :: [c2].
[thirteen] :: [c2,-s1].
[thirteen] :: [cfin].
[thirty] :: [c3].
[thirty] :: [c2].
[thirty] :: [c2,-s1].
[thirty] :: [cfin].
[thirty_] :: [=c1,c3].
[thirty_] :: [=c1,c2].
[thirty_] :: [=c1,c2,-s1].
[thirty_] :: [=c1,cfin].
[three] :: [c2].
[three] :: [c3].
[three] :: [c1].
[three] :: [cfin].
[twelve] :: [c3].
[twelve] :: [c2].
[twelve] :: [c2,-s1].
[twelve] :: [cfin].
[twenty] :: [c3].
[twenty] :: [c2].
[twenty] :: [c2,-s1].
[twenty] :: [cfin].
[twenty_] :: [=c1,c3].
[twenty_] :: [=c1,c2].
[twenty_] :: [=c1,c2,-s1].
[twenty_] :: [=c1,cfin].
[two] :: [c2].
[two] :: [c3].
[two] :: [c1].
[two] :: [cfin].
[ty] :: [=c1,+d,c3].
[ty] :: [=c1,+d,c2].
[ty] :: [=c1,+d,c2,-s1].
[ty] :: [=c1,+d,cfin].
[ty_] :: [=c1,=c2d,c3].
[ty_] :: [=c1,=c2d,c2].
[ty_] :: [=c1,=c2d,c2,-s1].
[ty_] :: [=c1,=c2d,cfin].
[y] :: [=c1,+b,c3].
[y] :: [=c1,+b,c2].
[y] :: [=c1,+b,c2,-s1].
[y] :: [=c1,+b,cfin].
[y_] :: [=c1,=c2b,c3].
[y_] :: [=c1,=c2b,c2].
[y_] :: [=c1,=c2b,c2,-s1].
[y_] :: [=c1,=c2b,cfin].
[nine] :: [c2d].
[seven] :: [c2d].
[six] :: [c2d].
[] :: [cnix].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% these should succed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse("seven",T).
% parse("twenty",T).
% parse("twenty_,one",T).
% parse("six,teen",T).
% parse("forty_,seven",T).
% parse("two,hundred_and,four",T).
% parse("two,hundred_and,eight,y_,six",T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%these should fail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse("fourty_,seven",T).
% parse("bacon",T).
% parse("two,hundred",T).