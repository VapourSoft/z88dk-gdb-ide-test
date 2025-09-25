; CP/M Z80 debugging practice program (for z88dk +cpm, .COM @ 0x0100 via CRT)
; Features:
; - Nested calls (step into/over): nested_1 -> nested_2 -> nested_3
; - Conditional branches (JR C / JR NC)
; - Loop (DJNZ) summing 1..N
; - Basic math and memory writes (counter)
; - Console output via BDOS (function 9 for string, 2 for char)
; Entry point is _main (z88dk CRT calls this). No manual ORG needed when
; linking with the CP/M CRT (-lndos); the CRT sets ORG 0x0100.

	SECTION CODE
	PUBLIC _main
	XDEF   _main

	SECTION BSS
	PUBLIC _counter
	XDEF   _counter
_counter:
	DEFS 1			; 1-byte counter for side effects

	SECTION DATA
msg_counter:	DEFB "Counter: ", '$'
msg_sum:		DEFB "Sum(L): ", '$'
msg_demo:		DEFB "Cond demo(A): ", '$'

	SECTION CODE
; --- BDOS helpers ---
; print_str: DE points to $-terminated string
print_str:
	push af
	push bc
	ld c,9
	call 5			; BDOS 9: print until '$'
	pop bc
	pop af
	ret

; print_char: A = character
print_char:
	push bc
	push de
	ld e,a
	ld c,2
	call 5			; BDOS 2: print E
	pop de
	pop bc
	ret

; nibble_to_hex: A = 0..15, returns ASCII hex in A
nibble_to_hex:
	add a,'0'
	cp '9'+1
	ret c
	add a,7			; adjust to 'A'
	ret

; print_hex8: prints A as two hex digits
print_hex8:
	push af
	push af
	and $F0
	rrca
	rrca
	rrca
	rrca
	call nibble_to_hex
	call print_char
	pop af
	and $0F
	call nibble_to_hex
	call print_char
	pop af
	ret

; print_crlf: prints CR LF
print_crlf:
	ld a,13
	call print_char
	ld a,10
	call print_char
	ret

; --- Demo helpers ---
; inc_counter: ++_counter
inc_counter:
	ld hl,_counter
	inc (hl)
	ret

; sum_1_to_n: input A=n, output HL = 1+2+..+n (loop + conditionals)
sum_1_to_n:
	ld b,a			; B = n
	xor a			; A=0 (not used for sum)
	ld hl,0
sum_loop:
	ld a,l
	add a,b
	ld l,a
	jr nc,no_carry
	inc h
no_carry:
	djnz sum_loop
	ret

; cond_demo: input A; if A < 0x20 then A+=0x80 else A-=0x10
cond_demo:
	cp $20
	jr c,lt_path
	sub $10
	ret
lt_path:
	add a,$80
	ret

; nested call chain to practice step-into/step-over
nested_1:
	push af
	call nested_2
	pop af
	ret

nested_2:
	push af
	call nested_3
	pop af
	ret

nested_3:
	xor $55			; simple mutation of A
	ret

forever:
	nop
	nop
	nop
	jr forever		; infinite loop to prevent running into unknown code

; --- Program entry (called by z88dk CP/M CRT) ---
_main:
	; preserve some registers commonly used
	push bc
	push de
	push hl

	; side-effects to watch in memory
	call inc_counter
	call inc_counter

	; simple math with loop and conditions
	ld a,5
	call sum_1_to_n	; HL = 1+..+5 = 0x000F
	ld a,l			; A = low byte
	call cond_demo	; tweak A through conditional path
	call nested_1	; demonstrate nested calls

	; print counter value
	ld de,msg_counter
	call print_str
	ld a,(_counter)
	call print_hex8
	call print_crlf

	; print sum/demo value (A)
	ld de,msg_demo
	call print_str
	call print_hex8
	call print_crlf

	; also show sum(L) for stepping
	ld de,msg_sum
	call print_str
	ld a,l
	call print_hex8
	call print_crlf

	jmp forever	; infinite loop to prevent running into unknown code

	; restore regs and return to CRT
	pop hl
	pop de
	pop bc
	ret
