uses crt;

const    nagyit: word = 12; maxnagyit=12;
         eltol=60;

var      Shapes :   array [0..2047+256] of byte;
         c:char;

Procedure Load_Datas(mi:string);
var f:file;
Begin
assign(f,mi);reset(f,1);blockread(f,Shapes,2048);close(f);
End;

Procedure Save_Datas(mi:string);
var f:file;
begin
assign(f,mi);rewrite(f,1);blockwrite(f,shapes,2048);close(f);
end;

PROCEDURE _320X200; ASSEMBLER;ASM MOV AX,$0013;INT $10;END;
procedure putpixel(x,y:word;szin:byte);begin mem[$a000:x*320+y]:=szin;end;
function  getpixel(x,y:word):byte;begin getpixel:=mem[$a000:x*320+y];end;
PROCEDURE KEPT;
VAR I,J:WORD;
BEGIN FOR I:=0 TO 199 DO FOR J:=0 TO 319 DO PUTPIXEL(i,j,200);END;

procedure szoveg(x,y:byte;s:string;szin,hszin:byte);
var i:integer;a:byte;
begin
asm mov ah,2;mov dh,x;mov dl,y;mov bh,0;int $10;end;
for i:=1 to length(s) do begin a:=ord(s[i]);
    asm mov al,a;mov bl,szin;mov bh,hszin;mov ah,$09;mov cx,1;int $10;
    mov bh,0;mov ah,3;int $10;inc dl;mov ah,2;int $10;end;end;
end;

procedure pont(x,y:word;szin:byte);
var i,j:word;
begin
for i:=0 to nagyit-1 do for j:=0 to nagyit-1 do putpixel(x+i,y+j,szin);
end;

procedure ShapesShow(num:byte;x,y:word);
var i,j,w:word;
begin
i:=0;w:=num*256;
repeat
      j:=0;
      repeat
      if shapes[w]<>0
         then pont(x+i,y+j,shapes[w])
         else pont(x+i,y+j,200);
      w:=w+1;j:=j+nagyit;until j>nagyit*16-1;
      i:=i+nagyit;
until i>nagyit*16-1;
end;

Procedure keret;
var i,kx,ky:word;
begin
kx:=(200-nagyit*16) div 2-1;ky:=(320-nagyit*16) div 2-1+eltol;
for i:=0 to nagyit*16+1
    do begin
       putpixel(kx,ky+i,15);putpixel(kx+nagyit*16+1,ky+i,15);
       putpixel(kx+i,ky,15);putpixel(kx+i,ky+nagyit*16+1,15);
       end;
end;

Procedure racs;
var i,j,kx,ky:word;
begin
kx:=(200-nagyit*16) div 2;ky:=(320-nagyit*16) div 2+eltol;
for i:=0 to nagyit*16-1
    do begin
       j:=0;repeat putpixel(kx+j,ky+i,8);j:=j+nagyit;until j>nagyit*16-1;
       j:=0;repeat putpixel(kx+i,ky+j,8);j:=j+nagyit;until j>nagyit*16-1;
       end;
end;

Procedure SpriteShow(num:byte);
var kx,ky:word;
begin
kx:=(200-nagyit*16) div 2;ky:=(320-nagyit*16) div 2+eltol;
ShapesShow(num,kx,ky);
end;

Procedure Torol;
var i,j,kx,ky:word;
begin
kx:=(200-nagyit*16) div 2-1;ky:=(320-nagyit*16) div 2-1+eltol;
for j:=0 to nagyit*16+1 do for i:=0 to nagyit*16+1 do putpixel(kx+i,ky+j,200);
end;

Procedure KurzorBe(x,y:word;k:byte);
var kx,ky:word;
begin
kx:=(200-nagyit*16) div 2+nagyit div 4;ky:=(320-nagyit*16) div 2+eltol+nagyit div 4;
x:=kx+x*nagyit;y:=ky+y*nagyit;
kx:=nagyit;nagyit:=nagyit div 2+1;pont(x,y,k);nagyit:=kx;
end;

Procedure Szin(num:byte;x,y:word;l:byte);
var mi:string;k:word;
begin
k:=num*256+x*16+y;k:=shapes[k];str(k,mi);szoveg(2,0,'By:'+mi+'  ',4,200);
str(x,mi);szoveg(4,0,'Xk:'+mi+'  ',3,200);
str(y,mi);szoveg(5,0,'Yk:'+mi+'  ',3,200);
str(l,mi);szoveg(6,0,'Ck:'+mi+'  ',3,200);
str(num+1,mi);szoveg(0,0,'Sp:'+mi+'  ',2,200);
str(nagyit,mi);szoveg(8,0,'Na:'+mi+' ',7,200);
k:=nagyit;nagyit:=1;ShapesShow(num,80,10);nagyit:=k;
end;

