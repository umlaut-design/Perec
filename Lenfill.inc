{
|----------------------------
| Lens generator ...
|-------------------------------------
}

procedure tabfill;
var x,y,z:integer;
const r=50; d=10;
begin
 fillchar(lenm,sizeof(lenm),0);
 for x:=-50 to 50 do
  for y:=-50 to 50 do
  begin
    if (x*x+y*y<=r*r) then
    begin 
      z:=round(sqrt(d*d-x*x-y*y+r*r)/3+1); 
      lenm[x+50,y+50].x:=trunc((x*d)/(z+d)+50);
      lenm[x+50,y+50].y:=trunc((y*d)/(z+d)+50);
    end
    else
    begin
      lenm[x+50,y+50].x:=x+50;
      lenm[x+50,y+50].y:=y+50;
    end;
  end;
end;
