(***********************************************************************
 *                                                                     *
 *                               ˛ P E R E C ˛                         *
 *                                                                     *
 *                             by ömlaÅt Design                        *
 *                                                                     *
 ***********************************************************************)
program demo;
uses plasm,scroll,plane,bump,lens,cube,endtext,
     midas, mfile, mplayer, modp, errors, mconfig, s3m;

type tomb=array[0..63999] of byte;
     mapt=array[0..199,0..319] of byte;
     mxt=array[1..8000] of byte;
     tab=array[0..255] of shortint;

var sint,cost:array[0..255] of byte;
    light:array[0..99,0..99] of byte;
    kep,bmpdat:^tomb;
    bmapx,bmapy:^mapt;
    a,b,c1,c2:integer;
    x1,x2,x3:byte;
    c,beta,z,w1,t:byte;
    h:shortint;
    module : pointer;
    str : array [0..256] of char;
    info : PmpInformation;
    MP : PModulePlayer;
    i, error, isConfig, configured : integer;
    masks:array [1..3] of ^mxt;
    noyzmask:^mxt;
    wx,wy,w:word;
    ascii:array[1..4000] of char;

    bmppal:array[0..33] of
    record
     b,g,r,temp:byte;
    end;

    lenm:array[0..100,0..100] of
    record
     x,y:byte;
    end;

{$I ASCZ.INC}
{$I LENFILL.INC}
{$I BMP_load.INC}
{$I Gen_bump.INC}
{$I Getmasks.INC}
{$I GetASCII.INC}


procedure setpal(c,r,g,b : byte); assembler;
asm
 mov dx,03c8h;
 mov al,c;
 out dx,al;
 inc dx;
 mov al,r
 out dx,al;
 mov al,g;
 out dx,al;
 mov al,b;
 out dx,al
end;

procedure calclight;
var x,y:shortint;
    r2:integer;
const r=50;
begin
 fillchar(light,sizeof(light),0);
 r2:=sqr(r);
 for x:=-r to r do
  for y:=-r to r do begin
   if sqr(x)+sqr(y)<r2 then
    light[50+y,50+x]:=round(r-(sqrt(sqr(x)+sqr(y))))*4;
  end;
end;

procedure exitme(why:byte);
var msg:string;
begin
 asm
  mov ax,3h
  int 10h
 end;
 if kep<>nil then dispose(kep);
 if bmapx<>nil then dispose(bmapx);
 if bmapy<>nil then dispose(bmapy);
 if bmpdat<>nil then dispose(bmpdat);
 if noyzmask<>nil then dispose(noyzmask);
 for z:=1 to 3 do
  if masks[z]<>nil then dispose(masks[z]);

 case why of
  0:msg:='Not enough memory!';
  1:msg:='Demo terminated, go stand in the corner.';
{  2:msg:='MIDAS error: '+midasErrorMsg[mod];}
 end;
 writeln(msg);

 midasStopModule(module);            { stop playing }
 midasFreeModule(module);            { deallocate module }
 midasClose;                         { uninitialize MIDAS }

 halt;
end;

{===== KEZDODIK A MOKA =================================================}

BEGIN
new(kep);
if kep=nil then exitme(0);
new(bmapx);
if bmapx=nil then exitme(0);
new(bmapy);
if bmapy=nil then exitme(0);
new(bmpdat);
if bmpdat=nil then exitme(0);
new(noyzmask);
if noyzmask=nil then exitme(0);
for z:=1 to 3 do
begin
 new(masks[z]);
 if masks[z]=nil then exitme(0);
end;

writeln;
writeln('...:::[ P E R E C ]:::...');
writeln('      ömlaÅt Design');
writeln;

write('Calculating light...       ');
calclight;
writeln('DONE!');

write('Generating bump maps...    ');
genbumpmap;
writeln('DONE!');

write('Generating lens...         ');
tabfill;
writeln('DONE!');

write('Loading bitmaps...         ');
bmp_load;

