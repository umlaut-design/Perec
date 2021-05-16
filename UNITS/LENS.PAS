unit lens;

interface
procedure disp_lens(x,y:word; lenp,lenmap:pointer; segm:word);

implementation

procedure disp_lens(x,y:word; lenp,lenmap:pointer; segm:word);

type l=array[0..100,0..100] of
       record
        x,y:byte;
       end;
     m=array[0..64000] of byte;
var n,o:word;
const r=50;

begin
  for n:=0 to 100 do
   for o:=0 to 100 do
    begin
{     if (x+n>0) and (x+n<320) and (y+o>0) and (y+o<200) then}
      mem[segm:x+n+(y+o)*320]:=
       m(lenmap^)[x+l(lenp^)[n,o].x+(y+l(lenp^)[n,o].y)*320];
    end;
end;

BEGIN
END.