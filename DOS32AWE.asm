.686p
.mmx
.model large


; Segment type:	Regular
seg000 segment byte public 'UNK' use16
assume cs:seg000
assume es:nothing, ss:nothing, ds:nothing, fs:nothing, gs:nothing
db  49h	; I
db  44h	; D
db  33h	; 3
db  32h	; 2
db  3Fh	; ?
db  40h	; @
db    2
db  10h
db    0
db    1
db    8
db    8
db  20h
db    0
db  20h
db    0
db 0FFh
db 0FFh
db 0FFh
db 0FFh
db  77h	; w
db  49h	; I
db    0
db    2
db  0Ch
db    9
db    0
db    0
db  44h	; D
db  4Fh	; O
db  53h	; S
db  2Fh	; /
db  33h	; 3
db  32h	; 2
db  41h	; A
db    0
db  43h	; C
db  6Fh	; o
db  70h	; p
db  79h	; y
db  72h	; r
db  69h	; i
db  67h	; g
db  68h	; h
db  74h	; t
db  20h
db  28h	; (
db  43h	; C
db  29h	; )
db  20h
db  31h	; 1
db  39h	; 9
db  39h	; 9
db  36h	; 6
db  2Dh	; -
db  32h	; 2
db  30h	; 0
db  30h	; 0
db  36h	; 6
db  20h
db  62h	; b
db  79h	; y
db  20h
db  4Eh	; N
db  61h	; a
db  72h	; r
db  65h	; e
db  63h	; c
db  68h	; h
db  20h
db  4Bh	; K
db  2Eh	; .
db    0
db  31h	; 1
db  30h	; 0
db  2Fh	; /
db  30h	; 0
db  37h	; 7
db  2Fh	; /
db  32h	; 2
db  31h	; 1
db    0
db  32h	; 2
db  33h	; 3
db  3Ah	; :
db  34h	; 4
db  39h	; 9
db  3Ah	; :
db  31h	; 1
db  31h	; 1
db    0
db    0
db    0
db    0
db    0
db    0
seg000 ends


; Segment type:	Pure code
seg001 segment byte public 'CODE' use16
assume cs:seg001
assume es:nothing, ss:nothing, ds:nothing, fs:nothing, gs:nothing
db 3 dup(0FFh)
byte_10063 db 0FFh
word_10064 dw 0FFFFh
byte_10066 db 0FFh
byte_10067 db 0FFh
word_10068 dw 0FFFFh
word_1006A dw 0FFFFh
dword_1006C dd 0FFFFFFFFh
dword_10070 dd 0
word_10074 dw 0
word_10076 dw 0
byte_10078 db 0
align 2
byte_1007A db 0
byte_1007B db 9	dup(0)
dword_10084 dd 0
dword_10088 dd 0
byte_1008C db 18h, 0
word_1008E dw 10h
byte_10090 db 48h, 0Bh dup(0), 0FFh, 7,	4 dup(0), 0FFh
db 3, 4	dup(0),	0Ch, 11h, 5Ch, 11h, 2 dup(0)
dword_100AE dd 0
dword_100B2 dd 0
db 6 dup(0)
dword_100BC dd 34h
dword_100C0 dd 3Ch
db 2 dup(0), 20h, 0, 2Ch, 11h, 2 dup(0)
db 8, 5	dup(0),	28h, 3 dup(0)
dword_100D6 dd 58h
db 4 dup(0), 0FFh, 0EEh, 79h, 2Eh, 87h,	0DBh



sub_100E4 proc far
cld
push	ds
push	es
push	cs

loc_100E8:
push	cs
pop	ds
assume ds:seg001
pop	es
call	sub_102EC
cmp	al, 3
mov	ax, 1
jnb	short loc_100F8
jmp	loc_101AD

loc_100F8:
call	sub_10366
mov	ah, 30h
int	21h		; DOS -	GET DOS	VERSION
			; Return: AL = major version number (00h for DOS 1.x)
cmp	al, 4
mov	ax, 0
jb	loc_101AD
mov	ax, 4300h
int	2Fh		; - Multiplex -	XMS - INSTALLATION CHECK
			; Return: AL = 80h XMS driver installed
			; AL <>	80h no driver
cmp	al, 80h	; '€'
jnz	short loc_1014C
push	es
mov	ax, 4310h
int	2Fh		; - Multiplex -	XMS - GET DRIVER ADDRESS
			; Return: ES:BX	-> driver entry	point
mov	word ptr dword_100AE, bx
mov	word ptr dword_100AE+2,	es
mov	ah, 30h
int	21h		; DOS -	GET DOS	VERSION
			; Return: AL = major version number (00h for DOS 1.x)
mov	ah, 88h	; 'ˆ'
xor	bx, bx
call	dword_100AE
test	bl, bl
jz	short loc_10139
mov	ah, 8
call	dword_100AE
movzx	eax, ax

loc_10139:
mov	dword_100B2, eax
pop	es
pushf
pop	ax
and	ah, 0CFh
push	ax
popf
pushf
pop	ax
test	ah, 30h
jz	short loc_1015C

loc_1014C:
call	near ptr sub_101D9
call	near ptr sub_101B0
smsw	ax
and	al, 1
mov	ax, 2
jnz	short loc_101AD

loc_1015C:
cmp	dword_100B2, 0
setnz	ch
mov	bx, 80h	; '€'

loc_10168:
movzx	ax, byte_10066
imul	ax, word_10068
add	bx, ax
movzx	ax, byte_10067
imul	ax, word_1006A
add	bx, ax
movzx	ax, byte_10063
imul	ax, 19h
add	ax, 0Fh
shr	ax, 4
add	bx, ax
mov	ax, word_10064
add	ax, 0Bh
shr	ax, 1
add	bx, ax

loc_1019A:
xor	ax, ax
mov	cl, byte_10078
mov	byte_1007A, ch
mov	dx, 2950h
mov	di, 550h

loc_101AA:
pop	es
pop	ds
assume ds:nothing
retf

loc_101AD:
stc
jmp	short loc_101AA
sub_100E4 endp ; sp-analysis failed




sub_101B0 proc far
pop	bp
mov	ax, 1687h
int	2Fh		; - Multiplex -	MS WINDOWS - Mode Interface - INSTALLATION CHECK
			; Return: AX = 0000h if	installed, BX =	flags
			; CL = processor type, DH = DPMI major version
			; DL = DPMI minor version
			; SI = number of paragraphs
			; ES:DI	-> DPMI	mode-switch entry point
test	ax, ax
jnz	short loc_101D7
mov	ax, 1
cmp	cl, 3
jb	short loc_101AD
mov	al, 3
test	bl, 1
jz	short loc_101AD
mov	ds:28h,	di
mov	word ptr ds:2Ah, es
mov	bx, si
mov	ch, 3
jmp	short loc_1019A

loc_101D7:
jmp	bp
sub_101B0 endp ; sp-analysis failed




sub_101D9 proc far
pop	bp
xor	ax, ax
mov	es, ax
assume es:nothing
mov	ax, es:19Ch
or	ax, es:19Eh
jz	short loc_101D7
mov	ax, 0DE00h
int	67h		;  - LIM EMS Program Interface - INSTALLATION CHECK
			; Return: AH = 00h    VCPI is present, BH = major version number
			; BL = minor version number, AH	nonzero	 VCPI not present
test	ah, ah
jnz	short loc_101D7
mov	ax, 0DE0Ah
int	67h		;  - LIM EMS Program Interface - GET 8259 INTERRUPT VECTOR MAPPINGS
			; Return: AH = 00h successful, BX = first vector used by master	8259 (IRQ0)
			; CX = first vector used by slave 8259 (IRQ8)
			; AH nonzero: failed
mov	ds:1Dh,	bl
mov	ds:1Ch,	cl
mov	ax, 4
cmp	bl, cl
jz	short loc_101AD
cmp	bl, 30h	; '0'
jz	short loc_101AD
cmp	cl, 30h	; '0'
jz	short loc_101AD
cmp	cl, 8
jz	short loc_101AD
test	bl, bl
jz	short loc_101AD
test	cl, cl
jz	short loc_101AD
mov	edx, ds:52h
mov	ecx, edx
jecxz	loc_1023A
test	byte ptr ds:0, 8
jz	short loc_10237
call	sub_10DCC
mov	di, dx
dec	ax
jz	short loc_1023A

loc_10237:
xor	ecx, ecx

loc_1023A:
mov	ax, 0DE03h
int	67h		;  - LIM EMS Program Interface - GET NUMBER OF FREE 4K PAGES
			; Return: AH = 00h  successful,	EDX = number of	free 4K	pages
			; AH nonzero: failed
push	es
push	ecx
push	edx
push	di
test	byte ptr ds:0, 4
jz	short loc_1027B
mov	ah, 48h	; 'H'
mov	bx, 100h
int	21h		; DOS -	2+ - ALLOCATE MEMORY
			; BX = number of 16-byte paragraphs desired
jb	short loc_1027B
mov	es, ax
assume es:nothing
xor	di, di
sub	sp, 18h
mov	si, sp
push	ds
push	ss
pop	ds
mov	ax, 0DE01h
int	67h		;  - LIM EMS Program Interface - GET PROTECTED MODE INTERFACE
			; ES:DI	-> 4K page table buffer
			; DS:SI	-> three descriptor table entries in GDT
			; Return: AH = 00h successful, AH = nonzero  failed
pop	ds
add	sp, 18h
mov	ah, 49h
int	21h		; DOS -	2+ - FREE MEMORY
			; ES = segment address of area to be freed
mov	eax, 1000h
sub	ax, di
shr	ax, 2
jmp	short loc_1027E

loc_1027B:
xor	eax, eax

loc_1027E:
pop	di
pop	edx
pop	ecx
pop	es
assume es:nothing
mov	esi, ecx
shr	esi, 2
lea	esi, [edx+esi+3FFh]

loc_10294:
sub	esi, eax
jnb	short loc_1029C
adc	esi, eax

loc_1029C:
shr	esi, 0Ah
jecxz	loc_102AB
mov	dx, di
mov	ah, 0Ah
call	dword ptr ds:4Eh

loc_102AB:
movzx	ax, byte ptr ds:1
cmp	ax, si
jbe	short loc_102B6

loc_102B4:
mov	ax, si

loc_102B6:
test	ax, ax

loc_102B8:
jnz	short loc_102D0
pushad

loc_102BC:
mov	bp, sp
mov	ax, 0FF88h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
cmp	eax, 49443332h
jnz	short loc_102CE
mov	[bp+1Ch], si

loc_102CE:
popad

loc_102D0:
cmp	al, 40h	; '@'
jbe	short loc_102D6
mov	al, 40h	; '@'

loc_102D6:
mov	ds:1Bh,	al
add	al, ds:2
shl	ax, 8
add	ax, 386h
mov	bx, ax
mov	ch, 2
jmp	loc_10168
sub_101D9 endp ; sp-analysis failed

jmp	bp



sub_102EC proc near
cli
mov	cl, 2
pushf
pop	ax
or	ax, 0F000h
push	ax
popf
pushf
pop	ax
and	ax, 0F000h
jnz	short loc_102FF
jmp	short loc_1035F

loc_102FF:
inc	cl
pushfd
pop	eax
mov	edx, eax

loc_10308:
xor	eax, 40000h
push	eax
popfd
pushfd
pop	eax
xor	eax, edx
jnz	short loc_1031D
jmp	short loc_1035F

loc_1031D:
inc	cl
push	edx
popfd
pushfd
pushfd
pop	eax
mov	edx, eax
xor	eax, 200000h
push	eax
popfd
pushfd
pop	eax
xor	eax, edx
jnz	short loc_10341
jmp	short loc_10357

loc_10341:
xor	eax, eax
cpuid
mov	ds:20h,	eax
mov	eax, 1
cpuid
and	ah, 0Fh
mov	cl, ah

loc_10357:
popfd
xor	eax, eax
xor	edx, edx

loc_1035F:
mov	al, cl
mov	ds:18h,	al
sti
retn
sub_102EC endp




sub_10366 proc near
push	large 0
mov	bp, sp
fninit
fnstcw	word ptr [bp+2]
mov	ax, [bp+2]
cmp	ah, 3
jnz	short loc_103C7
mov	word ptr [bp+0], 1
and	word ptr [bp+2], 0FF7Fh
wait
fldcw	word ptr [bp+2]
fdisi
fstcw	word ptr [bp+2]
wait
test	word ptr [bp+2], 80h
jnz	short loc_103C7
mov	word ptr [bp+0], 2
fninit
wait
fld1
wait
fldz
wait
fdivp	st(1), st
wait
fld	st
wait
fchs
wait
fcompp
fstsw	ax
fclex
wait
sahf
jz	short loc_103C7
mov	word ptr [bp+0], 3
mov	al, ds:18h
cmp	al, 4
jb	short loc_103C7
mov	[bp+0],	al

loc_103C7:
pop	eax
and	eax, 7
jz	short loc_103D9
mov	cx, 8

loc_103D2:
fldz
loop	loc_103D2
finit

loc_103D9:
mov	ds:19h,	al
retn
sub_10366 endp

align 4



sub_103E0 proc far

; FUNCTION CHUNK AT 0443 SIZE 0000007F BYTES
; FUNCTION CHUNK AT 0526 SIZE 0000001D BYTES
; FUNCTION CHUNK AT 0550 SIZE 0000011F BYTES
; FUNCTION CHUNK AT 07AF SIZE 000002C3 BYTES

push	ax
push	bx
push	ds
xor	ax, ax
mov	ds, ax
assume ds:nothing
mov	ax, ds:0Ah
mov	bx, ds:8
add	bx, 9
mov	ds, ax
assume ds:nothing
cmp	dword ptr [bx],	40A861E4h
jnz	short loc_1040E
cmp	byte ptr [bx+4], 74h ; 't'
jnz	short loc_1040E
mov	dword ptr [bx],	90909090h
mov	word ptr [bx+4], 9090h

loc_1040E:
pop	ds
pop	bx
pop	ax
cld
pushad
push	ds
push	cs
pop	ds
assume ds:seg001
xor	eax, eax
mov	word_10076, cs
mov	word_10074, bx
mov	word ptr dword_10070, dx
mov	ax, cs
shl	eax, 4
mov	dword_10084, eax
add	dword_100BC, eax
add	dword_100C0, eax
add	dword_100D6, eax
btr	dword_1006C, 1Fh
push	es
push	cs
pop	es
assume es:seg001
mov	di, 84h	; '„'
mov	cx, 17Eh
xor	ax, ax
rep stosw
pop	es
assume es:nothing
mov	bp, sp
mov	[bp+2],	ax
mov	ax, 0FF88h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
cmp	eax, 49443332h
jnz	short loc_10490
mov	[bp+2],	bx
cmp	bx, word_10074
jnz	short loc_10490
mov	dword ptr loc_102B4, ecx
mov	dword ptr loc_102B8, edx
mov	dword ptr loc_102BC, edi
shr	esi, 10h
inc	si
mov	word ptr loc_102BE+2, si
mov	dword_1006C, 0

loc_10490:
movzx	bx, byte_1007A
add	bx, bx
jmp	off_1049B[bx]
sub_103E0 endp ; sp-analysis failed

off_1049B dw offset loc_10879
dw offset loc_1080F
dw offset loc_105B0
dw offset loc_10586
; START	OF FUNCTION CHUNK FOR sub_103E0

loc_104A3:
xor	ax, ax
mov	cx, 1
int	31h		; DPMI Services	  ax=func xxxxh
			; ALLOCATE LDT DESCRS
			; CX = number of descriptors to	allocate
			; Return: CF set on error
			; CF clear if successful, AX = base selector
jnb	short loc_104B1

loc_104AC:
mov	ax, 4CFFh
int	21h		; DOS -	2+ - QUIT WITH EXIT CODE (EXIT)
			; AL = exit code

loc_104B1:
mov	bp, sp
mov	bx, ax
mov	ax, 7
mov	dx, [bp+24h]
mov	cx, dx
shl	dx, 4
shr	cx, 0Ch
int	31h		; DPMI Services	  ax=func xxxxh
			; SET SEGMENT BASE ADDRESS
			; BX = selector, CX:DX = linear	base address
			; Return: CF set on error
			; CF clear if successful
jb	short loc_104AC
inc	ax
xor	cx, cx
mov	dx, 0FFFFh
int	31h		; DPMI Services	  ax=func xxxxh
			; SET SEGMENT LIMIT
			; BX = selector, CX:DX = segment limit
			; Return: CF set on error
			; CF clear if successful
jb	short loc_104AC
inc	ax
mov	dx, cs
lar	cx, dx
shr	cx, 8
int	31h		; DPMI Services	  ax=func xxxxh
			; SET DESCRIPTOR ACCESS	RIGHTS
			; BX = selector, CL = access rights/type byte
			; CH = 80386 extended rights/type byte (32-bit DPMI implementations only)
			; Return: CF set on error
			; CF clear if successful
jb	short loc_104AC
mov	[bp+24h], bx
cmp	cs:byte_1007A, 3
jz	short loc_104F4
push	ds
mov	ds, cs:word_1008E
assume ds:nothing
mov	ds:12h,	bx
pop	ds
assume ds:nothing

loc_104F4:
xor	bx, bx

loc_104F6:
mov	[bp+1Eh], bx
jb	short loc_10516
mov	eax, dword ptr cs:loc_100E8
mov	edx, dword ptr cs:sub_100E4
mov	[bp+1Ah], eax
mov	[bp+16h], edx
or	eax, edx
jnz	short loc_10516
call	sub_10522

loc_10516:
pop	ds
popad
mov	bx, cs
mov	si, word ptr cs:loc_102BE+2
cld
retf
; END OF FUNCTION CHUNK	FOR sub_103E0



sub_10522 proc near
cmp	cs:byte_1007A, 3
jz	short locret_10585
mov	ds, cs:word_1008E
assume ds:nothing
cmp	word ptr ds:260h, 0
jz	short locret_10585
mov	eax, ds:254h
mov	edx, ds:258h
mov	[bp+1Ah], eax
mov	[bp+16h], edx
mov	ds:88h,	eax
mov	ds:84h,	edx
lea	ecx, [eax+10h]
lea	eax, [ecx+edx]
mov	ds:8Ch,	eax
mov	al, ds:1Ah
cmp	al, 0
jz	short locret_10585
cmp	al, 1
jz	short locret_10585
push	es
mov	esi, ds:25Ch
mov	edi, ds:270h
mov	es, word ptr ds:2Ch
mov	ds, word ptr ds:2Ch
assume ds:nothing
shr	ecx, 0Ch
rep movs dword ptr es:[edi], dword ptr [esi]
pop	es

locret_10585:
retn
sub_10522 endp

; START	OF FUNCTION CHUNK FOR sub_103E0

loc_10586:
pop	ds
mov	ax, 1
call	cs:dword_10088
push	ds
jnb	loc_104A3
mov	bx, 6
cmp	ax, 8011h
stc
jz	loc_104F6
dec	bx
jmp	loc_104F6
; END OF FUNCTION CHUNK	FOR sub_103E0
align 10h
; START	OF FUNCTION CHUNK FOR sub_103E0

loc_105B0:
xor	eax, eax
mov	ax, es
add	ax, 0FFh
xor	al, al
mov	es, ax
assume es:nothing
mov	dx, ax
shl	eax, 4
add	eax, 1000h
mov	ds:268h, eax
add	eax, 1000h
movzx	ecx, byte ptr ds:1Bh
shl	ecx, 0Ch
add	eax, ecx
mov	ds:26Ch, eax
mov	ds:274h, eax
movzx	ecx, byte ptr ds:2
shl	ecx, 0Ch
add	eax, ecx
mov	ds:278h, eax
xor	di, di
xor	eax, eax
mov	cx, 800h
rep stosd
mov	gs, dx
assume gs:nothing
mov	ax, dx
add	ax, 100h
mov	es, ax
assume es:nothing
mov	fs, ax
assume fs:nothing
sub	sp, 18h
mov	si, sp
xor	di, di
push	ds
push	ss
pop	ds
mov	ax, 0DE01h
int	67h		;  - LIM EMS Program Interface - GET PROTECTED MODE INTERFACE
			; ES:DI	-> 4K page table buffer
			; DS:SI	-> three descriptor table entries in GDT
			; Return: AH = 00h successful, AH = nonzero  failed
pop	ds
push	di
mov	ds:6Eh,	ebx

loc_10624:
and	byte ptr es:[di+1], 0F1h
sub	di, 4
jnb	short loc_10624
mov	cx, dx
shr	cx, 8
mov	ax, 0DE06h
int	67h		;  - LIM EMS Program Interface - GET PHYS ADDR OF PAGE IN FIRST	MB
			; CX = page number (linear address shifted right 12 bits)
			; Return: AH = 00h successful, EDX = physical address of page
			; AH nonzero: invalid page number (AH =	8Bh recommended)
and	dx, 0F000h
mov	ds:58h,	edx
mov	cx, es
shr	cx, 8
mov	ax, 0DE06h
int	67h		;  - LIM EMS Program Interface - GET PHYS ADDR OF PAGE IN FIRST	MB
			; CX = page number (linear address shifted right 12 bits)
			; Return: AH = 00h successful, EDX = physical address of page
			; AH nonzero: invalid page number (AH =	8Bh recommended)
and	dh, 0F0h
mov	dl, 7
mov	gs:0, edx
mov	ax, es
add	ax, 100h
mov	es, ax
assume es:nothing
mov	si, ax
mov	al, ds:1Bh
mov	ebx, 1
call	sub_106CF
mov	ax, gs
add	ax, 80h	; '€'
mov	gs, ax
assume gs:nothing
mov	al, ds:2
xor	ebx, ebx
call	sub_106CF
pop	di
xor	eax, eax
test	byte ptr ds:0, 4
jnz	short loc_10689
mov	di, 1000h

loc_10689:
mov	ax, di
add	eax, ds:268h
mov	ds:270h, eax
push	si
push	es
call	sub_10707
pop	es
assume es:nothing
pop	si
push	si
xor	di, di
mov	cx, 34h	; '4'
xor	ax, ax
rep stosw
mov	eax, ds:58h
mov	es:1Ch,	eax
mov	dword ptr es:64h, 680000h
add	si, 7
mov	es, si
mov	word ptr ds:48h, 110Ch
mov	dword ptr ds:4Ah, 115Ch
jmp	loc_1097B
; END OF FUNCTION CHUNK	FOR sub_103E0



sub_106CF proc near
push	bp
movzx	bp, al
test	bp, bp
jz	short loc_10705

loc_106D7:
mov	cx, si
shr	cx, 8
mov	ax, 0DE06h
int	67h		;  - LIM EMS Program Interface - GET PHYS ADDR OF PAGE IN FIRST	MB
			; CX = page number (linear address shifted right 12 bits)
			; Return: AH = 00h successful, EDX = physical address of page
			; AH nonzero: invalid page number (AH =	8Bh recommended)
and	dh, 0F0h
mov	dl, 7
mov	gs:0[ebx*4], edx
add	si, 100h
mov	es, si
xor	di, di
xor	eax, eax
mov	cx, 400h
rep stosd
inc	bx
dec	bp
jnz	short loc_106D7

loc_10705:
pop	bp
retn
sub_106CF endp




sub_10707 proc near
push	fs
pop	es
assume es:nothing
movzx	eax, byte ptr ds:1Bh
shl	eax, 16h
mov	ecx, 1000h
sub	cx, di
and	cl, 0FCh
shl	ecx, 0Ah
add	eax, ecx
mov	ecx, ds:0Ch
cmp	ecx, eax
jbe	short loc_10733
mov	ecx, eax

loc_10733:
xor	ebx, ebx
jecxz	locret_1079A

loc_10739:
cmp	di, 1000h
jb	short loc_10748
mov	ax, es
add	ax, 100h
mov	es, ax
assume es:nothing
xor	di, di

loc_10748:
mov	ax, 0DE04h
int	67h		;  - LIM EMS Program Interface - ALLOCATE A 4K PAGE
			; Return: AH = 00h successful, EDX = physical address of allocated page
			; AH nonzero: failed
test	ah, ah
jnz	short loc_10767
and	dh, 0F0h
mov	dl, 7
mov	es:[di], edx
add	di, 4
inc	bx
sub	ecx, 1000h
ja	short loc_10739

loc_10767:
mov	ds:74h,	bx
cmp	ecx, 1000h
jb	short loc_1077E
test	byte ptr ds:0, 8
jz	short loc_1077E
call	sub_1079B

loc_1077E:
shl	ebx, 0Ch
jz	short locret_1079A
mov	ds:88h,	ebx
mov	eax, ds:270h
sub	eax, ds:268h
shl	eax, 0Ah
mov	ds:84h,	eax

locret_1079A:
retn
sub_10707 endp




sub_1079B proc near
push	ebx
shr	ecx, 0Ah
and	cl, 0FCh

loc_107A4:
mov	edx, ecx
jecxz	loc_1080C
call	sub_10DCC
dec	ax
jz	short loc_107B8
sub	ecx, 4
jnb	short loc_107A4
jmp	short loc_1080C

loc_107B8:
mov	ds:56h,	dx
mov	ah, 0Ch
call	dword ptr ds:4Eh
dec	ax
jz	short loc_107D3
xor	dx, dx
xchg	dx, ds:56h
mov	ah, 0Ah
call	dword ptr ds:4Eh
jmp	short loc_1080C

loc_107D3:
shl	edx, 10h
mov	dx, bx
shr	ecx, 2
movzx	eax, cx
pop	ebx
add	ebx, eax
push	ebx

loc_107E8:
cmp	di, 1000h
jb	short loc_107F7
mov	ax, es
add	ax, 100h
mov	es, ax
assume es:nothing
xor	di, di

loc_107F7:
and	dh, 0F0h
mov	dl, 7
mov	es:[di], edx
add	di, 4
add	edx, 1000h
loop	loc_107E8

loc_1080C:
pop	ebx
retn
sub_1079B endp

; START	OF FUNCTION CHUNK FOR sub_103E0

loc_1080F:
mov	ah, 7
call	dword ptr ds:4Eh
mov	ds:1Fh,	al
mov	ah, 3
call	dword ptr ds:4Eh
mov	bx, 7
dec	ax
stc
jnz	loc_104F6
mov	eax, ds:52h
mov	edx, ds:0Ch
shr	edx, 0Ah
cmp	edx, eax
jbe	short loc_1083C
mov	edx, eax

loc_1083C:
mov	esi, edx
test	edx, edx
jz	short loc_10876
call	sub_10DCC
dec	ax
jnz	short loc_10876
mov	ds:56h,	dx
mov	ah, 0Ch
call	dword ptr ds:4Eh
dec	ax
jz	short loc_10865
xor	dx, dx
xchg	dx, ds:56h
mov	ah, 0Ah
call	dword ptr ds:4Eh
jmp	short loc_10876

loc_10865:
mov	ds:84h,	bx
mov	ds:86h,	dx
shl	esi, 0Ah
mov	ds:88h,	esi

loc_10876:
jmp	loc_10966

loc_10879:
call	sub_110D3
mov	bx, 7
jb	loc_104F6
push	es
push	ss
pop	es
assume es:nothing
xor	eax, eax
mov	ebx, eax
mov	ecx, eax
mov	edi, eax
sub	sp, 20h
mov	di, sp

loc_10897:
mov	cl, 14h
mov	eax, 0E820h
mov	edx, 534D4150h
int	15h		; BIOS Memory Services
jb	short loc_108E7
jcxz	short loc_108E7
cmp	eax, 534D4150h
jnz	short loc_108E7
xor	eax, eax
cmp	eax, es:[di+4]
jnz	short loc_10897
cmp	eax, es:[di+0Ch]
jnz	short loc_10897
inc	ax
cmp	eax, es:[di+10h]
jnz	short loc_10897
mov	edx, es:[di]
cmp	edx, 100000h
jnz	short loc_10897
mov	eax, es:[di+8]
add	edx, eax
add	sp, 20h
pop	es
jmp	short loc_10931

loc_108E7:
add	sp, 20h
pop	es
xor	bx, bx
xor	cx, cx
xor	dx, dx
mov	ax, 0E801h
stc
int	15h		; BIOS Memory Services
jb	short loc_1091A
mov	di, cx
or	di, dx
jz	short loc_10903
mov	ax, cx
mov	bx, dx

loc_10903:
mov	di, ax
or	di, bx
jz	short loc_1091A
movzx	eax, ax
movzx	ebx, bx
shl	ebx, 6
add	eax, ebx
jmp	short loc_10925

loc_1091A:
xor	eax, eax
mov	ah, 88h	; 'ˆ'
int	15h		; Get Extended Memory Size
			; Return: CF clear on success
			; AX = size of memory above 1M in K
test	ax, ax
jz	short loc_10966

loc_10925:
shl	eax, 0Ah
lea	edx, [eax+100000h]

loc_10931:
cmp	eax, ds:0Ch
jbe	short loc_1093C
mov	eax, ds:0Ch

loc_1093C:
add	eax, 3FFh
and	eax, 0FFFFFC00h
sub	edx, eax
mov	ds:84h,	edx
mov	ds:88h,	eax
shr	eax, 0Ah
test	eax, 0FFFF0000h
jz	short loc_10963
or	ax, 0FFFFh

loc_10963:
mov	ds:90h,	ax

loc_10966:
mov	word ptr ds:1Ch, 870h
mov	word ptr ds:48h, 11C8h
mov	dword ptr ds:4Ah, 120Ch

loc_1097B:
call	sub_10C89
xor	eax, eax
mov	ax, es
mov	ds:3Ah,	ax
mov	ebx, eax
shl	ebx, 4
mov	ds:3Eh,	ebx
add	ax, 80h	; '€'
mov	ds:2B6h, ax
movzx	bx, byte ptr ds:6
mov	cx, ds:8
mov	ds:2B4h, cx
imul	bx, cx
add	ax, bx
mov	ds:2B8h, ax
mov	ds:2BAh, ax
shl	eax, 4
mov	ds:2A8h, eax
movzx	ebx, byte ptr ds:7
movzx	ecx, word ptr ds:0Ah
shl	ecx, 4
mov	ds:2A4h, ecx
imul	ebx, ecx
add	eax, ebx
mov	ds:2ACh, eax
mov	ds:2B0h, eax
mov	ds:2CCh, eax
shr	eax, 4
mov	ds:2D0h, ax
mov	es, ax
call	sub_10D6A
xor	eax, eax
mov	ax, es
mov	ds:32h,	ax
shl	eax, 4
mov	ds:36h,	eax
movzx	ecx, word ptr ds:4
lea	ecx, ds:4Fh[ecx*8]
mov	ds:34h,	cx
xor	di, di
inc	cx
shr	cx, 1
xor	eax, eax
rep stosw
cmp	byte ptr ds:1Ah, 2
jnz	short loc_10A4B
pop	ax
shl	eax, 4
mov	es:22h,	eax
mov	byte ptr es:20h, 67h ; 'g'
mov	byte ptr es:25h, 89h ; '‰'
add	eax, 40h ; '@'
mov	ds:7Ah,	eax
mov	di, 28h	; '('
mov	si, sp
mov	cl, 0Ch
rep movs word ptr es:[di], word	ptr ss:[si]
add	sp, 18h

loc_10A4B:
mov	ax, 0FFFFh
mov	es:18h,	ax
mov	es:48h,	ax
mov	ax, 0DF92h
mov	es:1Dh,	ax
mov	es:4Dh,	ax
mov	ax, cs
mov	bx, 8
mov	cx, 0FFFFh
mov	dx, 109Ah
call	sub_10DB2
mov	bx, 10h
mov	dx, 1092h
call	sub_10DB2
mov	ax, 40h	; '@'
mov	bx, 40h	; '@'
call	sub_10DB2
mov	bx, 50h	; 'P'
push	bx
mov	ax, ss
mov	dx, 5092h
call	sub_10DB2
mov	ax, [bp+0]
mov	[bp+0],	bx
call	sub_10DB2
push	bx
mov	ah, 51h
int	21h		; DOS -	2+ internal - GET PSP SEGMENT
			; Return: BX = current PSP segment
mov	si, bx
pop	bx
push	ds
mov	ds, si
mov	ax, ds:2Ch
test	ax, ax
jz	short loc_10AB1
mov	ds:2Ch,	bx
call	sub_10DB2
mov	ax, si

loc_10AB1:
mov	cx, 0FFh
call	sub_10DB2
pop	ds
sub	bx, 8
mov	cx, bx
pop	dx
mov	ax, 18h
movzx	ebx, sp
mov	si, 8
mov	edi, 0A72h
jmp	word ptr ds:48h
; END OF FUNCTION CHUNK	FOR sub_103E0
db 0FAh, 66h, 2Eh, 8Bh,	3Eh, 24h, 0, 66h
db 2Eh,	0A1h, 58h, 0, 0Fh, 22h,	0D8h, 0Fh
db 20h,	0C0h, 66h, 67h,	89h, 87h, 24h, 2
db 2 dup(0), 66h, 33h, 0C0h, 0Fh, 22h, 0D0h
db 66h,	2Eh, 3Bh, 6, 20h, 0, 74h, 1Eh, 0B0h
db 1, 0Fh, 0A2h, 66h, 0F7h, 0C2h, 3 dup(0)
db 1, 74h, 11h,	0Fh, 20h, 0E0h,	0Dh, 0,	2
db 0Fh,	22h, 0E0h, 0Fh,	20h, 0C0h, 24h,	0F9h
db 0Fh,	22h, 0C0h, 0Fh,	6, 66h,	0A1h, 54h
db 0, 66h, 67h,	89h, 87h, 28h, 2, 2 dup(0)
db 66h,	0A1h, 6Ch, 0, 66h, 67h,	89h, 87h
db 2Ch,	2, 2 dup(0), 66h, 0A1h,	70h, 0,	66h
db 67h,	89h, 87h, 30h, 2, 2 dup(0), 66h
db 0A1h, 84h, 0, 66h, 67h, 89h,	87h, 34h
db 2, 2	dup(0),	66h, 0A1h, 8Ch,	0, 66h,	67h
db 89h,	87h, 38h, 2, 2 dup(0), 66h, 0A1h
db 90h,	0, 66h,	67h, 89h, 87h, 3Ch, 2, 2 dup(0)
db 66h,	0A1h, 0BCh, 0, 66h, 67h, 89h, 87h
db 40h,	2, 2 dup(0), 66h, 0A1h,	8, 0, 66h
db 67h,	89h, 87h, 0D6h,	2, 2 dup(0), 2Eh
db 0A1h, 16h, 0, 66h, 0C1h, 0E0h, 10h, 0B8h
db 0Dh,	0Fh, 66h, 0A3h,	84h, 0,	2Eh, 0A1h
db 16h,	0, 66h,	0C1h, 0E0h, 10h, 0B8h, 0CBh
db 0Eh,	66h, 0A3h, 8, 0, 66h, 67h, 89h,	87h
db 0DAh, 2, 2 dup(0), 2Eh, 80h,	3Eh, 1Ah
db 2 dup(0), 75h, 0Fh, 2Eh, 83h, 3Eh, 60h
db 2, 0, 75h, 7, 0B8h, 0D8h, 0Eh, 66h, 0A3h
db 54h,	0, 1Eh,	6, 66h,	57h, 0Eh, 1Fh, 8Eh
db 6, 2Eh, 0, 0B8h, 2 dup(3), 66h, 0BEh
db 0B0h, 0Fh, 2	dup(0),	66h, 0BFh, 50h,	5
db 2 dup(0), 0CDh, 31h,	51h, 52h, 0BEh,	0BBh
db 0Fh,	0BFh, 82h, 5, 0CDh, 31h, 51h, 52h
db 0BEh, 0E6h, 0Fh, 0BFh, 0B4h,	5, 0CDh
db 31h,	51h, 52h, 0BEh,	8, 10h,	0BFh, 0E6h
db 5, 0CDh, 31h, 51h, 52h, 8Eh,	1Eh, 2Eh
db 0, 66h, 8Fh,	6, 50h,	2, 66h,	8Fh, 6,	4Ch
db 2, 66h, 8Fh,	6, 48h,	2, 66h,	8Fh, 6,	44h
db 2, 66h, 5Fh,	7, 1Fh,	66h, 33h, 0C0h,	66h
db 2Eh,	8Bh, 1Eh, 84h, 0, 66h, 2Eh, 8Bh
db 0Eh,	88h, 0,	66h, 8Bh, 0D3h,	66h, 83h
db 0C3h, 0Fh, 80h, 0E3h, 0F0h, 66h, 8Bh
db 0F3h, 66h, 2Bh, 0F2h, 66h, 83h, 0C6h
db 10h,	66h, 2Bh, 0CEh,	77h, 12h, 66h, 67h
db 89h,	87h, 84h, 3 dup(0), 66h, 67h, 89h
db 87h,	88h, 3 dup(0), 0EBh, 3Dh, 66h, 0B8h
db 78h,	56h, 34h, 12h, 66h, 67h, 89h, 3
db 66h,	67h, 89h, 43h, 0Ch, 66h, 0Fh, 0B7h
db 6, 60h, 2, 66h, 67h,	89h, 43h, 8, 66h
db 67h,	89h, 4Bh, 4, 66h, 67h, 8Dh, 54h
db 0Bh,	10h, 66h, 67h, 89h, 97h, 8Ch, 3	dup(0)
db 66h,	67h, 89h, 9Fh, 84h, 3 dup(0), 66h
db 67h,	89h, 8Fh, 88h, 3 dup(0), 0FBh, 0E9h
db 1Ah,	0F8h



sub_10C89 proc near
xor	di, di
xor	ecx, ecx
mov	dx, ds:1Ch

loc_10C92:
lea	eax, ds:81260h[ecx*4]
stosd
mov	eax, 8E00h
mov	bl, cl
and	bl, 0F8h
test	cl, 0F0h
jz	short loc_10CBD
cmp	bl, dl
jz	short loc_10CBD
cmp	bl, dh
jz	short loc_10CBD
cmp	cl, 2
jz	short loc_10CBD
mov	ax, 8F00h

loc_10CBD:
stosd
inc	cl
jnz	short loc_10C92
mov	word ptr es:108h, 0D87h
mov	word ptr es:188h, 1EA6h
push	ds
push	es
push	ds
pop	es
assume ds:seg001
xor	ax, ax
mov	ds, ax
assume ds:nothing
mov	di, 0DAh ; 'Ú'
movzx	si, dh
shl	si, 2
mov	cx, 8
rep movsd
movzx	si, dl
shl	si, 2
mov	cl, 8
rep movsd
mov	cl, 10h
mov	di, 19Ah
mov	ax, 16E0h

loc_10CFB:
stosw
mov	word ptr es:[di+2], 8
add	di, 6
add	ax, 4
loop	loc_10CFB
pop	es
pop	ds
assume ds:nothing
mov	ax, 19E2h
sub	ax, 1264h
mov	di, 1262h
mov	cl, 0Fh

