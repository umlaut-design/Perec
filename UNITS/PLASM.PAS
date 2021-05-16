unit plasm;
interface

procedure disp_plasma(z,w,t:byte; segm:word; sint,cost:pointer; masks:pointer);

implementation


var f:byte;
    x,y,a,b:word;

procedure disp_plasma(z,w,t:byte; segm:word; sint,cost:pointer; masks:pointer);
type s=array[0..255] of byte;
     m=array[1..8000] of byte;
BEGIN

 for y:=50 to 150 do
  for x:=50 to 280 do
  begin
   if (ord(m(masks^)[((y*320+x) div 8)+1]) and (1 shl ((y*320+x) mod 8)))<>0 then
   begin
   a:=s(sint^)[(y+z) mod 255];
   b:=s(sint^)[w mod 255];
   f:=s(sint^)[(x+a) mod 255]+s(cost^)[(y+b) mod 255];
{   if f=0 then f:=1;}
    mem[segm:x+y*320]:=f;
   end;
  end;
END;

begin
end.