fillchar(kep^,64000,0);
for wy:=5 to 195 do
 for wx:=0 to 320 do
   kep^[wx+wy*320]:=bmpdat^[wx+(200-wy)*320];

move(kep^,bmpdat^,64000);
writeln('DONE!');


write('Loading masks...           ');
getmask;
writeln('DONE!');

write('Loading endscreen ASCII... ');
getascii;
writeln('DONE!');

{===== Zene belì =======================================================}

 error := fileExists('MIDAS.CFG', @isConfig);
 if error <> OK then
     midasError(error);
 if (isConfig <> 1) or (paramstr(1)='/setup') then
  begin
   { Run MIDAS Sound System configuration: }
   configured := midasConfig;
   if configured = 1 then
   begin
       { Configuration succesful - save configuration file: }
       midasSaveConfig('MIDAS.CFG');
   end;
 end;
 midasSetDefaults;                   { set MIDAS defaults }
 midasLoadConfig('MIDAS.CFG');       { load configuration }
 midasInit;                          { initialize MIDAS Sound System }

 { Convert command line argument to ASCIIZ and load module: }
 toASCIIZ(str,'perec.s3m');

 module := midasLoadModule(str, @mpS3M, nil);
 midasPlayModule(module, 0);

asm
 mov ax,13h
 int 10h
end;

{===== Sinus plasma ====================================================}

randomize;
a:=random(255);
b:=random(255);
c2:=1;
h:=1;
t:=1;

for c:=0 to 255 do
begin
 sint[c]:=round(sin(2*pi*c/255)*128)+128;
 cost[c]:=round(cos(2*pi*c/255)*128)+128;
end;

repeat
 MP := midasMP;
 MP^.GetInformation(@info);

 for z:=0 to 127 do
 begin
  w1:=(z shr 2)*((c2 shl 5) div 127) shr 5;
  case t of
  1:begin
     setpal(z    ,0,w1,0);
     setpal(255-z,0,w1,0);
    end;
  2:begin
     setpal(z    ,0,0,w1);
     setpal(255-z,0,0,w1);
    end;
  3:begin
     setpal(z    ,w1,0,0);
     setpal(255-z,w1,0,0);
    end;
  end;
 end;

 fillchar(kep^,64000,0);

 disp_plasma(a,b,t,seg(kep^),@sint,@cost,masks[t]);

 move(kep^,mem[$a000:0],64000);
 inc(a);
 dec(b);

 if info^.row<32 then
  c2:=(info^.row shl 3)-1
 else
  c2:=(64-info^.row) shl 3;

 t:=info^.pos+1;

until (port[$60]=1) or (info^.pos=3);

if port[$60]=1 then exitme(1);

fillchar(kep^,64000,0);
move(kep^,mem[$a000:0],64000);

{===== Bump ============================================================}

for c2:=0 to 255 do setpal(c2    ,c2 shr 2,c2 shr 2,c2 shr 2);

{
 move(bmapx^,mem[$a000:0],64000);
 readln;
 move(bmapy^,mem[$a000:0],64000);
 readln;
}

a:=0;
b:=0;
c2:=0;
c:=255;
t:=0;
for c2:=0 to 255 do setpal(c2    ,c2 shr 2,c2 shr 2,c2 shr 2);

for c:=0 to 255 do
begin
 sint[c]:=round(sin(2*pi*c/255)*127)+128;
 cost[c]:=round(cos(2*pi*c/255)*127)+128;
end;

repeat
 MP := midasMP;
 MP^.GetInformation(@info);

 c2:=c2 mod 255+3;

 a:=(sint[c2] shr 1)+50;
 b:=cost[c2] div 3;

 fillchar(kep^,64000,0);
 disp_bump(a,b,@light,bmapx,bmapy,seg(kep^));
 move(kep^,mem[$a000:0],64000);