loc_10D17:
mov	[di], ax
sub	ax, 4
add	di, 4
loop	loc_10D17
movzx	dx, byte ptr ds:1Dh
call	sub_10D45
movzx	dx, byte ptr ds:1Ch
call	sub_10D45
mov	ax, 50Eh
mov	ds:126Ah, ax
cmp	byte ptr ds:1Dh, 10h
jnb	short locret_10D44
mov	ax, 6D1h
mov	ds:129Eh, ax

locret_10D44:
retn
sub_10C89 endp




sub_10D45 proc near
cmp	dl, 0Fh
mov	ax, 1919h
jbe	short loc_10D50
mov	ax, 1971h

loc_10D50:
shl	dx, 2
sub	ax, 1264h
sub	ax, dx
mov	di, 1262h
add	di, dx
mov	cl, 8

loc_10D5F:
mov	[di], ax
sub	ax, 4
add	di, 4
loop	loc_10D5F
retn
sub_10D45 endp




sub_10D6A proc near
movzx	cx, byte ptr ds:3
jcxz	short locret_10DB1
xor	di, di
mov	ax, 6866h
mov	dx, ds:16h
push	ds
push	es
pop	ds

loc_10D7D:
mov	word ptr [di], 6066h
mov	[di+2],	ah
mov	word ptr [di+3], 0
mov	[di+5],	ax
mov	byte ptr [di+0Bh], 0B9h	; '¹'
mov	[di+0Eh], ax
mov	byte ptr [di+14h], 0EAh	; 'ê'
mov	word ptr [di+15h], 1C9Dh
mov	[di+17h], dx
add	di, 19h
loop	loc_10D7D
pop	ds
add	di, 0Fh
shr	di, 4
mov	ax, es
add	ax, di
mov	es, ax
assume es:nothing

locret_10DB1:
retn
sub_10D6A endp




sub_10DB2 proc near
push	ax
movzx	eax, ax
shl	eax, 4
mov	es:[bx], cx
mov	es:[bx+2], eax
mov	es:[bx+5], dx
add	bx, 8
pop	ax
retn
sub_10DB2 endp




sub_10DCC proc near
push	edi
mov	edi, edx
mov	ah, 89h	; '‰'
call	dword ptr ds:4Eh
cmp	ax, 1
jz	short loc_10DE4
mov	dx, di
mov	ah, 9
call	dword ptr ds:4Eh

loc_10DE4:
pop	edi
retn
sub_10DCC endp


loc_10DE7:
cmp	ah, 4Ch	; 'L'
jnz	short loc_10E4D
cli
cld
push	ax
mov	ds, cs:word_1008E
assume ds:nothing
mov	es, word ptr ds:2Ch
assume es:nothing
mov	eax, ds:224h
mov	cr0, eax
mov	eax, ds:22Ch
mov	es:6Ch,	eax
mov	eax, ds:2D6h
mov	es:8, eax
mov	eax, ds:230h
mov	es:70h,	eax
mov	eax, ds:234h
mov	es:84h,	eax
mov	eax, ds:238h
mov	es:8Ch,	eax
mov	eax, ds:23Ch
mov	es:90h,	eax
mov	eax, ds:240h
mov	es:0BCh, eax
call	sub_10E58
movzx	bx, byte ptr ds:1Ah
add	bx, bx
call	word ptr [bx+0DF0h]
pop	ax

loc_10E4D:
jmp	loc_11344
db 40h,	0Eh, 4Ah, 0Eh, 5Ch, 0Eh, 0CAh, 0Eh



sub_10E58 proc near
cmp	word ptr ds:260h, 0
jz	short locret_10E9F
mov	esi, ds:84h
mov	eax, ds:88h
or	eax, esi
jz	short locret_10E9F

loc_10E6D:
mov	eax, es:[esi+4]
mov	edx, es:[esi+8]
btr	eax, 1Fh
cmp	edx, ds:260h
jnz	short loc_10E8B
mov	es:[esi+4], eax

loc_10E8B:
lea	esi, [esi+eax+10h]
cmp	esi, ds:8Ch
jb	short loc_10E6D
push	ds
push	es
pop	ds
assume ds:nothing
call	sub_12C7A
pop	ds

locret_10E9F:
retn
sub_10E58 endp

mov	eax, ds:228h
mov	es:54h,	eax
retn
db 0E8h, 38h, 0, 8Ah, 26h, 1Fh,	0, 80h,	0E4h
db 1, 80h, 0F4h, 1, 80h, 0C4h, 3, 0EBh,	38h
db 8Bh,	0Eh, 74h, 0, 66h, 8Bh, 36h, 70h
db 2, 0E3h, 1Eh, 66h, 26h, 67h,	8Bh, 16h
db 66h,	83h, 0C6h, 4, 81h, 0E2h, 0, 0F0h
db 0B8h, 5, 0DEh, 66h, 0FFh, 1Eh, 6Eh, 0
db 0E2h, 0E9h, 66h, 0A1h, 58h, 0, 0Fh, 22h
db 0D8h, 8Bh, 16h, 56h,	0, 85h,	0D2h, 74h
db 3Dh,	0B4h, 0Dh, 0E8h, 2, 0, 0B4h, 0Ah
db 16h,	7, 66h,	83h, 0ECh, 32h,	66h, 8Bh
db 0FCh, 66h, 33h, 0C9h, 67h, 89h, 54h,	24h
db 14h,	67h, 89h, 44h, 24h, 1Ch, 66h, 0A1h
db 4Eh,	0, 67h,	89h, 4Ch, 24h, 20h, 66h
db 67h,	89h, 4Ch, 24h, 2Eh, 66h, 67h, 89h
db 44h,	24h, 2Ah, 33h, 0DBh, 0B8h, 1, 3
db 0CDh, 31h, 66h, 83h,	0C4h, 32h, 0C3h
db 50h,	9Ch, 2Eh, 0FFh,	1Eh, 0D6h, 2, 32h
db 0C0h, 0E6h, 70h, 58h, 0CFh, 80h, 0FCh
db 88h,	74h, 0Fh, 3Dh, 1, 0E8h,	74h, 22h
db 3Dh,	20h, 0E8h, 74h,	1Dh, 2Eh, 0FFh,	2Eh
db 28h,	2, 9Ch,	2Eh, 0FFh, 1Eh,	28h, 2,	2Eh
db 2Bh,	6, 90h,	0, 73h,	2, 33h,	0C0h
push	bp
mov	bp, sp
and	byte ptr [bp+6], 0FEh
pop	bp
iret
push	bp
mov	bp, sp
or	byte ptr [bp+6], 1
pop	bp
iret
cmp	byte ptr cs:loc_102C3+3, 0
jnz	short loc_10F91
cmp	ax, 0FF88h
jz	short loc_10FD6
cmp	byte ptr cs:loc_102C3+1, 0
jnz	short loc_10F91
cmp	ah, 4Ch	; 'L'
jz	short loc_10F96
cmp	ah, 4Bh	; 'K'
jz	short loc_10FBE
cmp	ah, 31h	; '1'
jz	short loc_11005

loc_10F91:
jmp	dword ptr cs:loc_10294

loc_10F96:
cli
mov	bp, ax
mov	al, 80h	; '€'
out	70h, al		; CMOS Memory:
			;
mov	ax, 10h
mov	cx, ax
mov	dx, 18h
mov	ebx, dword ptr cs:loc_10308+4
mov	si, 8
mov	edi, 0F59h
jmp	word ptr cs:byte_10090+18h
mov	ax, bp
jmp	loc_10DE7

loc_10FBE:
mov	byte ptr cs:loc_102C3+1, 1
pushf
call	dword ptr cs:loc_10294
mov	byte ptr cs:loc_102C3+1, 0
pop	bx
pop	cx
pop	dx
push	cx
push	bx
retf

loc_10FD6:
mov	eax, 49443332h
movzx	ebx, cs:word_10074
mov	ecx, dword ptr cs:loc_100E8
mov	edx, dword ptr cs:sub_100E4
mov	si, word ptr cs:loc_102BE+2
shl	esi, 10h
movzx	si, cs:byte_1007B
mov	edi, dword ptr cs:loc_102D0
iret

loc_11005:
mov	byte ptr cs:loc_102C3+3, 1
jmp	dword ptr cs:loc_10294
db 0E8h, 9Dh, 0, 0CDh, 1Bh, 0B8h, 6, 0,	0E9h
db 0AEh, 0, 0E8h, 92h, 0, 1Eh, 2Eh, 8Eh
db 1Eh,	2Ch, 0,	66h, 2Eh, 0A1h,	30h, 2,	66h
db 0A3h, 70h, 0, 1Fh, 0CDh, 1Ch, 1Eh, 2Eh
db 8Eh,	1Eh, 2Ch, 0, 66h, 2Eh, 0A1h, 48h
db 2, 66h, 0A3h, 70h, 0, 1Fh, 0B8h, 6, 0
db 0E9h, 83h, 0, 0E8h, 67h, 0, 0F8h, 66h
db 8Bh,	0ECh, 0CDh, 23h, 66h, 8Bh, 0E5h
db 0Fh,	92h, 0C4h, 26h,	67h, 8Ah, 47h, 20h
db 24h,	0FEh, 2, 0C4h, 26h, 67h, 88h, 47h
db 20h,	0B8h, 4, 0, 0EBh, 61h, 0E8h, 45h
db 0, 66h, 57h,	66h, 67h, 0FFh,	76h, 1Ah
db 66h,	67h, 0FFh, 76h,	16h, 66h, 67h, 0FFh
db 76h,	12h, 66h, 67h, 0FFh, 76h, 0Eh, 66h
db 67h,	0FFh, 76h, 0Ah,	66h, 67h, 0FFh,	76h
db 6, 26h, 67h,	8Bh, 47h, 1Ch, 26h, 67h
db 8Bh,	6Fh, 8,	26h, 67h, 8Bh, 77h, 4, 26h
db 67h,	8Bh, 3Fh, 0CDh,	24h, 66h, 83h, 0C4h
db 18h,	66h, 5Fh, 26h, 67h, 88h, 47h, 1Ch
db 0B8h, 6, 0, 0EBh, 19h



sub_110B0 proc near
pop	bp
mov	ax, [esi+4]
mov	es:[edi+20h], ax
mov	eax, [esi]
mov	es:[edi+2Ah], eax
push	es
push	edi
jmp	bp
sub_110B0 endp

db 66h,	5Fh, 7,	26h, 67h, 1, 47h, 2Eh, 66h
db 0CFh



sub_110D3 proc near
pushf
cli
mov	al, 80h	; '€'
out	70h, al		; CMOS Memory:
			;
call	sub_11143
setz	al
mov	ds:1Fh,	al
jz	short loc_11131
in	al, 92h
or	al, 2
jmp	short $+2
jmp	short $+2
jmp	short $+2
out	92h, al
call	sub_11143
jz	short loc_11131
call	sub_11134
jnz	short loc_1110A
mov	al, 0D1h ; 'Ñ'
out	64h, al		; 8042 keyboard	controller command register.
			; Write	output port (next byte to port 60h):
			; 7:  1=keyboard data line pulled low (inhibited)
			; 6:  1=keyboard clock line pulled low (inhibited)
			; 5:  enables IRQ 12 interrupt on mouse	IBF
			; 4:  enables IRQ 1 interrupt on keyboard IBF
			; 3:  1=mouse clock line pulled	low (inhibited)
			; 2:  1=mouse data line	pulled low (inhibited)
			; 1:  A20 gate on/off
			; 0:  reset the	PC (THIS BIT SHOULD ALWAYS BE SET TO 1)
call	sub_11134
jnz	short loc_1110A
mov	al, 0DFh ; 'ß'
out	60h, al		; 8042 keyboard	controller data	register.
call	sub_11134

loc_1110A:
mov	cx, 800h

loc_1110D:
call	sub_11143
jz	short loc_11131
in	al, 40h		; Timer	8253-5 (AT: 8254.2).
jmp	short $+2
jmp	short $+2
jmp	short $+2
in	al, 40h		; Timer	8253-5 (AT: 8254.2).
mov	ah, al

loc_1111E:		; Timer	8253-5 (AT: 8254.2).
in	al, 40h
jmp	short $+2
jmp	short $+2
jmp	short $+2
in	al, 40h		; Timer	8253-5 (AT: 8254.2).
cmp	al, ah
jz	short loc_1111E
loop	loc_1110D
popf
stc
retn

loc_11131:
popf
clc
retn
sub_110D3 endp




sub_11134 proc near
xor	cx, cx

