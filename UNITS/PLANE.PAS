{$G+,N+}
unit plane;
interface

procedure disp_plane(x,y:word; z,alfa,beta,gamma:byte; segm:word; sinp,cosp:pointer);

implementation

type type3d=record
       x,y,z:integer;
      end;

const numvertex=81; numfaces=64;

const faces:array[1..numfaces,1..4] of byte=
      (( 1, 2,11,10),
       ( 2, 3,12,11),
       ( 3, 4,13,12),
       ( 4, 5,14,13),
       ( 5, 6,15,14),
       ( 6, 7,16,15),
       ( 7, 8,17,16),
       ( 8, 9,18,17),
       (10,11,20,19),
       (11,12,21,20),
       (12,13,22,21),
       (13,14,23,22),
       (14,15,24,23),
       (15,16,25,24),
       (16,17,26,25),
       (17,18,27,26),
       (19,20,29,28),
       (20,21,30,29),
       (21,22,31,30),
       (22,23,32,31),
       (23,24,33,32),
       (24,25,34,33),
       (25,26,35,34),
       (26,27,36,35),
       (28,29,38,37),
       (29,30,39,38),
       (30,31,40,39),
       (31,32,41,40),
       (32,33,42,41),
       (33,34,43,42),
       (34,35,44,43),
       (35,36,45,44),
       (37,38,47,46),
       (38,39,48,47),
       (39,40,49,48),
       (40,41,50,49),
       (41,42,51,50),
       (42,43,52,51),
       (43,44,53,52),
       (44,45,54,53),
       (46,47,56,55),
       (47,48,57,56),
       (48,49,58,57),
       (49,50,59,58),
       (50,51,60,59),
       (51,52,61,60),
       (52,53,62,61),
       (53,54,63,62),
       (55,56,65,64),
       (56,57,66,65),
       (57,58,67,66),
       (58,59,68,67),
       (59,60,69,68),
       (60,61,70,69),
       (61,62,71,70),
       (62,63,72,71),
       (64,65,74,73),
       (65,66,75,74),
       (66,67,76,75),
       (67,68,77,76),
       (68,69,78,77),
       (69,70,79,78),
       (70,71,80,79),
       (71,72,81,80));

const cube:array[1..numvertex] of type3d=
     ((x:-40; y:-40; z:  0),
      (x:-30; y:-40; z:  0),
      (x:-20; y:-40; z:  0),
      (x:-10; y:-40; z:  0),
      (x:  0; y:-40; z:  0),
      (x: 10; y:-40; z:  0),
      (x: 20; y:-40; z:  0),
      (x: 30; y:-40; z:  0),
      (x: 40; y:-40; z:  0),
      (x:-40; y:-30; z:  0),
      (x:-30; y:-30; z:  0),
      (x:-20; y:-30; z:  0),
      (x:-10; y:-30; z:  0),
      (x:  0; y:-30; z:  0),
      (x: 10; y:-30; z:  0),
      (x: 20; y:-30; z:  0),
      (x: 30; y:-30; z:  0),
      (x: 40; y:-30; z:  0),
      (x:-40; y:-20; z:  0),
      (x:-30; y:-20; z:  0),
      (x:-20; y:-20; z:  0),
      (x:-10; y:-20; z:  0),
      (x:  0; y:-20; z:  0),
      (x: 10; y:-20; z:  0),
      (x: 20; y:-20; z:  0),
      (x: 30; y:-20; z:  0),
      (x: 40; y:-20; z:  0),
      (x:-40; y:-10; z:  0),
      (x:-30; y:-10; z:  0),
      (x:-20; y:-10; z:  0),
      (x:-10; y:-10; z:  0),
      (x:  0; y:-10; z:  0),
      (x: 10; y:-10; z:  0),
      (x: 20; y:-10; z:  0),
      (x: 30; y:-10; z:  0),
      (x: 40; y:-10; z:  0),
      (x:-40; y:  0; z:  0),
      (x:-30; y:  0; z:  0),
      (x:-20; y:  0; z:  0),
      (x:-10; y:  0; z:  0),
      (x:  0; y:  0; z:  0),
      (x: 10; y:  0; z:  0),
      (x: 20; y:  0; z:  0),
      (x: 30; y:  0; z:  0),
      (x: 40; y:  0; z:  0),
      (x:-40; y: 10; z:  0),
      (x:-30; y: 10; z:  0),
      (x:-20; y: 10; z:  0),
      (x:-10; y: 10; z:  0),
      (x:  0; y: 10; z:  0),
      (x: 10; y: 10; z:  0),
      (x: 20; y: 10; z:  0),
      (x: 30; y: 10; z:  0),
      (x: 40; y: 10; z:  0),
      (x:-40; y: 20; z:  0),
      (x:-30; y: 20; z:  0),
      (x:-20; y: 20; z:  0),
      (x:-10; y: 20; z:  0),
      (x:  0; y: 20; z:  0),
      (x: 10; y: 20; z:  0),
      (x: 20; y: 20; z:  0),
      (x: 30; y: 20; z:  0),
      (x: 40; y: 20; z:  0),
      (x:-40; y: 30; z:  0),
      (x:-30; y: 30; z:  0),
      (x:-20; y: 30; z:  0),
      (x:-10; y: 30; z:  0),
      (x:  0; y: 30; z:  0),
      (x: 10; y: 30; z:  0),
      (x: 20; y: 30; z:  0),
      (x: 30; y: 30; z:  0),
      (x: 40; y: 30; z:  0),
      (x:-40; y: 40; z:  0),
      (x:-30; y: 40; z:  0),
      (x:-20; y: 40; z:  0),
      (x:-10; y: 40; z:  0),
      (x:  0; y: 40; z:  0),
      (x: 10; y: 40; z:  0),
      (x: 20; y: 40; z:  0),
      (x: 30; y: 40; z:  0),
      (x: 40; y: 40; z:  0));

