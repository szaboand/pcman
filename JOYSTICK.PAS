uses dos,crt;

var joyx,joyy:word;
    joybutton:byte;

procedure ido; assembler;
asm
   xor al,al
   out $43,al
   push cx
   mov cx,2
@i1:
   in al,$40
   xchg ah,al
   loop @i1
   pop cx
   ret
end;

procedure hivas; assembler;
asm
   cli
   call ido
   mov dx,$0201
   out dx,al
   push ax
   mov cx,$04ff
@i1:
   in al,dx
   and al,bh
   loopnz @i1
@i5:
   pop dx
   jcxz @i3
   call ido
   xchg dx,ax
   cmp ax,dx
   sbb ax,dx
   mov cl,4
   shr ax,cl
   and ax,$01ff
   push ax
@i4:
   sti
   mov dx,$0201
  mov cx,$04ff
@i2:
   in al,dx
   and al,$0f
   loopnz @i2
   pop ax
   ret
@i3:
   push cx
   jmp @i4
end;

procedure joys1; assembler;
asm
   mov bh,8
@ide:
   call hivas
   push ax
   shr bh,1
   jne @ide
   pop ax
   pop bx
   pop cx
   pop dx
   clc
   sti
   mov joyx,ax
   mov joyy,bx
end;

procedure joys2; assembler;
asm
   mov ah,$84;mov dx,01;int $15;
   mov joyx,ax;mov joyy,bx;
end;

procedure joygomb; assembler;
asm
   mov dx,$0201
   in al,dx
   and al,$f0
   mov joybutton,al
end;


begin
clrscr;
repeat
      joys1;joygomb;
      writeln('Joyx:',joyx,'  Joyy:',joyy,' JG:',joybutton);
 until joyx>999999;
end.