loc_11136:
jmp	short $+2
jmp	short $+2
jmp	short $+2
in	al, 64h		; 8042 keyboard	controller status register
			; 7:  PERR    1=parity error in	data received from keyboard
			;    +----------- AT Mode ----------+------------ PS/2 Mode ------------+
			; 6: |RxTO    receive (Rx) timeout  | TO      general timeout (Rx or Tx)|
			; 5: |TxTO    transmit (Tx) timeout | MOBF    mouse output buffer full	|
			;    +------------------------------+-----------------------------------+
			; 4:  INH     0=keyboard communications	inhibited
			; 3:  A2      0=60h was	the port last written to, 1=64h	was last
			; 2:  SYS     distinguishes reset types: 0=cold	reboot,	1=warm reboot
			; 1:  IBF     1=input buffer full (keyboard can't accept data)
			; 0:  OBF     1=output buffer full (data from keyboard is available)
test	al, 2
loopne	loc_11136
retn
sub_11134 endp




sub_11143 proc near
push	fs
push	gs
xor	ax, ax
mov	fs, ax
assume fs:nothing
dec	ax
mov	gs, ax
assume gs:nothing
mov	al, fs:0
mov	ah, al
not	al
xchg	al, gs:10h
cmp	ah, fs:0
mov	gs:10h,	al
pop	gs
pop	fs
assume fs:nothing
retn
sub_11143 endp

align 4
db 9Ch,	2Eh, 8Eh, 1Eh, 16h, 0, 8Fh, 6, 1Ch
db 2, 0A3h, 1Eh, 2, 0B0h, 80h, 0E6h, 70h
db 0FAh, 89h, 36h, 20h,	2, 66h,	8Bh, 36h
db 76h,	0, 0B8h, 0Ch, 0DEh, 0CDh, 67h, 8Eh
db 0D2h, 66h, 8Bh, 0E3h, 2Eh, 8Eh, 2 dup(1Eh)
db 2, 8Eh, 0C1h, 33h, 0C0h, 8Eh, 0E0h, 8Eh
db 0E8h, 66h, 9Ch, 2Eh,	0A1h, 1Ch, 2, 80h
db 0E4h, 0Fh, 67h, 89h,	4, 24h,	66h, 2Eh
db 0FFh, 36h, 20h, 2, 66h, 57h,	32h, 0C0h
db 0E6h, 70h, 66h, 0CFh, 87h, 0DBh, 90h
db 9Ch,	0FAh, 50h, 0B0h, 80h, 0E6h, 70h
db 2Eh,	8Eh, 1Eh, 2Ch, 0, 66h, 0Fh, 0B7h
db 0DBh, 66h, 2Eh, 0A1h, 7Ah, 0, 66h, 0Fh
db 0B7h, 0D2h, 66h, 67h, 0C7h, 40h, 20h
db 4 dup(0), 66h, 0Fh, 0B7h, 0C9h, 66h,	67h
db 0C7h, 40h, 1Ch, 4 dup(0), 66h, 67h, 89h
db 48h,	14h, 59h, 66h, 67h, 89h, 48h, 18h
db 66h,	67h, 89h, 50h, 10h, 66h, 67h, 89h
db 58h,	0Ch, 66h, 67h, 0C7h, 40h, 4
dw seg seg001
db 2 dup(0), 66h, 67h, 0C7h, 0,	0C3h, 11h
db 2 dup(0), 5Bh, 2Eh, 8Eh, 16h, 2Ch, 0
db 66h,	8Bh, 0E0h, 0B8h, 0Ch, 0DEh, 66h
db 2Eh,	0FFh, 1Eh, 6Eh,	0, 53h,	56h, 57h
db 0CFh, 90h, 66h, 9Ch,	0FAh, 50h, 0B0h
db 80h,	0E6h, 70h, 2Eh,	0Fh, 1,	1Eh, 3Ch
db 0, 2Eh, 0Fh,	1, 16h,	34h, 0,	0Fh, 20h
db 0C0h, 0Ch, 1, 0Fh, 22h, 0C0h, 0EAh, 0E9h
db 11h,	8, 0, 1Fh, 8Eh,	0C1h, 33h, 0C0h
db 8Eh,	0E0h, 8Eh, 0E8h, 66h, 58h, 8Eh,	0D2h
db 66h,	8Bh, 0E3h, 80h,	0E4h, 0BFh, 50h
db 9Dh,	66h, 50h, 66h, 56h, 66h, 57h, 32h
db 0C0h, 0E6h, 70h, 66h, 0CFh, 87h, 0DBh
db 9Ch,	0FAh, 50h, 0B0h, 80h, 0E6h, 70h
db 2Eh,	8Eh, 1Eh, 2Eh, 0, 8Fh, 6, 1Ch, 2
db 8Fh,	6, 1Eh,	2, 0B8h, 10h, 0, 8Eh, 0D8h
db 8Eh,	0C0h, 8Eh, 0E0h, 8Eh, 0E8h, 8Eh
db 0D0h, 66h, 0Fh, 0B7h, 0E3h, 0Fh, 1, 1Eh
db 42h,	0, 0Fh,	20h, 0C0h, 24h,	0FEh, 0Fh
db 22h,	0C0h, 0EAh, 43h, 12h
dw seg seg001
mov	ss, dx
mov	ds, word ptr cs:loc_1027B+1
assume ds:nothing
mov	es, cx
xor	ax, ax
mov	fs, ax
assume fs:nothing
mov	gs, ax
assume gs:nothing
push	word ptr cs:loc_1027E
push	si
push	di
out	70h, al		; CMOS Memory:
			; used by real-time clock
iret
retfd
align 4
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E

loc_11344:
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_1186E
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11BA7
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11C47
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
push	ax
call	sub_11B99
; START	OF FUNCTION CHUNK FOR sub_1186E

loc_11780:
cli
mov	ds, cs:word_1008E
assume ds:nothing
mov	es, word ptr ds:2Ch
mov	eax, ds:230h
mov	es:70h,	eax
mov	ax, ds:2BAh
mov	ds:2B8h, ax
mov	ax, 8200h
jmp	dword ptr ds:10h
; END OF FUNCTION CHUNK	FOR sub_1186E
; START	OF FUNCTION CHUNK FOR sub_11C47

loc_117A0:
cli
xor	ax, ax
mov	ds, cs:word_10076
assume ds:nothing
mov	es, ax
assume es:nothing
mov	eax, ds:230h
mov	es:70h,	eax
mov	eax, ds:2B0h
mov	ds:2ACh, eax
mov	ebx, eax
mov	ax, 10h
mov	cx, ax
mov	dx, 18h
mov	si, 8
mov	edi, 1773h
jmp	word ptr ds:48h
; END OF FUNCTION CHUNK	FOR sub_11C47
mov	ax, 8300h
jmp	dword ptr ds:10h
pop	ax
pushad
push	ds
push	es
push	fs
push	gs
mov	ds, cs:word_1008E
assume ds:nothing
movzx	eax, al
mov	dx, ds:2B8h
mov	bx, ds:2B4h
movzx	esi, dx
sub	dx, bx
shl	esi, 4
cmp	dx, ds:2B6h
jb	loc_11780
mov	ds:2B8h, dx
shl	bx, 4
mov	edi, ds:2DAh
mov	ds, word ptr ds:2Ch
assume ds:nothing
mov	ds:8, edi
mov	word ptr [esi-2], ss
mov	[esi-6], esp
mov	dword ptr [esi-0Ah], seg seg001
mov	word ptr [esi-0Ch], 17E1h
shld	esi, edi, 10h
sub	bx, 0Ch
jmp	large [dword ptr cs:byte_10090+1Ah]
cli
mov	ax, 10h
mov	cx, ax
pop	ebx
pop	dx
mov	si, 8
mov	edi, 17F8h
jmp	word ptr cs:byte_10090+18h
db 0A1h, 0B4h, 2, 1, 6,	0B8h, 2, 8Eh, 1Eh
db 2Ch,	0, 0Fh,	0A9h, 0Fh, 0A1h, 7, 1Fh
db 66h,	61h, 58h, 66h, 0CFh



sub_1186E proc near

var_1E=	byte ptr -1Eh
arg_0= word ptr	 2

; FUNCTION CHUNK AT 1720 SIZE 00000020 BYTES

cli
pop	ax
sub	ax, 1261h
shr	ax, 2
pushad
push	ds
push	es
push	fs
push	gs
mov	ds, cs:word_1008E
assume es:nothing, ds:nothing, fs:nothing, gs:nothing
inc	dword ptr ds:288h
mov	ds:188Fh, al
mov	dx, ds:2B8h
mov	bx, ds:2B4h
movzx	esi, dx
sub	dx, bx
shl	esi, 4
cmp	dx, ds:2B6h
jb	loc_11780
mov	ds:2B8h, dx
shl	bx, 4
mov	es, word ptr ds:2Ch
mov	ds, word ptr ds:2Ch
assume ds:nothing
lea	edi, [esi-26h]
mov	ecx, 8
mov	word ptr [esi-2], ss
mov	[esi-6], esp
lea	esi, [esp+26h+var_1E]
cld
rep movs dword ptr es:[edi], dword ptr ss:[esi]
mov	ax, [esp+26h+arg_0]
mov	[edi-4], ax
mov	si, seg	seg001
mov	di, 188Ch
sub	bx, 26h	; '&'
jmp	large [dword ptr cs:byte_10090+1Ah]
sub_1186E endp

db 66h,	61h, 0CDh, 0, 66h, 60h,	9Ch, 0FAh
db 66h,	33h, 0C0h, 66h,	8Bh, 0E8h, 8Ch,	0D0h
db 66h,	0C1h, 0E0h, 4, 8Bh, 0ECh, 66h, 8Bh
db 5Eh,	22h, 8Bh, 56h, 26h, 66h, 3, 0E8h
db 0B8h, 18h, 0, 0B9h, 10h, 0, 0BEh, 8,	0
db 66h,	0BFh, 0C0h, 18h, 2 dup(0), 2Eh,	0FFh
db 26h,	48h, 0,	66h, 26h, 0FFh,	6, 84h,	2
db 26h,	0A1h, 0B4h, 2, 26h, 1, 6, 0B8h,	2
db 3Eh,	67h, 8Bh, 45h, 0, 25h, 0D5h, 8,	67h
db 8Bh,	54h, 24h, 32h, 81h, 0E2h, 2Ah, 0F7h
db 0Bh,	0C2h, 67h, 89h,	44h, 24h, 32h, 66h
db 8Bh,	0C5h, 66h, 67h,	8Bh, 78h, 2, 66h
db 67h,	8Bh, 70h, 6, 66h, 67h, 8Bh, 68h
db 0Ah,	66h, 67h, 8Bh, 58h, 12h, 66h, 67h
db 8Bh,	50h, 16h, 66h, 67h, 8Bh, 48h, 1Ah
db 66h,	67h, 8Bh, 40h, 1Eh, 0Fh, 0A9h, 0Fh
db 0A1h, 7, 1Fh, 66h, 83h, 0C4h, 22h, 66h
db 0CFh, 0B0h, 0Bh, 0E6h, 20h, 0E4h, 20h
db 84h,	0C0h, 0Fh, 84h,	0BDh, 0, 67h, 8Bh
db 4, 24h, 2Dh,	61h, 12h, 0C1h,	0E8h, 2
db 67h,	89h, 4,	2 dup(24h), 7, 2Eh, 0Fh
db 0A3h, 6, 0D6h, 0, 58h, 73h, 3Ah, 24h
db 7, 0C1h, 0E0h, 3, 93h, 66h, 83h, 0ECh
db 6, 67h, 89h,	44h, 24h, 4, 2Eh, 8Bh, 87h
db 1Ah,	1, 67h,	89h, 4,	24h, 2Eh, 8Bh, 87h
db 1Ch,	1, 67h,	89h, 44h, 24h, 2, 2Eh, 8Bh
db 9Fh,	1Eh, 1,	67h, 87h, 5Ch, 24h, 4, 67h
db 8Bh,	44h, 24h, 6, 66h, 0CBh,	58h, 2Dh
db 61h,	12h, 0C1h, 0E8h, 2, 66h, 60h, 1Eh
db 6, 0Fh, 0A0h, 0Fh, 0A8h, 2Eh, 8Eh, 1Eh
db 2Eh,	0, 66h,	0FFh, 6, 90h, 2, 66h, 0Fh
db 0B6h, 0C0h, 8Bh, 16h, 0B8h, 2, 8Bh, 1Eh
db 0B4h, 2, 66h, 0Fh, 0B7h, 0F2h, 2Bh, 0D3h
db 66h,	0C1h, 0E6h, 4, 3Bh, 16h, 0B6h, 2
db 0Fh,	82h, 78h, 0FDh,	89h, 16h, 0B8h,	2
db 0C1h, 0E3h, 4, 8Eh, 1Eh, 2Ch, 0, 66h
db 67h,	8Bh, 3Ch, 85h, 4 dup(0), 67h, 8Ch
db 56h,	0FEh, 66h, 67h,	89h, 66h, 0FAh,	66h
db 67h,	0C7h, 46h, 0F6h
dw seg seg001
db 2 dup(0), 67h, 0C7h,	46h, 0F4h, 0B9h
db 1Bh,	66h, 0Fh, 0A4h,	0FEh, 10h, 83h,	0EBh
db 0Ch,	66h, 2Eh, 0FFh,	26h, 4Ah, 0, 58h
db 2Dh,	61h, 12h, 0C1h,	0E8h, 2, 3Ch, 8
db 0Fh,	82h, 80h, 0, 3Ch, 9, 74h, 7Ch, 3Ch
db 0Eh,	77h, 78h, 66h, 83h, 0ECh, 16h, 66h
db 67h,	89h, 44h, 24h, 8, 66h, 0Fh, 0B7h
db 0C0h, 66h, 2Eh, 67h,	8Bh, 4,	0C5h, 9Ah
db 1, 2	dup(0),	66h, 67h, 89h, 4, 24h, 66h
db 67h,	0Fh, 0B7h, 44h,	24h, 8,	66h, 2Eh
db 67h,	8Bh, 4,	0C5h, 9Eh, 1, 2	dup(0),	66h
db 67h,	89h, 44h, 24h, 4, 67h, 8Bh, 44h
db 24h,	16h, 67h, 89h, 44h, 24h, 8, 8Ch
db 0C8h, 66h, 67h, 89h,	44h, 24h, 0Ch, 66h
db 67h,	8Bh, 44h, 24h, 18h, 66h, 67h, 89h
db 44h,	24h, 10h, 66h, 67h, 8Bh, 44h, 24h
db 1Ch,	66h, 67h, 89h, 44h, 24h, 14h, 66h
db 67h,	8Bh, 44h, 24h, 20h, 66h, 67h, 89h
db 44h,	24h, 18h, 66h, 67h, 8Bh, 44h, 2	dup(24h)
db 66h,	67h, 89h, 44h, 24h, 1Ch, 0EBh, 73h
db 66h,	83h, 0ECh, 1Ah,	66h, 67h, 89h, 44h
db 24h,	8, 66h,	0Fh, 0B7h, 0C0h, 66h, 2Eh
db 67h,	8Bh, 4,	0C5h, 9Ah, 1, 2	dup(0),	66h
db 67h,	89h, 4,	24h, 66h, 67h, 0Fh, 0B7h
db 44h,	24h, 8,	66h, 2Eh, 67h, 8Bh, 4, 0C5h
db 9Eh,	1, 2 dup(0), 66h, 67h, 89h, 44h
db 24h,	4, 67h,	8Bh, 44h, 24h, 1Ah, 67h
db 89h,	44h, 24h, 8, 8Ch, 0C8h,	66h, 67h
db 89h,	44h, 24h, 0Ch, 66h, 33h, 0C0h, 66h
db 67h,	89h, 44h, 24h, 10h, 66h, 67h, 8Bh
db 44h,	24h, 1Ch, 66h, 67h, 89h, 44h, 24h
db 14h,	66h, 67h, 8Bh, 44h, 24h, 20h, 66h
db 67h,	89h, 44h, 24h, 18h, 66h, 67h, 8Bh
db 44h,	2 dup(24h), 66h, 67h, 89h, 44h,	24h
db 1Ch,	66h, 67h, 8Dh, 44h, 24h, 28h, 66h
db 67h,	89h, 44h, 24h, 20h, 8Ch, 0D0h, 66h
db 0Fh,	0B7h, 0C0h, 66h, 67h, 89h, 44h,	2 dup(24h)
db 0B8h, 5, 1Bh, 66h, 67h, 87h,	44h, 24h
db 8, 66h, 0CBh, 66h, 67h, 89h,	4, 24h,	66h
db 67h,	8Bh, 44h, 24h, 0Ch, 66h, 67h, 89h
db 44h,	24h, 14h, 66h, 67h, 8Bh, 44h, 24h
db 8, 66h, 67h,	89h, 44h, 24h, 10h, 66h
db 67h,	8Bh, 44h, 24h, 4, 66h, 67h, 89h
db 44h,	24h, 0Ch, 66h, 67h, 8Bh, 4, 24h
db 66h,	83h, 0C4h, 0Ch,	66h, 0CFh



sub_11B99 proc near
pop	ax
sub	ax, 16E1h
shr	ax, 2
mov	ah, 81h	; ''
jmp	cs:dword_10070
sub_11B99 endp ; sp-analysis failed




sub_11BA7 proc near
cli
pop	ax
sub	ax, 1661h
shr	ax, 2
pushad
push	ds
push	es
push	fs
push	gs
mov	ds, cs:word_1008E
assume ds:nothing
inc	dword ptr ds:290h
movzx	eax, al
mov	dx, ds:2B8h
mov	bx, ds:2B4h
movzx	esi, dx
sub	dx, bx
shl	esi, 4
cmp	dx, ds:2B6h
jb	loc_11780
mov	ds:2B8h, dx
shl	bx, 4
mov	edi, ds:0DAh[eax*4]
mov	ds, word ptr ds:2Ch
assume ds:nothing
mov	word ptr [esi-2], ss
mov	[esi-6], esp
mov	dword ptr [esi-0Ah], seg seg001
mov	word ptr [esi-0Ch], 1BB9h
shld	esi, edi, 10h
sub	bx, 0Ch
jmp	large [dword ptr cs:byte_10090+1Ah]
sub_11BA7 endp

cli
mov	ax, 10h
mov	cx, ax
pop	ebx
pop	dx
mov	si, 8
mov	edi, 1BD0h
jmp	word ptr cs:byte_10090+18h
db 66h,	0FFh, 6, 8Ch, 2, 0A1h, 0B4h, 2,	1
db 6, 0B8h, 2, 0Fh, 0A9h, 0Fh, 0A1h, 7,	1Fh
db 66h,	61h, 58h, 66h, 0CFh



sub_11C47 proc near

; FUNCTION CHUNK AT 1740 SIZE 00000033 BYTES

cli
pop	ax
sub	ax, 16A1h
shr	ax, 2
pushad
push	ds
push	es
push	fs
push	gs
mov	ds, cs:word_10076
inc	dword ptr ds:294h
mov	ds:0D3h, al
mov	edx, ds:2ACh
mov	ebx, edx
sub	edx, ds:2A4h
cmp	edx, ds:2A8h
jb	loc_117A0
mov	ds:2ACh, edx
mov	bp, ss
shl	ebp, 10h
mov	bp, sp
mov	si, ds:2D4h
mov	[si+650h], esp
add	word ptr ds:2D4h, 4
mov	ax, 8
mov	cx, 18h
mov	dx, cx
mov	si, ax
mov	edi, 1C49h
jmp	word ptr ds:48h
sub_11C47 endp

movzx	bx, byte ptr ds:0D3h
shl	bx, 3
pushfd
push	large 8
push	large 1C61h
jmp	large fword ptr	[bx+11Ah]
mov	ax, seg	seg001
mov	si, ax
mov	di, 1C77h
mov	bx, bp
shr	ebp, 10h
mov	dx, bp
jmp	large [dword ptr cs:byte_10090+1Ah]
inc	dword ptr ds:298h
mov	eax, ds:2A4h
add	ds:2ACh, eax
sub	word ptr ds:2D4h, 4
mov	si, ds:2D4h
mov	esp, [si+650h]
pop	gs
pop	fs
pop	es
pop	ds
popad
pop	ax
iret
mov	ax, sp
push	ss
push	ax
push	gs
push	fs
push	ds
push	es
pushf
cli
push	cs
pop	ds
assume ds:seg001
inc	dword ptr loc_102FB+1
mov	ebp, dword ptr loc_10308+4
mov	ebx, ebp
sub	ebx, dword ptr loc_10303+1
mov	dword ptr loc_10308+4, ebx
cmp	ebx, dword ptr loc_10308
jb	loc_117A0
xor	eax, eax
mov	ebx, eax
mov	ax, ss
shl	eax, 4
mov	bx, sp
add	ebx, eax
mov	es, word ptr byte_10090+2
assume es:nothing
or	eax, 92000000h
mov	es:4Ah,	eax
mov	ax, 18h
mov	dx, ax
mov	si, 8
mov	edi, 1CFDh
jmp	word ptr byte_10090+18h
mov	edi, [esp+0Eh]
lea	esi, [esp+18h]
mov	ecx, 8
cld
rep movs dword ptr es:[edi], dword ptr [esi]
mov	esi, esp
movs	word ptr es:[edi], word	ptr [esi]
movs	dword ptr es:[edi], dword ptr [esi]
movs	dword ptr es:[edi], dword ptr [esi]
lods	dword ptr [esi]
add	ax, 2Ah	; '*'
mov	es:[edi+4], eax
mov	ds, word ptr cs:byte_10090
assume ds:nothing
sub	edi, 2Ah ; '*'
movzx	esi, ax
xchg	esp, ebp
pushfd
db	66h
push	cs
push	large offset loc_11DB4
movzx	eax, word ptr [ebp+16h]
push	eax
push	large dword ptr	[ebp+12h]
retfd

loc_11DB4:
cli
push	es
pop	ds
assume ds:nothing
mov	esi, edi
mov	es, word ptr cs:byte_1008C
assume es:nothing
movzx	ebx, word ptr [esi+2Eh]
movzx	edx, word ptr [esi+30h]
sub	bx, 2Ah	; '*'
mov	ebp, [esi+0Ch]
mov	bp, bx
lea	edi, ds:0[edx*4]
lea	edi, [ebx+edi*4]
mov	ecx, 8
cld
rep movs dword ptr es:[edi], dword ptr [esi]
mov	eax, [esi+6]
mov	es:[edi], eax
mov	eax, [esi+0Ah]
mov	es:[edi+4], eax
mov	ax, [esi]
mov	es:[edi+8], ax
mov	ax, [esi+4]
mov	cx, [esi+2]
mov	si, seg	seg001
mov	di, 1DBFh
jmp	large [dword ptr cs:byte_10090+1Ah]
inc	dword ptr cs:loc_102FF+1
mov	esp, ebp
mov	eax, dword ptr cs:loc_10303+1
add	dword ptr cs:loc_10308+4, eax
popad
pop	fs
pop	gs
iret
db 0, 3, 7, 25h, 1, 3, 0FFh, 24h, 2, 3,	0FFh
db 24h,	2 dup(0), 0EEh,	1Fh, 1,	0, 3Bh,	20h
db 2, 0, 78h, 20h, 3, 0, 0E4h, 20h, 6, 0
db 0EAh, 20h, 7, 0, 0FFh, 20h, 8, 0, 14h
db 21h,	9, 0, 3Ch, 21h,	0Ah, 0,	5Bh, 21h
db 0Bh,	0, 8Bh,	21h, 0Ch, 0, 0A1h, 21h,	0Eh
db 0, 0C5h, 21h, 0Fh, 0, 0CAh, 21h, 0, 1
db 0F0h, 21h, 2	dup(1),	2Eh, 22h, 2, 1,	3Eh
db 22h,	0, 2, 0B0h, 22h, 1, 2, 0C7h, 22h
db 2 dup(2), 0EAh, 22h,	3, 2, 1Dh, 23h,	4
db 2, 4Dh, 23h,	5, 2, 0A5h, 23h, 2 dup(3)
db 6Dh,	26h, 4,	3, 0B4h, 26h, 5, 3, 0EDh
db 26h,	6, 3, 7, 27h, 0, 4, 21h, 27h, 0
db 5, 15h, 29h,	1, 5, 7Dh, 29h,	2, 5, 0B7h
db 29h,	3, 5, 0D3h, 29h, 0Ah, 5, 97h, 2Ah
db 0, 6, 0A0h, 2Ch, 1, 6, 0A0h,	2Ch, 2,	6
db 0A0h, 2Ch, 3, 6, 0A0h, 2Ch, 4, 6, 0A3h
db 2Ch,	2, 7, 0A0h, 2Ch, 3, 7, 0A0h, 2Ch
db 0, 8, 0ABh, 2Ch, 1, 8, 0DFh,	2Dh, 0,	9
db 0C9h, 24h, 1, 9, 0DBh, 24h, 2, 9, 0EDh
db 24h,	0, 0Ah,	43h, 27h, 0, 0Eh, 49h, 2Eh
db 1, 0Eh, 64h,	2Eh, 0FFh, 0EEh, 79h, 2Eh
db 0FAh, 0FCh, 1Eh, 6, 0Fh, 0A0h, 0Fh, 0A8h
db 66h,	60h, 53h, 2Eh, 8Eh, 1Eh, 2Eh, 0
db 3Bh,	6, 7Eh,	0, 8Bh,	1Eh, 80h, 0, 74h
db 1Fh,	33h, 0DBh, 3Bh,	87h, 0DAh, 1Dh,	74h
db 0Ch,	83h, 0C3h, 4, 81h, 0FBh, 0CCh, 0
db 72h,	0F1h, 5Bh, 0EBh, 14h, 8Bh, 9Fh,	0DCh
db 1Dh,	0A3h, 7Eh, 0, 89h, 1Eh,	80h, 0,	8Eh
db 1Eh,	2Ch, 0,	67h, 87h, 1Ch, 24h, 0C3h
db 0B0h, 1, 0EBh, 2Ah, 0B0h, 10h, 0EBh,	26h
db 0B0h, 11h, 0EBh, 22h, 0B0h, 12h, 0EBh
db 1Eh,	0B0h, 13h, 0EBh, 1Ah, 0B0h, 15h
db 0EBh, 16h, 0B0h, 16h, 0EBh, 12h, 0B0h
db 21h,	0EBh, 0Eh, 0B0h, 22h, 0EBh, 0Ah
db 0B0h, 23h, 0EBh, 6, 0B0h, 24h, 0EBh,	2
db 0B0h, 25h, 0B4h, 80h, 67h, 89h, 44h,	24h
db 1Ch,	0EBh, 11h, 67h,	89h, 5Ch, 24h, 10h
db 0EBh, 5, 67h, 89h, 4Ch, 24h,	18h, 67h
db 89h,	44h, 24h, 1Ch, 66h, 61h, 0Fh, 0A9h
db 0Fh,	0A1h, 7, 1Fh, 67h, 80h,	4Ch, 24h
db 8, 1, 66h, 0CFh, 66h, 67h, 89h, 54h,	24h
db 14h,	0EBh, 1Ah, 67h,	89h, 54h, 24h, 14h
db 0EBh, 13h, 67h, 8Bh,	44h, 24h, 1Ch, 67h
db 89h,	74h, 24h, 4, 67h, 89h, 3Ch, 24h
db 67h,	89h, 5Ch, 24h, 10h, 67h, 89h, 4Ch
db 24h,	18h, 67h, 89h, 44h, 24h, 1Ch, 66h
db 61h,	0Fh, 0A9h, 0Fh,	0A1h, 7, 1Fh, 67h
db 80h,	64h, 24h, 8, 0FEh, 66h,	0CFh, 5Dh
db 2Eh,	3Bh, 1Eh, 34h, 0, 77h, 84h, 66h
db 2Eh,	8Bh, 3Eh, 36h, 0, 66h, 81h, 0E3h
db 0F8h, 0FFh, 2 dup(0), 67h, 0F6h, 44h
db 1Fh,	6, 10h,	0Fh, 84h, 6Dh, 2 dup(0FFh)
db 0E5h, 5Dh, 0F6h, 0C5h, 20h, 0Fh, 85h
db 5Fh,	0FFh, 0F6h, 0C1h, 90h, 0Fh, 84h
db 58h,	0FFh, 0Fh, 8Bh,	54h, 0FFh, 0F6h
db 0C1h, 60h, 0Fh, 85h,	4Dh, 0FFh, 0F6h
db 0C1h, 8, 74h, 0Eh, 0F6h, 0C1h, 2, 0Fh
db 84h,	41h, 0FFh, 0F6h, 0C1h, 4, 0Fh, 85h
db 3Ah,	2 dup(0FFh), 0E5h, 66h,	0Fh, 0B6h
db 0DBh, 8Ah, 0C3h, 8Ah, 0E3h, 25h, 7, 0F8h
db 66h,	0Fh, 0B6h, 0F0h, 3Ah, 26h, 1Dh,	0
db 74h,	0Ch
db 83h,	0C6h, 8, 3Ah, 26h, 1Ch,	0, 74h,	3
db 83h,	0CEh, 0FFh, 0C3h, 85h, 0C9h, 0Fh
db 84h,	10h, 0FFh, 66h,	2Eh, 8Bh, 16h, 36h
db 0, 66h, 2Eh,	0Fh, 0B7h, 6, 34h, 0, 24h
db 0F8h, 8Bh, 0D9h, 67h, 0F6h, 44h, 2, 6
db 10h,	75h, 21h, 4Bh, 75h, 20h, 66h, 8Bh
db 0D8h, 66h, 67h, 0C7h, 4, 1Ah, 4 dup(0)
db 66h,	67h, 0C7h, 44h,	1Ah, 4,	0, 92h,	10h
db 0, 83h, 0C3h, 8, 0E2h, 0E8h,	0E9h, 39h
db 0FFh, 8Bh, 0D9h, 2Dh, 8, 0, 3Dh, 50h
db 0, 73h, 0CDh, 0E9h, 0B5h, 0FEh, 8Ch,	0C8h
db 3Bh,	0C3h, 0Fh, 84h,	0C5h, 0FEh, 8Ch
db 0D0h, 3Bh, 0C3h, 0Fh, 84h, 0BDh, 0FEh
db 0E8h, 2Eh, 0FFh, 66h, 33h, 0C0h, 66h
db 67h,	89h, 4,	1Fh, 66h, 67h, 89h, 44h
db 1Fh,	4, 0B9h, 4, 0, 66h, 67h, 8Dh, 6Ch
db 24h,	20h, 67h, 39h, 5Dh, 0, 75h, 4, 67h
db 89h,	45h, 0,	66h, 83h, 0C5h,	2, 0E2h
db 0F0h, 0E9h, 0F4h, 0FEh, 2Eh,	8Eh, 1Eh
db 2Eh,	0, 0B9h, 10h, 0, 0BEh, 92h, 0, 8Bh
db 4, 85h, 0C0h, 74h, 7, 3Bh, 5Ch, 2, 0Fh
db 84h,	0D7h, 0FEh, 83h, 0C6h, 4, 0E2h,	0EEh
db 0B1h, 10h, 0BEh, 92h, 0, 83h, 3Ch, 0
db 74h,	8, 83h,	0C6h, 4, 0E2h, 0F6h, 0E9h
db 45h,	0FEh, 89h, 5Ch,	2, 66h,	0Fh, 0B7h
db 0FBh, 66h, 0C1h, 0E7h, 4, 0B1h, 1, 33h
db 0C0h, 0CDh, 31h, 0Fh, 82h, 6Fh, 0FEh
db 89h,	4, 8Bh,	0D8h, 33h, 0C9h, 0BAh, 2 dup(0FFh)
db 0B8h, 8, 0, 0CDh, 31h, 8Bh, 0D7h, 66h
db 0C1h, 0EFh, 10h, 8Bh, 0CFh, 0B8h, 7,	0
db 0CDh, 31h, 0B9h, 92h, 0, 0B8h, 9, 0,	0CDh
db 31h,	8Bh, 0C3h, 0E9h, 83h, 0FEh, 0B8h
db 8, 0, 0E9h, 7Dh, 0FEh, 0E8h,	8Fh, 0FEh
db 67h,	8Bh, 54h, 1Fh, 2, 67h, 8Ah, 4Ch
db 1Fh,	4, 67h,	8Ah, 6Ch, 1Fh, 7, 0E9h,	49h
db 0FEh, 0E8h, 7Ah, 0FEh, 67h, 89h, 54h
db 1Fh,	2, 67h,	88h, 4Ch, 1Fh, 4, 67h, 88h
db 6Ch,	1Fh, 7,	0E9h, 58h, 0FEh, 0E8h, 65h
db 0FEh, 83h, 0F9h, 0Fh, 76h, 0Eh, 81h,	0CAh
db 0FFh, 2 dup(0Fh), 0ACh, 0CAh, 0Ch, 0C1h
db 0E9h, 0Ch, 80h, 0C9h, 80h, 67h, 89h,	14h
db 1Fh,	67h, 80h, 64h, 1Fh, 6, 50h, 67h
db 8, 4Ch, 1Fh,	6, 0E9h, 30h, 0FEh, 0E8h
db 3Dh,	0FEh, 0E8h, 5Bh, 0FEh, 80h, 0CDh
db 10h,	80h, 0E5h, 0D0h, 67h, 80h, 64h,	1Fh
db 6, 0Fh, 67h,	8, 6Ch,	1Fh, 6,	67h, 88h
db 4Ch,	1Fh, 5,	0E9h, 11h, 0FEh, 0E8h, 1Eh
db 0FEh, 33h, 0C0h, 0B9h, 1, 0,	0CDh, 31h
db 0Fh,	82h, 87h, 0FDh,	50h, 1Eh, 7, 66h
db 0Fh,	0B7h, 0F8h, 66h, 2Eh, 8Bh, 2 dup(36h)
db 0, 66h, 3, 0FEh, 66h, 3, 0F3h, 66h, 67h
db 0A5h, 66h, 67h, 0ADh, 0B4h, 92h, 66h
db 67h,	0ABh, 58h, 0E9h, 0DCh, 0FDh, 0E8h
db 0EEh, 0FDh, 66h, 67h, 8Dh, 34h, 1Fh,	66h
db 67h,	8Bh, 3Ch, 24h, 66h, 67h, 0A5h, 66h
db 67h,	0A5h, 0E9h, 0CBh, 0FDh,	0E8h, 0D8h
db 0FDh, 66h, 67h, 8Bh,	34h, 24h, 26h, 67h
db 8Bh,	4Eh, 5,	0E8h, 0ECh, 0FDh, 1Eh, 6
db 1Fh,	7, 66h,	3, 0FBh, 66h, 67h, 0A5h
db 66h,	67h, 0ADh, 0Ch,	10h, 67h, 0ABh,	0E9h
db 0A7h, 0FDh, 0B8h, 0Bh, 0, 0EBh, 3, 0B8h
db 0Ch,	0, 85h,	0C9h, 0Fh, 84h,	99h, 0FDh
db 8Bh,	0D1h, 33h, 0C9h, 26h, 67h, 8Bh,	1Fh
db 66h,	83h, 0C7h, 2, 0CDh, 31h, 0Fh, 82h
db 41h,	0FDh, 66h, 83h
db 0C7h, 8, 41h, 4Ah, 75h, 0EAh, 0E9h, 7Ch
db 0FDh, 0B4h, 48h, 0E8h, 85h, 0, 0Fh, 82h
db 26h,	0FDh, 8Bh, 0D0h, 33h, 0C0h, 0B9h
db 1, 0, 0CDh, 31h, 73h, 8, 0B4h, 49h, 0E8h
db 71h,	0, 0E9h, 0E4h, 0FCh, 67h, 89h, 44h
db 24h,	14h, 67h, 89h, 54h, 24h, 1Ch, 8Bh
db 0D8h, 8Bh, 0CAh, 0C1h, 0E2h,	4, 0C1h
db 0E9h, 0Ch, 0B8h, 7, 0, 0CDh,	31h, 0B9h
db 92h,	0, 0B0h, 9, 0CDh, 31h, 0EBh, 1Dh
db 0B4h, 49h, 8Bh, 0F2h, 0E8h, 30h, 0, 0Fh
db 82h,	0F2h, 0FCh, 8Bh, 0DEh, 0E9h, 2 dup(0FDh)
db 0B4h, 4Ah, 8Bh, 0F2h, 0E8h, 20h, 0, 0Fh
db 82h,	0D6h, 0FCh, 8Bh, 0DEh, 66h, 67h
db 0Fh,	0B7h, 54h, 24h,	10h, 66h, 0C1h,	0E2h
db 4, 66h, 4Ah,	66h, 0Fh, 0A4h,	0D1h, 10h
db 0B8h, 8, 0, 0CDh, 31h, 0E9h,	7, 0FDh
db 5Dh,	50h, 53h, 8Bh, 0DAh, 0B8h, 6, 0
db 0CDh, 31h, 5Bh, 58h,	0Fh, 82h, 0B6h,	0FCh
db 0Fh,	0ACh, 0CAh, 4, 55h, 33h, 0C9h, 2 dup(51h)
db 66h,	83h, 0ECh, 0Ah,	52h, 51h, 66h, 60h
db 16h,	7, 66h,	8Bh, 0FCh, 0B3h, 21h, 0B8h
db 0, 3, 0CDh, 31h, 67h, 8Bh, 5Ch, 24h,	10h
db 67h,	8Bh, 44h, 24h, 1Ch, 66h, 67h, 8Dh
db 64h,	24h, 32h, 5Dh, 0Fh, 82h, 84h, 0FCh
db 67h,	0Fh, 0BAh, 64h,	24h, 0ECh, 0, 0FFh
db 0E5h, 66h, 0Fh, 0B6h, 0DBh, 67h, 8Bh
db 14h,	9Dh, 4 dup(0), 67h, 8Bh, 0Ch, 9Dh
db 2, 3	dup(0),	0E9h, 81h, 0FCh, 0Fh, 21h
db 0FDh, 66h, 33h, 0C0h, 0Fh, 23h, 0F8h
db 66h,	0Fh, 0B6h, 0DBh, 67h, 89h, 14h,	9Dh
db 4 dup(0), 67h, 89h, 0Ch, 9Dh, 2, 3 dup(0)
db 0Fh,	23h, 0FDh, 0E9h, 82h, 0FCh, 2Eh
db 8Eh,	1Eh, 2Eh, 0, 80h, 0FBh,	20h, 0Fh
db 83h,	0Eh, 0FCh, 33h,	0C9h, 66h, 33h,	0D2h
db 80h,	0FBh, 10h, 73h,	15h, 66h, 0Fh, 0B6h
db 0DBh, 67h, 8Bh, 0Ch,	0DDh, 9Eh, 1, 2	dup(0)
db 66h,	67h, 8Bh, 14h, 0DDh, 9Ah, 1, 2 dup(0)
db 67h,	8Bh, 44h, 24h, 1Ch, 0E9h, 23h, 0FCh
db 87h,	0D9h, 0E8h, 5Ah, 0FCh, 87h, 0D9h
db 2Eh,	8Eh, 1Eh, 2Eh, 0, 80h, 0FBh, 20h
db 0Fh,	83h, 0D4h, 0FBh, 80h, 0FBh, 10h
db 73h,	15h, 66h, 0Fh, 0B6h, 0DBh, 67h,	89h
db 0Ch,	0DDh, 9Eh, 1, 2	dup(0),	66h, 67h
db 89h,	14h, 0DDh, 9Ah,	1, 2 dup(0), 0E9h
db 1Fh,	0FCh, 2Eh, 8Eh,	1Eh, 2Eh, 0, 0E8h
db 77h,	0FCh, 74h, 1Bh,	66h, 0C1h, 0E3h
db 3, 66h, 3, 1Eh, 3Eh,	0, 8Eh,	1Eh, 2Ch
db 0, 66h, 67h,	8Bh, 53h, 4, 67h, 8Bh, 13h
db 67h,	8Bh, 4Bh, 2, 0EBh, 2Bh,	0Fh, 0A3h
db 36h,	0D6h, 0, 73h, 18h, 0F6h, 0C3h, 0F0h
db 75h,	0D9h, 67h, 8Bh,	0Ch, 0F5h, 1Eh,	1
db 2 dup(0), 66h, 67h, 8Bh, 14h, 0F5h, 1Ah
db 1, 2	dup(0),	0EBh, 0Ch, 0B9h, 8, 0, 66h
db 67h,	8Dh, 14h, 0B5h,	60h, 16h, 2 dup(0)
db 67h,	8Bh, 44h, 24h, 1Ch, 0E9h, 9Bh, 0FBh
db 87h,	0D9h, 0E8h, 0D2h, 0FBh,	87h, 0D9h
db 2Eh,	8Eh, 1Eh, 2Eh, 0, 8Eh, 6, 2Ch, 0
db 66h,	0Fh, 0B7h, 0C9h, 0E8h, 10h, 0FCh
db 74h,	39h, 80h, 0FBh,	1Bh, 0Fh, 84h, 0B0h
db 0, 80h, 0FBh, 1Ch, 0Fh, 84h,	0BEh, 0
db 80h,	0FBh, 23h, 0Fh,	84h, 0CCh, 0, 80h
db 0FBh, 24h, 0Fh, 84h,	0DAh, 0, 66h, 0C1h
db 0E3h, 3, 66h, 3, 1Eh, 3Eh, 0, 26h, 67h
db 89h,	13h, 66h, 0C1h,	0EAh, 10h, 26h,	67h
db 89h,	53h, 6,	26h, 67h, 89h, 4Bh, 2, 0EBh
db 7Bh,	83h, 0F9h, 8
db 75h,	24h, 0Fh, 0B3h,	36h, 0D4h, 0, 0Fh
db 0B3h, 36h, 0D6h, 0, 66h, 67h, 8Bh, 4
db 0B5h, 0DAh, 3 dup(0), 66h, 26h, 67h,	89h
db 4, 9Dh, 4 dup(0), 80h, 0FBh,	10h, 73h
db 0BCh, 0EBh, 52h, 0Fh, 0ABh, 36h, 0D4h
db 0, 0Fh, 0ABh, 36h, 0D6h, 0, 66h, 26h
db 67h,	8Bh, 4,	9Dh, 4 dup(0), 66h, 67h
db 89h,	4, 0B5h, 0DAh, 3 dup(0), 66h, 67h
db 8Dh,	4, 0B5h, 0A0h, 16h, 2 dup(0), 26h
db 67h,	89h, 4,	9Dh, 4 dup(0), 26h, 67h
db 0C7h, 4, 9Dh, 2, 3 dup(0)
dw seg seg001
db 80h,	0FBh, 10h, 0Fh,	83h, 79h, 0FFh,	67h
db 89h,	0Ch, 0F5h, 1Eh,	1, 2 dup(0), 66h
db 67h,	89h, 14h, 0F5h,	1Ah, 1,	2 dup(0)
db 0E9h, 0F7h, 0FAh, 83h, 0F9h,	8, 66h,	0A1h
db 44h,	2, 75h,	4, 66h,	0A1h, 2Ch, 2, 66h
db 26h,	0A3h, 6Ch, 0, 0E9h, 50h, 0FFh, 83h
db 0F9h, 8, 66h, 0A1h, 48h, 2, 75h, 4, 66h
db 0A1h, 30h, 2, 66h, 26h, 0A3h, 70h, 0
db 0E9h, 3Bh, 0FFh, 83h, 0F9h, 8, 66h, 0A1h
db 4Ch,	2, 75h,	4, 66h,	0A1h, 38h, 2, 66h
db 26h,	0A3h, 8Ch, 0, 0E9h, 26h, 0FFh, 83h
db 0F9h, 8, 66h, 0A1h, 50h, 2, 75h, 4, 66h
db 0A1h, 3Ch, 2, 66h, 26h, 0A3h, 90h, 0
db 0E9h, 11h, 0FFh, 66h, 83h, 0C4h, 26h
db 1Fh,	67h, 0Fh, 0BAh,	74h, 24h, 8, 9,	0Fh
db 92h,	0C0h, 0E9h, 99h, 0FAh, 66h, 83h
db 0C4h, 26h, 1Fh, 67h,	0Fh, 0BAh, 6Ch,	24h
db 8, 9, 0Fh, 92h, 0C0h, 0E9h, 87h, 0FAh
db 66h,	83h, 0C4h, 26h,	1Fh, 67h, 0Fh, 0BAh
db 64h,	24h, 8,	9, 0Fh,	92h, 0C0h, 0E9h
db 75h,	0FAh, 66h, 26h,	67h, 8Bh, 6Fh, 2Ah
db 0EBh, 0Dh, 66h, 0Fh,	0B6h, 0DBh, 66h
db 67h,	8Bh, 2Ch, 9Dh, 4 dup(0), 2Eh, 8Eh
db 2 dup(2Eh), 0, 66h, 26h, 67h, 0Fh, 0B7h
db 5Fh,	2Eh, 66h, 26h, 67h, 0Fh, 0B7h, 57h
db 30h,	8Bh, 0C3h, 0Bh,	0C2h, 75h, 1Dh,	2Eh
db 8Bh,	16h, 0B8h, 2, 2Eh, 8Bh,	1Eh, 0B4h
db 2, 2Bh, 0D3h, 2Eh, 3Bh, 16h,	0B6h, 2
db 0Fh,	82h, 0B2h, 0F9h, 65h, 89h, 16h,	0B8h
db 2, 0C1h, 0E3h, 4, 66h, 67h, 8Dh, 3Ch
db 95h,	4 dup(0), 66h, 67h, 8Dh, 3Ch, 0BBh
db 8Ch,	0D0h, 65h, 87h,	6, 0C8h, 2, 50h
db 66h,	67h, 8Dh, 44h, 24h, 0FCh, 66h, 65h
db 87h,	6, 0C4h, 2, 66h, 50h, 66h, 0Fh,	0B7h
db 0C9h, 8Bh, 0C1h, 3, 0C0h, 83h, 0EBh,	2Eh
db 2Bh,	0D8h, 1Eh, 6, 1Fh, 7, 0FDh, 66h
db 83h,	0EFh, 2, 66h, 67h, 8Dh,	74h, 4Ch
db 38h,	0F3h, 36h, 67h,	0A5h, 66h, 67h,	8Bh
db 74h,	24h, 6,	67h, 8Bh, 46h, 20h, 67h
db 80h,	7Ch, 24h, 22h, 1, 74h, 8, 80h, 0E4h
db 0FCh, 67h, 0ABh, 83h, 0EBh, 2, 0FCh,	66h
db 67h,	8Dh, 3Ch, 95h, 4 dup(0), 66h, 67h
db 8Dh,	3Ch, 0BBh, 0B1h, 8, 0F3h, 66h, 67h
db 0A5h, 66h, 83h, 0C6h, 6, 66h, 67h, 0A5h
db 26h,	67h, 0C7h, 47h,	8
dw seg seg001
mov	word ptr es:[edi+6], 25F7h
mov	es:[edi+4], ax
mov	es:[edi], ebp
mov	ax, [esi-6]
mov	cx, [esi-8]
mov	si, seg	seg001
mov	di, 25F0h
jmp	large [dword ptr cs:byte_10090+1Ah]
popad
pop	fs
pop	gs
iret
push	gs
push	fs
push	ds
push	es
pushf
cli
pushad
xor	eax, eax
mov	ax, ss
xor	ebp, ebp
shl	eax, 4
mov	bp, sp
add	ebp, eax
mov	dx, word ptr cs:loc_10327+1
mov	ebx, dword ptr cs:loc_10323+1
mov	ax, 18h
mov	cx, 10h
mov	si, 8
mov	edi, 2631h
jmp	word ptr cs:byte_10090+18h
db 6, 0Fh, 0A9h, 66h, 26h, 8Fh,	6, 0C4h
db 2, 26h, 8Fh,	6, 0C8h, 2, 66h, 8Bh, 0F5h
db 66h,	67h, 8Bh, 3Ch, 24h, 67h, 8Eh, 44h
db 2 dup(24h), 66h, 0B9h, 15h, 3 dup(0)
db 0FCh, 0F3h, 67h, 0A5h, 66h, 26h, 67h
db 83h,	7Fh, 4,	0, 0Fh,	85h, 0Bh, 0F9h,	2Eh
db 0A1h, 0B4h, 2, 65h, 1, 6, 0B8h, 2, 0E9h
db 0FFh, 0F8h, 2Eh, 8Ah, 1Eh, 3, 0, 84h
db 0DBh, 0Fh, 2	dup(84h), 0F8h,	66h, 2Eh
db 8Bh,	16h, 0CCh, 2, 66h, 8Bh,	0CAh, 67h
db 83h,	7Ah, 3,	0, 74h,	0Bh, 66h, 83h, 0C2h
db 19h,	0FEh, 0CBh, 75h, 0F1h, 0E9h, 69h
db 0F8h, 67h, 8Bh, 5Ch,	24h, 26h, 67h, 89h
db 5Ah,	3, 66h,	67h, 89h, 72h, 7, 67h, 8Ch
db 42h,	0Ch, 66h, 67h, 89h, 7Ah, 10h, 66h
db 2Bh,	0D1h, 66h, 0C1h, 0E9h, 4, 0E9h,	94h
db 0F8h, 2Eh, 3Bh, 0Eh,	0D0h, 2, 0Fh, 85h
db 53h,	0F8h, 66h, 0Fh,	0B7h, 0DAh, 33h
db 0C0h, 92h, 0B9h, 19h, 0, 0F7h, 0F1h,	85h
db 0D2h, 0Fh, 85h, 41h,	0F8h, 84h, 0E4h
db 0Fh,	85h, 3Bh, 0F8h,	2Eh, 3Ah, 6, 3,	0
db 0Fh,	83h, 32h, 0F8h,	66h, 2Eh, 3, 1Eh
db 0CCh, 2, 67h, 0C7h, 43h, 3, 2 dup(0)
db 0E9h, 7Fh, 0F8h, 66h, 83h, 0C4h, 26h
db 1Fh,	33h, 0C0h, 2Eh,	8Bh, 1Eh, 16h, 0
db 0B9h, 5Dh, 12h, 8Ch,	0CEh, 66h, 0BFh
db 5Ch,	12h, 2 dup(0), 0E9h, 6Dh, 0F8h,	66h
db 83h,	0C4h, 26h, 1Fh,	8Ch, 0CEh, 66h,	2Eh
db 8Bh,	3Eh, 4Ah, 0, 2Eh, 8Bh, 1Eh, 16h
db 0, 2Eh, 8Bh,	0Eh, 48h, 0, 0E9h, 53h,	0F8h
db 66h,	83h, 0C4h, 26h,	1Fh, 0B8h, 5Ah,	0
db 0BBh, 3, 0, 2Eh, 80h, 3Eh, 1Ah, 0, 2
db 75h,	2, 0B3h, 1, 2Eh, 8Ah, 0Eh, 18h,	0
db 2Eh,	8Bh, 16h, 1Ch, 0, 0E9h,	31h, 0F8h
db 66h,	83h, 0C4h, 26h,	1Fh, 6,	66h, 57h
db 66h,	51h, 66h, 56h, 0Eh, 7, 66h, 0B9h
db 0Fh,	3 dup(0), 66h, 0BFh, 0CFh, 27h,	2 dup(0)
db 66h,	56h, 0F3h, 67h,	0A6h, 66h, 5Eh,	66h
db 0BFh, 0F6h, 27h, 2 dup(0), 74h, 26h,	2Eh
db 0F6h, 6, 2 dup(0), 80h, 75h,	4Eh, 0B1h
db 10h,	66h, 0BFh, 0DEh, 27h, 2	dup(0),	0F3h
db 67h,	0A6h, 75h, 41h,	66h, 0BFh, 0EEh
db 27h,	2 dup(0), 66h, 5Eh, 66h, 59h, 66h
db 83h,	0C4h, 6, 0E9h, 0E2h, 0F7h, 66h,	83h
db 0C4h, 0Eh, 66h, 33h,	0C0h, 66h, 8Bh,	0D8h
db 66h,	8Bh, 0C8h, 66h,	8Bh, 0D0h, 2Eh,	0A1h
db 14h,	0, 2Eh,	8Ah, 1Eh, 2 dup(0), 2Eh
db 8Ah,	3Eh, 1Ah, 0, 2Eh, 8Ah, 0Eh, 18h
db 0, 2Eh, 8Ah,	2Eh, 19h, 0, 2Eh, 8Bh, 16h
db 1Ch,	0, 0E9h, 0B2h, 0F7h, 66h, 5Eh, 66h
db 59h,	66h, 5Fh, 7, 0B8h, 1, 80h, 0E9h
db 69h,	0F7h, 53h, 55h,	4Eh, 53h, 59h, 53h
db 20h,	44h, 4Fh, 53h, 2Fh, 33h, 32h, 41h
db 0, 52h, 41h,	54h, 49h, 4Fh, 4Eh, 41h
db 4Ch,	20h, 44h, 4Fh, 53h, 2Fh, 34h, 47h
db 0, 0B8h, 0, 85h, 2Eh, 0FFh, 2Eh, 10h
db 0, 84h, 0C0h, 74h, 33h, 3Ch,	1, 74h,	4Fh
db 3Ch,	2, 74h,	6Ch, 3Ch, 3, 74h, 7Ah, 3Ch
db 4, 0Fh, 84h,	8Bh, 0,	3Ch, 5,	0Fh, 84h
db 0A6h, 0, 3Ch, 6, 0Fh, 84h, 0BDh, 0, 3Ch
db 7, 0Fh, 84h,	0CEh, 0, 3Ch, 8, 0Fh, 84h
db 0D4h, 0, 3Ch, 9, 0Fh, 84h, 0DFh, 0, 0F9h
db 66h,	0CBh, 0BBh, 18h, 0, 66h, 2Eh, 0Fh
db 0B7h, 0Eh, 34h, 0, 66h, 2Eh,	0Fh, 0B7h
db 16h,	3Ch, 0,	66h
db 2Eh,	8Bh, 2 dup(36h), 0, 66h, 2Eh, 8Bh
db 2 dup(3Eh), 0, 0E9h,	0C5h, 0, 0BBh, 18h
db 0, 66h, 2Eh,	0Fh, 0B6h, 0Eh,	1Bh, 0,	66h
db 2Eh,	0Fh, 0B6h, 16h,	2, 0, 66h, 2Eh,	8Bh
db 36h,	68h, 2,	66h, 2Eh, 8Bh, 3Eh, 74h
db 2, 41h, 0E9h, 0A4h, 0, 0BBh,	10h, 0,	66h
db 0BEh, 0D4h, 3 dup(0), 66h, 0BFh, 0DAh
db 3 dup(0), 0E9h, 92h,	0, 0BBh, 18h, 0
db 66h,	2Eh, 8Bh, 0Eh, 88h, 0, 66h, 2Eh
db 8Bh,	16h, 84h, 0, 66h, 2Eh, 8Bh, 36h
db 8Ch,	0, 0EBh, 7Bh, 0BBh, 18h, 0, 66h
db 2Eh,	0Fh, 0B7h, 0Eh,	0B4h, 2, 66h, 2Eh
db 0Fh,	0B7h, 16h, 0B8h, 2, 66h, 2Eh, 0Fh
db 0B7h, 36h, 0B6h, 2, 66h, 2Eh, 0Fh, 0B7h
db 3Eh,	0BAh, 2, 0EBh, 5Ah, 0BBh, 18h, 0
db 66h,	2Eh, 8Bh, 0Eh, 0A4h, 2,	66h, 2Eh
db 8Bh,	16h, 0ACh, 2, 66h, 2Eh,	8Bh, 36h
db 0A8h, 2, 66h, 2Eh, 8Bh, 3Eh,	0B0h, 2
db 0EBh, 3Dh, 0BBh, 8, 0, 0B9h,	10h, 0,	0BAh
db 18h,	0, 66h,	2Eh, 0Fh, 0B7h,	36h, 16h
db 0, 2Eh, 8Bh,	3Eh, 12h, 0, 0EBh, 26h,	2Eh
db 8Bh,	0Eh, 12h, 0, 2Eh, 8Bh, 16h, 10h
db 0, 0EBh, 1Ah, 1Eh, 2Eh, 8Eh,	1Eh, 2Eh
db 0, 89h, 0Eh,	12h, 0,	89h, 16h, 10h, 0
db 1Fh,	0EBh, 9, 0B9h, 10h, 0, 66h, 0BAh
db 84h,	2, 2 dup(0), 0F8h, 66h,	0CBh, 66h
db 83h,	0C8h, 0FFh, 66h, 0B9h, 0Ch, 3 dup(0)
db 66h,	57h, 0F3h, 66h,	67h, 0ABh, 66h,	5Fh
db 66h,	2Eh, 0A1h, 84h,	0, 66h,	2Eh, 0Bh
db 6, 88h, 0, 74h, 6, 0E8h, 0A9h, 1, 0E8h
db 50h,	2, 66h,	8Bh, 0D8h, 66h,	8Bh, 0D0h
db 66h,	2Eh, 0A1h, 88h,	0, 66h,	0C1h, 0E8h
db 0Ch,	66h, 0C1h, 0EBh, 0Ch, 66h, 0C1h
db 0E9h, 0Ch, 6, 1Fh, 66h, 67h,	89h, 17h
db 66h,	67h, 89h, 5Fh, 4, 66h, 67h, 89h
db 5Fh,	8, 66h,	67h, 89h, 47h, 0Ch, 66h
db 67h,	89h, 5Fh, 10h, 66h, 67h, 89h, 4Fh
db 14h,	66h, 67h, 89h, 47h, 18h, 66h, 67h
db 89h,	4Fh, 1Ch, 0E9h,	0EFh, 0F5h, 0E8h
db 4Ah,	1, 0E8h, 0E7h, 1, 66h, 81h, 0C3h
db 0, 10h, 2 dup(0), 0E8h, 53h,	1, 66h,	2Eh
db 8Bh,	36h, 84h, 0, 66h, 67h, 8Bh, 46h
db 4, 66h, 0Fh,	0BAh, 0F0h, 1Fh, 72h, 7
db 66h,	3Bh, 0C3h, 0Fh,	83h, 16h, 2, 66h
db 67h,	8Dh, 74h, 6, 10h, 66h, 2Eh, 3Bh
db 36h,	8Ch, 0,	72h, 0DFh, 0E9h, 41h, 0F5h
db 66h,	0C1h, 0E6h, 10h, 8Bh, 0F7h, 0E8h
db 0Ah,	1, 0E8h, 1Dh, 1, 0E8h, 7Bh, 1, 66h
db 67h,	0Fh, 0BAh, 76h,	4, 1Fh,	0E8h, 4Ah
db 2, 0E9h, 99h, 0F5h, 66h, 0C1h, 0E6h,	10h
db 8Bh,	0F7h, 0E8h, 0EEh, 0, 0E8h, 8Bh,	1
db 66h,	81h, 0C3h, 0, 10h, 2 dup(0), 0E8h
db 0F7h, 0, 0E8h, 55h, 1, 66h, 67h, 8Bh
db 46h,	4, 66h,	0Fh, 0BAh, 0F0h, 1Fh, 0Fh
db 83h,	12h, 0F5h, 66h,	3Bh, 0C3h, 0Fh,	83h
db 0BBh, 1, 66h, 67h, 89h, 46h,	4, 66h,	67h
db 8Dh,	7Ch, 6,	10h, 66h, 2Eh, 3Bh, 3Eh
db 8Ch,	0, 73h,	22h, 66h, 67h, 8Bh, 57h
db 4, 66h, 0Fh,	0BAh, 0F2h, 1Fh, 72h, 16h
db 66h,	67h, 8Dh, 54h, 2 dup(10h), 66h,	3Bh
db 0D3h, 72h, 0Bh, 66h,	8Bh, 0C2h, 66h,	67h
db 89h,	46h, 4,	0E9h, 86h, 1, 66h, 2Eh,	8Bh
db 3Eh,	84h, 0,	66h, 67h, 8Bh, 57h, 4, 66h
db 0Fh,	0BAh, 0F2h, 1Fh, 72h, 5, 66h, 3Bh
db 0D3h
db 73h,	1Bh, 66h, 67h, 8Dh, 7Ch, 17h, 10h
db 66h,	2Eh, 3Bh, 3Eh, 8Ch, 0, 72h, 0E1h
db 66h,	0Fh, 0BAh, 0E8h, 1Fh, 66h, 67h,	89h
db 46h,	4, 0E9h, 90h, 0F4h, 66h, 56h, 66h
db 57h,	66h, 8Bh, 0C8h,	66h, 0C1h, 0E9h
db 2, 66h, 83h,	0C6h, 10h, 66h,	83h, 0C7h
db 10h,	0F3h, 66h, 67h,	0A5h, 8Ah, 0C8h
db 80h,	0E1h, 3, 0F3h, 67h, 0A4h, 66h, 5Fh
db 66h,	5Eh, 0E8h, 8Ch,	1, 66h,	8Bh, 0F7h
db 66h,	8Bh, 0C2h, 0E9h, 25h, 1, 66h, 0C1h
db 0E6h, 10h, 8Bh, 0F7h, 0E8h, 2Ah, 0, 0E8h
db 3Dh,	0, 0E8h, 9Bh, 0, 66h, 67h, 8Bh,	5Eh
db 4, 66h, 0Fh,	0BAh, 0F3h, 1Fh, 0Fh, 83h
db 58h,	0F4h, 66h, 83h,	0C6h, 10h, 66h,	87h
db 0DEh, 8Bh, 0CBh, 66h, 0C1h, 0EBh, 10h
db 8Bh,	0FEh, 66h, 0C1h, 0EEh, 10h, 0E9h
db 85h,	0F4h, 5Dh, 66h,	50h, 66h, 2Eh, 0A1h
db 84h,	0, 66h,	2Eh, 0Bh, 6, 88h, 0, 66h
db 58h,	0Fh, 84h, 1Ah, 0F4h, 0FFh, 0E5h
db 66h,	50h, 66h, 56h, 66h, 2Eh, 8Bh, 36h
db 84h,	0, 0F7h, 0C6h, 0Fh, 0, 75h, 3Ah
db 66h,	0B8h, 78h, 56h,	34h, 12h, 66h, 67h
db 3Bh,	6, 75h,	2Eh, 66h, 67h, 3Bh, 46h
db 0Ch,	75h, 27h, 66h, 67h, 8Bh, 46h, 4
db 66h,	0Fh, 0BAh, 0F0h, 1Fh, 66h, 67h,	8Dh
db 74h,	6, 10h,	66h, 2Eh, 3Bh, 36h, 84h
db 0, 72h, 0Fh,	66h, 2Eh, 3Bh, 36h, 8Ch
db 0, 77h, 7, 72h, 0C5h, 66h, 5Eh, 66h,	58h
db 0C3h, 2Eh, 8Eh, 1Eh,	2Eh, 0,	66h, 33h
db 0C0h, 66h, 0A3h, 84h, 0, 66h, 0A3h, 88h
db 0, 0B8h, 0, 84h, 0FFh, 2Eh, 10h, 0, 5Dh
db 66h,	2Eh, 3Bh, 36h, 84h, 0, 72h, 1Dh
db 66h,	2Eh, 3Bh, 36h, 8Ch, 0, 77h, 15h
db 66h,	0B8h, 78h, 56h,	34h, 12h, 66h, 67h
db 3Bh,	6, 75h,	9, 66h,	67h, 3Bh, 46h, 0Ch
db 75h,	2, 0FFh, 0E5h, 0E9h, 0A2h, 0F3h
db 5Dh,	66h, 0C1h, 0E3h, 10h, 8Bh, 0D9h
db 66h,	85h, 0DBh, 0Fh,	84h, 8Ch, 0F3h,	66h
db 83h,	0C3h, 0Fh, 80h,	0E3h, 0F0h, 66h
db 0Fh,	0BAh, 0E3h, 1Fh, 0Fh, 82h, 7Ch,	0F3h
db 0FFh, 0E5h, 66h, 33h, 0C0h, 66h, 33h
db 0C9h, 66h, 2Eh, 8Bh,	36h, 84h, 0, 66h
db 67h,	8Bh, 56h, 4, 66h, 0Fh, 0BAh, 0F2h
db 1Fh,	72h, 0Bh, 66h, 3, 0CAh,	66h, 3Bh
db 0C2h, 77h, 3, 66h, 8Bh, 0C2h, 66h, 67h
db 8Dh,	74h, 16h, 10h, 66h, 2Eh, 3Bh, 36h
db 8Ch,	0, 72h,	0DBh, 0C3h, 66h, 0B9h, 78h
db 56h,	34h, 12h, 66h, 2Eh, 0Fh, 0B7h, 16h
db 60h,	2, 66h,	2Bh, 0C3h, 66h,	83h, 0E8h
db 10h,	72h, 19h, 66h, 67h, 8Dh, 7Ch, 1Eh
db 10h,	66h, 67h, 89h, 0Fh, 66h, 67h, 89h
db 47h,	4, 66h,	67h, 89h, 57h, 8, 66h, 67h
db 89h,	4Fh, 0Ch, 66h, 0Fh, 0BAh, 0EBh,	1Fh
db 66h,	67h, 89h, 0Eh, 66h, 67h, 89h, 5Eh
db 4, 66h, 67h,	89h, 56h, 8, 66h, 67h, 89h
db 4Eh,	0Ch, 0E8h, 14h,	0, 66h,	67h, 8Dh
db 5Eh,	10h, 8Bh, 0CBh,	66h, 0C1h, 0EBh
db 10h,	8Bh, 0FEh, 66h,	0C1h, 0EEh, 10h
db 0E9h, 35h, 0F3h



sub_12C7A proc near
pushad
mov	edi, dword ptr cs:sub_100E4
mov	ebp, dword ptr cs:loc_100EB+1
mov	eax, [edi+4]
btr	eax, 1Fh
lea	esi, [edi+eax+10h]
cmp	esi, ebp
jnb	short loc_12CFD
mov	esi, edi

loc_12CA0:
mov	eax, [esi+4]
btr	eax, 1Fh
jb	short loc_12CF2
xor	ebx, ebx
xor	ecx, ecx
mov	edi, esi
jmp	short loc_12CDD

loc_12CB7:
add	ecx, 10h
mov	eax, [esi+4]
btr	eax, 1Fh
lea	ebx, [eax+ebx]
jnb	short loc_12CDD
sub	ebx, eax
sub	ecx, 10h
add	ebx, ecx
add	[edi+4], ebx
jmp	short loc_12CF2

loc_12CDD:
lea	esi, [esi+eax+10h]
cmp	esi, ebp
jb	short loc_12CB7
add	ebx, ecx
add	[edi+4], ebx
jmp	short loc_12CFD

loc_12CF2:
lea	esi, [esi+eax+10h]
cmp	esi, ebp
jb	short loc_12CA0

loc_12CFD:
popad
retn
sub_12C7A endp

db 0E9h, 0C9h, 0F2h, 33h, 0DBh,	0B9h, 0
db 10h,	0E9h, 0B2h, 0F2h, 66h, 0C1h, 0E3h
db 10h,	66h, 0C1h, 0E6h, 10h, 8Bh, 0D9h
db 8Bh,	0F7h, 66h, 81h,	0FBh, 2	dup(0),	10h
db 0, 0Fh, 82h,	42h, 0F2h, 66h,	85h, 0F6h
db 0Fh,	84h, 3Bh, 0F2h,	2Eh, 80h, 3Eh, 1Ah
db 0, 2, 74h, 3, 0E9h, 98h, 0F2h, 2Eh, 80h
db 3Eh,	2, 2 dup(0), 0Fh, 84h, 16h, 0F2h
db 1Eh,	7, 66h,	2Eh, 8Bh, 3Eh, 74h, 2, 66h
db 8Bh,	0C3h, 66h, 67h,	8Dh, 8Eh, 0FFh,	0Fh
db 2 dup(0), 25h, 0, 0F0h, 66h,	0C1h, 0E9h
db 0Ch,	66h, 8Bh, 0D7h,	66h, 2Eh, 3Bh, 3Eh
db 78h,	2, 73h,	2Dh, 66h, 67h, 8Bh, 2Fh
db 81h,	0E5h, 0, 0F0h, 66h, 3Bh, 0C5h, 74h
db 6, 66h, 83h,	0C7h, 4, 0EBh, 0D0h, 66h
db 83h,	0C7h, 4, 66h, 5, 0, 10h, 2 dup(0)
db 66h,	49h, 75h, 0D7h,	66h, 8Bh, 0C3h,	25h
db 0, 0F0h, 66h, 2Bh, 0D8h, 0E9h, 7Fh, 0
db 66h,	2Eh, 8Bh, 3Eh, 74h, 2, 66h, 2Eh
db 8Bh,	0Eh, 78h, 2, 66h, 2Bh, 0CFh, 66h
db 0C1h, 0E9h, 2, 66h, 8Bh, 0C3h, 25h, 0
db 0F0h, 66h, 67h, 8Dh,	0ACh, 33h, 0FFh
db 0Fh,	2 dup(0), 66h, 2Bh, 0E8h, 66h, 0C1h
db 0EDh, 0Ch, 66h, 85h,	0C9h, 0Fh, 84h,	0A4h
db 0F1h, 66h, 33h, 0C0h, 0F2h, 66h, 67h
db 0AFh, 66h, 67h, 8Dh,	57h, 0FCh, 0F3h
db 66h,	67h, 0AFh, 66h,	8Bh, 0C7h, 66h,	2Bh
db 0C2h, 66h, 0C1h, 0E8h, 2, 66h, 3Bh, 0C5h
db 72h,	0DAh, 66h, 8Bh,	0C3h, 25h, 0, 0F0h
db 66h,	2Bh, 0D8h, 66h,	8Bh, 0FAh, 66h,	8Bh
db 0CDh, 0B0h, 7, 2Eh, 80h, 3Eh, 18h, 0
db 3, 76h, 2, 0B0h, 1Fh, 66h, 67h, 0ABh
db 66h,	5, 0, 10h, 2 dup(0), 0E2h, 0F5h
db 67h,	80h, 4Ah, 1, 2,	67h, 80h, 4Fh, 0FDh
db 4, 66h, 2Eh,	2Bh, 16h, 74h, 2, 66h, 0C1h
db 0E2h, 0Ah, 66h, 3, 0D3h, 67h, 89h, 54h
db 24h,	18h, 66h, 0C1h,	0EAh, 10h, 81h,	0CAh
db 0, 80h, 67h,	89h, 54h, 24h, 10h, 66h
db 2Eh,	0A1h, 58h, 0, 0Fh, 22h,	0D8h, 66h
db 33h,	0C0h, 0Fh, 22h,	0D0h, 0E9h, 8Dh
db 0F1h, 2Eh, 80h, 3Eh,	1Ah, 0,	2, 74h,	3
db 0E9h, 82h, 0F1h, 2Eh, 80h, 3Eh, 2, 2	dup(0)
db 0Fh,	84h, 0,	0F1h, 81h, 0E3h, 0FFh, 7Fh
db 66h,	0C1h, 0E3h, 10h, 8Bh, 0D9h, 66h
db 0C1h, 0EBh, 0Ah, 80h, 0E3h, 0FCh, 66h
db 2Eh,	3, 1Eh,	74h, 2,	66h, 2Eh, 3Bh, 1Eh
db 74h,	2, 0Fh,	82h, 0FFh, 0F0h, 66h, 2Eh
db 3Bh,	1Eh, 78h, 2, 0Fh, 83h, 0F5h, 0F0h
db 67h,	0F6h, 43h, 1, 2, 0Fh, 84h, 0ECh
db 0F0h, 66h, 33h, 0C0h, 66h, 67h, 87h,	3
db 66h,	83h, 0C3h, 4, 0F6h, 0C4h, 4, 74h
db 0F0h, 66h, 2Eh, 0A1h, 58h, 0, 0Fh, 22h
db 0D8h, 66h, 33h, 0C0h, 0Fh, 22h, 0D0h
db 0E9h, 23h, 0F1h, 2Eh, 0Fh, 0B6h, 6, 19h
db 0, 0C1h, 0E0h, 4, 0Fh, 1, 0E2h, 80h,	0E2h
db 6, 0D0h, 0EAh, 0Ah, 0C2h, 0C0h, 0E2h
db 2, 0Ah, 0C2h, 0E9h, 3, 0F1h,	2Eh, 8Eh
db 1Eh,	2Eh, 0,	80h, 0E3h, 3, 0D0h, 0E3h
db 0Fh,	1, 0E0h, 0Ah, 0C3h, 0Fh, 1, 0F0h
db 0E9h, 0F3h, 0F0h, 66h, 83h, 0C4h, 26h
db 1Fh,	0Eh, 7,	66h, 0B8h, 41h,	32h, 33h
db 44h,	66h, 0BBh, 88h,	2Eh, 2 dup(0), 2Eh
db 8Ah,	2Eh, 1Ah, 0, 2Eh, 8Ah, 0Eh, 18h
db 0, 2Eh, 8Bh,	16h, 14h, 0, 0E9h, 0D6h
db 0F0h, 87h, 0DBh
seg001 ends


; Segment type:	Pure code
seg002 segment byte public 'CODE' use16
assume cs:seg002
assume es:nothing, ss:nothing, ds:nothing, fs:nothing, gs:nothing



sub_12F00 proc near
push	ds
push	es
mov	ax, seg	seg000

loc_12F05:
mov	dx, seg	seg001
mov	ds:3088h, ax
mov	ds:308Ah, dx
push	ax
push	dx
mov	ax, 0FF87h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
cmp	dx, 4944h
jnz	short loc_12F37
cmp	ax, 3332h
jnz	short loc_12F37
mov	es, cs:word_15F88
assume es:nothing
xor	di, di
mov	cx, 0Ch
rep movsw
mov	ds, cs:word_15F7A
or	word ptr ds:305Eh, 1

loc_12F37:
pop	dx
pop	ax
mov	ds, ax
mov	es, dx
assume es:nothing
xor	si, si
mov	di, 0
lodsw
cmp	ax, 4449h
jnz	short loc_12F6E
lodsw
cmp	ax, 3233h
jnz	short loc_12F6E
mov	cx, 10h
rep movsb
mov	es, cs:word_15F7A
and	word ptr [si], 7FFFh
lodsw
mov	es:3058h, ax
lodsw
mov	es:30A8h, ax
lodsw
mov	es:305Ah, ax
clc
jmp	short loc_12F6F

loc_12F6E:
stc

loc_12F6F:
pop	es
pop	ds
retn
sub_12F00 endp




sub_12F72 proc near
push	ds
push	es
jb	short loc_12FB2
test	byte ptr ds:3059h, 1
jz	short loc_12FB2
mov	es, word ptr ds:3080h
xor	di, di
mov	cx, 0FFFFh
xor	ax, ax

loc_12F88:
push	cx
mov	cx, 7
mov	si, 3222h
repe cmpsb
pop	cx
jz	short loc_12F9D
repne scasb
cmp	al, es:[di]
jnz	short loc_12F88
jmp	short loc_12FB2

loc_12F9D:
call	sub_12FD9
cmp	byte ptr es:[di], 0
jz	short loc_12FB2
call	sub_12FB5
call	sub_12FED
cmp	byte ptr es:[di], 0
jnz	short loc_12F9D

loc_12FB2:
pop	es
pop	ds
retn
sub_12F72 endp




sub_12FB5 proc near

; FUNCTION CHUNK AT 0170 SIZE 0000002F BYTES
; FUNCTION CHUNK AT 3230 SIZE 0000003E BYTES
; FUNCTION CHUNK AT 32D6 SIZE 0000060A BYTES
; FUNCTION CHUNK AT 38E3 SIZE 000004DD BYTES

xor	bx, bx

loc_12FB7:
mov	si, [bx+2F6Eh]
cmp	si, 0FFFFh
jz	short locret_12FCF
mov	cx, [bx+2F70h]
push	di
repe cmpsb
pop	di
jz	short loc_12FD0
add	bx, 6
jmp	short loc_12FB7

locret_12FCF:
retn

loc_12FD0:
add	di, [bx+2F70h]
jmp	cs:word_15E72[bx]
sub_12FB5 endp ; sp-analysis failed




sub_12FD9 proc near
mov	al, es:[di]
test	al, al
jz	short locret_12FEC
cmp	al, 2Fh	; '/'
jz	short loc_12FEB
cmp	al, 20h	; ' '
jnz	short locret_12FEC
inc	di
jmp	short sub_12FD9

loc_12FEB:
inc	di

locret_12FEC:
retn
sub_12FD9 endp




sub_12FED proc near
mov	al, es:[di]
test	al, al
jz	short locret_13000
cmp	al, 2Fh	; '/'
jz	short loc_12FFF
cmp	al, 20h	; ' '
jz	short locret_13000
inc	di
jmp	short sub_12FED

loc_12FFF:
inc	di

locret_13000:
retn
sub_12FED endp




sub_13001 proc near
cmp	byte ptr es:[di], 3Ah ;	':'
jnz	short loc_13008
inc	di

loc_13008:
xor	ax, ax
cmp	byte ptr es:[di], 30h ;	'0'
jz	short loc_13031
inc	ax
cmp	byte ptr es:[di], 31h ;	'1'
jz	short loc_13031
cmp	word ptr es:[di], 4E4Fh
jz	short loc_13030
dec	ax
cmp	word ptr es:[di], 464Fh
jnz	short loc_1302D
cmp	byte ptr es:[di+2], 46h	; 'F'
jz	short loc_1302F

loc_1302D:
stc
retn

loc_1302F:
inc	di

loc_13030:
inc	di

loc_13031:
inc	di
test	al, al
retn
sub_13001 endp




sub_13035 proc near
cmp	byte ptr es:[di], 3Ah ;	':'
jnz	short loc_1303C
inc	di

loc_1303C:
xor	ax, ax
xor	bx, bx
mov	cx, 0Ah
mov	al, es:[di]
sub	al, 30h	; '0'
jb	short loc_1306E
cmp	al, 9
ja	short loc_1306E
xchg	ax, bx
mul	cx
xchg	ax, bx
add	bx, ax

loc_13054:
inc	di
xor	ax, ax
mov	al, es:[di]
sub	al, 30h	; '0'
jb	short loc_1306A
cmp	al, 9
ja	short loc_1306A
xchg	ax, bx
mul	cx
xchg	ax, bx
add	bx, ax
jmp	short loc_13054

loc_1306A:
mov	ax, bx
clc
retn

loc_1306E:
stc
retn
sub_13035 endp

; START	OF FUNCTION CHUNK FOR sub_12FB5

loc_13070:
and	word ptr ds:3058h, 0F7FCh
retn

loc_13077:
call	sub_13001
jb	short locret_1308B
jz	short loc_13085
or	word ptr ds:3058h, 801h
retn

loc_13085:
and	word ptr ds:3058h, 0F7FEh

locret_1308B:
retn

loc_1308C:
call	sub_13001
jb	short locret_1309E
jz	short loc_13099
or	byte ptr ds:3058h, 2
retn

loc_13099:
and	byte ptr ds:3058h, 0FDh

locret_1309E:
retn
; END OF FUNCTION CHUNK	FOR sub_12FB5
call	sub_13035
jb	short locret_130CE
push	ds
mov	ds, word ptr ds:308Ah
push	ax
mov	bx, 400h
mul	bx
mov	ds:0Ch,	ax
mov	ds:0Eh,	dx
pop	ax
add	ax, 0FFFh
and	ax, 0F000h
xor	dx, dx
mov	bx, 1000h
div	bx
test	al, al
jnz	short loc_130CA
inc	al

loc_130CA:
mov	ds:1, al
pop	ds

locret_130CE:
retn
call	sub_13035
cmp	ax, 1
jb	short locret_130EA
cmp	ax, 40h	; '@'
ja	short locret_130EA
jnz	short loc_130E3
mov	ax, 0FFFh
jmp	short loc_130E7

loc_130E3:
mov	cl, 6
shl	ax, cl

loc_130E7:
mov	ds:30A8h, ax

locret_130EA:
retn
call	sub_13001
retn
call	sub_13001
jb	short locret_13101
jz	short loc_130FC
or	byte ptr ds:3058h, 4
retn

loc_130FC:
and	byte ptr ds:3058h, 0FBh

locret_13101:
retn
call	sub_13001
jb	short loc_13109
jz	short loc_1310F

loc_13109:
or	byte ptr ds:3058h, 80h
retn

loc_1310F:
and	byte ptr ds:3058h, 7Fh
retn
call	sub_13001
jb	short loc_1311C
jz	short loc_13122

loc_1311C:
or	byte ptr ds:3059h, 10h
retn

loc_13122:
and	byte ptr ds:3059h, 0EFh
retn

loc_13128:
call	sub_13035
sub	ax, 2328h
jb	short locret_13147
cmp	al, 6
ja	short locret_13147
add	ax, ax
mov	bx, ax
mov	word ptr [bx+302Ah], 0
cmp	byte ptr es:[di], 2Ch ;	','
jnz	short locret_13147
inc	di
jmp	short loc_13128

locret_13147:
retn
and	byte ptr ds:3059h, 0F7h
retn
; START	OF FUNCTION CHUNK FOR sub_156F5

loc_1314E:
mov	ax, cs:word_15F64
; END OF FUNCTION CHUNK	FOR sub_156F5



sub_13152 proc near

; FUNCTION CHUNK AT 0488 SIZE 00000039 BYTES

push	bx
push	ds
cmp	cs:word_15F8E, 0
jnz	short loc_13163
mov	ds, cs:word_15F7A
jmp	short loc_13168

loc_13163:
mov	ds, cs:word_15F8E

loc_13168:
xor	bx, bx

loc_1316A:
cmp	ah, [bx+2FB2h]
jz	short loc_1317A
cmp	byte ptr [bx], 0FFh
jz	short loc_131C4
add	bx, 4
jmp	short loc_1316A

loc_1317A:
cmp	byte ptr [bx+2FB3h], 1
jnz	short loc_13188
test	byte ptr ds:3058h, 1
jz	short loc_131C4

loc_13188:
push	ax
push	cx
push	dx
push	bx
mov	bl, [bx+2FB3h]
mov	bh, 0
mov	cx, bx
add	bx, bx
mov	dx, [bx+2FD4h]
pop	bx
push	di
push	si
mov	si, [bx+2FB4h]
mov	bl, al
mov	bh, 0
add	bx, bx
mov	di, [bx+si]
test	di, di
jz	short loc_131BA
push	ax
call	sub_13221
pop	ax
mov	dx, di
call	sub_13221
call	sub_13218

loc_131BA:
pop	si
pop	di
cmp	cl, 1
jnz	short loc_131C7
pop	dx
pop	cx
pop	ax

loc_131C4:
pop	ds
pop	bx
retn

loc_131C7:
mov	al, 0FFh
cmp	word ptr ds:308Ch, 0
jnz	short loc_131D3
jmp	loc_13388

loc_131D3:
jmp	loc_133A6
sub_13152 endp




sub_131D6 proc near
test	byte ptr ds:3059h, 8
jz	short locret_13209
mov	ax, ds:305Ah
mov	bx, 3188h
mov	si, 3167h
push	ax
mov	al, ah
aam
add	al, 30h	; '0'
mov	[bx], al
pop	ax
aam
add	ax, 3030h
mov	[bx+2],	ah
mov	[bx+4],	al
mov	cx, 74h	; 't'

loc_131FE:
lodsb
push	cx
xor	bx, bx
mov	ah, 0Eh
int	10h		; - VIDEO - WRITE CHARACTER AND	ADVANCE	CURSOR (TTY WRITE)
			; AL = character, BH = display page (alpha modes)
			; BL = foreground color	(graphics modes)
pop	cx
loop	loc_131FE

locret_13209:
retn
sub_131D6 endp

align 4
or	ax, 0Ah



sub_1320F proc near
push	dx
mov	ds:30Ah, al
mov	dx, 30Ah
jmp	short loc_1321C
sub_1320F endp




sub_13218 proc near
push	dx
mov	dx, 30Ch

loc_1321C:
call	sub_13221
pop	dx
retn
sub_13218 endp




sub_13221 proc near
push	ax
push	bx
push	cx
push	dx
push	si
push	di
push	bp
push	ds
push	es
push	ss
pop	es
mov	bp, sp
sub	sp, 100h
add	bp, 14h
mov	si, dx
mov	di, sp
push	di

loc_1323A:
lodsb
cmp	al, 25h	; '%'
jz	short loc_1325C
cmp	al, 24h	; '$'
jnz	short loc_13245
mov	al, 3Fh	; '?'

loc_13245:
stosb
test	al, al
jnz	short loc_1323A
pop	di
call	sub_13326
add	sp, 100h
pop	es
pop	ds
pop	bp
pop	di
pop	si
pop	dx
pop	cx
pop	bx
pop	ax
retn

loc_1325C:
lodsb
cmp	al, 25h	; '%'
jz	short loc_13245
cmp	al, 63h	; 'c'
jz	short loc_1327B
cmp	al, 73h	; 's'
jz	short loc_13283
cmp	al, 62h	; 'b'
jz	short loc_13299
cmp	al, 77h	; 'w'
jz	short loc_132A7
cmp	al, 6Ch	; 'l'
jz	short loc_132B5
cmp	al, 64h	; 'd'
jz	short loc_132CD
jmp	short loc_13245

loc_1327B:
mov	al, [bp+0]
add	bp, 2
jmp	short loc_13245

loc_13283:
mov	bx, [bp+0]
add	bp, 2

loc_13289:
mov	al, [bx]
inc	bx
test	al, al
jz	short loc_1323A
cmp	al, 24h	; '$'
jnz	short loc_13296
mov	al, 3Fh	; '?'

loc_13296:
stosb
jmp	short loc_13289

loc_13299:
mov	ah, [bp+0]
add	bp, 2
mov	cx, 2
call	sub_132DB
jmp	short loc_1323A

loc_132A7:
mov	ax, [bp+0]
add	bp, 2
mov	cx, 4
call	sub_132DB
jmp	short loc_1323A

loc_132B5:
mov	ax, [bp+2]
mov	cx, 4
call	sub_132DB
mov	ax, [bp+0]
add	bp, 4
mov	cx, 4
call	sub_132DB
jmp	loc_1323A

loc_132CD:
mov	ax, [bp+0]
add	bp, 2
xor	cx, cx
call	sub_132F9
jmp	loc_1323A
sub_13221 endp




sub_132DB proc near
rol	ax, 1
rol	ax, 1
rol	ax, 1
rol	ax, 1
mov	bl, al
and	bl, 0Fh
add	bl, 30h	; '0'
cmp	bl, 39h	; '9'
jbe	short loc_132F3
add	bl, 7

loc_132F3:
xchg	ax, bx
stosb
xchg	ax, bx
loop	sub_132DB
retn
sub_132DB endp




sub_132F9 proc near
mov	bx, 2710h
call	sub_13313
mov	bx, 3E8h
call	sub_13313
mov	bx, 64h	; 'd'
call	sub_13313
mov	bx, 0Ah
call	sub_13313
jmp	short loc_13320
sub_132F9 endp




sub_13313 proc near
xor	dx, dx
div	bx
test	ax, ax
jz	short loc_1331C
inc	cx

loc_1331C:
test	cx, cx
jz	short loc_13323

loc_13320:
add	al, 30h	; '0'
stosb

loc_13323:
mov	ax, dx
retn
sub_13313 endp




sub_13326 proc near
xor	al, al
mov	dx, di
mov	cx, 0FFFFh
repne scasb
dec	di
push	es
pop	ds
mov	ax, 924h
mov	[di], al
cmp	cs:word_15F8C, 0
jnz	short loc_13342
int	21h		; DOS -	PRINT STRING
			; DS:DX	-> string terminated by	"$"
retn

loc_13342:
push	ebp
sub	esp, 32h
mov	ebp, esp
mov	[ebp+1Ch], ax
mov	[ebp+14h], dx
mov	ax, cs:word_15F7E
mov	[ebp+24h], ax
call	sub_134DA
add	esp, 32h
pop	ebp
retn
sub_13326 endp

; START	OF FUNCTION CHUNK FOR sub_15924

loc_13365:
mov	si, 2C6Ch
jmp	sub_13152
; END OF FUNCTION CHUNK	FOR sub_15924
; START	OF FUNCTION CHUNK FOR sub_156F5

loc_1336B:
mov	si, 2C6Ch
jmp	loc_1314E
; END OF FUNCTION CHUNK	FOR sub_156F5
mov	si, ax
mov	ax, 8002h
jmp	short loc_1337D
; START	OF FUNCTION CHUNK FOR sub_134DA

loc_13378:
mov	si, ax
mov	ax, 8003h

loc_1337D:
cli
lss	esp, fword ptr cs:byte_15F92
jmp	sub_13152
; END OF FUNCTION CHUNK	FOR sub_134DA
; START	OF FUNCTION CHUNK FOR sub_13152

loc_13388:
cli
cld
mov	ds, cs:word_15F7A
mov	es, word ptr ds:307Ch
mov	ss, word ptr ds:307Eh
mov	sp, 800h
mov	ax, ds:3080h
mov	es:2Ch,	ax
mov	ax, 4CFFh
int	21h		; DOS -	2+ - QUIT WITH EXIT CODE (EXIT)
			; AL = exit code

loc_133A6:
cli
cld
mov	ds, cs:word_15F8E
mov	es, word ptr ds:3090h
lss	esp, ds:3092h
xor	dx, dx
mov	fs, dx
assume fs:nothing
mov	gs, dx
assume gs:nothing
mov	ah, 4Ch
int	21h		; DOS -	2+ - QUIT WITH EXIT CODE (EXIT)
; END OF FUNCTION CHUNK	FOR sub_13152 ;	AL = exit code



sub_133C1 proc near
push	cx
push	si
push	di
push	ds
push	es
xor	si, si
mov	di, 800h
mov	ds, cs:word_15F98
assume ds:nothing
mov	es, word ptr cs:byte_15F92+4
mov	cx, 200h
cld
rep movsw
in	al, 21h		; Interrupt controller,	8259A.
mov	ah, al
in	al, 0A1h	; Interrupt Controller #2, 8259A
pop	es
pop	ds
assume ds:nothing
pop	di
pop	si
pop	cx
mov	ds:3062h, ax
retn
sub_133C1 endp




sub_133EA proc near
test	cs:byte_15F58, 4
jz	short locret_1342A
cmp	byte ptr cs:word_15F5C+1, 3
jz	short loc_13400
xor	eax, eax
mov	dr7, eax

loc_13400:
pushf
cli
push	si
push	di
push	ds
push	es
xor	di, di
mov	si, 800h
mov	es, cs:word_15F98
assume es:nothing
mov	ds, word ptr cs:byte_15F92+4
mov	cx, 200h
cld
rep movsw
mov	ax, cs:word_15F62
out	0A1h, al	; Interrupt Controller #2, 8259A
mov	al, ah
out	21h, al		; Interrupt controller,	8259A.
pop	es
assume es:nothing
pop	ds
pop	di
pop	si
popf

locret_1342A:
retn
sub_133EA endp

test	cs:byte_15F58, 8
jz	short locret_1345D
pushad
push	ds
push	es
xor	bx, bx
mov	ds, word ptr cs:byte_15F92+4
mov	es, cs:word_15F98
assume es:nothing
mov	esi, 800h
xor	edi, edi
cld

loc_1344D:
cmps	dword ptr [esi], dword ptr es:[edi]
jnz	short loc_1345E

loc_13452:
inc	bx
cmp	bx, 100h
jb	short loc_1344D
pop	es
assume es:nothing
pop	ds
popad

locret_1345D:
retn

loc_1345E:
mov	ax, 9003h
push	bx
push	si
mov	si, bx
call	sub_13152
pop	si
pop	bx
jmp	short loc_13452



sub_1346C proc near
push	ax
mov	al, 36h	; '6'
out	43h, al		; Timer	8253-5 (AT: 8254.2).
mov	al, 0
out	40h, al		; Timer	8253-5 (AT: 8254.2).
out	40h, al		; Timer	8253-5 (AT: 8254.2).
pop	ax
retn
sub_1346C endp




sub_13479 proc near
push	ebx
push	ecx
push	edx
push	ebp
mov	ebp, ecx
xor	ax, ax
mov	cx, 1
int	31h		; DPMI Services	  ax=func xxxxh
			; ALLOCATE LDT DESCRS
			; CX = number of descriptors to	allocate
			; Return: CF set on error
			; CF clear if successful, AX = base selector
jb	short loc_134B6
mov	bx, ax
mov	ax, 9
mov	cx, dx
int	31h		; DPMI Services	  ax=func xxxxh
			; SET DESCRIPTOR ACCESS	RIGHTS
			; BX = selector, CL = access rights/type byte
			; CH = 80386 extended rights/type byte (32-bit DPMI implementations only)
			; Return: CF set on error
			; CF clear if successful
jb	short loc_134B6
dec	ax
mov	ecx, ebp
mov	dx, cx
shr	ecx, 10h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET SEGMENT LIMIT
			; BX = selector, CX:DX = segment limit
			; Return: CF set on error
			; CF clear if successful
jb	short loc_134B6
dec	ax
mov	ecx, edi
mov	dx, cx
shr	ecx, 10h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET SEGMENT BASE ADDRESS
			; BX = selector, CX:DX = linear	base address
			; Return: CF set on error
			; CF clear if successful
jb	short loc_134B6
mov	ax, bx

loc_134B6:
pop	ebp
pop	edx
pop	ecx
pop	ebx
retn
sub_13479 endp

db 1Eh,	2Eh, 8Eh, 1Eh, 8Eh, 30h, 81h, 0Eh
db 5Eh,	30h, 0,	1, 1Fh,	66h, 0CFh



sub_134CE proc near
push	bx
mov	bx, 10h
jmp	short loc_134DE
sub_134CE endp

push	bx
mov	bx, 33h	; '3'
jmp	short loc_134DE



sub_134DA proc near

; FUNCTION CHUNK AT 0478 SIZE 00000010 BYTES

push	bx
mov	bx, 21h	; '!'

loc_134DE:
push	cx
push	edi
push	es
xor	eax, eax
mov	[ebp+20h], ax
mov	[ebp+2Eh], eax
xor	cx, cx
push	ss
pop	es
mov	edi, ebp
mov	ax, 300h
int	31h		; DPMI Services	  ax=func xxxxh
			; SIMULATE REAL	MODE INTERRUPT
			; BL=interrupt number
			; CX=number of words to	copy from protected mode to real mode stack
			; ES:DI	/ ES:EDI = selector:offset of real mode	call structure
			; Return: CF set on error
			; CF clear if ok
pop	es
pop	edi
pop	cx
pop	bx
jb	loc_13378
retn
sub_134DA endp




sub_13504 proc near
sub	esp, 32h
mov	ebp, esp
mov	ax, ds:307Eh
add	ax, 10h
mov	ds:3084h, ax
mov	[ebp+24h], ax
add	ax, 8
mov	ds:3086h, ax
mov	ax, ss
mov	ds:30BAh, ax
mov	ds:30C0h, ax
mov	eax, 100h
mov	ds:30BCh, eax
mov	ds:30C2h, eax
mov	byte ptr [ebp+1Dh], 1Ah
mov	word ptr [ebp+14h], 0
call	sub_134DA
add	esp, 32h
retn
sub_13504 endp




sub_13547 proc near
push	ds
mov	ds, word ptr ds:3098h
cmp	dword ptr ds:0CCh, 0
pop	ds
jz	short loc_135A0
mov	ax, 21h	; '!'
int	33h		; - MS MOUSE - SOFTWARE	RESET
			; Return: AX = FFFFh if	mouse driver installed
			; AX = 0021h if	mouse driver not installed
			; BX = 2 if mouse driver is installed
cmp	ax, 21h	; '!'
jnz	short loc_13566
xor	ax, ax
int	33h		; - MS MOUSE - RESET DRIVER AND	READ STATUS
			; Return: AX = status
			; BX = number of buttons
inc	ax
jnz	short loc_135A0

loc_13566:
mov	ax, 15h
int	33h		; - MS MOUSE - RETURN DRIVER STORAGE REQUIREMENTS
			; Return: BX = size of buffer needed to	store driver state
movzx	eax, bx
cmp	eax, ds:30B2h
jnb	short loc_135A0
mov	ds:3068h, eax
push	ds
push	es
push	cs
pop	ds
assume ds:seg002
push	ss
pop	es
mov	esi, 227Fh
mov	edi, 7C0h
mov	ax, 303h
int	31h		; DPMI Services	  ax=func xxxxh
			; ALLOCATE REAL	MODE CALL-BACK ADDRESS
			; DS:SI=selector:offset	of procedure to	call
			; ES:DI=selector:offset	of real	mode call structure
			; Return: CF set on error
			; CF clear if ok, CX:DX	= segment:offset of real mode call address
pop	es
pop	ds
assume ds:nothing
jb	loc_13378
mov	ds:306Ch, dx
mov	ds:306Eh, cx
retn

loc_135A0:
mov	word ptr ds:2159h, 0CF66h
mov	ax, 9004h
jmp	sub_13152
sub_13547 endp




sub_135AC proc near
mov	ax, 205h
mov	cx, cs
mov	bl, 10h
mov	edx, 11A5h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROTECTED	MODE INTERRUPT VECTOR
			; BL = interrupt number, CX:DX / CX:EDX	= selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	locret_1366B
mov	bl, 21h	; '!'
mov	dx, 14BCh
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROTECTED	MODE INTERRUPT VECTOR
			; BL = interrupt number, CX:DX / CX:EDX	= selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	locret_1366B
mov	bl, 23h	; '#'
mov	dx, 5BFh
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROTECTED	MODE INTERRUPT VECTOR
			; BL = interrupt number, CX:DX / CX:EDX	= selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	locret_1366B
mov	bl, 33h	; '3'
mov	dx, 2159h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROTECTED	MODE INTERRUPT VECTOR
			; BL = interrupt number, CX:DX / CX:EDX	= selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	locret_1366B
mov	ax, 203h
mov	bl, 0
mov	dx, 0D1Dh
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
nop
nop
mov	bl, 1
mov	dx, 0D21h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 2
mov	dx, 0D25h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 3
mov	dx, 0D29h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 4
mov	dx, 0D2Dh
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 5
mov	dx, 0D31h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 6
mov	dx, 0D35h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 7
mov	dx, 0D39h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 8
mov	dx, 0D3Dh
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 9
mov	dx, 0D41h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 0Ah
mov	dx, 0D45h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 0Bh
mov	dx, 0D49h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 0Ch
mov	dx, 0D4Dh
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 0Dh
mov	dx, 0D51h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
jb	short locret_1366B
mov	bl, 0Eh
mov	dx, 0D55h
int	31h		; DPMI Services	  ax=func xxxxh
			; SET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh), CX:DX / CX:EDX = selector:offset of handler
			; Return: CF set on error
			; CF clear if successful
