{
|----------------------------
| Fetching endpart ASCII...
|-------------------------------------
}

procedure getascii;
var f:file;
begin
 assign(f,'perec005.dat');
 reset(f);
 blockread(f,ascii,filesize(f));
 close(f);
end;
