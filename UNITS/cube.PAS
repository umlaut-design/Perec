{$G+,N+}
unit cube;
interface

procedure disp_cube(x,y:word; c,alfa,beta,gamma:byte; segm:word; sinp,cosp:pointer);

implementation

type type3d=record
       x,y,z:integer;
      end;

const numvertex=8; numfaces=6;

const faces:array[1..numfaces,1..4] of byte=
      ((1,2,3,4),
       (5,6,7,8),
       (1,4,8,5),
       (2,3,7,6),
       (1,2,6,5),
       (4,3,7,8));

const oldkoords:array[1..numvertex] of type3d=
     ((x:-50; y:-50; z:-50),
      (x: 50; y:-50; z:-50),
      (x: 50; y: 50; z:-50),
      (x:-50; y: 50; z:-50),
      (x:-50; y:-50; z: 50),
      (x: 50; y:-50; z: 50),
      (x: 50; y: 50; z: 50),
      (x:-50; y: 50; z: 50));

var newkoords:array[1..numvertex] of type3d;
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


procedure line(x1,y1,x2,y2:word; color:byte; segm:word);
var dx,dy,sdx,sdy,px,py,dxabs,dyabs,i:integer;
    slope:real;
begin
  dx:=x2-x1;
  dy:=y2-y1;
  dxabs:=abs(dx);
  dyabs:=abs(dy);
  if dx<>0 then sdx:=(dx div dxabs) else sdx:=0;
  if dy<>0 then sdy:=(dy div dyabs) else sdy:=0;
  if (dxabs>=dyabs) then
  begin
    slope:=dy/dx;
    i:=0;
    repeat
     i:=i+sdx;
     px:=i+x1;
     py:=trunc(slope*i+y1);
     mem[segm:px+py*320]:=color;
    until i=dx;
  end
  else
  begin
    slope:=dx/dy;
    i:=0;
    repeat
     i:=i+sdy;
     px:=trunc(slope*i+x1);
     py:=i+y1;
     mem[segm:px+py*320]:=color;
    until i=dy
  end;
end;

procedure poly(x1,y1,x2,y2,x3,y3,x4,y4:word; c:byte; segm:word);
var x:byte;
begin
 line(x1,y1,x2,y2,c,segm);
 line(x2,y2,x3,y3,c,segm);
 line(x3,y3,x4,y4,c,segm);
 line(x4,y4,x1,y1,c,segm);
end;

procedure forgat2d(old1,old2:integer; var new1,new2:integer; a:byte);
begin
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

procedure disp_cube(x,y:word; c,alfa,beta,gamma:byte; segm:word; sinp,cosp:pointer);
type s=array[0..255] of byte;
BEGIN
fillchar(newkoords,sizeof(newkoords),0);
m:=100;
p:=200;

for i:=0 to 255 do
begin
 cost[i]:=s(cosp^)[i];
 sint[i]:=s(sinp^)[i];
end;

forgat(x,y,alfa,beta,gamma);

for i:=1 to numfaces do
begin
   poly(newkoords[faces[i,1]].x,
	newkoords[faces[i,1]].y,
	newkoords[faces[i,2]].x,
	newkoords[faces[i,2]].y,
	newkoords[faces[i,3]].x,
	newkoords[faces[i,3]].y,
	newkoords[faces[i,4]].x,
	newkoords[faces[i,4]].y,
	c,segm);
end;


end;

BEGIN
END.