clc

locret_1366B:
retn
sub_135AC endp

db 0B8h, 5, 2, 0B3h, 10h, 2Eh, 8Bh, 0Eh
db 0CAh, 30h, 66h, 2Eh,	8Bh, 16h, 0C6h,	30h
db 0CDh, 31h, 0B3h, 21h, 2Eh, 8Bh, 0Eh,	0D2h
db 30h,	66h, 2Eh, 8Bh, 16h, 0CEh, 30h, 0CDh
db 31h,	0B3h, 23h, 2Eh,	8Bh, 0Eh, 0DAh,	30h
db 66h,	2Eh, 8Bh, 16h, 0D6h, 30h, 0CDh,	31h
db 0B3h, 33h, 2Eh, 8Bh,	0Eh, 0E2h, 30h,	66h
db 2Eh,	8Bh, 16h, 0DEh,	30h, 0CDh, 31h,	0B8h
db 3, 2, 66h, 33h, 0DBh, 2Eh, 67h, 8Bh,	0Ch
db 0DDh, 0EAh, 30h, 2 dup(0), 66h, 2Eh,	67h
db 8Bh,	14h, 0DDh, 0E6h, 30h, 2	dup(0),	0CDh
db 31h,	0FEh, 0C3h, 80h, 0FBh, 0Fh, 72h
db 0E4h, 0F8h, 0C3h



sub_136CF proc near
cmp	byte ptr ds:305Dh, 3
jz	short locret_136FE
test	byte ptr ds:3058h, 80h
jz	short locret_136FE
xor	eax, eax
mov	dr6, eax
mov	dr0, eax
add	al, 4
mov	dr1, eax
add	al, 4
mov	dr2, eax
add	al, 4
mov	dr3, eax
mov	eax, 0DDDD03FFh
mov	dr7, eax

locret_136FE:
retn
sub_136CF endp




sub_136FF proc near
xor	edi, edi
or	ecx, 0FFFFFFFFh
mov	ax, cs
lar	dx, ax
mov	dl, 0C0h ; 'À'
xchg	dh, dl
and	dl, 60h
or	dl, 92h
mov	ds:3066h, dx
call	sub_13479
jb	short loc_13730
mov	ds:3098h, ax
mov	ax, 8
mov	bx, ds
mov	cx, 0FFFFh
mov	dx, cx
int	31h		; DPMI Services	  ax=func xxxxh
			; SET SEGMENT LIMIT
			; BX = selector, CX:DX = segment limit
			; Return: CF set on error
			; CF clear if successful
jb	short loc_13730
retn

loc_13730:
mov	ax, 4CFFh
int	21h		; DOS -	2+ - QUIT WITH EXIT CODE (EXIT)
sub_136FF endp		; AL = exit code




sub_13735 proc near
mov	di, 80h	; '€'
movzx	cx, byte ptr es:[di]
jcxz	short loc_13764
inc	di
mov	al, 20h	; ' '
repe scasb
jz	short loc_13764
dec	di
inc	cx
mov	bx, di

loc_13749:
mov	al, es:[di]
cmp	al, 9
jz	short loc_1375B
cmp	al, 0Dh
jz	short loc_1375B
cmp	al, 20h	; ' '
jz	short loc_1375B
inc	di
loop	loc_13749

loc_1375B:
mov	cx, di
mov	si, bx
mov	di, bx
sub	cx, bx
retn

loc_13764:
xor	si, si
retn
sub_13735 endp




sub_13767 proc near
call	sub_13735
jz	short locret_13770
mov	al, 20h	; ' '
rep stosb

locret_13770:
retn
sub_13767 endp




sub_13771 proc near
push	ds
push	es
call	sub_13735
jz	short loc_13792
mov	al, 5Ch	; '\'
mov	bx, cx
repne scasb
jcxz	short loc_13792
push	ds
push	es
pop	ds
pop	es
mov	cx, bx
mov	di, 2CACh
rep movsb
xor	al, al
stosb
pop	es
pop	ds
stc
retn

loc_13792:
pop	es
pop	ds
clc
retn
sub_13771 endp




sub_13796 proc near
push	ds
push	es
call	sub_13771
jb	short loc_137DB
mov	ah, 19h
int	21h		; DOS -	GET DEFAULT DISK NUMBER
mov	dl, al
add	al, 41h	; 'A'
mov	ds:2CACh, al
mov	word ptr ds:2CADh, 5C3Ah
inc	dx
mov	ah, 47h	; 'G'
mov	esi, 2CAFh
int	21h		; DOS -	2+ - GET CURRENT DIRECTORY
			; DL = drive (0=default, 1=A, etc.)
			; DS:SI	points to 64-byte buffer area
push	ds
pop	es
xor	al, al
mov	di, si
mov	cx, 40h	; '@'
repne scasb
cmp	byte ptr [di-2], 5Ch ; '\'
jnz	short loc_137CB
dec	di

loc_137CB:
mov	byte ptr [di-1], 5Ch ; '\'
mov	si, 2C6Ch
mov	cx, 40h	; '@'

loc_137D5:
lodsb
stosb
test	al, al
loopne	loc_137D5

loc_137DB:
push	ds
pop	es
xor	al, al
mov	cx, 0FFFFh
mov	di, 2CACh
repne scasb
not	cx
mov	bx, cx
pop	es
push	es
mov	ax, es:2Ch
test	ax, ax
jz	short loc_13823
lar	cx, ax
jnz	short loc_13823
mov	es, ax
xor	al, al
xor	di, di
mov	cx, 0FFFFh

