unit endtext;

interface
procedure disp_text(color:byte; mask:pointer; segm:word);

implementation

procedure disp_text(color:byte; mask:pointer; segm:word);
type m=array[1..8000] of shortint;
var x,y:word;
begin
 for y:=50 to 190 do
  for x:=60 to 270 do
  begin
   if (ord(m(mask^)[((y*320+x) div 8)+1]) and (1 shl ((y*320+x) mod 8)))<>0 then
   begin
    mem[segm:x+y*320]:=random(color);
   end;
  end;
end;

BEGIN

END.