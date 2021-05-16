{
|----------------------------
| Load BMP PAL ...
|-------------------------------------
}

procedure bmp_load;
type bmpt=array[0..65100] of char;
var bmp:^bmpt;
    bpp,n:word;
    offset:longint;
    f:file;
begin
 new(bmp);
 if bmp=nil then halt;

 assign(f,'perec001.dat');
 reset(f);
 fillchar(bmp^,sizeof(bmp^),' ');
 blockread(f,bmp^,filesize(f));
 close(f);
 move(bmp^[10],offset,4);
 move(bmp^[54],bmppal,132);
 move(bmp^[offset],bmpdat^,64000);

 dispose(bmp);
end;