Procedure SzinBeIr(num:byte;x,y:word;kszin:byte);
var k:word;
begin
k:=num*256+x*16+y;shapes[k]:=kszin;
end;

procedure CopySprite(num1,num2:byte);
var k1,k2,j:word;
begin
k1:=num1*256;k2:=num2*256;
for j:=0 to 255 do shapes[k2+j]:=shapes[k1+j];
end;

Procedure Copy(num:byte);
var mi:string;c:char;m:string;n2:byte;
begin
str(num+1,mi);m:=mi;n2:=num;
repeat
      szoveg(24,0,'Copy '+mi+' to '+m,12,200);
      c:=readkey;
      if (ord(c)>48) and (ord(c)<58)then begin m:=c;n2:=ord(c)-49;end;
      if ord(c)=13 then copysprite(num,n2);
      if ord(c)=0 then c:=readkey;
until (ord(c)=13) or (ord(c)=27);
szoveg(24,0,'            ',0,200);
end;

Procedure SaveSprites;
var mi:string;f:file;
begin
szoveg(21,0,'Save FileName:',11,200);szoveg(23,0,'-',15,200);
readln(mi);
szoveg(21,0,'              ',11,200);szoveg(23,0,'              ',15,200);
if mi='' then exit;
mi:=mi+'.dat';save_datas(mi);
end;

Procedure LoadSprites;
var mi:string;f:file;
begin
szoveg(21,0,'Load FileName:',11,200);szoveg(23,0,'-',15,200);
readln(mi);
szoveg(21,0,'              ',11,200);szoveg(23,0,'              ',15,200);
if mi='' then exit;
mi:=mi+'.dat';Load_datas(mi);
end;

Procedure Animal(num:byte);
var k:byte;po:word;c:char;
begin
if num=1 then exit;
po:=nagyit;nagyit:=1;
repeat
      for k:=0 to num do
          begin
          shapesshow(k,80,10);
          delay(200);
          end;
      for k:=num-1 to 1 do begin shapesshow(k,80,10);delay(200);end;
until keypressed;
nagyit:=po;c:=readkey;
end;

procedure szintorol(num,szin:byte);
var k1,i:word;
begin
k1:=num*256;
for i:=0 to 255 do if shapes[k1+i]=szin then shapes[k1+i]:=0;
end;

procedure szinvalt(x,y:word;num,szin1:byte);
var k1:word;w,i:byte;
begin
k1:=num*256+x*16+y;w:=shapes[k1];
k1:=num*256;
for i:=0 to 255 do if shapes[k1+i]=w then shapes[k1+i]:=szin1;
end;

procedure cls(num:byte);
var k1:word;i:byte;
begin
k1:=num*256;
for i:=0 to 255 do shapes[k1+i]:=0;
end;

Procedure Main;
var c:char;k:byte;
    r:boolean;
    kurzorx,kurzory:word;kurzorszin:byte;
begin
k:=1;r:=true;
kurzorx:=0;kurzory:=0;kurzorszin:=1;
repeat
      spriteshow(k);keret;
      if r then racs;
      kurzorbe(kurzorx,kurzory,kurzorszin);
      szin(k,kurzorx,kurzory,kurzorszin);
      c:=readkey;
      if ord(c)=0
         then begin
              c:=readkey;
              case ord(c) of
                   72: if kurzorx>0 then kurzorx:=kurzorx-1;
                   80: if kurzorx<15 then kurzorx:=kurzorx+1;
                   75: if kurzory>0 then kurzory:=kurzory-1;
                   77: if kurzory<15 then kurzory:=kurzory+1;
                   73: if nagyit<maxnagyit then nagyit:=nagyit+1;
                   81: begin torol;if nagyit>1 then nagyit:=nagyit-1;end;
                   83: szinbeir(k,kurzorx,kurzory,0);
                   end;
              end
         else begin
              case upcase(c) OF
                   'R': r:=not r;
                   '-': if kurzorszin>0 then kurzorszin:=kurzorszin-1;
                   '+': if kurzorszin<255 then kurzorszin:=kurzorszin+1;
                   'C': copy(k);
                   'S':savesprites;
                   'L':loadsprites;
                   'A':animal(k);
                   'D':szintorol(k,kurzorszin);
                   'V':szinvalt(kurzorx,kurzory,k,kurzorszin);
                   'K': cls(k);
                   end;
              if (ord(c)>48) and (ord(c)<58) then k:=ord(c)-49;
              if ord(c)=13 then szinbeir(k,kurzorx,kurzory,kurzorszin);
              end;
until ord(c)=27;
end;

begin
_320x200;kept;keret;
main;
end.