{
 if info^.row>32 then
 begin
  for c1:=0 to 255 do
   begin
    w1:=(c1 shr 2)*(((64-info^.row) shl 8) div 255) shr 5;
    setpal(c1,w1,w1,w1);
   end;
 end;
}

until (port[$60]=1) or (info^.pos=4);

if port[$60]=1 then exitme(1);

fillchar(kep^,64000,0);
move(kep^,mem[$a000:0],64000);

{===== Perec kÇpe be ===================================================}
c2:=0;
repeat

 MP := midasMP;
 MP^.GetInformation(@info);

 c2:=info^.row;

 fillchar(kep^,64000,0);
 move(bmpdat^,kep^,64000);

 if info^.row<32 then
  for c:=0 to 255 do
  begin
{
  setpal(c,
         (255-round((255-bmppal[c].r)*(c2/32))) shr 2,
         (255-round((255-bmppal[c].g)*(c2/32))) shr 2,
         (255-round((255-bmppal[c].b)*(c2/32))) shr 2);
}
  setpal(c,
         (255-(255-bmppal[c].r)*((c2 shl 5) div 32) shr 5) shr 2,
         (255-(255-bmppal[c].g)*((c2 shl 5) div 32) shr 5) shr 2,
         (255-(255-bmppal[c].b)*((c2 shl 5) div 32) shr 5) shr 2);
  end;
 move(kep^,mem[$a000:0],64000);

until (port[$60]=1) or (info^.pos=5);

{===== Lens ============================================================}

a:=0;
b:=0;
c2:=0;
c:=255;
t:=0;

for c:=0 to 255 do
begin
 sint[c]:=round(sin(2*pi*c/255)*127)+128;
 cost[c]:=round(cos(2*pi*c/255)*127)+128;
end;

for c:=0 to 255 do
 setpal(c,
        bmppal[c].r shr 2,
        bmppal[c].g shr 2,
        bmppal[c].b shr 2);

repeat

 MP := midasMP;
 MP^.GetInformation(@info);

 c2:=c2 mod 255+3;

 a:=(sint[c2] shr 1)+50;
 b:=cost[c2] div 3;

 fillchar(kep^,64000,0);
 move(bmpdat^,kep^,64000);
 disp_lens(a,b,@lenm,@bmpdat^,seg(kep^));
 move(kep^,mem[$a000:0],64000);

until (port[$60]=1) or (info^.pos=6);

if port[$60]=1 then exitme(1);

{===== Fagyi :) ========================================================}

repeat
 MP := midasMP;
 MP^.GetInformation(@info);
until (port[$60]=1) or (info^.pos=8);

if port[$60]=1 then exitme(1);

{===== Restart :) ======================================================}

asm
 mov ax,3h
 int 10h
end;

repeat
 MP := midasMP;
 MP^.GetInformation(@info);

 if info^.row=8 then
 asm
  mov ax,13h
  int 10h
 end;

until (port[$60]=1) or (info^.pos=9);

if port[$60]=1 then exitme(1);

{===== Greetz part init ================================================}

c2:=200;
beta:=0;
z:=0;

for c:=0 to 255 do
begin
 cost[c]:=round(-cos(c*(pi/128))*64);
 sint[c]:=round( sin(c*(pi/128))*64);
end;

{
for c2:=0 to 127 do
begin
 setpal(c2    ,c2 shr 1,c2 shr 1,c2 shr 1);
 setpal(c2+128,255-(c2 shr 1),255-(c2 shr 1),255-(c2 shr 1));
end;
}

fillchar(kep^,64000,0);
move(kep^,mem[$a000:0],64000);

{===== Hull†mz¢ izÇ befadel ============================================}
c1:=0;
repeat
 MP := midasMP;
 MP^.GetInformation(@info);

 for c2:=0 to 127 do
 begin
{  c1:=round((c2 shr 2)*(info^.row/64));}
  c1:=(c2 shr 2)*((info^.row shl 5) div 64) shr 5;
  setpal(c2,c1,c1,c1);
 end;

 fillchar(kep^,64000,0);
 disp_plane(160,100, z, 90,beta,0, seg(kep^), @sint,@cost);
 move(kep^,mem[$a000:0],64000);

 inc(beta);
 z:=z mod 127+1;