const dist:array[1..numvertex] of byte=
      (57,50,45,41,40,41,45,50,57,
       50,42,36,32,30,32,36,42,50,
       45,36,28,22,20,22,28,36,45,
       41,32,22,14,10,14,22,32,41,
       40,30,20,10, 0,10,20,30,40,
       41,32,22,14,10,14,22,32,41,
       45,36,28,22,20,22,28,36,45,
       50,42,36,32,30,32,36,42,50,
       57,50,45,41,40,41,45,50,57);

var oldkoords:array[1..numvertex] of type3d;
    newkoords:array[1..numvertex] of type3d;
    sint,cost:array[0..255] of shortint;
    c,e,d,f:integer;
    x,y,z,i,j,m,p:byte;
    w:word;
    sorttab:array[1..numfaces] of byte;

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

procedure horline(xb,xe,y:integer; c:byte; where:word); assembler;
asm
  mov bx,[xb]
  cmp bx,0              { if zero don't draw }
  jz @out
  mov cx,[xe]
  jcxz @out
  cmp bx,cx             { see if x-end is smaller than x-begin }
  jb @skip
  xchg bx,cx            { yes: switch coords }
 @skip:
  dec bx                { atatch planes }
  inc cx
  sub cx,bx             { length of line in cx }
  mov es,[where]        { segment to draw in }
  mov ax,[y]            { heigth of line }
  shl ax,6
  mov di,ax
  shl ax,2
  add di,ax             { y*320 in di (offset) }
  add di,bx             { add x-begin }
  mov al,[c]            { get color }
  shr cx,1              { div length by 2 }
  jnc @skip2            { carry set? }
  stosb                 { draw byte }
 @skip2:
  mov ah,al             { copy color in hi-byte }
  rep stosw             { draw (rest of) line }
 @out:
end;

procedure poly(x1,y1,x2,y2,x3,y3,x4,y4:integer; c:byte; segm:word);
var
  xpos:array[0..199,0..1] of integer;
  mny,mxy,y:integer;
  i:word;
  s1,s2,s3,s4:shortint;
begin
  mny:=y1;
  if y2<mny then mny:=y2;
  if y3<mny then mny:=y3;
  if y4<mny then mny:=y4;
  mxy:=y1;
  if y2>mxy then mxy:=y2;
  if y3>mxy then mxy:=y3;
  if y4>mxy then mxy:=y4;
  s1:=byte(y1<y2)*2-1;
  s2:=byte(y2<y3)*2-1;
  s3:=byte(y3<y4)*2-1;
  s4:=byte(y4<y1)*2-1;
  y:=y1;
  if y1<>y2 then repeat
    xpos[y,byte(y1<y2)]:=integer(x2-x1)*(y-y1) div (y2-y1)+x1;
    inc(y,s1);
  until y=y2+s1 else xpos[y,byte(y1<y2)]:=x1;
  y:=y2;
  if y2<>y3 then repeat
    xpos[y,byte(y2<y3)]:=integer(x3-x2)*(y-y2) div (y3-y2)+x2;
    inc(y,s2);
  until y=y3+s2 else xpos[y,byte(y2<y3)]:=x2;
  y:=y3;
  if y3<>y4 then repeat
    xpos[y,byte(y3<y4)]:=integer(x4-x3)*(y-y3) div (y4-y3)+x3;
    inc(y,s3);
  until y=y4+s3 else xpos[y,byte(y3<y4)]:=x3;
  y:=y4;
  if y4<>y1 then repeat
    xpos[y,byte(y4<y1)]:=integer(x1-x4)*(y-y4) div (y1-y4)+x4;
    inc(y,s4);
  until y=y1+s4 else xpos[y,byte(y1<y4)]:=x4;
  for y:=mny to mxy do
    horline(xpos[y,0],xpos[y,1],y,c,segm);
end;

procedure sort;
var x,i,j:byte;
    f,buf:longint;
    zbuffer:array[1..numfaces] of shortint;
begin
 for i:=1 to numfaces do
 begin
  f:=0;
  for j:=1 to 4 do f:=f+newkoords[faces[i,j]].z;
  f:=f shr 2;
  zbuffer[i]:=f;
  sorttab[i]:=i;
 end;
 for i:=1 to numfaces-1 do begin
  for j:=i+1 to numfaces do
   if zbuffer[j] > zbuffer[i] then
   begin
    Buf:=sorttab[i];
    sorttab[i]:=sorttab[j];
    sorttab[j]:=Buf;
    Buf:=zbuffer[i];
    zbuffer[i]:=zbuffer[j];
    zbuffer[j]:=Buf;
   end;
  end;
end;

procedure forgat2d(old1,old2:integer; var new1,new2:integer; a:byte);
begin
{
 a:=a/2048;
 new1:=trunc(old1*cos((180/pi)*a)+old2*sin((180/pi)*a));
 new2:=trunc(old2*cos((180/pi)*a)-old1*sin((180/pi)*a));
}
 new1:=trunc(old1*cost[a]/64+old2*sint[a]/64);
 new2:=trunc(old2*cost[a]/64-old1*sint[a]/64);
end;

procedure forgat(x,y:word; alfa,beta,gamma:byte);
var i:byte;
begin
 for i:=1 to numvertex do
 begin
  forgat2d(oldkoords[i].y, oldkoords[i].z, newkoords[i].y, newkoords[i].z, alfa);
  forgat2d(oldkoords[i].x, newkoords[i].z, newkoords[i].x, newkoords[i].z, beta);
  forgat2d(newkoords[i].x, newkoords[i].y, newkoords[i].x, newkoords[i].y, gamma);
  newkoords[i].x:=M*newkoords[i].x div (P+newkoords[i].z)+x;
  newkoords[i].y:=M*newkoords[i].y div (P+newkoords[i].z)+y;
 end;
end;

procedure disp_plane(x,y:word; z,alfa,beta,gamma:byte; segm:word; sinp,cosp:pointer);
type s=array[0..255] of byte;
BEGIN
fillchar(newkoords,sizeof(newkoords),0);
m:=200;
p:=200;

for i:=1 to numvertex do oldkoords[i]:=cube[i];

for i:=0 to 255 do
begin
 cost[i]:=s(cosp^)[i];
 sint[i]:=s(sinp^)[i];
end;

for i:=1 to numvertex do
begin
{
  c:=sqr(oldkoords[i].x)+sqr(oldkoords[i].y);
  d:=round(sqrt(c));
  oldkoords[i].z:=(sint[abs(d-z)] shr 1);
}
  oldkoords[i].z:=(sint[abs(dist[i]-z)] shr 1);
end;

forgat(x,y,alfa,beta,gamma);
sort;

for i:=1 to numfaces do
begin
 f:=0;
 for j:=1 to 4 do f:=f+newkoords[faces[sorttab[i],j]].z;
 f:=f div 4;
   poly(newkoords[faces[sorttab[i],1]].x,
	newkoords[faces[sorttab[i],1]].y,
	newkoords[faces[sorttab[i],2]].x,
	newkoords[faces[sorttab[i],2]].y,
	newkoords[faces[sorttab[i],3]].x,
	newkoords[faces[sorttab[i],3]].y,
	newkoords[faces[sorttab[i],4]].x,
	newkoords[faces[sorttab[i],4]].y,
	(64-f) div 4,segm);
end;


end;

BEGIN
END.