loc_13803:
repne scasb
scasb
jnz	short loc_13803
inc	di
inc	di
mov	cx, 0FFFFh
mov	dx, di
repne scasb
not	cx
cmp	bx, cx
ja	short loc_13829
mov	cx, bx
mov	di, dx
mov	si, 2CACh
rep movsb
pop	es
pop	ds
retn

loc_13823:
mov	ax, 2000h
jmp	sub_13152

loc_13829:
push	bx
mov	cx, 0FFFFh
xor	di, di

loc_1382F:
repne scasb
dec	cx
scasb
jnz	short loc_1382F
not	cx
inc	cx
inc	cx
push	cx
add	bx, cx
shr	bx, 4
inc	bx
mov	ax, 100h
int	31h		; DPMI Services	  ax=func xxxxh
			; ALLOCATE DOS MEMORY BLOCK
			; BX = number of paragraphs to allocate
			; Return: CF set on error
			; CF clear if successful
pop	cx
jb	short loc_13862
push	es
pop	ds
mov	es, dx
xor	si, si
xor	di, di
rep movsb
pop	cx
mov	si, 2CACh
push	cs
pop	ds
assume ds:seg002
rep movsb
pop	es
pop	ds
assume ds:nothing
mov	es:2Ch,	dx
retn

loc_13862:
mov	ax, 2000h
jmp	sub_13152
sub_13796 endp




sub_13868 proc near
push	ds
push	es
mov	ax, es:2Ch
test	ax, ax
jz	short loc_138B0
lar	cx, ax
jnz	short loc_138B0
mov	es, ax
xor	ax, ax
xor	di, di
mov	cx, 0FFFFh

loc_13880:
repne scasb
scasb
jcxz	short loc_138B0
jnz	short loc_13880
inc	di
inc	di
push	ds
push	es
pop	ds
pop	es
push	di
mov	si, di
mov	di, 2C6Ch

loc_13893:
lodsb
stosb
test	al, al
jnz	short loc_13893
pop	di
movzx	edx, di
mov	ax, 3DC0h
int	21h		; DOS -	2+ - OPEN DISK FILE WITH HANDLE
			; DS:DX	-> ASCIZ filename
			; AL = access mode
			; 0 - read, 1 -	write, 2 - read	& write
pop	es
pop	ds
mov	ds:3270h, ax
mov	ax, 2001h
jb	loc_13365
retn

loc_138B0:
mov	ax, 2000h
jmp	sub_13152
sub_13868 endp




sub_138B6 proc near
xor	edx, edx
mov	ecx, 40h ; '@'
mov	word ptr ds:3064h, 2002h
call	sub_13A9F
cmp	word ptr fs:0, 5A4Dh
jnz	loc_1336B
mov	eax, fs:3Ch
mov	edx, fs:18h
mov	ds:3274h, eax
retn
sub_138B6 endp




sub_138E3 proc near
push	ds
push	es
push	ds
push	es
pop	ds
pop	es
mov	di, 2C6Ch
rep movsb
push	es
pop	ds
mov	byte ptr [di], 0
mov	edx, 2C6Ch
mov	ax, 3DC0h
int	21h		; DOS -	2+ - OPEN DISK FILE WITH HANDLE
			; DS:DX	-> ASCIZ filename
			; AL = access mode
			; 0 - read, 1 -	write, 2 - read	& write
jb	short loc_13906
pop	es
pop	ds
mov	ds:3270h, ax
retn

loc_13906:
mov	bx, 2C6Ch

loc_13909:
cmp	byte ptr [bx], 2Eh ; '.'
stc
jz	short loc_1393A
inc	bx
cmp	bx, di
jb	short loc_13909
mov	eax, 4558452Eh
cmp	eax, [di-4]
stc
jz	short loc_1393A
mov	eax, 6578652Eh
cmp	eax, [di-4]
stc
jz	short loc_1393A
mov	[di], eax
mov	byte ptr [di+4], 0
mov	ax, 3DC0h
int	21h		; DOS -	2+ - OPEN DISK FILE WITH HANDLE
			; DS:DX	-> ASCIZ filename
			; AL = access mode
			; 0 - read, 1 -	write, 2 - read	& write

loc_1393A:
pop	es
pop	ds
mov	ds:3270h, ax
mov	ax, 3001h
jb	loc_13365
retn
sub_138E3 endp




sub_13947 proc near
xor	edx, edx
mov	ecx, 40h ; '@'
mov	word ptr ds:3064h, 3002h
call	sub_13A9F
call	sub_13A7B
xor	ebp, ebp
mov	ds:3274h, ebp
mov	ds:3294h, ebp
cmp	word ptr fs:0, 5A4Dh
jnz	sub_13A2B
mov	eax, fs:18h
cmp	ax, 40h	; '@'
jnz	short loc_1398C
mov	eax, fs:3Ch
test	ax, ax
jz	short loc_1398C
mov	ds:3274h, eax
retn

loc_1398C:
xor	esi, esi

loc_1398F:
movzx	eax, word ptr fs:4
shl	eax, 9
movzx	ebx, word ptr fs:2
add	eax, ebx
mov	bx, fs:0
cmp	bx, 5A4Dh
jz	short loc_139B7
cmp	bx, 5742h
jz	short loc_139BD
jmp	short loc_139E0

loc_139B7:
sub	eax, 200h

loc_139BD:
mov	esi, ebp
add	ebp, eax
mov	edx, ebp
call	sub_13A7B
mov	ecx, 40h ; '@'
xor	edx, edx
call	sub_13A9F
test	eax, eax
jnz	short loc_1398F
mov	ax, 3003h
jmp	loc_13365

loc_139E0:
mov	bx, fs:0
cmp	bx, 454Ch
jz	short loc_13A06
cmp	bx, 584Ch
jz	short loc_13A06
cmp	bx, 434Ch
jz	short loc_13A06
cmp	bx, 4550h
jz	short loc_13A06
mov	edx, ebp
call	sub_13A7B
call	sub_13A2B

loc_13A06:
cmp	eax, esi
jz	short locret_13A2A
mov	edx, esi
add	eax, 10h
add	edx, 10h
and	al, 0F0h
and	dl, 0F0h
cmp	eax, edx
jz	short locret_13A2A
mov	ds:3274h, ebp
mov	ds:3294h, esi

locret_13A2A:
retn
sub_13947 endp




sub_13A2B proc near
mov	edx, ds:30AAh
mov	ecx, ds:30B2h
call	sub_13AA6
test	ax, ax
mov	ax, 3003h
jz	loc_13365
shr	cx, 1

loc_13A43:
mov	ax, gs:[edx]
mov	bx, gs:[edx+2]
test	bx, bx
jnz	short loc_13A64
cmp	ax, 454Ch
jz	short locret_13A70
cmp	ax, 584Ch
jz	short locret_13A70
cmp	ax, 434Ch
jz	short locret_13A70
cmp	ax, 5045h
jz	short locret_13A70

loc_13A64:
add	edx, 2
add	ebp, 2
loop	loc_13A43
jmp	short sub_13A2B

locret_13A70:
retn
sub_13A2B endp




sub_13A71 proc near
mov	bx, cs:word_16170
mov	ah, 3Eh
int	21h		; DOS -	2+ - CLOSE A FILE WITH HANDLE
			; BX = file handle
retn
sub_13A71 endp




sub_13A7B proc near
push	bx
push	ecx
push	edx
push	eax
mov	ecx, edx
shr	ecx, 10h
mov	bx, cs:word_16170
mov	ax, 4200h
int	21h		; DOS -	2+ - MOVE FILE READ/WRITE POINTER (LSEEK)
			; AL = method: offset from beginning of	file
pop	eax
pop	edx
pop	ecx
pop	bx
jb	loc_1336B
retn
sub_13A7B endp




sub_13A9F proc near
push	bx
push	ds
push	fs
pop	ds
assume ds:nothing
jmp	short loc_13AAB
sub_13A9F endp




sub_13AA6 proc near
push	bx
push	ds
push	gs
pop	ds

loc_13AAB:
mov	bx, cs:word_16170
mov	ah, 3Fh
int	21h		; DOS -	2+ - READ FROM FILE WITH HANDLE
			; BX = file handle, CX = number	of bytes to read
			; DS:DX	-> buffer
pop	ds
assume ds:nothing
pop	bx
jb	loc_1336B
retn
sub_13AA6 endp




sub_13ABB proc near
pop	bp
mov	ax, 0FF90h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
shr	eax, 0Ah
test	eax, 0FFFF0000h
mov	dx, 38F8h
jz	short loc_13AD7
mov	dx, 38FBh
shr	eax, 0Ah

loc_13AD7:
push	dx
push	ax
mov	ah, 48h	; 'H'
mov	bx, 0FFFFh
int	21h		; DOS -	2+ - ALLOCATE MEMORY
			; BX = number of 16-byte paragraphs desired
shr	bx, 6
push	bx
jmp	bp
sub_13ABB endp ; sp-analysis failed




sub_13AE6 proc near
test	byte ptr ds:3059h, 10h
jz	short locret_13B15
call	sub_13ABB
movzx	eax, byte ptr ds:305Dh
lea	eax, [eax+eax*4+38D8h]
push	ax
movzx	ax, byte ptr ds:305Ch
imul	ax, 64h
add	ax, 56h	; 'V'
push	ax
mov	dx, 389Fh
call	sub_13221
add	sp, 0Ah

locret_13B15:
retn
sub_13AE6 endp ; sp-analysis failed




sub_13B16 proc near
test	byte ptr ds:3059h, 10h
jz	short locret_13B39
movzx	eax, byte ptr ds:32D0h
lea	eax, [eax+eax*2+38ECh]
push	ax
push	2C6Ch
mov	dx, 38FEh
call	sub_13221
add	sp, 4

locret_13B39:
retn
sub_13B16 endp




sub_13B3A proc near
test	byte ptr ds:3059h, 10h
jz	short locret_13B61
pushad
mov	ax, dx
shr	edx, 10h
shl	ebx, 0Ch
push	dx
push	ax
push	ebp
push	ebx
push	edi
push	cx
mov	dx, 391Fh
call	sub_13221
add	sp, 12h
popad

locret_13B61:
retn
sub_13B3A endp




sub_13B62 proc near
test	byte ptr ds:3059h, 10h
jz	short locret_13BA6
push	word ptr ds:3080h
push	word ptr es:2Ch
push	word ptr ds:3090h
call	sub_13ABB
mov	eax, ds:32A4h
sub	eax, ds:32ACh
push	eax
push	word ptr ds:329Ch
push	3A51h
push	large [dword ptr ds:32A8h]
push	word ptr ds:30A2h
push	large [dword ptr ds:32A4h]
push	word ptr ds:309Eh
mov	dx, 395Bh
call	sub_13221
add	sp, 20h

locret_13BA6:
retn
sub_13B62 endp ; sp-analysis failed




sub_13BA7 proc near
test	byte ptr ds:3059h, 2
jz	short locret_13BB5
xor	bx, bx
mov	ax, 168Bh
int	2Fh		; - Multiplex -	MS WINDOWS - SET FOCUS TO SPECIFIED VIRTUAL MACHINE
			; BX = virtual machine id (0 - for current DOS box)

locret_13BB5:
retn
sub_13BA7 endp

cli
cld
mov	ds, cs:word_15F8E
lss	esp, ds:3092h
push	ax
mov	al, 20h	; ' '
out	0A0h, al	; PIC 2	 same as 0020 for PIC 1
out	20h, al		; Interrupt controller,	8259A.
mov	ax, ds:3062h
out	0A1h, al	; Interrupt Controller #2, 8259A
mov	al, ah
out	21h, al		; Interrupt controller,	8259A.
call	sub_1346C
call	sub_133EA
call	sub_1403A
call	sub_14084
pop	dx
mov	ax, 6001h
cmp	dh, 81h	; ''
jz	short loc_13C06
mov	al, 2
cmp	dh, 82h	; '‚'
jz	short loc_13C15
mov	al, 3
cmp	dh, 83h	; 'ƒ'
jz	short loc_13C15
mov	al, 4
cmp	dh, 84h	; '„'
jz	short loc_13C0B
mov	al, 5
cmp	dh, 85h	; '…'
jz	short loc_13C15
mov	al, 0

loc_13C06:
movzx	si, dl
jmp	short loc_13C15

loc_13C0B:
rol	esi, 10h
mov	di, si
shr	esi, 10h

loc_13C15:
call	sub_13152
mov	al, 0FFh
jmp	loc_133A6
push	0
jmp	short loc_13C78
push	1
jmp	short loc_13C59
push	2
jmp	short loc_13C78
push	3
jmp	short loc_13C59
push	4
jmp	short loc_13C78
push	5
jmp	short loc_13C78
push	6
jmp	short loc_13C78
push	7
jmp	short loc_13C78
push	8
jmp	short loc_13C78
push	9
jmp	short loc_13C78
push	0Ah
jmp	short loc_13C78
push	0Bh
jmp	short loc_13C78
push	0Ch
jmp	short loc_13C78
push	0Dh
jmp	short loc_13C78
push	0Eh
jmp	short loc_13C78

loc_13C59:
cmp	byte ptr cs:word_15F5C+1, 3
jz	short loc_13C6C
push	eax
mov	eax, dr6
and	al, 0Fh
pop	eax
jnz	short loc_13C78

loc_13C6C:
add	esp, 2
and	byte ptr [esp+15h], 0FEh
retfd

loc_13C78:
cli
cld
push	ax
mov	ax, ds
mov	ds, cs:word_15F8E
mov	ds:3318h, ax
pop	ax
pop	word ptr ds:331Ch
mov	word ptr ds:3314h, ss
mov	ds:3310h, esp
lss	esp, ds:3092h
push	word ptr ds:3318h
push	es
push	fs
push	gs
pushad
mov	es, word ptr ds:3314h
mov	ebp, ds:3310h
mov	eax, es:[ebp+8]
mov	ds:3304h, eax
mov	eax, es:[ebp+14h]
mov	ds:3300h, eax
mov	ax, es:[ebp+10h]
call	sub_13FF1
mov	fs, ax
assume fs:nothing
mov	ax, es:[ebp+1Ch]
call	sub_13FF1
mov	gs, ax
assume gs:nothing
mov	esi, es:[ebp+0Ch]
mov	edi, es:[ebp+18h]
xor	eax, eax
mov	ds:32F0h, eax
mov	ds:32F4h, eax
mov	ds:32F8h, eax
mov	ds:32FCh, eax
cmp	byte ptr ds:305Dh, 3
jz	short loc_13D17
mov	eax, cr0
mov	ds:32F0h, eax
mov	eax, cr2
mov	ds:32F4h, eax
mov	eax, cr3
mov	ds:32F8h, eax
mov	eax, dr6
mov	ds:32FCh, eax

loc_13D17:
mov	ebp, esp
mov	al, 20h	; ' '
out	0A0h, al	; PIC 2	 same as 0020 for PIC 1
out	20h, al		; Interrupt controller,	8259A.
mov	ax, ds:3062h
out	0A1h, al	; Interrupt Controller #2, 8259A
mov	al, ah
out	21h, al		; Interrupt controller,	8259A.
call	sub_1346C
call	sub_133EA
call	sub_1403A
call	sub_14084
call	sub_13D5F
call	sub_13DB6
push	word ptr ds:309Ch
push	2C6Ch
mov	dx, 3A5Dh
call	sub_13221
add	sp, 4
call	sub_13DEF
call	sub_13E1E
call	sub_13E4C
call	sub_13E68
call	sub_13EE6
mov	al, 0FFh
jmp	loc_133A6



sub_13D5F proc near
mov	eax, ds:32FCh
and	al, 0Fh
jz	short loc_13D78
call	sub_13FBF
push	esi
push	fs
mov	dx, 3A7Fh
call	sub_13221
add	sp, 6
retn

loc_13D78:
push	6001h
mov	dx, 3209h
call	sub_13221
pop	ax
mov	ebx, 0FFFFFFFEh
call	sub_14018
mov	bl, 0CDh ; 'Í'
mov	bh, ds:331Ch
cmp	ax, bx
mov	cx, 39D4h
jnz	short loc_13D9B
mov	cx, 39DEh

loc_13D9B:
mov	ax, ds:331Ch
mov	bx, ax
add	bx, bx
push	esi
push	fs
push	word ptr [bx+3038h]
push	ax
push	cx
mov	dx, 39F3h
call	sub_13221
add	sp, 0Ch
retn
sub_13D5F endp




sub_13DB6 proc near
call	sub_13FBF
push	eax
push	cx
mov	ax, 3A4Ah
jb	short loc_13DC4
mov	ax, 3A51h

loc_13DC4:
push	ax
mov	dx, 3A13h
call	sub_13221
add	sp, 8
mov	ax, ds:331Ch
cmp	al, 8
jb	short loc_13DEB
cmp	al, 9
jz	short loc_13DDD
cmp	al, 0Eh
ja	short loc_13DEB

loc_13DDD:
push	large [dword ptr ds:3304h]
mov	dx, 3A2Ah
call	sub_13221
add	sp, 4

loc_13DEB:
call	sub_13218
retn
sub_13DB6 endp




sub_13DEF proc near
mov	al, 3Dh	; '='
mov	cx, 48h	; 'H'

loc_13DF4:
call	sub_1320F
loop	loc_13DF4
mov	ax, fs
cmp	ax, 8
mov	dx, 3C73h
jz	short loc_13E18
cmp	ax, ds:308Ch
mov	dx, 3C7Bh
jz	short loc_13E18
cmp	ax, ds:309Eh
mov	dx, 3C83h
jz	short loc_13E18
mov	dx, 3C8Bh

loc_13E18:
call	sub_13221
jmp	sub_13218
sub_13DEF endp




sub_13E1E proc near
mov	cl, 8
mov	ebx, ds:3300h
xor	eax, eax
xor	edx, edx

loc_13E2B:
shr	bl, 1
rcr	eax, 4
shr	bh, 1
rcr	edx, 4
loop	loc_13E2B
push	eax
push	edx
push	large [dword ptr ds:3300h]
mov	dx, 3AA2h
call	sub_13221
add	sp, 0Ch
retn
sub_13E1E endp




sub_13E4C proc near
mov	cl, 0Ah
mov	ebx, 9

loc_13E54:
call	sub_14006
push	ax
dec	ebx
loop	loc_13E54
mov	dx, 3AB8h
call	sub_13221
add	sp, 14h
jmp	sub_13218
sub_13E4C endp ; sp-analysis failed




sub_13E68 proc near
xor	ebx, ebx
call	sub_14029
push	eax
push	large [dword ptr ds:32FCh]
push	large dword ptr	[ebp+4]
push	large dword ptr	[ebp+1Ch]
mov	dx, 3AE1h
call	sub_13221
add	sp, 10h
add	bx, 4
call	sub_14029
push	eax
push	large [dword ptr ds:32F0h]
push	large dword ptr	[ebp+0]
push	large dword ptr	[ebp+10h]
mov	dx, 3B1Bh
call	sub_13221
add	sp, 10h
add	bx, 4
call	sub_14029
push	eax
push	large [dword ptr ds:32F4h]
push	large dword ptr	[ebp+8]
push	large dword ptr	[ebp+18h]
mov	dx, 3B55h
call	sub_13221
add	sp, 10h
add	bx, 4
call	sub_14029
push	eax
push	large [dword ptr ds:32F8h]
push	edi
push	large dword ptr	[ebp+14h]
mov	dx, 3B8Fh
call	sub_13221
add	sp, 10h
retn
sub_13E68 endp




sub_13EE6 proc near
mov	dx, 3BE8h
mov	ax, fs
call	sub_13F1F
mov	dx, 3BF3h
mov	ax, [ebp+26h]
call	sub_13F1F
mov	dx, 3BFEh
mov	ax, [ebp+24h]
call	sub_13F1F
mov	dx, 3C09h
mov	ax, gs
call	sub_13F1F
mov	dx, 3C14h
mov	ax, [ebp+22h]
call	sub_13F1F
mov	dx, 3C1Fh
mov	ax, [ebp+20h]
call	sub_13F1F
retn
sub_13EE6 endp




sub_13F1F proc near
push	ax
call	sub_13221
pop	ax
test	ax, ax
jnz	short loc_13F31
mov	dx, 3BDAh
call	sub_13221
jmp	sub_13218

loc_13F31:
mov	bx, ax
sub	sp, 8
push	ss
pop	es
mov	edi, esp
mov	ax, 0Bh
int	31h		; DPMI Services	  ax=func xxxxh
			; GET DESCRIPTOR
			; BX = selector, ES:DI / ES:EDI	-> 8-byte buffer for copy of descriptor
			; Return: CF set on error
			; CF clear if successful
jnb	short loc_13F4E
add	sp, 8
mov	dx, 3BC9h
call	sub_13221
jmp	sub_13218

loc_13F4E:
mov	ax, es:[edi+5]
mov	dx, ax
push	ax
shr	al, 1
and	ax, 7
push	ax
mov	cl, dh
shr	cl, 6
and	cl, 1
mov	ax, 10h
shl	ax, cl
push	ax
mov	al, dl
shr	al, 3
and	eax, 1
lea	eax, [eax+eax*4+3C69h]
push	ax
mov	al, dh
shr	al, 7
and	eax, 1
lea	eax, [eax+eax*4+3C5Fh]
push	ax
mov	al, dh
and	eax, 0Fh
shl	eax, 10h
mov	ax, es:[edi]
push	eax
mov	ah, es:[edi+7]
mov	al, es:[edi+4]
shl	eax, 10h
mov	ax, es:[edi+2]
push	eax
mov	dx, 3C2Ah
call	sub_13221
add	sp, 1Ah
retn
sub_13F1F endp




sub_13FBF proc near
mov	ax, 6
mov	bx, fs
int	31h		; DPMI Services	  ax=func xxxxh
			; GET SEGMENT BASE ADDRESS
			; BX = selector
			; Return: CF set on error
			; CF clear if successful, CX:DX	= linear base address of segment
shl	ecx, 10h
mov	cx, dx
lea	eax, [ecx+esi]
mov	ecx, ds:3280h
jcxz	short loc_13FE4

loc_13FD8:
cmp	bx, ds:72h[ecx*2]
jz	short loc_13FE6
loop	loc_13FD8

loc_13FE4:
stc
retn

loc_13FE6:
sub	eax, ds:0F2h[ecx*4]
clc
retn
sub_13FBF endp




sub_13FF1 proc near
lar	bx, ax
jnz	short loc_14003
verr	ax
jnz	short loc_14003
not	bx
test	bh, 80h
jnz	short loc_14003
retn

loc_14003:
xor	ax, ax
retn
sub_13FF1 endp




sub_14006 proc near
mov	ax, fs
test	ax, ax
jnz	short loc_14010
xor	eax, eax
retn

loc_14010:
movzx	eax, byte ptr fs:[esi+ebx]
retn
sub_14006 endp




sub_14018 proc near
mov	ax, fs
test	ax, ax
jnz	short loc_14022
xor	eax, eax
retn

loc_14022:
mov	eax, fs:[esi+ebx]
retn
sub_14018 endp




sub_14029 proc near
mov	ax, gs
test	ax, ax
jnz	short loc_14033
xor	eax, eax
retn

loc_14033:
mov	eax, gs:[edi+ebx]
retn
sub_14029 endp




sub_1403A proc near
push	ax
push	cx
mov	ax, 500h
mov	cx, 110h
call	sub_1404E
mov	ax, 300h
call	sub_1404E
pop	cx
pop	ax
retn
sub_1403A endp




sub_1404E proc near
test	cs:byte_15F58, 2
jnz	short loc_14057
retn

loc_14057:
push	cx
push	dx
push	ax
mov	al, 0B6h ; '¶'
out	43h, al		; Timer	8253-5 (AT: 8254.2).
pop	ax
out	42h, al		; Timer	8253-5 (AT: 8254.2).
mov	al, ah
out	42h, al		; Timer	8253-5 (AT: 8254.2).
in	al, 61h		; PC/XT	PPI port B bits:
			; 0: Tmr 2 gate	ÍËÍ OR	03H=spkr ON
			; 1: Tmr 2 data	Í¼  AND	0fcH=spkr OFF
			; 3: 1=read high switches
			; 4: 0=enable RAM parity checking
			; 5: 0=enable I/O channel check
			; 6: 0=hold keyboard clock low
			; 7: 0=enable kbrd
or	al, 3
out	61h, al		; PC/XT	PPI port B bits:
			; 0: Tmr 2 gate	ÍËÍ OR	03H=spkr ON
			; 1: Tmr 2 data	Í¼  AND	0fcH=spkr OFF
			; 3: 1=read high switches
			; 4: 0=enable RAM parity checking
			; 5: 0=enable I/O channel check
			; 6: 0=hold keyboard clock low
			; 7: 0=enable kbrd

loc_1406B:		; Timer	8253-5 (AT: 8254.2).
in	al, 40h
in	al, 40h		; Timer	8253-5 (AT: 8254.2).
mov	ah, al

loc_14071:		; Timer	8253-5 (AT: 8254.2).
in	al, 40h
in	al, 40h		; Timer	8253-5 (AT: 8254.2).
cmp	ah, al
jz	short loc_14071
loop	loc_1406B
in	al, 61h		; PC/XT	PPI port B bits:
			; 0: Tmr 2 gate	ÍËÍ OR	03H=spkr ON
			; 1: Tmr 2 data	Í¼  AND	0fcH=spkr OFF
			; 3: 1=read high switches
			; 4: 0=enable RAM parity checking
			; 5: 0=enable I/O channel check
			; 6: 0=hold keyboard clock low
			; 7: 0=enable kbrd
and	al, 0FCh
out	61h, al		; PC/XT	PPI port B bits:
			; 0: Tmr 2 gate	ÍËÍ OR	03H=spkr ON
			; 1: Tmr 2 data	Í¼  AND	0fcH=spkr OFF
			; 3: 1=read high switches
			; 4: 0=enable RAM parity checking
			; 5: 0=enable I/O channel check
			; 6: 0=hold keyboard clock low
			; 7: 0=enable kbrd
pop	dx
pop	cx
retn
sub_1404E endp




sub_14084 proc near
push	ax
push	bx
push	cx
push	dx
test	cs:byte_15F58, 40h
jz	short loc_14095
mov	ax, 3
int	10h		; - VIDEO - SET	VIDEO MODE
			; AL = mode

loc_14095:
mov	dx, 3C4h
mov	al, 1
out	dx, al		; EGA: sequencer address reg
			; clocking mode. Data bits:
			; 0: 1=8 dots/char; 0=9	dots/char
			; 1: CRT bandwidth: 1=low; 0=high
			; 2: 1=shift every char; 0=every 2nd char
			; 3: dot clock:	1=halved
inc	dx
in	al, dx		; EGA port: sequencer data register
and	al, 0DFh
out	dx, al		; EGA port: sequencer data register
pop	dx
pop	cx
pop	bx
pop	ax
retn
sub_14084 endp

db 0FCh, 1Eh, 6, 66h, 60h, 80h,	0FCh, 1Bh
db 74h,	34h, 80h, 0FCh,	1Ch, 0Fh, 84h, 7Fh
db 0, 3Dh, 0, 4Fh, 0Fh,	84h, 0FEh, 0, 3Dh
db 1, 4Fh, 0Fh,	84h, 0F7h, 0, 3Dh, 4, 4Fh
db 0Fh,	84h, 83h, 1, 3Dh, 9, 4Fh, 0Fh, 84h
db 0EBh, 1, 3Dh, 0Ah, 4Fh, 0Fh,	84h, 4Dh
db 2, 66h, 61h,	7, 1Fh,	66h, 2Eh, 0FFh,	2Eh
db 0C6h, 30h, 66h, 83h,	0ECh, 32h, 66h,	8Bh
db 0ECh, 67h, 89h, 45h,	1Ch, 67h, 89h, 5Dh
db 10h,	2Eh, 8Eh, 1Eh, 8Eh, 30h, 0A1h, 82h
db 30h,	67h, 89h, 45h, 22h, 67h, 0C7h, 45h
db 3 dup(0), 0E8h, 0C7h, 0F3h, 66h, 0B9h
db 10h,	3 dup(0), 66h, 8Bh, 36h, 0AEh, 30h
db 0F3h, 66h, 67h, 0A5h, 66h, 67h, 0Fh,	0B7h
db 45h,	1Ch, 66h, 67h, 0Fh, 0B7h, 5Dh, 10h
db 66h,	83h, 0C4h, 32h,	66h, 67h, 89h, 44h
db 24h,	1Ch, 66h, 67h, 89h, 5Ch, 24h, 10h
db 0E9h, 0Ch, 0Fh, 84h,	0C0h, 74h, 0Bh,	3Ch
db 1, 74h, 26h,	3Ch, 2,	74h, 4Ch, 0E9h,	6Bh
db 2, 66h, 9Ch,	66h, 2Eh, 0FFh,	1Eh, 0C6h
db 30h,	66h, 0Fh, 0B7h,	0C0h, 66h, 0Fh,	0B7h
db 0DBh, 66h, 67h, 89h,	44h, 24h, 1Ch, 66h
db 67h,	89h, 5Ch, 24h, 10h, 0E9h, 0DEh,	0Eh
db 66h,	83h, 0ECh, 32h,	66h, 8Bh, 0ECh,	0E8h
db 10h,	2, 0E8h, 5Eh, 0F3h, 66h, 8Bh, 36h
db 0AEh, 30h, 66h, 8Bh,	0FBh, 0B8h, 0, 1Ch
db 33h,	0DBh, 0CDh, 10h, 66h, 8Bh, 0CBh
db 66h,	0C1h, 0E1h, 4, 0F3h, 66h, 67h, 0A5h
db 0E9h, 0Fh, 2, 66h, 83h, 0ECh, 32h, 66h
db 8Bh,	0ECh, 0E8h, 0E6h, 1, 66h, 8Bh, 0F3h
db 66h,	8Bh, 3Eh, 0AEh,	30h, 0B8h, 0, 1Ch
db 33h,	0DBh, 0CDh, 10h, 66h, 8Bh, 0CBh
db 66h,	0C1h, 0E1h, 4, 1Eh, 6, 1Fh, 7, 0F3h
db 66h,	67h, 0A5h, 0E8h, 16h, 0F3h, 0E9h
db 0E1h, 1, 66h, 83h, 0ECh, 32h, 66h, 8Bh
db 0ECh, 67h, 89h, 45h,	1Ch, 67h, 89h, 4Dh
db 18h,	8Bh, 0D0h, 2Eh,	8Eh, 1Eh, 8Eh, 30h
db 0A1h, 82h, 30h, 67h,	89h, 45h, 22h, 67h
db 0C7h, 45h, 3	dup(0),	0E8h, 0EDh, 0F2h
db 66h,	8Bh, 36h, 0AEh,	30h, 84h, 0D2h,	66h
db 0B9h, 40h, 3	dup(0),	75h, 2Eh, 66h, 67h
db 8Dh,	5Eh, 6,	0E8h, 2Dh, 0, 66h, 67h,	8Dh
db 5Eh,	0Eh, 0E8h, 25h,	0, 66h,	67h, 8Dh
db 5Eh,	16h, 0E8h, 1Dh,	0, 66h,	67h, 8Dh
db 5Eh,	1Ah, 0E8h, 15h,	0, 66h,	67h, 8Dh
db 5Eh,	1Eh, 0E8h, 0Dh,	0, 66h,	0B9h, 80h
db 3 dup(0), 0F3h, 66h,	67h, 0A5h, 0E9h
db 77h,	1, 66h,	67h, 0Fh, 0B7h,	13h, 66h
db 67h,	0Fh, 0B7h, 43h,	2, 66h,	0C1h, 0E0h
db 4, 66h, 3, 0C2h, 67h, 8Bh, 53h, 2, 3Bh
db 16h,	82h, 30h, 75h, 8, 66h, 2Bh, 6, 0AAh
db 30h,	66h, 3,	0C7h, 66h, 67h,	89h, 3,	0C3h
db 84h,	0D2h, 0Fh, 84h,	0F0h, 0FEh, 80h
db 0FAh, 1, 74h, 8, 80h, 0FAh, 2, 74h, 2Fh
db 0E9h, 4Eh, 1, 66h, 83h, 0ECh, 32h, 66h
db 8Bh,	0ECh, 0E8h, 12h, 1, 0E8h, 60h, 0F2h
db 66h,	8Bh, 36h, 0AEh,	30h, 66h, 8Bh, 0FBh
db 0B8h, 4, 4Fh, 32h, 0D2h, 33h, 0DBh, 0CDh
db 10h,	66h, 8Bh, 0CBh,	66h, 0C1h, 0E1h
db 4, 0F3h, 66h, 67h, 0A5h, 0E9h, 0Fh, 1
db 66h,	83h, 0ECh, 32h,	66h, 8Bh, 0ECh,	0E8h
db 0E6h, 0, 66h, 8Bh, 0F3h, 66h, 8Bh, 3Eh
db 0AEh, 30h, 0B8h, 4, 4Fh, 32h, 0D2h, 33h
db 0DBh, 0CDh, 10h, 66h, 8Bh, 0CBh, 66h
db 0C1h, 0E1h, 4
db 1Eh,	6, 1Fh,	7, 0F3h, 66h, 67h, 0A5h
db 0E8h, 14h, 0F2h, 0E9h, 0DFh,	0, 80h,	0FBh
db 3, 76h, 7, 80h, 0FBh, 80h, 0Fh, 85h,	0E6h
db 0, 66h, 83h,	0ECh, 32h, 66h,	8Bh, 0ECh
db 67h,	89h, 45h, 1Ch, 67h, 89h, 4Dh, 18h
db 67h,	89h, 55h, 14h, 67h, 89h, 5Dh, 10h
db 2Eh,	8Eh, 1Eh, 8Eh, 30h, 0A1h, 82h, 30h
db 67h,	89h, 45h, 22h, 67h, 0C7h, 45h, 3 dup(0)
db 84h,	0DBh, 74h, 0Ch,	0FEh, 0CBh, 74h
db 1Eh,	0FEh, 0CBh, 74h, 4, 0FEh, 0CBh,	74h
db 16h,	66h, 8Bh, 0F7h,	66h, 8Bh, 3Eh, 0AEh
db 30h,	1Eh, 6,	1Fh, 7,	0F3h, 66h, 67h,	0A5h
db 0E8h, 0B9h, 0F1h, 0E9h, 84h,	0, 0E8h
db 0B3h, 0F1h, 66h, 8Bh, 36h, 0AEh, 30h
db 0F3h, 66h, 67h, 0A5h, 0EBh, 76h, 66h
db 83h,	0ECh, 32h, 66h,	8Bh, 0ECh, 67h,	89h
db 45h,	1Ch, 67h, 89h, 5Dh, 10h, 0E8h, 96h
db 0F1h, 66h, 67h, 0Fh,	0B7h, 45h, 1Ch,	66h
db 67h,	0Fh, 0B7h, 4Dh,	18h, 66h, 67h, 0Fh
db 0B7h, 55h, 22h, 66h,	67h, 0Fh, 0B7h,	7Dh
db 0, 3Dh, 4Fh,	0, 75h,	47h, 66h, 0C1h,	0E2h
db 4, 66h, 3, 0FAh, 66h, 83h, 0C4h, 32h
db 66h,	67h, 89h, 44h, 24h, 1Ch, 66h, 67h
db 89h,	4Ch, 24h, 18h, 66h, 67h, 89h, 3Ch
db 24h,	2Eh, 0A1h, 98h,	30h, 67h, 89h, 44h
db 24h,	20h, 0E9h, 0C4h, 0Ch



sub_1437D proc near
mov	[ebp+1Ch], ax
mov	[ebp+18h], cx
mov	[ebp+14h], dx
mov	ds, cs:word_15F8E
mov	ax, ds:3082h
mov	[ebp+22h], ax
mov	word ptr [ebp+10h], 0
retn
sub_1437D endp