{
 for c2:=0 to 127 do
 begin
  w1:=round((c2 shr 2)*(c1/127));
  setpal(c2,w1,w1,w1);
 end;
}


until (port[$60]=1) or (info^.pos=10);

if port[$60]=1 then exitme(1);

{===== Greetz ==========================================================}

for c2:=0 to 127 do
begin
 setpal(c2    ,c2 shr 1,c2 shr 1,c2 shr 1);
 setpal(c2+128,255-(c2 shr 1),255-(c2 shr 1),255-(c2 shr 1));
end;

c2:=200;
c1:=0;
repeat
 MP := midasMP;
 MP^.GetInformation(@info);

 fillchar(kep^,64000,0);
 disp_plane(160,100, z, 90,beta,0, seg(kep^), @sint,@cost);
 disp_scroll(c2,seg(kep^));
 move(kep^,mem[$a000:0],64000);

 if c2>-210 then dec(c2,3);

 c1:=c1 mod 10+1;

 inc(beta);
 z:=z mod 127+1;
until (port[$60]=1) or (info^.pos=12);

{===== Hull†mz¢ izÇ kifadel ============================================}
c1:=255;
repeat
 MP := midasMP;
 MP^.GetInformation(@info);

 fillchar(kep^,64000,0);
 disp_plane(160,100, z, 90,beta,0, seg(kep^), @sint,@cost);
 move(kep^,mem[$a000:0],64000);

 dec(c1);
 inc(beta);
 z:=z mod 127+1;

 for c2:=0 to 127 do
 begin
{  c1:=round((c2 shr 2)*((64-info^.row)/64));}
  c1:=(c2 shr 2)*(((64-info^.row) shl 5) div 64) shr 5;
  setpal(c2,c1,c1,c1);
 end;


{
 for c2:=0 to 127 do
 begin
  w1:=round((c2 shr 2)*(c1/127));
  setpal(c2,w1,w1,w1);
 end;
}

until (port[$60]=1) or (info^.pos=13);
if port[$60]=1 then exitme(1);

fillchar(kep^,64000,0);
move(kep^,mem[$a000:0],64000);

{===== End part, credz =================================================}

for c:=0 to 255 do
begin
 cost[c]:=round(-cos(c*(pi/128))*64);
 sint[c]:=round( sin(c*(pi/128))*64);
end;

for c1:=0 to 255 do setpal(c1,c1 shr 2,c1 shr 2,c1 shr 2);

x1:=0; x2:=0; x3:=0;
c2:=0;
repeat
 MP := midasMP;
 MP^.GetInformation(@info);

 fillchar(kep^,64000,0);

 if info^.row<32 then
  disp_text(info^.row shl 3, noyzmask, seg(kep^))
 else
  disp_text((63-info^.row) shl 3, noyzmask, seg(kep^));

 x1:=x1+2;
 x2:=x2+1;
 x3:=x3-1;

 c2:=(c2 mod 225)+3;

 move(kep^,mem[$a000:0],64000);

until (port[$60]=1) or (info^.row>60) or (info^.pos=0);

midasStopModule(module);            { stop playing }


{===== Ennyi ===========================================================}
asm
 mov ax,3h
 int 10h
end;

midasFreeModule(module);            { deallocate module }
midasClose;                         { uninitialize MIDAS }

if kep<>nil then dispose(kep);
if bmapx<>nil then dispose(bmapx);
if bmapy<>nil then dispose(bmapy);
if bmpdat<>nil then dispose(bmpdat);
if noyzmask<>nil then dispose(noyzmask);
for z:=1 to 3 do
 if masks[z]<>nil then dispose(masks[z]);

move(ascii,mem[$b800:0],4000);

END.