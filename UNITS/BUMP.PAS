unit bump;

interface
procedure disp_bump(x,y:integer; lightp,dxtabp,dytabp:pointer; segm:word);

implementation

const cox=100;coy=100;
      codx=8;cody=8;

procedure disp_bump(x,y:integer; lightp,dxtabp,dytabp:pointer; segm:word);
type l=array[0..100,0..100] of byte;
     m=array[0..199,0..319] of byte;
var bex,bey:integer;
    addofs:word;
begin
 asm
  mov   ax,(coy+2*cody)
  cmp   [y],(cody)
  jnc   @fentok;        mov bx,[y];   sub bx,(cody);   add ax,bx
     @fentok:
  mov   bx,(199-coy-cody)
  sub   bx,[y]
  jnc   @lentisrendben; add ax,bx
     @lentisrendben:
  cmp   [y],(cody)
  jnc   @habent
  mov   [bex],0
  mov   [bey],0
  jmp   @ertekeles
     @habent:
  mov   [bex],0
  mov   bx,[y];         sub bx,(cody)
  mov   [bey],bx
     @ertekeles:
  mov   bx,320
  mul   bx
  xchg  ax,cx
  mov   ax,[bey]     (* ax: ami a kezdocim (MUL BX utan) => di *)
  mul   bx
  mov   di,ax

  push  ds
  push  di



  push  es
  les   di,[dxtabp]
  db    $06,$0f,$a1            (* push es/pop fs *)
  les   di,[dytabp]
  db    $06,$0f,$a9            (* push es/pop gs *)
  pop   es

 {  ##### ezzel itt vmi gaz van, fenti 6 sor uzembiztosabb megoldas
  db    $0f,$b4,$7e,$06          (*  lfs di,[dxtabp] *)
  db    $0f,$b5,$7e,$0a           (*  lgs di,[dytabp] *)}
  mov   [addofs],di
  lds   si,[lightp]
  nop
  mov   ax,[segm]
  mov   es,ax
  pop   di
  mov   dx,(cox)
     @ujcim:

  push  di
  add   di,[addofs]

  db    $65,$8a,$05      {mov al,gs:[di]}
  db    $64,$8a,$1d      {mov bl,fs:[di]}
  pop   di

  db    $0f,$be,$c0      {movsx ax,al}
  db    $0f,$be,$db      {movsx bx,bl}


  add   ax,[bey]
  add   bx,[bex]
  sub   ax,[y]
  sub   bx,[x]
  cmp   ax,0
  jc    @kivul
  cmp   ax,(coy-1)
  jnc   @kivul
  cmp   bx,0
  jc    @kivul
  cmp   bx,(cox-1)
  jnc   @kivul
  mul   dl
  add   ax,bx
  push  si
  add   si,ax
  lodsb
  stosb

  pop   si

  jmp   @kesz
     @kivul:
  xor   al,al
  stosb
     @kesz:
  inc   [bex]
  cmp   [bex],320
  jne   @megnemsorvege
  mov   [bex],0
  inc   [bey]
     @megnemsorvege:
  loop  @ujcim
  pop   ds

 end;
end;

BEGIN

END.