db 66h,	67h, 0Fh, 0B7h,	45h, 1Ch, 66h, 83h
db 0C4h, 32h, 66h, 67h,	89h, 44h, 24h, 1Ch
db 0E9h, 92h, 0Ch, 66h,	67h, 0C7h, 44h,	24h
db 1Ch,	4 dup(0FFh), 0E9h, 85h,	0Ch, 0FCh
db 2Eh,	0F7h, 6, 5Eh, 30h, 0, 1, 0Fh, 85h
db 5Ah,	1, 1Eh,	6, 66h,	60h, 80h, 0FCh,	9
db 0Fh,	84h, 55h, 1, 80h, 0FCh,	1Ah, 0Fh
db 84h,	95h, 1,	80h, 0FCh, 1Bh,	0Fh, 84h
db 0C1h, 1, 80h, 0FCh, 1Ch, 0Fh, 84h, 0BAh
db 1, 80h, 0FCh, 1Fh, 0Fh, 84h,	0E4h, 1
db 80h,	0FCh, 25h, 0Fh,	84h, 2 dup(2), 80h
db 0FCh, 2Fh, 0Fh, 84h,	0Bh, 2,	80h, 0FCh
db 31h,	0Fh, 84h, 1Bh, 2, 80h, 0FCh, 32h
db 0Fh,	84h, 0C8h, 1, 80h, 0FCh, 34h, 0Fh
db 84h,	35h, 2,	80h, 0FCh, 35h,	0Fh, 84h
db 4Ah,	2, 80h,	0FCh, 39h, 0Fh,	84h, 58h
db 2, 80h, 0FCh, 3Ah, 0Fh, 84h,	51h, 2,	80h
db 0FCh, 3Bh, 0Fh, 84h,	4Ah, 2,	80h, 0FCh
db 3Ch,	0Fh, 84h, 53h, 2, 80h, 0FCh, 3Dh
db 0Fh,	84h, 4Ch, 2, 80h, 0FCh,	3Fh, 0Fh
db 84h,	55h, 2,	80h, 0FCh, 40h,	0Fh, 84h
db 0D5h, 2, 80h, 0FCh, 41h, 0Fh, 84h, 27h
db 2, 80h, 0FCh, 42h, 0Fh, 84h,	49h, 3,	80h
db 0FCh, 43h, 0Fh, 84h,	58h, 3,	3Dh, 2,	44h
db 0Fh,	84h, 32h, 2, 3Dh, 3, 44h, 0Fh, 84h
db 0B2h, 2, 3Dh, 4, 44h, 0Fh, 84h, 24h,	2
db 3Dh,	5, 44h,	0Fh, 84h, 0A4h,	2, 80h,	0FCh
db 47h,	0Fh, 84h, 4Ch, 3, 80h, 0FCh, 48h
db 0Fh,	84h, 9Dh, 3, 80h, 0FCh,	49h, 0Fh
db 84h,	0C1h, 3, 80h, 0FCh, 4Ah, 0Fh, 84h
db 0DAh, 3, 80h, 0FCh, 4Bh, 0Fh, 84h, 0F5h
db 3, 80h, 0FCh, 4Ch, 0Fh, 84h,	41h, 5,	80h
db 0FCh, 4Eh, 0Fh, 84h,	0B7h, 5, 80h, 0FCh
db 4Fh,	0Fh, 84h, 0E0h,	5, 80h,	0FCh, 51h
db 0Fh,	84h, 28h, 6, 80h, 0FCh,	56h, 0Fh
db 84h,	31h, 6,	80h, 0FCh, 5Ah,	0Fh, 84h
db 0B0h, 1, 80h, 0FCh, 5Bh, 0Fh, 84h, 0A9h
db 1, 80h, 0FCh, 62h, 0Fh, 84h,	98h, 6,	80h
db 0FCh, 0FFh, 0Fh, 84h, 85h, 7, 80h, 0FCh
db 71h,	75h, 36h, 3Ch, 39h, 0Fh, 84h, 90h
db 1, 3Ch, 3Ah,	0Fh, 84h, 8Ah, 1, 3Ch, 3Bh
db 0Fh,	2 dup(84h), 1, 3Ch, 41h, 0Fh, 84h
db 7Eh,	1, 3Ch,	43h, 0Fh, 84h, 0B7h, 2,	3Ch
db 47h,	0Fh, 84h, 0C8h,	2, 3Ch,	56h, 0Fh
db 84h,	0E6h, 5, 3Ch, 60h, 0Fh,	84h, 6Ch
db 6, 3Ch, 6Ch,	0Fh, 84h, 0E1h,	6, 66h,	61h
db 7, 1Fh, 66h,	2Eh, 0FFh, 2Eh,	0CEh, 30h
db 0B8h, 0FFh, 4Ch, 0E9h, 0BEh,	4, 1Eh,	7
db 66h,	83h, 0ECh, 32h,	66h, 8Bh, 0ECh,	67h
db 89h,	45h, 1Ch, 66h, 8Bh, 0F2h, 66h, 8Bh
db 0FAh, 0B0h, 24h, 66h, 83h, 0C9h, 0FFh
db 0F2h, 67h, 0AEh, 66h, 0F7h, 0D1h, 2Eh
db 8Eh,	6, 8Eh,	30h, 66h, 2Eh, 8Bh, 3Eh
db 0AEh, 30h, 0F3h, 67h, 0A4h, 67h, 0AAh
db 2Eh,	0A1h, 82h, 30h,	67h, 89h, 45h, 24h
db 67h,	0C7h, 45h, 14h,	2 dup(0), 0E8h,	72h
db 0EFh, 66h, 83h, 0C4h, 32h, 0E9h, 0D2h
db 0Ah,	2Eh, 8Eh, 6, 8Eh, 30h, 26h, 8Ch
db 1Eh,	0C0h, 30h, 66h,	26h, 89h, 16h, 0C2h
db 30h,	66h, 83h, 0ECh,	32h, 66h, 8Bh, 0ECh
db 67h,	89h, 45h, 1Ch, 2Eh, 0A1h, 84h, 30h
db 67h,	89h, 45h, 24h, 67h, 0C7h, 45h, 14h
db 2 dup(0), 0E8h, 3Fh,	0EFh, 66h, 83h,	0C4h
db 32h,	0E9h, 9Fh, 0Ah,	0E8h
db 39h,	0Ah, 67h, 88h, 44h, 24h, 1Ch, 3Ch
db 0FFh, 74h, 22h, 66h,	67h, 89h, 54h, 24h
db 14h,	66h, 67h, 89h, 4Ch, 24h, 18h, 66h
db 0C1h, 0E6h, 4, 66h, 3, 0DEh,	66h, 67h
db 89h,	5Ch, 24h, 10h, 2Eh, 0A1h, 98h, 30h
db 67h,	89h, 44h, 24h, 22h, 0E9h, 6Eh, 0Ah
db 0E8h, 8, 0Ah, 67h, 88h, 44h,	24h, 1Ch
db 3Ch,	0FFh, 74h, 16h,	66h, 0C1h, 0E6h
db 4, 66h, 3, 0DEh, 66h, 67h, 89h, 5Ch,	24h
db 10h,	2Eh, 0A1h, 98h,	30h, 67h, 89h, 44h
db 24h,	22h, 0E9h, 49h,	0Ah, 8Ah, 0D8h,	8Ch
db 0D9h, 0B8h, 5, 2, 0CDh, 31h,	0Fh, 82h
db 48h,	0Ah, 0E9h, 39h,	0Ah, 2Eh, 0A1h,	0C0h
db 30h,	67h, 89h, 44h, 24h, 20h, 66h, 2Eh
db 0A1h, 0C2h, 30h, 66h, 67h, 89h, 44h,	24h
db 10h,	0E9h, 22h, 0Ah,	66h, 83h, 0ECh,	32h
db 66h,	8Bh, 0ECh, 2Eh,	8Bh, 1Eh, 0A6h,	30h
db 2Eh,	3, 1Eh,	60h, 30h, 2Eh, 2Bh, 1Eh
db 7Ch,	30h, 67h, 89h, 45h, 1Ch, 67h, 89h
db 5Dh,	14h, 0E8h, 9Ah,	0EEh, 66h, 83h,	0C4h
db 32h,	0E9h, 0FAh, 9, 0E8h, 94h, 9, 66h
db 0C1h, 0E7h, 4, 66h, 3, 0DFh,	66h, 67h
db 89h,	5Ch, 24h, 10h, 2Eh, 0A1h, 98h, 30h
db 67h,	89h, 44h, 24h, 20h, 0E9h, 0DEh,	9
db 8Ah,	0D8h, 0B8h, 4, 2, 0CDh,	31h, 67h
db 89h,	4Ch, 24h, 20h, 66h, 67h, 89h, 54h
db 24h,	10h, 0E9h, 0C9h, 9, 0E8h, 31h, 9
db 0Fh,	84h, 0C2h, 9, 66h, 67h,	89h, 44h
db 24h,	1Ch, 0E9h, 0C5h, 9, 0E8h, 21h, 9
db 66h,	67h, 89h, 44h, 24h, 1Ch, 0Fh, 84h
db 0ACh, 9, 0E9h, 0B5h,	9, 1Eh,	7, 2Eh,	8Eh
db 1Eh,	8Eh, 30h, 66h, 83h, 0ECh, 32h, 66h
db 8Bh,	0ECh, 67h, 89h,	5Dh, 10h, 66h, 8Bh
db 0FAh, 66h, 8Bh, 0D9h, 66h, 33h, 0D2h
db 67h,	89h, 45h, 1Ch, 0A1h, 82h, 30h, 67h
db 89h,	45h, 24h, 67h, 0C7h, 45h, 14h, 2 dup(0)
db 66h,	8Bh, 0C3h, 66h,	3Bh, 6,	0B2h, 30h
db 76h,	4, 66h,	0A1h, 0B2h, 30h, 67h, 89h
db 45h,	18h, 0E8h, 1, 0EEh, 66h, 67h, 0Fh
db 0B7h, 45h, 1Ch, 67h,	0F6h, 45h, 20h,	1
db 75h,	2Ch, 85h, 0C0h,	74h, 1Bh, 66h, 8Bh
db 36h,	0AEh, 30h, 0E8h, 0A7h, 8, 66h, 3
db 0D0h, 67h, 83h, 7Dh,	10h, 0,	74h, 9,	66h
db 2Bh,	0D8h, 67h, 8Bh,	45h, 4Eh, 77h, 0AEh
db 66h,	83h, 0C4h, 32h,	66h, 67h, 89h, 54h
db 24h,	1Ch, 0E9h, 2Fh,	9, 66h,	83h, 0C4h
db 32h,	66h, 67h, 89h, 44h, 24h, 1Ch, 0E9h
db 2Eh,	9, 2Eh,	8Eh, 6,	8Eh, 30h, 66h, 83h
db 0ECh, 32h, 66h, 8Bh,	0ECh, 67h, 89h,	5Dh
db 10h,	66h, 8Bh, 0F2h,	66h, 8Bh, 0D9h,	66h
db 33h,	0D2h, 67h, 89h,	45h, 1Ch, 2Eh, 0A1h
db 82h,	30h, 67h, 89h, 45h, 24h, 67h, 0C7h
db 45h,	14h, 2 dup(0), 66h, 8Bh, 0C3h, 66h
db 2Eh,	3Bh, 6,	0B2h, 30h, 76h,	5, 66h,	2Eh
db 0A1h, 0B2h, 30h, 67h, 89h, 45h, 18h,	66h
db 2Eh,	8Bh, 3Eh, 0AEh,	30h, 0E8h, 32h,	8
db 0E8h, 70h, 0EDh, 66h, 67h, 0Fh, 0B7h
db 45h,	1Ch, 67h, 0F6h,	45h, 20h, 1, 75h
db 1Dh,	85h, 0C0h, 74h,	0Ch, 66h, 3, 0D0h
db 66h,	2Bh, 0D8h, 67h,	8Bh, 45h, 4Eh, 77h
db 0B1h, 66h, 83h, 0C4h, 32h, 66h, 67h,	89h
db 54h,	24h, 1Ch, 0E9h,	0ADh, 8, 66h, 83h
db 0C4h, 32h, 66h, 67h,	89h, 44h, 24h, 1Ch
db 0E9h, 0ACh, 8, 0E8h,	3Ah, 8,	66h
db 67h,	89h, 44h, 24h, 1Ch, 0Fh, 85h, 9Fh
db 8, 66h, 67h,	89h, 54h, 24h, 14h, 0E9h
db 8Ah,	8, 0E8h, 0F2h, 7, 74h, 9, 66h, 67h
db 89h,	44h, 24h, 1Ch, 0E9h, 88h, 8, 66h
db 67h,	89h, 4Ch, 24h, 18h, 0E9h, 73h, 8
db 66h,	83h, 0ECh, 32h,	66h, 8Bh, 0ECh,	67h
db 89h,	45h, 1Ch, 67h, 89h, 55h, 14h, 2Eh
db 0A1h, 82h, 30h, 67h,	89h, 45h, 24h, 67h
db 0C7h, 45h, 4, 2 dup(0), 0E8h, 2 dup(0ECh)
db 67h,	0F6h, 45h, 20h,	1, 75h,	2 dup(1Eh)
db 7, 66h, 8Bh,	0FEh, 2Eh, 8Eh,	1Eh, 8Eh
db 30h,	66h, 8Bh, 36h, 0AEh, 30h, 67h, 0ACh
db 67h,	0AAh, 84h, 0C0h, 75h, 0F8h, 66h
db 83h,	0C4h, 32h, 0E9h, 2Eh, 8, 66h, 67h
db 0Fh,	0B7h, 45h, 1Ch,	66h, 83h, 0C4h,	32h
db 66h,	67h, 89h, 44h, 24h, 1Ch, 0E9h, 27h
db 8, 0B8h, 0, 1, 0CDh,	31h, 72h, 0Dh, 66h
db 0Fh,	0B7h, 0D2h, 66h, 67h, 89h, 54h,	24h
db 1Ch,	0E9h, 7, 8, 66h, 0Fh, 0B7h, 0C0h
db 66h,	0Fh, 0B7h, 0DBh, 66h, 67h, 89h,	44h
db 24h,	1Ch, 66h, 67h, 89h, 5Ch, 24h, 10h
db 0E9h, 0FCh, 7, 0B8h,	2 dup(1), 8Ch, 0C2h
db 0CDh, 31h, 73h, 0Dh,	66h, 0Fh, 0B7h,	0C0h
db 66h,	67h, 89h, 44h, 24h, 1Ch, 0E9h, 0E6h
db 7, 67h, 0C7h, 44h, 24h, 20h,	2 dup(0)
db 0E9h, 0D0h, 7, 0B8h,	2, 1, 8Ch, 0C2h
db 0CDh, 31h, 0Fh, 83h,	0C5h, 7, 66h, 0Fh
db 0B7h, 0C0h, 66h, 0Fh, 0B7h, 0DBh, 66h
db 67h,	89h, 44h, 24h, 1Ch, 66h, 67h, 89h
db 5Ch,	24h, 10h, 0E9h,	0BAh, 7, 84h, 0C0h
db 0Fh,	85h, 0B4h, 7, 66h, 2Eh,	81h, 3Eh
db 0B2h, 30h, 0, 4, 2 dup(0), 0Fh, 82h,	0A6h
db 7, 66h, 83h,	0ECh, 32h, 66h,	8Bh, 0ECh
db 67h,	89h, 45h, 1Ch, 6, 2Eh, 8Eh, 6, 8Eh
db 30h,	66h, 2Eh, 8Bh, 3Eh, 0AEh, 30h, 66h
db 8Bh,	0F2h, 66h, 81h,	0C7h, 0, 1, 2 dup(0)
db 67h,	0ACh, 67h, 0AAh, 84h, 0C0h, 75h
db 0F8h, 7, 1Eh, 6, 66h, 26h, 67h, 8Bh,	73h
db 6, 66h, 2Eh,	8Bh, 3Eh, 0AEh,	30h, 26h
db 67h,	8Eh, 5Bh, 0Ah, 2Eh, 8Eh, 6, 8Eh
db 30h,	66h, 81h, 0C7h,	80h, 1,	2 dup(0)
db 66h,	67h, 0Fh, 0B6h,	0Eh, 2 dup(41h)
db 0F3h, 67h, 0A4h, 7, 1Fh, 1Eh, 6, 66h
db 26h,	67h, 8Bh, 3Bh, 26h, 67h, 8Bh, 43h
db 4, 85h, 0C0h, 74h, 2Eh, 8Eh,	0C0h, 33h
db 0C0h, 66h, 8Bh, 0F7h, 66h, 83h, 0C9h
db 0FFh, 0F2h, 67h, 0AEh, 66h, 49h, 67h
db 0AEh, 75h, 0F7h, 66h, 0F7h, 0D1h, 0B8h
db 0, 1, 8Bh, 0D9h, 0C1h, 0EBh,	4, 43h,	0CDh
db 31h,	72h, 3Bh, 6, 1Fh, 8Eh, 0C2h, 66h
db 33h,	0FFh, 0F3h, 67h, 0A4h, 2Eh, 8Eh
db 1Eh,	8Eh, 30h, 66h, 8Bh, 3Eh, 0AEh, 30h
db 67h,	89h, 7,	0A1h, 82h, 30h,	67h, 0C7h
db 47h,	2, 80h,	1, 67h,	89h, 47h, 4, 0A1h
db 7Ch,	30h, 67h, 0C7h,	47h, 6,	5Ch, 0,	67h
db 89h,	47h, 8,	67h, 0C7h, 47h,	0Ah, 6Ch
db 0, 67h, 89h,	47h, 0Ch, 7, 1Fh, 72h, 66h
db 52h,	2Eh, 8Eh, 1Eh, 8Eh, 30h, 0A1h, 82h
db 30h,	67h, 89h, 45h, 22h, 67h, 89h, 45h
db 24h,	67h, 0C7h, 45h,	10h, 2 dup(0), 67h
db 0C7h, 45h, 14h, 0, 1, 80h, 3Eh, 5Dh,	30h
db 3, 74h, 0Bh,	0Fh, 20h, 0C0h,	66h, 8Bh
db 0F8h, 24h, 0FBh, 0Fh, 22h, 0C0h, 0E8h
db 0CBh, 0ECh, 0E8h, 36h, 0EBh,	0E8h, 5
db 0ECh, 80h, 3Eh, 5Dh,	30h, 3,	74h, 3,	0Fh
db 22h,	0C7h, 5Ah, 0B8h, 2 dup(1), 0CDh
db 31h,	66h, 67h, 0Fh, 0B7h, 45h, 1Ch, 67h
db 0F6h, 45h, 20h, 1, 66h, 67h,	8Dh, 64h
db 24h,	32h, 66h, 67h, 89h, 44h, 24h, 1Ch
db 0Fh,	85h, 7Bh, 6, 0E9h, 6Ch,	6, 66h,	83h
db 0C4h, 32h, 66h, 67h,	0C7h, 44h, 24h,	1Ch
db 4 dup(0FFh),	0E9h, 67h, 6, 0FAh, 0FCh
db 2Eh,	8Eh, 1Eh, 8Eh, 30h, 8Eh, 6, 90h
db 30h,	66h, 0Fh, 0B2h,	26h, 92h, 30h, 50h
db 0A1h, 9Ah, 30h, 26h,	0A3h, 2Ch, 0, 80h
db 3Eh,	5Dh, 30h, 3, 74h, 6, 66h, 33h, 0C0h
db 0Fh,	23h, 0F8h, 6, 0B8h, 0Ch, 0, 66h
db 33h,	0D2h, 8Bh, 0CAh, 8Eh, 0C2h, 0CDh
db 33h,	7, 8Bh,	16h, 6Ch, 30h, 8Bh, 0Eh
db 6Eh,	30h, 8Bh, 0C1h,	0Bh, 0C2h, 74h,	5
db 0B8h, 4, 3, 0CDh, 31h, 66h, 8Bh, 0Eh
db 80h,	32h, 0E3h, 0Fh,	0B8h, 1, 0, 67h
db 8Bh,	1Ch, 4Dh, 72h, 3 dup(0), 0CDh, 31h
db 0E2h, 0F1h, 0E8h, 0E5h, 0E9h, 0E8h, 0A1h
db 0E9h, 0E8h, 20h, 0ECh, 0B8h,	1, 0, 2Eh
db 8Bh,	1Eh, 98h, 30h, 0CDh, 31h, 33h, 0C0h
db 8Eh,	0E0h, 8Eh, 0E8h, 58h, 66h, 2Eh,	0FFh
db 2Eh,	0CEh, 30h, 0E8h, 46h, 5, 75h, 22h
db 2Eh,	8Eh, 1Eh, 0BAh,	30h, 66h, 2Eh, 8Bh
db 36h,	0BCh, 30h, 2Eh,	8Eh, 6,	0C0h, 30h
db 66h,	2Eh, 8Bh, 3Eh, 0C2h, 30h, 66h, 0B9h
db 2Bh,	3 dup(0), 0F3h,	67h, 0A4h, 0E9h
db 0B7h, 5, 66h, 67h, 89h, 44h,	24h, 1Ch
db 0E9h, 0BAh, 5, 2Eh, 8Eh, 1Eh, 0C0h, 30h
db 66h,	2Eh, 8Bh, 36h, 0C2h, 30h, 2Eh, 8Eh
db 6, 0BAh, 30h, 66h, 2Eh, 8Bh,	3Eh, 0BCh
db 30h,	66h, 0B9h, 2Bh,	3 dup(0), 0F3h,	67h
db 0A4h, 0E8h, 29h, 5, 75h, 22h, 2Eh, 8Eh
db 1Eh,	0BAh, 30h, 66h,	2Eh, 8Bh, 36h, 0BCh
db 30h,	2Eh, 8Eh, 6, 0C0h, 30h,	66h, 2Eh
db 8Bh,	3Eh, 0C2h, 30h,	66h, 0B9h, 2Bh,	3 dup(0)
db 0F3h, 67h, 0A4h, 0E9h, 68h, 5, 66h, 67h
db 89h,	44h, 24h, 1Ch, 0E9h, 6Bh, 5, 66h
db 2Eh,	0Fh, 0B7h, 6, 7Ch, 30h,	66h, 67h
db 89h,	44h, 24h, 10h, 0E9h, 4Fh, 5, 66h
db 83h,	0ECh, 32h, 66h,	8Bh, 0ECh, 67h,	89h
db 45h,	1Ch, 66h, 83h, 0C9h, 0FFh, 32h,	0C0h
db 0F2h, 67h, 0AEh, 66h, 0F7h, 0D1h, 66h
db 2Bh,	0F9h, 66h, 8Bh,	0F7h, 1Eh, 6, 1Fh
db 2Eh,	8Eh, 6,	8Eh, 30h, 66h, 2Eh, 8Bh
db 3Eh,	0AEh, 30h, 0F3h, 67h, 0A4h, 1Fh
db 66h,	8Bh, 0CFh, 66h,	2Eh, 8Bh, 1Eh, 0AEh
db 30h,	66h, 2Bh, 0CBh,	66h, 87h, 0CBh,	1Eh
db 7, 66h, 8Bh,	0F2h, 66h, 87h,	0F7h, 66h
db 83h,	0C9h, 0FFh, 32h, 0C0h, 0F2h, 67h
db 0AEh, 66h, 0F7h, 0D1h, 66h, 2Bh, 0F9h
db 66h,	87h, 0F7h, 2Eh,	8Eh, 6,	8Eh, 30h
db 0F3h, 67h, 0A4h, 2Eh, 0A1h, 82h, 30h
db 67h,	89h, 45h, 24h, 67h, 89h, 45h, 22h
db 67h,	0C7h, 45h, 3 dup(0), 67h, 89h, 5Dh
db 14h,	0E8h, 6Fh, 2 dup(0E9h),	0BAh, 4
db 66h,	2Eh, 0Fh, 0B7h,	6, 90h,	30h, 66h
db 67h,	89h, 44h, 24h, 10h, 0E9h, 0C3h,	4
db 66h,	83h, 0ECh, 32h,	66h, 8Bh, 0ECh,	6
db 66h,	57h, 67h, 89h, 45h, 1Ch, 67h, 89h
db 4Dh,	18h, 2Eh, 8Eh, 6, 8Eh, 30h, 66h
db 2Eh,	8Bh, 3Eh, 0AEh,	30h, 66h, 81h, 0C7h
db 0, 2, 2 dup(0), 67h,	0ACh, 67h, 0AAh
db 84h,	0C0h, 75h, 0F8h, 2Eh, 0A1h, 82h
db 30h,	67h, 89h, 45h, 24h, 67h, 89h, 45h
db 22h,	67h, 0C7h, 45h,	4, 0, 2, 67h, 0C7h
db 45h
db 3 dup(0), 0E8h, 15h,	0E9h, 6, 1Fh, 66h
db 2Eh,	8Bh, 36h, 0AEh,	30h, 66h, 5Fh, 7
db 67h,	0F6h, 45h, 20h,	1, 75h,	0Fh, 67h
db 0ACh, 67h, 0AAh, 84h, 0C0h, 75h, 0F8h
db 66h,	83h, 0C4h, 32h,	0E9h, 5Bh, 4, 66h
db 67h,	0Fh, 0B7h, 45h,	1Ch, 66h, 83h, 0C4h
db 32h,	66h, 67h, 89h, 44h, 24h, 1Ch, 0E9h
db 54h,	4, 66h,	83h, 0ECh, 32h,	66h, 8Bh
db 0ECh, 67h, 89h, 7Dh,	0, 67h,	89h, 5Dh
db 10h,	67h, 89h, 55h, 14h, 67h, 89h, 4Dh
db 18h,	67h, 89h, 45h, 1Ch, 2Eh, 0A1h, 82h
db 30h,	67h, 89h, 45h, 24h, 67h, 0C7h, 45h
db 4, 2	dup(0),	2Eh, 8Eh, 6, 8Eh, 30h, 66h
db 2Eh,	8Bh, 3Eh, 0AEh,	30h, 67h, 0ACh,	67h
db 0AAh, 84h, 0C0h, 75h, 0F8h, 0E8h, 0A2h
db 0E8h, 66h, 67h, 0Fh,	0B7h, 45h, 1Ch,	66h
db 67h,	0Fh, 0B7h, 4Dh,	18h, 67h, 0F6h,	45h
db 20h,	1, 66h,	67h, 8Dh, 64h, 24h, 32h
db 66h,	67h, 89h, 44h, 24h, 1Ch, 0Fh, 85h
db 0F4h, 3, 66h, 67h, 89h, 4Ch,	24h, 18h
db 0E9h, 0DFh, 3, 3Ch, 88h, 0Fh, 84h, 7Fh
db 0, 3Ch, 89h,	0Fh, 84h, 0B5h,	0, 3Ch,	8Ah
db 0Fh,	84h, 0E0h, 0, 3Ch, 8Dh,	0Fh, 84h
db 13h,	1, 3Ch,	8Eh, 0Fh, 84h, 2Ch, 1, 3Ch
db 8Fh,	0Fh, 84h, 44h, 1, 3Ch, 80h, 0Fh
db 84h,	51h, 1,	3Ch, 90h, 0Fh, 84h, 83h
db 1, 3Ch, 91h,	0Fh, 84h, 9Dh, 1, 3Ch, 92h
db 0Fh,	84h, 0A2h, 1, 3Ch, 93h,	0Fh, 84h
db 0ABh, 1, 3Ch, 94h, 0Fh, 84h,	0B0h, 1
db 3Ch,	95h, 0Fh, 84h, 0BFh, 1,	3Ch, 96h
db 0Fh,	84h, 0EEh, 1, 3Ch, 97h,	0Fh, 84h
db 0Dh,	2, 3Ch,	98h, 0Fh, 84h, 49h, 2, 3Ch
db 99h,	0Fh, 84h, 51h, 2, 3Ch, 9Ah, 0Fh
db 84h,	5Ah, 2,	83h, 0FAh, 78h,	0Fh, 85h
db 43h,	0F8h, 2Eh, 8Eh,	2Eh, 8Eh, 30h, 66h
db 67h,	0C7h, 44h, 24h,	1Ch, 2 dup(0FFh)
db 34h,	47h, 0E9h, 5Ah,	3, 66h,	83h, 0ECh
db 32h,	66h, 8Bh, 0ECh,	67h, 89h, 45h, 1Ch
db 0E8h, 0E5h, 0E7h, 66h, 0B8h,	32h, 33h
db 44h,	49h, 66h, 2Eh, 0Fh, 0B7h, 1Eh, 5Ah
db 30h,	66h, 67h, 8Bh, 4Dh, 18h, 66h, 67h
db 8Bh,	55h, 14h, 66h, 67h, 8Bh, 75h, 4
db 66h,	67h, 8Bh, 7Dh, 0, 66h, 67h, 8Bh
db 6Ch,	24h, 3Ah, 66h, 83h, 0C4h, 52h, 0E9h
db 20h,	3, 66h,	0B8h, 32h, 33h,	44h, 49h
db 66h,	2Eh, 0Fh, 0B7h,	36h, 88h, 30h, 66h
db 0C1h, 0E6h, 4, 2Eh, 8Eh, 26h, 98h, 30h
db 66h,	2Eh, 0Fh, 0B7h,	1Eh, 5Ah, 30h, 66h
db 2Eh,	8Bh, 0Eh, 0B2h,	30h, 66h, 2Eh, 0Fh
db 0B7h, 16h, 58h, 30h,	66h, 83h, 0C4h,	20h
db 0E9h, 0EFh, 2, 66h, 0B8h, 32h, 33h, 44h
db 49h,	66h, 2Eh, 0Fh, 0B7h, 36h, 8Ah, 30h
db 66h,	0C1h, 0E6h, 4, 66h, 81h, 0C6h, 4 dup(0)
db 2Eh,	8Eh, 26h, 98h, 30h, 66h, 2Eh, 0Fh
db 0B7h, 1Eh, 5Ah, 30h,	2Eh, 8Ah, 0Eh, 5Ch
db 30h,	2Eh, 8Ah, 2Eh, 5Dh, 30h, 64h, 67h
db 8Ah,	16h, 66h, 83h, 0C4h, 20h, 0E9h,	0B6h
db 2, 0Fh, 0A8h, 1Eh, 0Fh, 0A9h, 2Eh, 8Eh
db 1Eh,	8Eh, 30h, 0E8h,	0Fh, 0Dh, 66h, 0A1h
db 7Ch,	32h, 66h, 2Bh, 0C7h, 0Fh, 0A9h,	66h
db 67h,	89h, 44h, 24h, 1Ch, 0E9h, 95h, 2
db 2Eh,	8Eh, 2Eh, 8Eh, 30h, 66h, 0BAh, 6Ch
db 2Ch,	2 dup(0), 66h, 0BEh, 72h, 3 dup(0)
db 66h,	0BFh, 58h, 30h,	2 dup(0), 66h, 83h
db 0C4h, 20h, 0E9h, 79h, 2
db 2Eh,	8Eh, 1Eh, 8Eh, 30h, 66h, 87h, 1Eh
db 0B2h, 30h, 66h, 67h,	89h, 5Ch, 24h, 10h
db 0E9h, 64h, 2, 2Eh, 8Eh, 6, 8Eh, 30h,	66h
db 2Eh,	8Bh, 3Eh, 0AEh,	30h, 66h, 8Bh, 0F2h
db 8Bh,	0D7h, 67h, 0ACh, 0AAh, 84h, 0C0h
db 75h,	0F9h, 6, 1Fh, 8Ch, 16h,	0CCh, 32h
db 66h,	89h, 26h, 0C8h,	32h, 66h, 0Fh, 0B2h
db 26h,	92h, 30h, 66h, 51h, 66h, 53h, 0E8h
db 15h,	0E4h, 66h, 0Fh,	0B2h, 26h, 0C8h
db 32h,	0E9h, 2Ch, 2, 16h, 7, 66h, 83h,	0ECh
db 30h,	66h, 8Bh, 0FCh,	0B8h, 0, 5, 0CDh
db 31h,	66h, 67h, 8Bh, 4, 24h, 66h, 83h
db 0C4h, 30h, 66h, 67h,	89h, 44h, 24h, 1Ch
db 0E9h, 0Ch, 2, 0E8h, 2, 1, 0B8h, 1, 5
db 0CDh, 31h, 0E9h, 7, 1, 0E8h,	0F7h, 0
db 0B8h, 2, 5, 0CDh, 31h, 0Fh, 82h, 1, 2
db 0E9h, 0F2h, 1, 2 dup(0E8h), 0, 0B8h,	3
db 5, 0CDh, 31h, 0E9h, 0EDh, 0,	0B4h, 48h
db 0BBh, 2 dup(0FFh), 0E8h, 7Ch, 1, 66h
db 0C1h, 0E3h, 4, 66h, 67h, 89h, 5Ch, 24h
db 1Ch,	0E9h, 0D2h, 1, 66h, 83h, 0C3h, 0Fh
db 66h,	0C1h, 0EBh, 4, 66h, 0F7h, 0C3h,	2 dup(0)
db 2 dup(0FFh),	0Fh, 85h, 0CBh,	1, 85h,	0DBh
db 0Fh,	84h, 0C5h, 1, 0B4h, 48h, 0E8h, 51h
db 1, 0Fh, 85h,	0BCh, 1, 66h, 67h, 89h,	44h
db 24h,	4, 66h,	0C1h, 0E0h, 4, 66h, 67h
db 89h,	44h, 24h, 10h, 0E9h, 9Dh, 1, 66h
db 83h,	0ECh, 32h, 66h,	8Bh, 0ECh, 67h,	0C6h
db 45h,	1Dh, 49h, 67h, 89h, 75h, 22h, 0E8h
db 23h,	0E6h, 67h, 0F6h, 45h, 20h, 1, 66h
db 67h,	8Dh, 64h, 24h, 32h, 0Fh, 85h, 87h
db 1, 0E9h, 78h, 1, 66h, 83h, 0C3h, 0Fh
db 66h,	0C1h, 0EBh, 4, 66h, 0F7h, 0C3h,	2 dup(0)
db 2 dup(0FFh),	0Fh, 85h, 71h, 1, 85h, 0DBh
db 0Fh,	84h, 6Bh, 1, 66h, 83h, 0ECh, 32h
db 66h,	8Bh, 0ECh, 67h,	0C6h, 45h, 1Dh,	4Ah
db 67h,	89h, 5Dh, 10h, 67h, 89h, 75h, 22h
db 0E8h, 0E1h, 0E5h, 67h, 0F6h,	45h, 20h
db 1, 66h, 67h,	8Dh, 64h, 24h, 32h, 0Fh
db 85h,	45h, 1,	0E9h, 36h, 1, 0E8h, 2Ch
db 0, 0B8h, 0, 8, 0CDh,	31h, 0Fh, 82h, 36h
db 1, 0EBh, 3Eh, 0E8h, 1Eh, 0, 0B8h, 1,	8
db 0CDh, 31h, 0Fh, 82h,	28h, 1,	0E9h, 19h
db 1, 66h, 8Bh,	0FBh, 0E8h, 4Bh, 0E5h, 0Fh
db 82h,	1Bh, 1,	67h, 89h, 44h, 24h, 1Ch
db 0E9h, 7, 1, 8Bh, 0CBh, 66h, 0C1h, 0EBh
db 10h,	8Bh, 0FEh, 66h,	0C1h, 0EEh, 10h
db 0C3h, 0Fh, 82h, 2, 1, 66h, 0C1h, 0E6h
db 10h,	8Bh, 0F7h, 66h,	67h, 89h, 74h, 24h
db 4, 66h, 0C1h, 0E3h, 10h, 8Bh, 0D9h, 66h
db 67h,	89h, 5Ch, 24h, 10h, 0E9h, 0DBh,	0
db 1Eh,	7, 33h,	0C0h, 66h, 8Bh,	0F2h, 66h
db 8Bh,	0FAh, 66h, 83h,	0C9h, 0FFh, 0F2h
db 67h,	0AEh, 66h, 0F7h, 0D1h, 2Eh, 8Eh
db 6, 8Eh, 30h,	66h, 2Eh, 8Bh, 3Eh, 0AEh
db 30h,	0F3h, 67h, 0A4h, 2Eh, 0A1h, 82h
db 30h,	67h, 89h, 45h, 24h, 67h, 0C7h, 45h
db 14h,	2 dup(0), 0E9h,	41h, 0E5h, 66h,	8Bh
db 0C8h, 0C1h, 0E9h, 2,	0F3h, 66h, 67h,	0A5h
db 8Ah,	0C8h, 80h, 0E1h, 3, 0F3h, 67h, 0A4h
db 0C3h, 66h, 83h, 0ECh, 32h, 66h, 8Bh,	0ECh
db 67h,	89h, 75h, 4, 67h, 89h, 5Dh, 10h
db 67h,	89h, 4Dh, 18h, 67h, 89h, 45h, 1Ch
db 0E8h, 0A0h, 0FFh, 66h, 67h, 0Fh, 0B7h
db 45h,	1Ch, 66h, 67h, 0Fh, 0B7h, 4Dh
db 18h,	67h, 0F6h, 45h,	20h, 1,	66h, 67h
db 8Dh,	64h, 24h, 32h, 0C3h, 66h, 83h, 0ECh
db 32h,	66h, 8Bh, 0ECh,	67h, 89h, 5Dh, 10h
db 67h,	89h, 55h, 14h, 67h, 89h, 4Dh, 18h
db 67h,	89h, 45h, 1Ch, 0E8h, 0E2h, 0E4h
db 66h,	67h, 0Fh, 0B7h,	45h, 1Ch, 66h, 67h
db 0Fh,	0B7h, 4Dh, 18h,	66h, 67h, 0Fh, 0B7h
db 55h,	14h, 66h, 67h, 0Fh, 0B7h, 5Dh, 10h
db 66h,	67h, 0Fh, 0B7h,	7Dh, 22h, 66h, 67h
db 0Fh,	0B7h, 75h, 24h,	67h, 0F6h, 45h,	20h
db 1, 66h, 67h,	8Dh, 64h, 24h, 32h, 0C3h
db 66h,	67h, 0Fh, 0B7h,	45h, 1Ch, 67h, 0F6h
db 45h,	20h, 1,	66h, 67h, 8Dh, 64h, 24h
db 32h,	66h, 67h, 89h, 44h, 24h, 1Ch, 75h
db 0Ch,	66h, 61h, 7, 1Fh, 67h, 80h, 64h
db 24h,	8, 0FEh, 66h, 0CFh, 66h, 61h, 7
db 1Fh,	67h, 80h, 4Ch, 24h, 8, 1, 66h, 0CFh
db 0FCh, 1Eh, 6, 66h, 60h, 3Dh,	9, 0, 74h
db 37h,	3Dh, 0Ch, 0, 74h, 78h, 3Dh, 14h
db 0, 74h, 79h,	3Dh, 16h, 0, 0Fh, 84h, 92h
db 1, 3Dh, 17h,	0, 0Fh,	84h, 0C3h, 1, 3Dh
db 18h,	0, 0Fh,	84h, 80h, 0, 3Dh, 19h, 0
db 0Fh,	84h, 85h, 0, 3Dh, 20h, 0, 0Fh, 84h
db 0EAh, 1, 66h, 61h, 7, 1Fh, 66h, 2Eh,	0FFh
db 2Eh,	0DEh, 30h, 6, 1Fh, 66h,	83h, 0ECh
db 32h,	66h, 8Bh, 0ECh,	66h, 8Bh, 0F2h,	2Eh
db 8Eh,	6, 98h,	30h, 66h, 2Eh, 0Fh, 0B7h
db 3Eh,	86h, 30h, 67h, 89h, 45h, 1Ch, 67h
db 89h,	4Dh, 18h, 67h, 89h, 5Dh, 10h, 67h
db 89h,	7Dh, 22h, 67h, 0C7h, 45h, 14h, 2 dup(0)
db 66h,	0C1h, 0E7h, 4, 66h, 0B9h, 10h, 3 dup(0)
db 0F3h, 66h, 67h, 0A5h, 0E8h, 0FBh, 0E3h
db 66h,	83h, 0C4h, 32h,	0E9h, 61h, 0FFh
db 0E8h, 43h, 0, 0E9h, 5Bh, 0FFh, 2Eh, 8Bh
db 36h,	74h, 30h, 66h, 2Eh, 8Bh, 3Eh, 70h
db 30h,	0E8h, 32h, 0, 66h, 67h,	89h, 7Ch
db 24h,	14h, 67h, 89h, 74h, 24h, 20h, 0E9h
db 3Fh,	0FFh, 0E8h, 21h, 0, 66h, 67h, 89h
db 44h,	24h, 1Ch, 0E9h,	33h, 0FFh, 2Eh,	0A1h
db 74h,	30h, 66h, 2Eh, 8Bh, 16h, 70h, 30h
db 66h,	67h, 89h, 54h, 24h, 14h, 67h, 89h
db 44h,	24h, 10h, 0E9h,	1Bh, 0FFh, 66h,	83h
db 0ECh, 32h, 66h, 8Bh,	0ECh, 67h, 89h,	45h
db 1Ch,	67h, 89h, 4Dh, 18h, 2Eh, 8Eh, 1Eh
db 8Eh,	30h, 66h, 33h, 0C0h, 66h, 89h, 16h
db 70h,	30h, 8Ch, 6, 74h, 30h, 8Ch, 0C0h
db 66h,	0Bh, 0C2h, 74h,	6, 0A1h, 7Ah, 30h
db 0BAh, 6Bh, 22h, 67h,	89h, 55h, 14h, 67h
db 89h,	45h, 22h, 0FAh,	0E8h, 75h, 0E3h
db 66h,	67h, 0Fh, 0B7h,	45h, 1Ch, 66h, 83h
db 0C4h, 32h, 0FBh, 0C3h, 2Eh, 80h, 3Eh
db 78h,	30h, 0,	2Eh, 0C6h, 6, 78h, 30h,	1
db 75h,	5, 2Eh,	0FFh, 2Eh, 6Ch,	30h, 0CBh
db 0FCh, 66h, 60h, 1Eh,	6, 0Fh,	0A0h, 0Fh
db 0A8h, 66h, 33h, 0C0h, 8Ch, 0D8h, 2Eh
db 8Eh,	1Eh, 8Eh, 30h, 66h, 89h, 26h, 0D4h
db 32h,	8Ch, 16h, 0D8h,	32h, 8Eh, 0D8h,	8Ch
db 0D0h, 66h, 0Fh, 2, 0C0h, 66h, 0C1h, 0E8h
db 17h,	72h, 4,	66h, 0Fh, 0B7h,	0E4h, 2Eh
db 0A1h, 7Ah, 30h, 26h,	67h, 89h, 47h, 2Ch
db 26h,	67h, 0C7h, 47h,	2Ah, 0FFh, 22h,	66h
db 26h,	67h, 0Fh, 0B7h,	47h, 1Ch, 66h, 26h
db 67h,	0Fh, 0B7h, 4Fh,	18h, 66h, 26h, 67h
db 0Fh,	0B7h, 57h, 14h,	66h, 26h
db 67h,	0Fh, 0B7h, 5Fh,	10h, 66h, 26h, 67h
db 0Fh,	0B7h, 77h, 4, 66h, 26h,	67h, 0Fh
db 0B7h, 3Fh, 66h, 9Ch,	66h, 2Eh, 0FFh,	1Eh
db 70h,	30h, 66h, 2Eh, 0Fh, 0B2h, 26h, 0D4h
db 32h,	0Fh, 0A9h, 0Fh,	0A1h, 7, 1Fh, 66h
db 61h,	66h, 0CFh, 2Eh,	0C6h, 6, 78h, 30h
db 0, 0CBh, 66h, 83h, 0ECh, 32h, 66h, 8Bh
db 0ECh, 66h, 8Bh, 0FAh, 67h, 89h, 45h,	1Ch
db 2Eh,	0A1h, 82h, 30h,	67h, 89h, 45h, 22h
db 67h,	0C7h, 45h, 14h,	2 dup(0), 0E8h,	0AFh
db 0E2h, 2Eh, 8Eh, 1Eh,	8Eh, 30h, 66h, 8Bh
db 36h,	0AEh, 30h, 66h,	8Bh, 0Eh, 68h, 30h
db 0F3h, 67h, 0A4h, 66h, 83h, 0C4h, 32h
db 0E9h, 3, 0FEh, 6, 1Fh, 66h, 83h, 0ECh
db 32h,	66h, 8Bh, 0ECh,	66h, 8Bh, 0F2h,	67h
db 89h,	45h, 1Ch, 2Eh, 0A1h, 82h, 30h, 67h
db 89h,	45h, 22h, 67h, 0C7h, 45h, 14h, 2 dup(0)
db 2Eh,	8Eh, 6,	8Eh, 30h, 66h, 2Eh, 8Bh
db 3Eh,	0AEh, 30h, 66h,	2Eh, 8Bh, 0Eh, 68h
db 30h,	0F3h, 67h, 0A4h, 0E8h, 61h, 0E2h
db 66h,	83h, 0C4h, 32h,	0E9h, 0C7h, 0FDh
db 66h,	83h, 0ECh, 32h,	66h, 8Bh, 0ECh,	67h
db 89h,	45h, 1Ch, 0E8h,	4Ch, 0E2h, 66h,	83h
db 0C4h, 32h, 67h, 0C7h, 44h, 24h, 1Ch,	2 dup(0FFh)
db 0E9h, 0ABh, 0FDh
; START	OF FUNCTION CHUNK FOR start

