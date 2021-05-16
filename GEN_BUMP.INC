{
|----------------------------
| Generating bumpmap...
|-------------------------------------
}

procedure genbumpmap;
type mxt=array[1..8000] of byte;
type bma=array[1..64000] of byte;
var x,y:word;
    map:^mxt;
    bmap:^bma;
    f:file;
begin
 new(map);
 if map=nil then halt;

 new(bmap);
 if bmap=nil then halt;

 assign(f,'perec002.dat');
 reset(f);
 fillchar(map^,sizeof(map^),0);
 fillchar(bmapx^,sizeof(bmapx^),0);
 fillchar(bmapy^,sizeof(bmapy^),0);
 blockread(f,map^,filesize(f));
 close(f);

 for x:=1 to 8000 do
  for y:=0 to 7 do
  begin
   if (ord(map^[x]) and (1 shl y))<>0 then
    bmap^[(x-1)*8+y]:=10
   else
    bmap^[(x-1)*8+y]:=0;
  end;
 for c:=1 to 3 do
  for x:=320 to (64000-320) do
   bmap^[x]:=(bmap^[x-1]+bmap^[x+1]+bmap^[x-320]+bmap^[x+320]+bmap^[x]) div 5;

 for y:=1 to 198 do
  for x:=0 to 319 do
   bmapx^[y,x]:=(bmap^[x+y*320]-bmap^[x+1+y*320])*4;

 for y:=1 to 198 do
  for x:=0 to 319 do
   bmapy^[y,x]:=(bmap^[x+y*320]-bmap^[x+(y+1)*320])*4;

 dispose(map);
 dispose(bmap);
end;
