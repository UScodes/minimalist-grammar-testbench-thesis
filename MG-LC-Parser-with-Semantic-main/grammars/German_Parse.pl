startCategory(cfin).
[acht] :: ([c1,-b],8).
[acht] :: ([c2b],8).
[acht] :: ([cfin],8).
[acht] :: ([c3e],8).
[drei] :: ([c1,-c],3).
[drei] :: ([cfin],3).
[drei] :: ([c3e],3).
[eins] :: ([cfin],1).
[eins] :: ([c3e],1).
[einund] :: ([=c21s,cfin],abst(x, '1X+1'(x))).
[einund] :: ([=c23s,cfin],abst(x, '1X+1'(x))).
[einundsechzig] :: ([c3e],61).
[einundsiebzig] :: ([c3e],71).
[einundzwanzig] :: ([c3e],21).
[elf] :: ([c3e],11).
[fünf] :: ([c1,-b],5).
[fünf] :: ([c2b],5).
[fünf] :: ([cfin],5).
[fünf] :: ([c3e],5).
[hundert] :: ([cfin],100).
[hundert] :: ([=c1,+b,cfin],abst(x,'100X'(x))).
[hundert] :: ([=c3e,cfin],abst(x,'1X+100'(x))).
[hundert] :: ([=c3e,=c2b,cfin],abst(x, abst(y,'1X+100Y'(x,y)))).
[neun] :: ([c1,-b],9).
[neun] :: ([c2b],9).
[neun] :: ([cfin],9).
[neun] :: ([c3e],9).
[sechs] :: ([c2b],6).
[sechs] :: ([c1,-b],6).
[sechs] :: ([c3e],6).
[sechs] :: ([cfin],6).
[sechzehn] :: ([c3e],16).
[sechzig] :: ([c3e],60).
[sieben] :: ([c2b],7).
[sieben] :: ([c1,-b],7).
[sieben] :: ([c3e],7).
[sieben] :: ([cfin],7).
[siebzehn] :: ([c3e],17).
[siebzig] :: ([c3e],70).
[und] :: ([=c22s,=c2b,cfin],abst(x, abst(y, '1X+1Y+3'(x,y)))).
[und] :: ([=c24s,=c2b,cfin],abst(x, abst(y,'1X+1Y'(x,y)))).
[undsechzig] :: ([=c1,+b,cfin],abst(x, plus60(x))).
[undsiebzig] :: ([=c1,+b,cfin],abst(x, plus70(x))).
[undzwanzig] :: ([=c1,+b,cfin],abst(x, '1X+20'(x))).
[vier] :: ([c1,-b],4).
[vier] :: ([c1,-d],4).
[vier] :: ([c2b],4).
[vier] :: ([cfin],4).
[vier] :: ([c3e],4).
[zehn] :: ([c3e],10).
[zehn] :: ([=c1,+a,cfin],abst(x,'1X+10'(x))).
[zig] :: ([=c1,+d,cfin],abst(x, '10X'(x))).
[zig] :: ([=c1,+d,c23s],abst(x,'10X+1'(x))).
[zig] :: ([=c1,+d,c24s],abst(x,'10X+N'(x))).
[zig] :: ([=c1,+d,c3e],abst(x, '10X'(x))).
[zwanzig] :: ([c3e],20).
[zwei] :: ([c2b],2).
[zwei] :: ([c1,-b],2).
[zwei] :: ([c3e],2).
[zwei] :: ([cfin],2).
[zwölf] :: ([c3e],12).
[ßig] :: ([=c1,+c,cfin],abst(x, '0X+30'(x))).
[ßig] :: ([=c1,+c,c21s],abst(x, '0X'(x))).
[ßig] :: ([=c1,+c,c22s],abst(x, '9X'(x))).
[acht] :: ([c1,-a],8).
[drei] :: ([c2b],3).
[drei] :: ([c1,-b],3).
[einundsechzig] :: ([cfin],61).
[einundsiebzig] :: ([cfin],71).
[einundzwanzig] :: ([cfin],21).
[elf] :: ([cfin],11).
[fünf] :: ([c1,-a],5).
[neun] :: ([c1,-a],9).
[sechzehn] :: ([cfin],16).
[sechzig] :: ([cfin],60).
[siebzehn] :: ([cfin],17).
[siebzig] :: ([cfin],70).
[vier] :: ([c1,-a],4).
[zehn] :: ([cfin],10).
[zwanzig] :: ([cfin],20).
[zwölf] :: ([cfin],12).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% these should succed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse("eins",T).
% parse("sieben",T).
% parse("zwei,undzwanzig",T).
% parse("drei,ßig",T).
% parse("zwei,und,drei,ßig",T).
% parse("sieben,und,vier,zig",T).
% parse("drei,hundert",T).
% parse("drei,hundert,vier",T).
% parse("drei,hundert,vier,zig",T).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% these should fail
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% parse("sieben,und,acht,zig",T).
% parse("drei,hundert,sieben,und,vier,zig",T).
% parse("Schinken",T).