loc_15296:
mov	byte ptr ds:32D0h, 0
jmp	short loc_152A9

loc_1529D:
mov	byte ptr ds:32D0h, 1
jmp	short loc_152A9

loc_152A4:
mov	byte ptr ds:32D0h, 2

loc_152A9:
call	sub_152FA
call	sub_13B16
mov	ecx, 1

loc_152B5:
call	sub_153CD
call	sub_15835
call	sub_13B3A
push	edx
push	edi
push	esi
push	ebx
inc	cx
cmp	cx, ds:3280h
jbe	short loc_152B5
call	sub_158C3
mov	ebp, esp
mov	ebx, ds:3280h
dec	bx
shl	bx, 4
mov	ds:3278h, ebx

loc_152E1:
call	sub_15493
sub	bx, 10h
jnb	short loc_152E1
call	sub_15924
call	sub_13A71
mov	esp, ds:3092h
call	sub_13B62
jmp	loc_15D0A
; END OF FUNCTION CHUNK	FOR start



sub_152FA proc near
mov	ecx, 0A8h ; '¨'
mov	edx, 4
mov	word ptr ds:3064h, 3002h
cmp	byte ptr ds:32D0h, 2
jz	loc_15941
call	sub_13A9F
mov	edx, ds:3274h
mov	ax, fs:10h
and	ax, 2000h
mov	ax, 3005h
jnz	loc_13365
mov	ax, fs:44h
mov	cx, ax
cmp	ax, 40h	; '@'
mov	ax, 4001h
ja	loc_13365
mov	ds:3280h, ecx
mov	eax, fs:40h
add	eax, edx
mov	ds:3284h, eax
mov	eax, fs:48h
add	eax, edx
mov	ds:3288h, eax
mov	eax, fs:68h
add	eax, edx
mov	ds:328Ch, eax
mov	eax, fs:6Ch
add	eax, edx
mov	ds:3290h, eax
mov	eax, fs:80h
add	ds:3294h, eax
mov	eax, fs:18h
mov	ds:329Ch, eax
mov	eax, fs:20h
mov	ds:32A0h, eax
mov	eax, fs:1Ch
mov	ds:32A4h, eax
mov	eax, fs:24h
mov	ds:32A8h, eax
mov	eax, fs:30h
mov	ds:32B4h, eax
mov	eax, fs:2Ch
mov	ds:32BCh, eax
mov	eax, 0FFFh
cmp	byte ptr ds:32D0h, 0
jz	short loc_153C8
mov	ax, 1
mov	cx, fs:2Ch
shl	ax, cl
dec	ax

loc_153C8:
mov	ds:3298h, eax
retn
sub_152FA endp




sub_153CD proc near

var_4= word ptr	-4

push	ecx
cmp	byte ptr ds:32D0h, 2
jz	loc_15993
mov	word ptr ds:3064h, 3002h
mov	edx, ds:3284h
call	sub_13A7B
mov	ecx, 18h
xor	edx, edx
call	sub_13A9F
add	ds:3284h, eax
mov	edx, ds:3294h
call	sub_13A7B
mov	eax, fs:0
mov	ebx, fs:10h
mov	ecx, fs:8
mov	esi, fs:0Ch
push	ecx
call	sub_156F5
mov	ecx, eax
mov	ebp, eax
mov	edx, edi
call	sub_156CC
mov	eax, ebx
test	eax, eax
jz	short loc_1548E
shl	eax, 0Ch
cmp	eax, ecx
jnb	short loc_1543B
mov	ecx, eax

loc_1543B:
mov	ax, [esp+8+var_4]
cmp	ax, ds:3280h
jnz	short loc_15464
cmp	byte ptr ds:32D0h, 0
jnz	short loc_1545D
lea	ecx, [ebx-1]
shl	ecx, 0Ch
add	ecx, ds:32BCh
jmp	short loc_15464

loc_1545D:
mov	ecx, ebx
shl	ecx, 0Ch

loc_15464:
mov	word ptr ds:3064h, 3002h
call	sub_13AA6
mov	eax, ecx
mov	edx, ds:3298h
test	eax, edx
jz	short loc_15489
mov	ecx, edx
not	edx
and	eax, edx
lea	eax, [eax+ecx+1]

loc_15489:
add	ds:3294h, eax

loc_1548E:
pop	edx
pop	ecx
retn
sub_153CD endp




sub_15493 proc near

var_4= dword ptr -4

xor	eax, eax
cmp	eax, [ebp+ebx+0]
jnz	short loc_1549F
retn

loc_1549F:
cmp	byte ptr ds:32D0h, 0
jnz	short loc_15522
mov	ecx, [ebp+ebx+4]
mov	edx, ds:3288h
lea	edx, [edx+ecx*4-4]
mov	word ptr ds:3064h, 3002h
call	sub_13A7B

loc_154C0:
push	eax
mov	ecx, 4
xor	edx, edx
mov	word ptr ds:3064h, 3002h
call	sub_13A9F
xor	ecx, ecx
mov	ch, fs:1
mov	cl, fs:2
jcxz	short loc_15517
mov	eax, ds:328Ch
lea	eax, [eax+ecx*4-4]
mov	esi, gs:[eax]
mov	ecx, gs:[eax+4]
sub	ecx, esi
jz	short loc_15517
add	esi, ds:3290h
mov	edi, [esp]
shl	edi, 0Ch
add	edi, [ebp+ebx+8]
add	ecx, esi
call	sub_15573

loc_15517:
pop	eax
inc	ax
cmp	ax, [ebp+ebx+0]
jb	short loc_154C0
retn

loc_15522:
mov	ecx, [ebp+ebx+4]
mov	edx, ds:328Ch
lea	edx, [edx+ecx*4-4]

loc_15533:
push	eax
push	edx
mov	esi, gs:[edx]
mov	ecx, gs:[edx+4]
sub	ecx, esi
jz	short loc_15562
add	esi, ds:3290h
mov	edi, [esp+8+var_4]
shl	edi, 0Ch
add	edi, [ebp+ebx+8]
add	ecx, esi
call	sub_15573

loc_15562:
pop	edx
pop	eax
add	edx, 4
inc	ax
cmp	ax, [ebp+ebx+0]
jb	short loc_15533
retn
sub_15493 endp




sub_15573 proc near
push	ecx
push	edi
mov	word ptr ds:3064h, 4005h
mov	cx, gs:[esi]
movsx	edx, word ptr gs:[esi+2]
movzx	eax, word ptr gs:[esi+4]
add	edi, edx
test	cx, 0F20h
jnz	loc_1336B
test	cx, 4000h
jnz	short loc_155A4
mov	ah, 0
dec	esi

loc_155A4:
add	esi, 6
dec	eax
shl	eax, 4
mov	edx, ds:3278h
sub	edx, eax
jb	loc_1336B
mov	ds:327Ch, edx
mov	edx, [ebp+edx+8]
mov	al, cl
and	al, 0Fh
cmp	al, 2
jz	short loc_155EA
cmp	al, 8
ja	loc_1336B
mov	eax, gs:[esi]
test	cx, 1000h
jnz	short loc_155E6
movzx	eax, ax
sub	esi, 2

loc_155E6:
add	esi, 4

loc_155EA:
cmp	cl, 7
jnz	short loc_15603
add	eax, edx
mov	gs:[edi], eax

loc_155F7:
pop	edi
pop	ecx
cmp	esi, ecx
jb	sub_15573
retn

loc_15603:
push	si
mov	si, cx
and	si, 0Fh
add	si, si
mov	word ptr ds:3064h, 4006h
call	word ptr [si+27BAh]
pop	si
jmp	short loc_155F7
sub_15573 endp

db 65h,	67h, 88h, 7, 0C3h, 65h,	67h, 89h
db 7, 0C3h, 66h, 3, 0C2h, 66h, 65h, 67h
db 89h,	7, 0C3h, 66h, 3, 0C2h, 66h, 67h
db 8Dh,	4Fh, 4,	66h, 2Bh, 0C1h,	67h, 0F7h
db 44h,	1Dh, 0Ch, 0, 20h, 75h, 15h, 66h
db 67h,	8Dh, 88h, 2, 80h, 2 dup(0), 66h
db 0C1h, 0E9h, 10h, 0Fh, 85h, 1Ch, 0DDh
db 65h,	67h, 89h, 7, 0C3h, 66h,	65h, 67h
db 89h,	7, 0C3h, 0E8h, 29h, 0, 65h, 67h
db 89h,	17h, 0C3h, 0E8h, 21h, 0, 65h, 67h
db 89h,	7, 65h,	67h, 89h, 57h, 2, 0C3h,	66h
db 3, 0C2h, 66h, 65h, 67h, 89h,	7, 0E8h
db 0Ch,	0, 65h,	67h, 89h, 57h, 4, 0C3h,	0B8h
db 5, 40h, 0E9h, 0DFh, 0DCh, 67h, 0F7h,	44h
db 1Dh,	0Ch, 0,	10h, 75h, 10h, 0F6h, 0C1h
db 10h,	75h, 0Bh, 66h, 8Bh, 0Eh, 7Ch, 32h
db 67h,	8Bh, 54h, 0Dh, 0Eh, 0C3h, 0F6h,	0C1h
db 10h,	74h, 0F0h, 66h,	8Bh, 0Eh, 7Ch, 32h
db 67h,	8Bh, 54h, 0Dh, 0Eh, 66h, 0A9h, 2 dup(0)
db 2 dup(0FFh),	0Fh, 85h, 0B3h,	0DCh, 0C3h
db 0, 18h, 27h,	80h, 27h, 5Ah, 27h, 62h
db 27h,	80h, 27h, 1Dh, 27h, 6Fh, 27h, 22h
db 27h,	2Bh, 27h



sub_156CC proc near
push	es
push	dx
push	eax
push	ecx
push	edi
push	gs
pop	es
mov	dl, cl
shr	ecx, 2
xor	eax, eax
rep stos dword ptr es:[edi]
mov	cl, dl
and	cl, 3
rep stos byte ptr es:[edi]
pop	edi
pop	ecx
pop	eax
pop	dx
pop	es
retn
sub_156CC endp




sub_156F5 proc near

arg_4= word ptr	 6

; FUNCTION CHUNK AT 024E SIZE 00000004 BYTES
; FUNCTION CHUNK AT 046B SIZE 00000006 BYTES

push	dx
test	eax, eax
jz	short loc_15712
mov	dl, ds:3058h
shr	dx, 4
and	dx, 3
jz	short loc_15726
dec	dx
jz	short loc_15739
dec	dx
jz	short loc_15758
dec	dx
jz	short loc_15766

loc_15710:
pop	dx
retn

loc_15712:
push	ax
push	si
mov	si, [esp+6+arg_4]
mov	ax, 9005h
call	sub_13152
pop	si
pop	ax
pop	dx
xor	edi, edi
retn

loc_15726:
call	sub_15774
jnb	short loc_15710
mov	word ptr ds:3064h, 4003h
call	sub_157B7
jnb	short loc_15710
jmp	loc_1336B

loc_15739:
test	cx, 2000h
jnz	short loc_1574A
mov	word ptr ds:3064h, 4002h
call	sub_15774
jnb	short loc_15710

loc_1574A:
mov	word ptr ds:3064h, 4003h
call	sub_157B7
jnb	short loc_15710
jmp	loc_1336B

loc_15758:
mov	word ptr ds:3064h, 4002h
call	sub_15774
jnb	short loc_15710
jmp	loc_1336B

loc_15766:
mov	word ptr ds:3064h, 4003h
call	sub_157B7
jnb	short loc_15710
jmp	loc_1336B
sub_156F5 endp ; sp-analysis failed




sub_15774 proc near
push	eax
push	ebp
add	eax, 0Fh
shr	eax, 4
test	eax, 0FFFF0000h
stc
jnz	short loc_157B2
sub	esp, 32h
mov	ebp, esp
mov	byte ptr [ebp+1Dh], 48h	; 'H'
mov	[ebp+10h], ax
call	sub_134DA
movzx	edi, word ptr [ebp+1Ch]
shl	edi, 4
bt	word ptr [ebp+20h], 0
lea	esp, [esp+32h]

loc_157B2:
pop	ebp
pop	eax
retn
sub_15774 endp




sub_157B7 proc near
push	esi
push	ebx
push	ecx
push	edx
push	eax
mov	ebx, eax
mov	ax, 0FF91h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
jb	short loc_1582A
mov	eax, ebx
xor	edx, edx
test	byte ptr ds:3059h, 4
jnz	short loc_157DE
test	al, 0Fh
jz	short loc_15810
jmp	short loc_157E3

loc_157DE:
test	ax, 0FFFh
jz	short loc_15810

loc_157E3:
test	byte ptr ds:3059h, 4
jnz	short loc_157F3
add	ebx, 0Fh
and	bl, 0F0h
jmp	short loc_157FE

loc_157F3:
add	ebx, 0FFFh
and	bx, 0F000h

loc_157FE:
sub	ebx, eax
mov	edx, ebx
add	ebx, [esp]
mov	ax, 0FF93h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
jb	short loc_1582A

loc_15810:
lea	edi, [ebx+edx]
test	byte ptr ds:3059h, 4
jnz	short loc_15822
test	di, 0Fh
jmp	short loc_15826

loc_15822:
test	di, 0FFFh

loc_15826:
stc
jnz	short loc_1582A
clc

loc_1582A:
pop	eax
pop	edx
pop	ecx
pop	ebx
pop	esi
retn
sub_157B7 endp




sub_15835 proc near

var_A= word ptr	-0Ah

push	ebx
push	ecx
push	edx
push	esi
push	edi
mov	ax, dx
mov	ecx, ebp
mov	dx, ds:3066h
test	al, 4
jz	short loc_1584F
or	dl, 8

loc_1584F:
test	ax, 2000h
jz	short loc_1586B
xor	edi, edi
or	ecx, 0FFFFFFFFh
test	al, 4
mov	ax, ds:309Eh
jnz	short loc_15865
mov	ax, ds:30A2h

loc_15865:
test	ax, ax
jnz	short loc_15876
jmp	short loc_1586F

loc_1586B:
and	dx, 0BFFFh

loc_1586F:
call	sub_13479
jb	loc_13378

loc_15876:
pop	edi
pop	esi
mov	[esp+0Ch+var_A], ax
pop	edx
pop	ecx
pop	ebx
mov	ds:72h[ecx*2], ax
mov	ds:0F2h[ecx*4],	edi
cmp	cx, ds:329Ch
jnz	short loc_158AF
mov	ds:309Eh, ax
mov	ds:32ACh, edi
test	dx, 2000h
jz	short loc_158AF
add	ds:32A4h, edi

loc_158AF:
cmp	cx, ds:32A0h
jnz	short locret_158C2
mov	ds:30A2h, ax
mov	ds:32B0h, edi
add	ds:32A8h, edi

locret_158C2:
retn
sub_15835 endp




sub_158C3 proc near
cmp	byte ptr ds:32D0h, 2
jz	loc_15A1B
mov	ebx, ds:32B4h
mov	byte ptr ds:32D1h, 0
mov	ax, 0FF95h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
jnb	short loc_158ED
mov	byte ptr ds:32D1h, 1
mov	al, 91h	; '‘'
int	21h		; DOS -	DOS v??? - OEM FUNCTION
mov	ax, 4004h
jb	loc_13365

loc_158ED:
mov	ds:32B8h, esi
mov	word ptr ds:3064h, 3002h
mov	edx, ds:328Ch
call	sub_13A7B
mov	edx, ebx
mov	ecx, ds:32B4h
call	sub_13AA6
mov	eax, ds:3290h
mov	ebx, ds:328Ch
sub	eax, ebx
add	eax, edx
mov	ds:328Ch, edx
mov	ds:3290h, eax
retn
sub_158C3 endp




sub_15924 proc near

; FUNCTION CHUNK AT 0465 SIZE 00000006 BYTES

cmp	byte ptr ds:32D0h, 2
jz	loc_15A9B
mov	esi, ds:32B8h
mov	ax, 0FF96h
cmp	byte ptr ds:32D1h, 0
jz	short loc_1593E
mov	al, 92h	; '’'

loc_1593E:		; DOS -	DOS v??? - OEM FUNCTION
int	21h
retn

loc_15941:
mov	cl, 0Ch
call	sub_13A9F
xor	eax, eax
mov	al, fs:4
mov	ds:3280h, eax
mov	al, fs:6
mov	ds:329Ch, eax
mov	al, fs:7
mov	ds:32A0h, eax
mov	eax, fs:8
mov	ds:32A4h, eax
mov	eax, fs:0Ch
mov	ds:32A8h, eax
mov	al, fs:5
and	al, 0Fh
cmp	al, 4
mov	ax, 3006h
jnz	loc_13365
mov	ax, 4007h
cmp	dword ptr ds:30B2h, 2000h
jb	loc_13365
retn

loc_15993:
mov	ecx, 10h
xor	edx, edx
mov	word ptr ds:3064h, 3002h
call	sub_13A9F
mov	eax, fs:0
btr	eax, 1Fh
setb	byte ptr ds:32C0h
push	eax
call	sub_156F5
mov	ecx, eax
mov	edx, edi
call	sub_156CC
mov	word ptr ds:3064h, 3002h
mov	ebx, fs:4
mov	ecx, ebx
jecxz	loc_15A01
cmp	byte ptr ds:32C0h, 0
jnz	short loc_159FE
mov	ax, 0FF91h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
mov	ax, 4003h
jb	loc_13365
mov	ds:32B8h, esi
mov	edx, ebx
call	sub_15AA6
mov	ax, 0FF92h
mov	esi, ds:32B8h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
jmp	short loc_15A01

loc_159FE:
call	sub_13AA6

loc_15A01:
pop	ebp
movzx	ebx, word ptr fs:0Eh
movzx	edx, word ptr fs:8
movzx	esi, word ptr fs:0Ch
pop	ecx
retn

loc_15A1B:
mov	ecx, 0Ch
xor	edx, edx
mov	word ptr ds:3064h, 3002h
call	sub_13A9F
mov	ax, 0FF91h
mov	ebx, fs:0
btr	ebx, 1Fh
setb	byte ptr ds:32C0h
mov	ecx, ebx
inc	ebx
int	21h		; DOS -	DOS v??? - OEM FUNCTION
mov	ax, 4003h
jb	loc_13365
mov	edx, ebx
mov	edi, ebx
mov	ds:32B8h, esi
call	sub_156CC
mov	ebx, fs:4
mov	ecx, ebx
cmp	byte ptr ds:32C0h, 0
jnz	short loc_15A87
mov	ax, 0FF91h
inc	ebx
int	21h		; DOS -	DOS v??? - OEM FUNCTION
mov	ax, 4003h
jb	loc_13365
mov	edx, ebx
call	sub_15AA6
mov	ax, 0FF92h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
jmp	short loc_15A8A

loc_15A87:
call	sub_13AA6

loc_15A8A:
mov	ds:328Ch, edi
add	edi, fs:8
mov	ds:3290h, edi
retn

loc_15A9B:
mov	ax, 0FF92h
mov	esi, ds:32B8h
int	21h		; DOS -	DOS v??? - OEM FUNCTION
retn
sub_15924 endp ; sp-analysis failed




sub_15AA6 proc near
call	sub_13AA6
pushad
mov	byte ptr ds:32D1h, 0
mov	ds:3278h, ebx
mov	ds:327Ch, ecx
push	edi
mov	ecx, ds:30B2h
mov	esi, ds:30AEh
mov	edi, ds:30AAh
call	sub_156CC
pop	edi
xor	bx, bx
mov	edx, 0FEEh

loc_15AD8:
shr	bx, 1
and	dx, 0FFFh
test	bh, 1
jz	short loc_15B02

loc_15AE3:
test	bl, 1
jz	short loc_15B0E
call	sub_15B47
js	short loc_15AFA
mov	[esi+edx], al
mov	gs:[edi], al
inc	dx
inc	edi
jmp	short loc_15AD8

loc_15AFA:
mov	ds:327Ch, edi
popad
retn

loc_15B02:
call	sub_15B47
js	short loc_15AFA
or	ah, 0FFh
mov	bx, ax
jmp	short loc_15AE3

loc_15B0E:
call	sub_15B47
js	short loc_15AFA
mov	cl, al
call	sub_15B47
js	short loc_15AFA
mov	ch, al
shr	ch, 4
and	ax, 0Fh
add	al, 2
mov	bp, ax
test	ax, ax
jl	short loc_15AD8

loc_15B2A:
and	cx, 0FFFh
and	dx, 0FFFh
mov	al, [esi+ecx]
mov	[esi+edx], al
mov	gs:[edi], al
inc	cx
inc	dx
inc	edi
dec	bp
jns	short loc_15B2A
jmp	short loc_15AD8
sub_15AA6 endp




sub_15B47 proc near
mov	eax, ds:3278h
mov	al, gs:[eax]
xor	al, ds:32D1h
inc	dword ptr ds:3278h
mov	ds:32D1h, al
dec	dword ptr ds:327Ch
retn
sub_15B47 endp

; START	OF FUNCTION CHUNK FOR start

loc_15B61:
mov	byte ptr ds:32D0h, 3
mov	ax, 3004h
jmp	loc_13365
; END OF FUNCTION CHUNK	FOR start
assume ss:seg003, ds:nothing



public start
start proc near

var_13=	byte ptr -13h

; FUNCTION CHUNK AT 2396 SIZE 00000064 BYTES
; FUNCTION CHUNK AT 2C61 SIZE 0000000B BYTES

push	cs
pop	ds
assume ds:seg002
mov	word_15F7A, ds
mov	word_15F7C, es
mov	word_15F7E, ss
mov	ax, es:2Ch
mov	word_15F80, ax
sti
cld
call	sub_12F00
call	sub_12F72
call	sub_131D6
mov	ax, ss
mov	si, es:2
add	ax, 0C0h ; 'À'
mov	word_15F82, ax
add	ax, word_15FA8
mov	word_15FA6, ax
sub	si, ax
jnb	short loc_15BB6

loc_15BA4:
neg	si
mov	cl, 6
shr	si, cl
mov	ax, 1001h
jmp	sub_13152

loc_15BB0:
mov	ax, 1002h
jmp	sub_13152

loc_15BB6:
sub	ax, word_15F7C
mov	bx, ax
mov	ah, 4Ah
int	21h		; DOS -	2+ - ADJUST MEMORY BLOCK SIZE (SETBLOCK)
			; ES = segment address of block	to change
			; BX = new size	in paragraphs
jb	short loc_15BB0
call	sub_100E4
pushf
cmp	ch, 1
jle	short loc_15BD4
mov	ax, 8
popf
jmp	sub_13152

loc_15BD4:
popf
jnb	short loc_15BDA
jmp	sub_13152

loc_15BDA:
mov	word_15F60, bx
mov	word_15F5C, cx
call	near ptr sub_15E30
mov	ax, word_15FA6
mov	si, es:2
add	ax, bx
sub	si, ax
jb	short loc_15BA4
add	bx, word_15FA6
sub	bx, word_15F7C
mov	ah, 4Ah
int	21h		; DOS -	2+ - ADJUST MEMORY BLOCK SIZE (SETBLOCK)
			; ES = segment address of block	to change
			; BX = new size	in paragraphs
jb	short loc_15BB0
movzx	eax, word_15F82
mov	edx, eax
sub	ax, word_15F7A
shl	edx, 4
shl	eax, 4
mov	dword_15FAE, eax
mov	dword_15FAA, edx
movzx	eax, word_15F7A
shl	eax, 4
mov	dword_15FB6, eax
movzx	eax, word_15FA8
shl	eax, 4
mov	dword_15FB2, eax
mov	es, word_15FA6
mov	bx, word_15F5A
mov	dx, 0CB6h
call	sub_103E0
jb	sub_13152
cli
mov	word_15F8C, cs
mov	word_15F8E, ds
mov	word_15F90, es
mov	word ptr byte_15F92+4, ss
mov	dword ptr byte_15F92, esp
mov	ax, es:2Ch
mov	word_15F9A, ax
mov	word_15F9C, si
push	di
push	ecx
call	sub_15D67
call	sub_133C1
call	sub_13AE6
pop	ecx
pop	di
sti
call	sub_15DF2
mov	fs, word ptr byte_15F92+4
mov	gs, word_15F98
assume gs:nothing
call	sub_13868
call	sub_138B6
call	sub_13735
cmp	dx, 40h	; '@'
jnz	short loc_15CA2
mov	edx, dword_16174
test	dx, dx
jnz	short loc_15CC3

loc_15CA2:
test	si, si
jnz	short loc_15CAF
call	sub_13A71
mov	ax, 8001h
jmp	sub_13152

loc_15CAF:
call	sub_13A71
call	sub_138E3
call	sub_13947
call	sub_13796
call	sub_13767
mov	edx, dword_16174

loc_15CC3:
mov	word_15F64, 3002h
call	sub_13A7B
mov	ecx, 4
xor	edx, edx
call	sub_13A9F
mov	ax, fs:0
mov	bx, fs:2
test	bx, bx
jnz	short loc_15D01
cmp	ax, 454Ch
jz	loc_15296
cmp	ax, 584Ch
jz	loc_1529D
cmp	ax, 434Ch
jz	loc_152A4
cmp	ax, 4550h
jz	loc_15B61

loc_15D01:
call	sub_13A71
mov	ax, 3004h
jmp	loc_13365

loc_15D0A:
test	cs:byte_15F59, 10h
jz	short loc_15D1F
sti
mov	al, 3Eh	; '>'
call	sub_1320F
xor	ax, ax
int	16h		; KEYBOARD - READ CHAR FROM BUFFER, WAIT IF EMPTY
			; Return: AH = scan code, AL = character
call	sub_13218

loc_15D1F:
cli
cld
call	sub_136CF
mov	ss, word_15FA2
assume ss:nothing
mov	esp, dword_161A8
mov	es, word_15F90
mov	fs, word_15F98
assume fs:nothing
mov	ds, word_15FA2
assume ds:nothing
xor	eax, eax
xor	ebx, ebx
xor	ecx, ecx
xor	edx, edx
xor	esi, esi
xor	edi, edi
xor	ebp, ebp
mov	gs, ax
pushfd
push	large [cs:dword_15F9E]
push	large [cs:dword_161A4]
or	[esp+1Ch+var_13], 2
sti
iretd
start endp ; sp-analysis failed




sub_15D67 proc near
xor	eax, eax
mov	ds:32A8h, eax
mov	ds:3280h, eax
mov	ds:3294h, eax
call	sub_136FF
call	sub_13504
call	sub_13547
mov	ax, 204h
mov	bl, 10h
int	31h		; DPMI Services	  ax=func xxxxh
			; GET PROTECTED	MODE INTERRUPT VECTOR
			; BL = interrupt number
			; Return: CF set on error
			; CF clear if successful, CX:DX	/ CX:EDX = selector:offset of handler
mov	ds:30CAh, cx
mov	ds:30C6h, edx
mov	bl, 21h	; '!'
int	31h		; DPMI Services	  ax=func xxxxh
			; GET PROTECTED	MODE INTERRUPT VECTOR
			; BL = interrupt number
			; Return: CF set on error
			; CF clear if successful, CX:DX	/ CX:EDX = selector:offset of handler
mov	ds:30D2h, cx
mov	ds:30CEh, edx
mov	bl, 23h	; '#'
int	31h		; DPMI Services	  ax=func xxxxh
			; GET PROTECTED	MODE INTERRUPT VECTOR
			; BL = interrupt number
			; Return: CF set on error
			; CF clear if successful, CX:DX	/ CX:EDX = selector:offset of handler
mov	ds:30DAh, cx
mov	ds:30D6h, edx
mov	bl, 33h	; '3'
int	31h		; DPMI Services	  ax=func xxxxh
			; GET PROTECTED	MODE INTERRUPT VECTOR
			; BL = interrupt number
			; Return: CF set on error
			; CF clear if successful, CX:DX	/ CX:EDX = selector:offset of handler
mov	ds:30E2h, cx
mov	ds:30DEh, edx
mov	ax, 202h
xor	ebx, ebx

loc_15DBC:		; DPMI Services	  ax=func xxxxh
int	31h		; GET PROCESSOR	EXCEPTION HANDLER VECTOR
			; BL = exception number	(00h-1Fh)
			; Return: CF set on error
			; CF clear if successful, CX:DX	/ CX:EDX = selector:offset of handler
mov	ds:30EAh[ebx*8], cx
mov	ds:30E6h[ebx*8], edx
inc	bl
cmp	bl, 0Fh
jb	short loc_15DBC
call	sub_135AC
jb	loc_13378
call	sub_13BA7
cmp	byte ptr ds:305Dh, 3
jz	short locret_15DF1
cmp	word ptr ds:309Ch, 0
jnz	short locret_15DF1
call	sub_1346C

locret_15DF1:
retn
sub_15D67 endp




sub_15DF2 proc near
test	di, di
jz	short loc_15E02
cmp	di, ds:305Ah
jz	short loc_15E02
mov	ax, 9006h
call	sub_13152

loc_15E02:
cmp	byte ptr ds:305Dh, 3
jz	short loc_15E14
test	ecx, ecx
jnz	short loc_15E14
mov	ax, 9001h
call	sub_13152

loc_15E14:
mov	ax, 400h
int	31h		; DPMI Services	  ax=func xxxxh
			; GET DPMI VERSION
			; Return: CF clear, AH = major version,	AL = minor version
			; BX = flags, CL = processor type
			; DH = curr value of virtual master interrupt controller base
			; DL = curr value of virtual slave interrupt controller	base
cmp	dh, 8
jnz	short loc_15E23
cmp	dl, 70h	; 'p'
jz	short locret_15E2F

loc_15E23:
movzx	si, dh
movzx	di, dl
mov	ax, 9002h
call	sub_13152

locret_15E2F:
retn
sub_15DF2 endp




sub_15E30 proc far
cmp	byte ptr ds:305Dh, 3
jnz	short locret_15E6C
cli
pop	bp
push	es
mov	es, word ptr ds:308Ah
mov	si, 0
mov	cx, 1EE0h
rep movsw
pop	es
mov	ax, dx
shr	ax, 4
mov	dx, ss
sub	dx, ax
mov	ss, dx
assume ss:nothing
mov	dx, ds
sub	dx, ax
mov	ds, dx
assume ds:nothing
sub	ds:307Ah, ax
sub	ds:307Eh, ax
sub	ds:3082h, ax
sub	ds:30A6h, ax
push	dx
push	bp
sti
retf

locret_15E6C:
retn
sub_15E30 endp ; sp-analysis failed

align 2
db 2Bh,	32h, 5,	0
word_15E72 dw 170h, 3230h, 5, 177h
dw offset loc_16135
dw offset loc_12F05
dw offset loc_1308C
dw offset loc_1613A
db 6, 0, 9Fh, 1, 40h, 32h, 6, 0, 0CFh, 1
db 46h,	32h, 7,	0, 0EBh, 1, 4Dh, 32h, 7
db 0, 0EFh, 1, 54h, 32h, 5, 0, 2 dup(2)
db 59h,	32h, 7,	0, 15h,	2, 60h,	32h, 6,	0
db 28h,	2, 66h,	32h, 3,	0, 48h,	2, 2 dup(0FFh)
db 2 dup(0), 0DAh, 2Fh,	10h, 0,	0ECh, 2Fh
db 20h,	0, 0F2h, 2Fh, 30h, 0, 0F8h, 2Fh
db 40h,	0, 6, 30h, 60h,	2, 16h,	30h, 80h
db 0, 22h, 30h,	90h, 1,	2Ah, 30h, 2 dup(0FFh)
db 0DBh, 31h, 0F1h, 31h, 9, 32h, 6Ch, 32h
db 94h,	32h, 0CDh, 32h,	6, 33h,	3Ch, 33h
db 5Bh,	33h, 80h, 33h, 0A4h, 33h, 0BEh,	33h
db 66h,	31h, 0F8h, 33h,	26h, 34h, 47h, 34h
db 5Bh,	34h, 79h, 34h, 66h, 31h, 91h, 34h
db 0B6h, 34h, 0D5h, 34h, 6, 35h, 0B6h, 34h
db 6, 35h, 66h,	31h, 2Dh, 35h, 57h, 35h
db 8Bh,	35h, 0C4h, 35h,	0FCh, 35h, 2Dh,	36h
db 5Bh,	36h, 0F0h, 37h,	66h, 31h, 0Ah, 38h
db 2Ah,	38h, 4Fh, 38h, 80h, 38h, 66h, 31h
db 95h,	36h, 0B7h, 36h,	0D4h, 36h, 66h,	31h
db 0F7h, 36h, 1Dh, 37h,	4Ah, 37h, 80h, 37h
db 9Ch,	37h, 0C0h, 37h,	93h, 3Ch, 0ACh,	3Ch
db 0C0h, 3Ch, 0C4h, 3Ch, 0D8h, 3Ch, 0EDh
db 3Ch,	0, 3Dh,	15h, 3Dh, 2Fh, 3Dh, 3Ch
db 3Dh,	58h, 3Dh, 6Ah, 3Dh, 84h, 3Dh, 90h
db 3Dh,	0A9h, 3Dh, 66h,	31h
byte_15F58 db 3
byte_15F59 db 7
word_15F5A dw 0
word_15F5C dw 0
align 4
word_15F60 dw 0
word_15F62 dw 0
word_15F64 dw 0
db 14h dup(0)
word_15F7A dw 0
word_15F7C dw 0
word_15F7E dw 0
word_15F80 dw 0
word_15F82 dw 0
align 8
word_15F88 dw 0
align 4
word_15F8C dw 0
word_15F8E dw 0
word_15F90 dw 0
byte_15F92 db 6	dup(0)
word_15F98 dw 0
word_15F9A dw 0
word_15F9C dw 0
dword_15F9E dd 0
word_15FA2 dw 0
db 2 dup(0)
word_15FA6 dw 0
word_15FA8 dw 0
dword_15FAA dd 0
dword_15FAE dd 0
dword_15FB2 dd 0
dword_15FB6 dd 0
db 0Ch dup(0)
db 6 dup(0)
db 9Bh dup(0)
aDos32aweDosExt	db 'DOS32AWE -- DOS Extender version x.'
db 'x.x',0Dh,0Ah
db 'Copyright (C) 1996-2006 by Narech K'
db '.',0Dh,0Ah
db 0Dh,0Ah
db 'AWEUTIL support V1.9 by George L',0Dh,0Ah
db 0Dh,0Ah
db 'DOS32AWE fatal (%w): ',0
aDos32aweWarnin	db 'DOS32AWE warning (%w): ',0
aDos32aweRunTim	db 'DOS32AWE run-time (%w): ',0
db 44h,	4Fh, 53h, 33h, 32h, 41h, 57h, 45h
db 3Dh,	51h, 55h, 49h, 45h, 54h
; START	OF FUNCTION CHUNK FOR sub_12FB5

loc_16130:
push	ax
push	dx
dec	cx
dec	si
push	sp

loc_16135:
push	bx
dec	di
push	bp
dec	si
inc	sp

