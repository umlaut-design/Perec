{
|----------------------------
| Retrieving masks...
|-------------------------------------
}

procedure getmask;
type tsux=array[1..24000] of byte;
var x:word;
    y:byte;
    f:file;
    sux:^tsux;
begin
new(sux);
if sux=nil then halt;

 assign(f,'perec003.dat');
 reset(f);
 blockread(f,sux^,filesize(f));

 close(f);

 move(sux^[1],masks[1]^,8000);
 move(sux^[8001],masks[2]^,8000);
 move(sux^[16001],masks[3]^,8000);

 assign(f,'perec004.dat');
 reset(f);
 blockread(f,noyzmask^,filesize(f));
 close(f);

dispose(sux);
end;
