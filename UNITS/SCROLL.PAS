unit scroll;
interface

procedure disp_scroll(c2:integer; segm:word);

implementation

uses font8;
var
 c1:integer;
 a,b,c,d,dd:byte;

const szoveg:array[0..19] of string[17]=
 ('GREETINGS TO:',
  '---',
  'AstroideA',         'Astral',            'Buzk Halaj',
  'CaPaN¥a',           'Digital Dynamite',  'Evidence',
  'FiRG!',             'Fresh!Mindworkz',   'Greenroom',
  'H£sdar l¢ Project', 'Inquisition',       'Kar kulum',
  'Mandula',           'Molecoola',         'MoSFeT',
  'Poisonmixers',      'Power Rangers',     'United Force');


procedure disp_scroll(c2:integer; segm:word);
begin

for c:=0 to 19 do
begin
 c1:=(320-length(szoveg[c])*8) shr 1;
 if szoveg[c]<>'' then
 begin
  for a:=1 to length(szoveg[c]) do
  begin
   for d:=0 to 7 do
   for b:=0 to 7 do
    begin
     dd:=((font[byte(szoveg[c][a])*8+1+d] shr b) and 1);
      if (dd<>0) and (c2+d+c*9<200) and (c2+d+c*9>0) then
     mem[segm:(c2+d+c*9)*320+c1+((a-1)*8)+(7-b)]:=round((c2+d+c*9)*1.275);
    end;
  end;
 end;
end;

end;


BEGIN

END.