loc_1613A:
inc	bp
pop	ax
push	sp
dec	bp
inc	bp
dec	bp
inc	sp
dec	di
push	bx
inc	dx
push	bp
inc	si
inc	sp
push	ax
dec	bp
dec	cx
push	sp
push	bx
push	sp
push	dx
inc	bp
push	bx
push	sp
dec	di
push	dx
inc	bp
dec	si
push	bp
dec	sp
dec	sp
push	ax
push	si
inc	bp
push	dx
inc	dx
dec	di
push	bx
inc	bp
dec	si
dec	di
push	di
inc	cx
push	dx
dec	si
dec	si
dec	di
inc	bx
xchg	bx, bx
nop
jz	short loc_161D6
; END OF FUNCTION CHUNK	FOR sub_12FB5
db 69h,	73h
word_16170 dw 7020h
db 72h,	6Fh
dword_16174 dd 6D617267h
aRequiresDos4_0	db ' requires DOS 4.0 or higher',0
db 38h,	30h, 33h, 38h, 36h, 20h, 70h, 72h
db 6Fh,	63h, 65h, 2 dup(73h), 6Fh, 72h,	20h
dword_161A4 dd 6220726Fh
dword_161A8 dd 65747465h
aRRequiredToRun	db 'r required to run protected mode',0
db 73h,	79h, 73h, 74h, 65h, 6Dh, 20h, 73h
db 6Fh
; START	OF FUNCTION CHUNK FOR sub_12FB5

loc_161D6:
db	66h
jz	short loc_16250
popa
jb	short loc_16241
and	[si+6Fh], ah
db	65h
jnb	short loc_16202
outsb
outsw
jz	short loc_16206
outsd
insb
insb
outsw
ja	short near ptr loc_1620C+1
push	si
inc	bx
push	ax
dec	cx
das
inc	sp
push	ax
dec	bp
dec	cx
and	[bp+di+70h], dh
arpl	gs:[bx+di+66h],	bp
imul	sp, [bp+di+61h], 6974h

loc_16202:
outsw
outsb
jnb	short $+2

loc_16206:
jo	short near ptr loc_16279+1
db	65h
jnb	short loc_16270
outsb

loc_1620C:
jz	short near ptr loc_1622D+1
inc	sp
push	ax
dec	bp
dec	cx
and	[bx+si+6Fh], ch
jnb	short loc_1628B
and	[si+6Fh], ah
db	65h
jnb	short near ptr loc_1623C+1
outsb
outsw
jz	short loc_16241
jnb	short near ptr loc_16297+1
jo	short loc_16295
outsw
jb	short loc_1629C
and	[bp+di], dh
xor	ah, [bp+si+69h]

loc_1622D:
jz	short near ptr loc_1624D+2
popa
jo	short near ptr loc_162A1+1
insb
imul	sp, [bp+di+61h], 6974h
outsw
outsb
jnb	short $+2

loc_1623C:
imul	bp, [bp+63h], 6D6Fh

loc_16241:
jo	short near ptr loc_162A3+1
jz	short loc_162AE
bound	bp, [si+65h]
and	[bp+43h], dl
push	ax
dec	cx

loc_1624D:
and	[bx+si+49h], dl

loc_16250:
inc	bx
and	[di+61h], ch
jo	short near ptr loc_162C4+2
imul	bp, [bp+67h], 73h
arpl	[bx+75h], bp
insb
and	fs:[bp+6Fh], ch
jz	short near ptr loc_16284+1
outs	dx, byte ptr gs:[si]
jz	short loc_162CE
jb	short loc_1628B
xor	si, [bp+si]
bound	bp, [bx+di+74h]

loc_16270:
and	[bx+si+72h], dh
outsw
jz	short loc_162DB
arpl	[si+65h], si

loc_16279:
and	fs:[di+6Fh], ch
db	64h
add	gs:[bp+di+6Fh],	ah
jnz	short loc_162F0

loc_16284:
and	fs:[bp+6Fh], ch
jz	short near ptr loc_162A8+2
popa

loc_1628B:
insb
insb
outsw
arpl	[bx+di+74h], sp
and	gs:[bp+di+79h],	dh

loc_16295:
jnb	short loc_1630B

loc_16297:
db	65h
insw
and	[bp+di+65h], dh

loc_1629C:
insb
arpl	gs:[si+6Fh], si

loc_162A1:
jb	short near ptr loc_16310+6

loc_162A3:
add	[bp+di+6Fh], ah
jnz	short near ptr loc_16310+4

loc_162A8:
and	fs:[bp+6Fh], ch
jz	short loc_162CE

loc_162AE:
outs	dx, byte ptr gs:[si]
popa
bound	bp, [si+65h]
and	[bx+di+32h], al
xor	[bx+si], ah
insb
imul	bp, [bp+65h], 5000h
insb
db	65h
popa
jnb	short loc_16329

loc_162C4:
and	[bp+si+75h], dh
outsb
and	[si+4Fh], al
push	bx
xor	si, [bp+si]

loc_162CE:
inc	cx
push	di
inc	bp
and	[di+6Eh], dh
db	64h, 65h
jb	short loc_162F8
push	dx
db	65h
popa

loc_162DB:
insb
and	[di+6Fh], cl
db	64h
and	gs:[si+4Fh], al
push	bx
and	[bx+6Eh], ch
insb
jns	short loc_1630B
sub	[bp+si+65h], dh
insw
outsw

loc_162F0:
jbe	short loc_16357
and	[di+4Dh], al
dec	bp
sub	[bx+si], ax

loc_162F8:
outsb
outsw
jz	short near ptr loc_1631B+1
outs	dx, byte ptr gs:[si]
outsw
jnz	short loc_16368
push	4420h
dec	di
push	bx
and	[di+65h], ch
insw
outsw

loc_1630B:
jb	short near ptr loc_16384+2
sub	al, 20h	; ' '
popa

loc_16310:
db	64h
imul	si, fs:[si+69h], 6E6Fh
popa
insb
and	[di], ah

loc_1631B:
db	64h
dec	bx
inc	dx
and	[bp+65h], ch
db	65h, 64h, 65h
add	fs:[si+4Fh], al
push	bx

loc_16329:
and	[bp+si+65h], dh
jo	short near ptr loc_1639C+1
jb	short loc_163A4
db	65h
and	fs:[bx+di+6Eh],	ch
jnb	short near ptr loc_163AB+1
db	66h, 66h
imul	sp, [bp+di+69h], 6E65h
jz	short near ptr loc_1635F+1
insw
db	65h
insw
outsw
jb	short near ptr loc_163BC+3
add	[bx+di+6Eh], ch
jbe	short near ptr loc_163AB+1
insb
imul	sp, [si+20h], 6E65h
jbe	short loc_163BC
jb	short near ptr loc_163C3+1
outsb
insw

loc_16357:
outs	dx, byte ptr gs:[si]
jz	short $+2
arpl	[bx+75h], bp
insb

loc_1635F:
and	fs:[bp+6Fh], ch
jz	short near ptr loc_16384+1
outsw
jo	short loc_163CD

loc_16368:
outsb
and	[di+78h], ah
arpl	gs:[bx+si], sp
imul	ebp, [si+65h], 73252220h
and	al, [bx+si]
db	65h
jb	short near ptr loc_163ED+1
outsw
jb	short loc_1639F
imul	bp, [bp+20h], 7865h

loc_16384:
arpl	gs:[bx+si], sp
imul	ebp, [si+65h], 73252220h
and	al, [bx+si]
arpl	[bx+75h], bp
insb
and	fs:[bp+6Fh], ch
jz	short near ptr loc_163BA+1
outsw

loc_1639C:
jo	short loc_16403
outsb

loc_1639F:
and	[bx+di+70h], ah
jo	short loc_16410

loc_163A4:
imul	sp, [bp+di+61h], 6974h
outsw
outsb

loc_163AB:
and	[bp+69h], ah
insb
and	gs:[bp+si], ah
and	ax, 2273h
add	[di+72h], ah
jb	short loc_16429

loc_163BA:
jb	short near ptr loc_163DB+1

loc_163BC:
imul	bp, [bp+20h], 7061h
jo	short loc_1642F

loc_163C3:
imul	sp, [bp+di+61h], 6974h
outsw
outsb
and	[bp+69h], ah

loc_163CD:
insb
and	gs:[bp+si], ah
and	ax, 2273h
add	[bp+69h], ah
insb
and	gs:[bp+si], ah

loc_163DB:
and	ax, 2273h
and	[si+6Fh], ah
db	65h
jnb	short loc_16404
outsb
outsw
jz	short near ptr loc_16406+2
arpl	[bx+6Eh], bp
jz	short near ptr loc_1644C+2

loc_163ED:
imul	bp, [bp+20h], 6E61h
jns	short loc_16414
jbe	short near ptr loc_16456+1
insb
imul	sp, [si+20h], 7865h
arpl	gs:[bx+si], sp
outsd
jb	short near ptr loc_1646F+1

loc_16403:
popa

loc_16404:
jz	short $+2

loc_16406:
db	65h
js	short near ptr loc_1646C+2
arpl	[bx+si], sp
outsd
jb	short near ptr loc_16479+3
popa

loc_16410:
jz	short near ptr loc_16430+2
outsb
outsw

loc_16414:
jz	short loc_16436
jnb	short loc_1648D
jo	short loc_1648A
outsw
jb	short loc_16491
db	65h
and	fs:[bx+di+6Eh],	ch
and	[bp+69h], ah
insb
and	gs:[bp+si], ah

loc_16429:
and	ax, 2273h
add	[si+6Fh], dh

loc_1642F:
outsw

loc_16430:
and	[di+61h], ch
outsb
jns	short loc_16456

loc_16436:
outsw
bound	bp, [bp+si+65h]
arpl	[si+73h], si
and	[bx+di+6Eh], ch
and	[bx+di+70h], ah
jo	short near ptr loc_164B0+1
imul	sp, [bp+di+61h], 6974h
outsw
outsb

loc_1644C:
and	[di+78h], ah
arpl	gs:[bx+si], sp
and	ah, [di]
jnb	short near ptr loc_16477+1

loc_16456:
add	[bp+6Fh], ch
jz	short near ptr loc_16479+2
outs	dx, byte ptr gs:[si]
outsw
jnz	short near ptr loc_164C6+1
push	4420h
dec	di
push	bx
and	[di+65h], ch
insw
outsw
jb	short loc_164E5

loc_1646C:
and	[si+6Fh], dh

loc_1646F:
and	[si+6Fh], ch
popa
and	fs:[bx+di+70h],	ah

loc_16477:
jo	short loc_164E5

loc_16479:
imul	sp, [bp+di+61h], 6974h
outsw
outsb
and	[di+78h], ah
arpl	gs:[bx+si], sp
and	ah, [di]
jnb	short loc_164AC

loc_1648A:
add	[bp+6Fh], ch

loc_1648D:
jz	short near ptr loc_164AC+3
outs	dx, byte ptr gs:[si]

loc_16491:
outsw
jnz	short loc_164FB
push	6520h
js	short near ptr loc_16509+4
outs	dx, byte ptr gs:[si]
db	64h, 65h
and	fs:[di+65h], ch
insw
outsw
jb	short near ptr loc_1651B+3
and	[si+6Fh], dh
and	[si+6Fh], ch
popa

loc_164AC:
and	fs:[bx+di+70h],	ah

loc_164B0:
jo	short near ptr loc_1651B+3
imul	sp, [bp+di+61h], 6974h
outsw
outsb
and	[di+78h], ah
arpl	gs:[bx+si], sp
and	ah, [di]
jnb	short loc_164E5
add	[bp+6Fh], ch

loc_164C6:
jz	short near ptr loc_164E5+3
outs	dx, byte ptr gs:[si]
outsw
jnz	short near ptr loc_16532+2
push	6520h
js	short near ptr loc_16542+4
outs	dx, byte ptr gs:[si]
db	64h, 65h
and	fs:[di+65h], ch
insw
outsw
jb	short near ptr loc_16556+1
and	[si+6Fh], dh
and	[si+6Fh], ch
popa

loc_164E5:
and	fs:[bp+69h], ah
js	short near ptr loc_1655F+1
jo	short near ptr loc_1655F+1
and	[bp+6Fh], ah
jb	short near ptr loc_16511+1
db	65h
js	short loc_1655A
arpl	[bx+si], sp
and	ah, [di]
jnb	short near ptr loc_1651B+2

loc_164FB:
add	[di+6Eh], dh
jb	short near ptr loc_16564+1
arpl	[bx+67h], bp
outsb
imul	di, [bp+si+65h], 2064h

loc_16509:
imul	edi, [bx+si+75h], 61642070h

loc_16511:
jz	short loc_16574
and	[bx+di+6Eh], ch
and	[bx+di+70h], ah
jo	short near ptr loc_16586+1

loc_1651B:
imul	sp, [bp+di+61h], 6974h
outsw
outsb
and	[di+78h], ah
arpl	gs:[bx+si], sp
and	ah, [di]
jnb	short loc_1654E
add	[bx+di], dh
bound	bp, ss:[bx+di+74h]

loc_16532:
and	[bp+69h], ah
js	short loc_165AC
jo	short near ptr loc_16558+1
outsw
jbe	short loc_165A1
jb	short loc_165A4
insb
outsw
ja	short loc_16562

loc_16542:
imul	bp, [bp+20h], 7061h
jo	short near ptr loc_165B4+1
imul	sp, [bp+di+61h], 6974h

loc_1654E:
outsw
outsb
and	[di+78h], ah
arpl	gs:[bx+si], sp

loc_16556:
and	ah, [di]

loc_16558:
jnb	short loc_1657C

loc_1655A:
add	[bp+6Fh], ch
jz	short near ptr loc_1657D+2

loc_1655F:
outs	dx, byte ptr gs:[si]
outsw

loc_16562:
jnz	short loc_165CB

loc_16564:
push	4420h
dec	di
push	bx
and	[si+72h], dl
popa
outsb
jnb	short loc_165D6
db	65h
jb	short near ptr loc_16592+1
inc	dx

loc_16574:
jnz	short near ptr loc_165DB+1
db	66h, 65h
jb	short loc_1659A
jnb	short loc_165EC

loc_1657C:
popa

loc_1657D:
arpl	[di+20h], sp
jz	short near ptr loc_165F0+1
and	[si+6Fh], ch
popa

loc_16586:
and	fs:[si+43h], cl
sub	ax, 7865h
arpl	gs:[bx+si], sp
and	ah, [di]

loc_16592:
jnb	short loc_165B6
add	[bp+di+79h], dh
outsb
jz	short near ptr loc_165F9+2

loc_1659A:
js	short near ptr loc_165BA+2
imul	si, [bp+di+20h], 4F44h

loc_165A1:
push	bx
xor	si, [bp+si]

loc_165A4:
inc	cx
push	di
inc	bp
and	[si], bh
db	65h
js	short loc_16611

loc_165AC:
arpl	[bp+61h], bp
insw
db	65h
hnt js	short near ptr loc_1662B+1

loc_165B4:
js	short near ptr loc_165F2+2

loc_165B6:
add	[si+4Fh], al
push	bx

loc_165BA:
and	[bp+si+65h], dh
jo	short loc_1662E
jb	short near ptr loc_16633+2
db	65h
and	fs:[bx+di+6Eh],	ah
and	[di+72h], ah
jb	short near ptr loc_16638+2

loc_165CB:
jb	short near ptr loc_165EC+1
sub	[bp+di], ah
and	ax, 6877h
sub	[bx+si], ax
inc	sp
push	ax

loc_165D6:
dec	bp
dec	cx
and	[bx+si+6Fh], ch

loc_165DB:
jnb	short loc_16651
and	[bp+si+65h], dh
jo	short loc_16651
jb	short loc_16658
db	65h
and	fs:[bx+di+6Eh],	ah
and	[di+72h], ah

loc_165EC:
jb	short near ptr loc_1665C+1
jb	short near ptr loc_1660E+2

loc_165F0:
sub	[bp+di], ah

loc_165F2:
and	ax, 6877h
sub	[bx+si], ax
outsb
outsw

loc_165F9:
and	[di+78h], ah
jz	short loc_16663
outsb
db	64h, 65h
and	fs:[di+65h], ch
insw
outsw
jb	short loc_16682
and	[bx+si+61h], ch
jnb	short loc_1662E

loc_1660E:
bound	sp, [di+65h]

loc_16611:
outsb
and	[bx+di+6Ch], ah
insb
outsw
arpl	[bx+di+74h], sp
db	65h
add	fs:[bx+si+49h],	dl
inc	bx
jnb	short near ptr loc_16641+1
push	7661h
and	gs:[bp+si+65h],	ah
outs	dx, byte ptr gs:[si]

loc_1662B:
and	[bp+si+65h], dh

loc_1662E:
insb
outsw
arpl	[bx+di+74h], sp

loc_16633:
db	65h
and	fs:[si+6Fh], dh

loc_16638:
and	[bx+di+4Eh], cl
push	sp
and	[di], ah
bound	bp, [bx+si+2Ch]

loc_16641:
and	[bx+di+4Eh], cl
push	sp
and	[di], ah
bound	bp, [bx+si+0]
jb	short loc_166B1
popa
insb
and	[di+6Fh], ch

loc_16651:
db	64h
and	gs:[bx+di+6Eh],	ch
jz	short loc_166BD

loc_16658:
jb	short loc_166CC
jnz	short loc_166CC

loc_1665C:
jz	short near ptr loc_1667D+1
jbe	short loc_166C5
arpl	[si+6Fh], si

loc_16663:
jb	short near ptr loc_16684+1
push	7361h
and	[bp+si+65h], ah
outs	dx, byte ptr gs:[si]
and	[di+6Fh], ch
imul	sp, fs:[bp+69h], 6465h
cmp	ah, [bx+si]
dec	cx
dec	si
push	sp
and	[di], ah

loc_1667D:
bound	bp, [bx+si+0]
insw
outsw

loc_16682:
jnz	short loc_166F7

loc_16684:
and	gs:[bx+di+6Eh],	ch
imul	si, [si+69h], 6C61h
imul	di, [bp+si+61h], 6974h
outsw
outsb
and	[bp+61h], ah
imul	bp, [si+65h], 64h
outsw
bound	bp, [bp+si+65h]
arpl	[si+20h], si
and	sp, [di]
and	fs:[bp+di+6Fh],	ah
outsb
jz	short near ptr loc_1670C+1
imul	bp, [bp+73h], 6E20h

loc_166B1:
outsw
and	[si+61h], ah
jz	short loc_16718
and	[bx+72h], ch
and	[bp+di+6Fh], ah

loc_166BD:
db	64h
add	gs:[bx+di+6Eh],	ch
arpl	[bx+6Dh], bp

loc_166C5:
jo	short near ptr loc_16726+2
jz	short near ptr loc_1672F+3
bound	bp, [si+65h]

loc_166CC:
and	[bp+65h], dh
jb	short loc_16744
imul	bp, [bx+6Eh], 6F20h
db	66h
and	[si+4Fh], al
push	bx
das
xor	si, [bp+si]
inc	cx
and	[bx+di+6Ch], ah
jb	short near ptr loc_16747+2
popa
db	64h
jns	short near ptr loc_16706+2
jb	short near ptr loc_1675E+1
outsb
outsb
imul	bp, [bp+67h], 7500h
outsb
imul	bp, [bp+6Fh], 77h
outsb

loc_166F7:
and	[di+72h], ah
jb	short near ptr loc_1676A+1
jb	short near ptr loc_1671D+1
arpl	[bx+64h], bp
and	gs:[bx+si], ch
and	sp, [di]

loc_16706:
bound	bp, [bx+si+29h]
add	[bx+75h], ch

loc_1670C:
jz	short loc_1672E
outsw
db	66h
and	[bp+si+65h], dh
popa
insb
sub	ax, 6F6Dh

loc_16718:
db	64h
and	gs:[bp+69h], dh

loc_1671D:
jb	short loc_16793
jnz	short loc_16782
insb
and	[bp+di+74h], dh
popa

loc_16726:
arpl	[bp+di+73h], bp
add	[bx+75h], ch
jz	short loc_1674E

loc_1672E:
outsw

loc_1672F:
db	66h
and	[bx+si+72h], dh
outsw
jz	short near ptr loc_1679A+1
arpl	[si+65h], si
db	64h
sub	ax, 6F6Dh
db	64h
and	gs:[bp+69h], dh
jb	short near ptr loc_167B6+2

loc_16744:
jnz	short loc_167A7
insb

loc_16747:
and	[bp+di+74h], dh
popa
arpl	[bp+di+73h], bp

loc_1674E:
add	[di+78h], ah
jz	short near ptr loc_167B6+2
outsb
db	64h, 65h
and	fs:[di+65h], ch
insw
outsw
jb	short near ptr loc_167D6+1

loc_1675E:
and	[bp+si+6Ch], ah
outsw
arpl	[bp+di+73h], bp
and	[bx+si+61h], ch
jbe	short loc_167CF

loc_1676A:
and	[bp+si+65h], ah
outs	dx, byte ptr gs:[si]
and	[bp+di+6Fh], ah
jb	short loc_167E6
jnz	short loc_167E6
jz	short near ptr loc_167DC+1
and	fs:[bx+si], ch
and	sp, [di]
insb
sub	[bx+si], ax
inc	sp
dec	di

loc_16782:
push	bx
das
xor	al, 47h
and	[bx+di+50h], al
dec	cx
and	[bp+di+61h], ah
insb
insb
jnb	short loc_167B1
outsb
outsw

loc_16793:
jz	short near ptr loc_167B4+1
jnb	short loc_1680C
jo	short loc_16809
outsw

loc_1679A:
jb	short near ptr loc_1680F+1
db	65h
add	fs:[bx+si+72h],	dl
outsw
arpl	[di+73h], sp
jnb	short near ptr loc_16814+2

loc_167A7:
jb	short loc_167E3
and	[di], ah
db	64h
sub	al, 20h	; ' '
push	bx
jns	short near ptr loc_16823+1

loc_167B1:
jz	short near ptr loc_16817+1
insw

loc_167B4:
cmp	ah, [bx+si]

loc_167B6:
and	ax, 2C73h
and	[di+65h], cl
insw
outsw
jb	short loc_16839
cmp	ah, [bx+si]
inc	sp
dec	di
push	bx
cmp	ax, 6425h
dec	bx
inc	dx
sub	al, 20h	; ' '
inc	sp
push	ax
dec	bp

loc_167CF:
dec	cx
cmp	ax, 6425h
and	ax, 0D73h

loc_167D6:
or	al, [bx+si]
dec	si
dec	di
dec	si
inc	bp

loc_167DC:
add	[bx+si+4Dh], bl
push	bx
; END OF FUNCTION CHUNK	FOR sub_12FB5
db 2 dup(0), 56h
; START	OF FUNCTION CHUNK FOR sub_12FB5

loc_167E3:
inc	bx
push	ax
dec	cx

loc_167E6:
add	[si+50h], al
dec	bp
dec	cx
add	[si+45h], cl
add	[si+58h], cl
add	[si+43h], cl
add	[bx+si+45h], dl
add	[bp+di+42h], cl
add	[di+42h], cl
add	[si+6Fh], cl
popa
imul	bp, fs:[bp+67h], 7020h
jb	short near ptr loc_16877+1

loc_16809:
db	67h
jb	near ptr loc_1686C+1

loc_1680C:
insw
and	[bp+si], ah

loc_1680F:
and	ax, 2273h
sub	al, 20h	; ' '

loc_16814:
and	ax, 2D73h

loc_16817:
jnb	short near ptr loc_1688B+2
jns	short near ptr loc_16885+2
db	65h
or	ax, 0Ah
dec	di
bound	bp, [bp+si+65h]

loc_16823:
arpl	[si+20h], si
and	sp, [di]
and	fs:[si+6Fh], ch
popa
db	64h, 65h
and	fs:[bx+di+74h],	ah
and	[di], ah
insb
sub	al, 20h	; ' '
push	si

loc_16839:
das
push	ax
jnb	short loc_168A6
jp	short loc_168A4
cmp	ah, [bx+si]
and	ax, 2F6Ch
and	ax, 2C6Ch
and	[bp+6Ch], al
popa
db	67h
jnb	loc_1688B
and	ax, 2C77h
and	[bp+di+65h], dl
insb
cmp	ax, 7725h
or	ax, 0Ah
push	bx
jz	short loc_168BF
jb	short loc_168D4
jnz	short near ptr loc_168D1+1
and	[bp+di+53h], al
cmp	al, [di+49h]
push	ax
cmp	ax, 7725h

loc_1686C:
cmp	ah, [di]
insb
sub	al, 20h	; ' '
push	bx
push	bx
cmp	al, [di+53h]
push	ax

loc_16877:
cmp	ax, 7725h
cmp	ah, [di]
insb
sub	al, 20h	; ' '
and	ax, 2073h
inc	bp
dec	cx
push	ax

loc_16885:
cmp	ax, 6425h
cmp	ah, [di]
insb

loc_1688B:
or	ax, 4D0Ah
db	65h
insw
outsw
jb	short near ptr loc_1690B+1
and	[si+65h], ch
db	66h
jz	short near ptr loc_168D1+2
and	[si+4Fh], al
push	bx
cmp	ax, 6425h
dec	bx
inc	dx
sub	al, 20h	; ' '

loc_168A4:
inc	sp
push	ax

loc_168A6:
dec	bp
dec	cx
cmp	ax, 6425h
and	ax, 2E73h
and	[bx+si+53h], dl
push	ax
pop	di
push	bx
db	65h
insb
cmp	ax, 7725h
sub	al, 20h	; ' '
inc	bp
outsb
jbe	short loc_1691E

loc_168BF:
push	bx
db	65h
insb
cmp	ax, 7725h
sub	al, 20h	; ' '
inc	bp
outsb
jbe	short near ptr loc_16929+1
push	bx
db	65h, 67h
cmp	ax, 7725h

loc_168D1:
or	ax, 0Ah

loc_168D4:
db	65h
js	short near ptr loc_16939+1
db	65h
jo	short near ptr loc_1694B+3
imul	bp, [bx+6Eh], 7500h
outsb
db	65h
js	short loc_16953
arpl	gs:[si+65h], si
and	fs:[bx+di+6Eh],	ch
jz	short near ptr loc_16950+2
jb	short near ptr loc_1695F+2
jnz	short near ptr loc_1695F+2
jz	short $+2
and	ax, 2073h
and	ax, 6862h
or	ax, 490Ah
db	64h
outs	dx, byte ptr gs:[si]
jz	short loc_1696A
jz	short loc_1697C
cmp	ah, [bx+si]
and	ax, 2073h
popa
jz	short loc_1692B

loc_1690B:
and	ax, 3A77h
and	ax, 0D6Ch
or	al, [bx+si]
and	ax, 2073h
arpl	[bp+si+61h], si
jnb	short loc_16983
and	[bx+di+64h], ah

loc_1691E:
db	64h
jb	short loc_16986
jnb	short loc_16996
and	[di], ah
cmp	ah, fs:[di]
insb

loc_16929:
add	[si], ch

loc_1692B:
and	[di+72h], ah
jb	short near ptr loc_1699D+2
jb	short near ptr loc_16950+2
arpl	[bx+64h], bp
and	gs:[bx+si+75h],	dh

loc_16939:
jnb	short loc_169A3
db	65h
and	fs:[bx+6Eh], ch
and	[bp+di+74h], dh
popa
arpl	[bp+di+20h], bp
and	ax, 6Ch
dec	sp

loc_1694B:
imul	bp, [bp+65h], 7261h

loc_16950:
add	[di+6Eh], dl

loc_16953:
jb	short loc_169BA
insb
outsw
arpl	[bx+di+74h], sp
db	65h
add	fs:[di+6Fh], cl

loc_1695F:
db	64h
jnz	short near ptr loc_169CC+2
and	gs:[bp+61h], ch
insw
cmp	ah, gs:[bx+si]

loc_1696A:
and	ah, [di]
jnb	short near ptr loc_1698F+1
sub	al, 20h	; ' '
push	ax
jb	short loc_169E2
arpl	[di+73h], sp
jnb	short near ptr loc_169C0+1
db	64h
cmp	ax, 7725h

loc_1697C:
or	ax, 0Ah
dec	si
jnz	short loc_169EE
insb

loc_16983:
sub	ax, 6F70h

loc_16986:
imul	bp, [bp+74h], 7265h
and	[bx+si+72h], dh
outsw

loc_1698F:
jz	short near ptr loc_169F5+1
arpl	[si+69h], si
outsw
outsb

loc_16996:
and	[bx+di+74h], ah
and	[di], ah
ja	short near ptr loc_169D5+2

loc_1699D:
and	ax, 0D6Ch
or	al, [bx+si]
inc	bp

loc_169A3:
inc	si
dec	sp
inc	cx
inc	di
push	bx
and	[di], bh
and	[di], ah
insb
and	[bp+di+25h], bl
insb
db	2Eh
and	ax, 5D6Ch
and	[bx+si], ah
add	[bp+di+53h], al

loc_169BA:
cmp	bl, [bp+di+45h]
dec	cx
push	ax
pop	bp

loc_169C0:
and	[di], bh
and	[di], ah
bound	sp, [bx+si]
and	ax, 2062h
and	ax, 2062h

loc_169CC:
and	ax, 2062h
and	ax, 2062h
and	ax, 2062h

loc_169D5:
and	ax, 2062h
and	ax, 2062h
and	ax, 2062h
and	ax, 62h
inc	bp

loc_169E2:
inc	cx
pop	ax
and	[di], bh
and	[di], ah
insb
and	[bx+si], ah
and	[bx+si], ah
inc	bp

loc_169EE:
push	bx
dec	cx
and	[di], bh
and	[di], ah
insb

loc_169F5:
and	[bx+si], ah
and	[bx+si], ah
and	[bx+si], ah
and	[si+52h], al
and	ss:[di], bh
and	[di], ah
insb
and	[bx+si], ah
and	[bx+si], ah
push	bx
push	bx
cmp	bl, [bp+di+45h]
push	bx
push	ax
sub	si, [bx+si]
xor	[di+20h], bl
cmp	ax, 2520h
insb
or	ax, 0Ah
inc	bp
inc	dx
pop	ax
and	[di], bh
and	[di], ah
insb
and	[bx+si], ah
and	[bx+si], ah
inc	bp
inc	sp
dec	cx
and	[di], bh
and	[di], ah
insb
and	[bx+si], ah
and	[bx+si], ah
and	[bx+si], ah
and	[bp+di+52h], al
xor	[bx+si], ah
cmp	ax, 2520h
insb
and	[bx+si], ah
and	[bx+si], ah
push	bx
push	bx
cmp	bl, [bp+di+45h]
push	bx
push	ax
sub	si, [bx+si]
xor	al, 5Dh
and	[di], bh
and	[di], ah
insb
or	ax, 0Ah
inc	bp
inc	bx
pop	ax
and	[di], bh
and	[di], ah
insb
and	[bx+si], ah
and	[bx+si], ah
inc	bp
inc	dx
push	ax
and	[di], bh
and	[di], ah
insb
and	[bx+si], ah
and	[bx+si], ah
and	[bx+si], ah
and	[bp+di+52h], al
xor	ah, [bx+si]
cmp	ax, 2520h
insb
and	[bx+si], ah
and	[bx+si], ah
push	bx
push	bx
cmp	bl, [bp+di+45h]
push	bx
push	ax
sub	si, [bx+si]
cmp	[di+20h], bl
cmp	ax, 2520h
insb
or	ax, 0Ah
inc	bp
inc	sp
pop	ax
and	[di], bh
and	[di], ah
insb
and	[bx+si], ah
and	[bx+si], ah
inc	bp
push	bx
push	ax
and	[di], bh
and	[di], ah
insb
and	[bx+si], ah
and	[bx+si], ah
and	[bx+si], ah
and	[bp+di+52h], al
xor	sp, [bx+si]
cmp	ax, 2520h
insb
and	[bx+si], ah
and	[bx+si], ah
push	bx
push	bx
cmp	bl, [bp+di+45h]
push	bx
push	ax
sub	si, [bx+si]
inc	bx
pop	bp
and	[di], bh
and	[di], ah
insb
or	ax, 0Ah
dec	cx
outsb
jbe	short loc_16B2E
insb
imul	sp, [si+20h], 6573h
insb
arpl	gs:[si+6Fh], si
jb	short $+2
dec	si
push	bp
dec	sp
dec	sp
and	[bp+di+65h], dh
insb
arpl	gs:[si+6Fh], si
jb	short $+2
inc	bx
push	bx
cmp	ah, [bx+si]
cmp	ax, 2520h
ja	short near ptr loc_16B10+1
and	[bx+si], al
inc	sp
push	bx
cmp	ah, [bx+si]
cmp	ax, 2520h
ja	short near ptr loc_16B1B+1
and	[bx+si], al
inc	bp
push	bx
cmp	ah, [bx+si]
cmp	ax, 2520h
ja	short near ptr loc_16B26+1
and	[bx+si], al
push	bx
push	bx
cmp	ah, [bx+si]
cmp	ax, 2520h

loc_16B10:
ja	short near ptr loc_16B31+1
and	[bx+si], al
inc	si
push	bx
cmp	ah, [bx+si]
cmp	ax, 2520h

loc_16B1B:
ja	short loc_16B3D
and	[bx+si], al
inc	di
push	bx
cmp	ah, [bx+si]
cmp	ax, 2520h

loc_16B26:
ja	short loc_16B48
and	[bx+si], al
inc	dx
popa
jnb	short near ptr loc_16B91+2

loc_16B2E:
cmp	ax, 6C25h

loc_16B31:
and	[si+69h], cl
insw
imul	si, [si+3Dh], 6C25h
and	[bx+72h], al

loc_16B3D:
cmp	ax, 7325h
and	[bp+di+65h], dl
db	67h
cmp	ax, 7325h
das

loc_16B48:
and	ax, 6264h
imul	si, [si+20h], 7954h
jo	short loc_16BB7
cmp	ax, 6425h
and	[bx+di+63h], al
arpl	[di], di
and	ax, 0D77h
or	al, [bx+si]
inc	dx
pop	cx
push	sp
inc	bp
add	[bx+si+41h], dl
inc	di
inc	bp
add	[si+41h], al
push	sp
inc	cx
add	[bp+di+4Fh], al
inc	sp
inc	bp
add	[bp+di+45h], cl
push	dx
dec	si
inc	bp
dec	sp
cmp	ax, 4300h
dec	sp
dec	cx
inc	bp
dec	si
push	sp
cmp	ax, 4100h
push	ax
push	ax
das
xor	si, [bp+si]
cmp	ax, 4100h
push	ax
push	ax
das
aas
aas

loc_16B91:
cmp	ax, 6900h
outsb
jz	short loc_16BFC
db	67h, 65h
jb	near ptr loc_16BB9+2
imul	si, fs:[bp+69h], 6973h
outsw
outsb
and	[bp+si+79h], ah
and	[bp+si+65h], bh
jb	short loc_16C1A
add	[bx+si+61h], ch
jb	short near ptr loc_16C13+1
ja	short loc_16C13
jb	short near ptr loc_16C18+1
and	[bp+si+72h], ah

loc_16BB7:
db	65h
popa

loc_16BB9:
imul	si, [bx+si+6Fh], 69h
outsb
jz	short $+2
dec	si
dec	bp
dec	cx
add	[bp+di+6Fh], dh
db	66h
jz	short near ptr loc_16C3F+1
popa
jb	short loc_16C31
and	[bp+si+72h], ah
db	65h
popa
imul	si, [bx+si+6Fh], 69h
outsb
jz	short $+2
outsw
jbe	short near ptr loc_16C3F+1
jb	short near ptr loc_16C41+2
insb
outsw
ja	short near ptr loc_16C00+1
arpl	[bx+si+65h], bp
arpl	[bp+di+20h], bp
popad
jnz	short loc_16C57
jz	short $+2
bound	bp, [bx+75h]
outsb
db	64h
jnb	short near ptr loc_16C13+1
arpl	[bx+si+65h], bp
arpl	[bp+di+20h], bp
popad

loc_16BFC:
jnz	short loc_16C6A
jz	short $+2

loc_16C00:
imul	bp, [bp+76h], 6C61h
imul	sp, [si+20h], 706Fh
arpl	[bx+64h], bp
and	gs:[bp+61h], ah
jnz	short near ptr loc_16C7E+1

loc_16C13:
jz	short $+2
arpl	[bx+70h], bp

loc_16C18:
jb	short near ptr loc_16C87+2

loc_16C1A:
arpl	[di+73h], sp
jnb	short loc_16C8E
jb	short loc_16C41
outsb
outsw
jz	short near ptr loc_16C44+1
popa
jbe	short near ptr loc_16C87+2
imul	bp, [si+61h], 6C62h
add	gs:[si+6Fh], ah

loc_16C31:
jnz	short near ptr loc_16C93+2
insb
and	gs:[bp+61h], ah
jnz	short near ptr loc_16CA5+1
jz	short $+2
arpl	[bx+70h], bp

loc_16C3F:
jb	short loc_16CB0

loc_16C41:
arpl	[di+73h], sp

loc_16C44:
jnb	short near ptr loc_16CB4+1
jb	short loc_16C68
jnb	short near ptr loc_16CAB+4
ins	word ptr es:[edi], dx
outs	dx, byte ptr gs:[si]
jz	short loc_16C70
outsw
jbe	short loc_16CB8
jb	short near ptr 3DC7h
jnz	short near ptr 3DC5h

loc_16C57:
add	[bx+di+6Eh], ch
jbe	short near ptr loc_16CBC+1
insb
imul	sp, [si+20h], 5354h
push	bx
and	[bp+61h], ah
jnz	short near ptr 3DD4h

loc_16C68:
jz	short $+2

loc_16C6A:
jnb	short near ptr 3DD1h
ins	word ptr es:[edi], dx
outs	dx, byte ptr gs:[si]

loc_16C70:
jz	short near ptr loc_16C90+2
outsb
outsw
jz	short loc_16C96
jo	short near ptr 3DEAh
db	65h
jnb	short near ptr 3DE0h
outsb
jz	short near ptr loc_16C9D+1

loc_16C7E:
popad
jnz	short near ptr 3DEEh
jz	short $+2
jnb	short near ptr 3DFAh
popa

loc_16C87:
arpl	[bp+di+20h], bp
popad
jnz	short near ptr 3DFAh

loc_16C8E:
jz	short $+2

loc_16C90:
outs	dx, byte ptr gs:[esi]

loc_16C93:
db	65h
jb	short near ptr 3DF7h

loc_16C96:
insb
and	[bx+si+72h], dh
outsw
jz	short near ptr 3E02h

loc_16C9D:
arpl	[si+69h], si
outsw
outsb
and	[bp+61h], ah

loc_16CA5:
jnz	short near ptr 3E13h
jz	short $+2
jo	short near ptr 3E0Ch

loc_16CAB:
and	gs:[esi+61h], ah

loc_16CB0:
jnz	short near ptr 3E1Eh
jz	short $+2

loc_16CB4:
xchg	bx, bx
xchg	bx, bx

loc_16CB8:
xchg	bx, bx
xchg	bx, bx

loc_16CBC:
xchg	bx, bx
xchg	bx, bx
; END OF FUNCTION CHUNK	FOR sub_12FB5
seg002 ends


; Segment type:	Uninitialized
seg003 segment byte stack 'STACK' use16
assume cs:seg003
assume es:nothing, ss:nothing, ds:nothing, fs:nothing, gs:nothing
db 800h	dup(?)
seg003 ends


end start
