unit noise;

interface
procedure disp_noise(noise:byte; mask:pointer; segm:word);

implementation

procedure disp_noise(noise:byte; mask:pointer; segm:word);
type m=array[1..8000] of shortint;
var x,y:word;
begin
 for y:=0 to 199 do
  for x:=0 to 319 do
  begin
   if (ord(m(mask^)[((y*320+x) div 8)+1]) and (1 shl ((y*320+x) mod 8)))=0 then
   begin
    mem[segm:x+y*320]:=random(noise);
   end;
  end;
end;

BEGIN

END.