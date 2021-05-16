{
|----------------------------
| Some kind of a MIDAS function ...
|-------------------------------------
}

function toASCIIZ(dest : PChar; str : string) : PChar;
var
    spos, slen : integer;
    i : integer;

begin
    spos := 0;                          { string position = 0 }
    slen := ord(str[0]);                { string length }

    { copy string to ASCIIZ conversion buffer: }
    while spos < slen do
    begin
        dest[spos] := str[spos+1];
        spos := spos + 1;
    end;

    dest[spos] := chr(0);               { put terminating 0 to end of string }

    toASCIIZ := dest;
end;
