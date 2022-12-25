draw_rect MACRO color
local l1
    mov dx,di
    mov bh,20
    mov al,color
    l1: mov cx,40
        rep STOSB
        add dx,320
        mov di,dx
        dec BH
        jnz l1
endm draw_rect
exchange_values MACRO c1,c2

endm exchange_values
;-------------
draw_piece MACRO piece,x_piece,y_piece
local l1,l2,skip_draw

mov si,offset piece
mov al,piece           ;just for storing the piece in piece_background
mov piece_background,al;to know background color of piece
mov ax,20d
mov bx,y_piece
mul bx  ; ax = y * 20
mov bx,ax
mov piece_y_end,bx
add piece_y_end,20d
l1:
    mov ax,40d
    mov di,x_piece
    mul di ;ax = x * 40
    mov di,ax
    mov piece_x_end,di
    add piece_x_end,40d ;40d
    l2:
            mov cx,di;column

            mov dx,bx;row
            mov ax,[si]
            mov ah,0ch  ;draw pixel
            cmp piece_background,al
            je skip_draw
            int 10h
        skip_draw:

            inc si

      inc di
      cmp di,piece_x_end
      jne l2
inc bx
cmp bx,piece_y_end
jne l1

endm draw_piece
;------------
draw_piece2 MACRO piece,x_piece,y_piece
local l1,l2,skip_draw

mov si,offset piece
mov al,piece           ;just for storing the piece in piece_background
mov piece_background,al;to know background color of piece
mov ax,25
mov bx,y_piece
mul bx  ; ax = y * 20
mov bx,ax
mov piece_y_end,bx
add piece_y_end,25
l1:
    mov ax,25
    mov di,x_piece
    mul di ;ax = x * 40
    mov di,ax
    mov piece_x_end,di
    add piece_x_end,25 ;40d
    l2:
            mov cx,di;column

            mov dx,bx;row
            mov ax,[si]
            mov ah,0ch  ;draw pixel
            cmp piece_background,al
            je skip_draw
            int 10h
        skip_draw:

            inc si

      inc di
      cmp di,piece_x_end
      jne l2
inc bx
cmp bx,piece_y_end
jne l1

endm draw_piece2
;-----------
;if row + column is even then background color1 (color of first square) else color2
check_square_color MACRO row,column ;if color1 then return al=0 else 1
local even_place,end_check
    mov ax,row
    add ax,column
    and ax,1        ;if last bit is 1 then odd else even
    jz even_place   ;even
    mov al,1 ;odd
    jmp end_check
even_place:
    mov al,0 ;even
end_check:
    jmp end_check
endm check_square_color
;------------

.model small
.stack 64
.data
start    dw 0    ;position of the starting point(pixel)
w       dw 40   ;width of the square
len     dw 20   ; length (height) of each row of squares
;count   dw 0    ; dummy maloosh lazma XD
color1  db 04h  ; primary color of the board
color2  db 02h  ; secondary color
c db ?
no_rows db 8    ; number of rows to be drawn
no_sqs db 8
;------------------end of Background vars
sel_color db 0ch ;color of the Navigateing square
continue_counter db 1
global_cursor db 0; 0-63
sq_cursor_h db 0; horizontal
sq_cursor_v db 0; vertical
step_size_row db 40; to traverse in a row
step_size_col dw 6400d; to traverse in a column
draw_start_width db 15
draw_start_height db 8
direction db 0
square_info LABEL BYTE
    ;first row
    db 6 ;sq_0  piece on it
    db 6 ;sq_1
    db 0
    db 0
    ;second row
    db 0
    db 0
    db 0
;-------------------pieces--------------
;king ,wazer ,tabia , horse ,soldier ,fel
    piece_x_end dw ?
    piece_y_end dw ?
    piece_background db ?
;-------------white pieces--------------;
soldier db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,7,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,8,8,8,8,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;--------------------
horse db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,7,15,15,15,7,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,8,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,8,7,15,15,15,15,15,15,15,15,15,15,15,15,7,8,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0;------------
;-------------
king db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,38,7,18,17,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,39,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,22,31,31,43,44,30,30,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,23,45,46,15,15,47,45,24,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,19,30,41,15,15,15,39,89,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,22,42,46,15,15,15,45,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,26,45,47,15,15,15,47,28,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,25,39,15,15,15,36,20,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,35,15,15,15,29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,35,15,15,15,29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,35,15,15,15,29,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,19,37,15,15,15,31,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,20,33,42,15,15,15,38,19,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,110,46,47,15,15,15,45,22,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,27,47,15,15,15,15,47,25,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,17,28,43,15,15,15,15,15,15,42,213,19,17,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,18,34,47,15,15,15,15,15,15,15,15,46,46,29,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,18,213,7,15,15,15,15,15,15,15,15,15,15,15,33,17,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,17,20,30,7,41,41,41,41,41,41,42,42,7,35,25,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,18,20,21,21,21,21,21,21,21,21,20,18,17,0,0,0,0,0,0,0,0,0,0,0,0,0
;-----------
wazer db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,7,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;----------
fel db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;--------
tabia db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,8,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,8,8,8,8,8,8,8,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;------------black pieces------------;
b_king db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,7,7,7,7,7,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
;----------
b_wazer db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,8,0,0,8,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
;-----------
b_fel db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,8,8,8,8,8,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
;---------------
b_horse db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,8,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,7,8,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,8,8,8,8,8,8,8,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
;--------------
b_tabia db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,15,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,8,8,8,8,8,8,8,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
;-------------
b_soldier db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,7,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0,7,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,15,15,15,15
db 15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,8,8,8,8,8,8,8,8,8,8,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15
;-----------
test db 0,0,0,0,0,0,0,0,0,0,0,0,38,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,35,15,30,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,0,19,15,0,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,24,41,45,15,42,38,19,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,21,15,15,15,15,15,19,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,43,15,15,15,7,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,34,15,15,15,28,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,15,15,15,15,46,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,33,15,15,15,15,15,26,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,39,15,15,15,34,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,29,15,15,15,110,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,26,15,15,15,19,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,25,15,15,15,0,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,26,15,15,15,17,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,28,15,15,15,20,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,33,15,15,15,24,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,7,15,15,15,31,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,0,15,15,15,15,7,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,21,15,15,15,15,15,0,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,0,42,15,15,15,15,15,8,0,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,36,15,15,15,15,15,15,15,24,0,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,43,15,15,15,15,15,15,15,15,15,28,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,234,15,15,15,15,15,15,15,15,15,28,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,15,15,15,15,15,15,15,15,15,15,38,0,0,0,0,0,0,0
db 0,0,0,0,0,0,0,0,23,24,24,24,24,24,25,26,21,0,0,0,0,0,0,0,0
;---------
.code
main proc far
    mov ax,@data
    mov ds,ax

    mov ax,0A000h
    mov es,ax
    
    mov ah,0
    mov al,13h
    int 10h

    mov di,0

    mov no_sqs,8
    call draw_board


    ;draw all pieces using draw_piece x,y
    ;draw white pieces
    draw_piece tabia,0,0
    draw_piece horse,1,0
    draw_piece fel,2,0
    draw_piece wazer,3,0
    draw_piece king,4,0
    draw_piece fel,5,0
    draw_piece horse,6,0
    draw_piece tabia,7,0
    draw_piece soldier,0,1
    draw_piece soldier,1,1
    draw_piece soldier,2,1
    draw_piece soldier,3,1
    draw_piece soldier,4,1
    draw_piece soldier,5,1
    draw_piece soldier,6,1
    draw_piece soldier,7,1

    ;draw black pieces
    draw_piece b_tabia,0,7
    draw_piece b_horse,1,7
    draw_piece b_fel,2,7
    draw_piece b_wazer,3,7
    draw_piece b_king,4,7
    draw_piece b_fel,5,7
    draw_piece b_horse,6,7
    draw_piece b_tabia,7,7
    draw_piece b_soldier,0,6
    draw_piece b_soldier,1,6
    draw_piece b_soldier,2,6
    draw_piece b_soldier,3,6
    draw_piece b_soldier,4,6
    draw_piece b_soldier,5,6
    draw_piece b_soldier,6,6
    draw_piece b_soldier,7,6



    ;draw_pieces--------
    ;   draw_piece fel,7,0
    ;   draw_piece tabia,6,0
    ;   draw_piece king,5,0
    ;   draw_piece horse,4,0
    ;   draw_piece wazer,3,0
    ;   draw_piece soldier,2,0
    ;   draw_piece b_fel,7,1
    ;   draw_piece b_tabia,6,1
    ;   draw_piece b_king,5,1
    ;   draw_piece b_horse,4,1
    ;   draw_piece b_wazer,3,1
    ;   draw_piece b_soldier,2,1
      ;-----------
      ;draw_piece2 test,2,4

    mov di,0
    ;draw_rect sel_color
    continue_label:
    
    push ax 
    call Navigate
    pop ax  
    cmp continue_counter,0  
    jnz continue_label

    mov       ah, 4ch
    mov       al, 01h
    int       21h
    
    hlt
main endp
;-----------------
draw_board proc 
    row_l1:
    push di
    draw_rect color1
    pop di
    add di,40
    mov al,color1
    mov bl,color2
    xchg al,bl
    mov color1,al
    mov color2,bl
    dec no_sqs
    jnz row_l1
    mov no_sqs,8
    mov al,color1
    mov bl,color2
    xchg al,bl
    mov color1,al
    mov color2,bl
    add start,6400
    mov di,start
    dec no_rows
    jnz row_l1 

    
    ret
draw_board endp

Draw_Tabia proc
        mov dx,di
        mov ah,3
        mov bh,3
        dots:;;3 dots
        mov al,0fh
        mov cx,3
        rep STOSB
        add di,3
        dec ah
        jnz dots 
        
        add dx,320
        mov di,dx
        sub dx,320
        mov ah,3
        dec bh
        jnz dots
        
        
        mov bh,2
         
        
        add dx,320
        add dx,320
        ;add dx,320
        ;add dx,320
        mov di,dx
        rect:;;rect
        mov cx,15
        rep STOSB
        add dx,320
        mov di,dx
        dec bh
        jnz rect
        
        
        add dx,321
        
        mov bh,3
        stickk: ;3amood
        mov di,dx
        mov cx,13 
        rep STOSB
        add dx,320
        dec bh
        jnz stickk
        
        mov bh,2
        add dx,319
        mov di,dx
        rect_ta7t:;;rect
        mov cx,15
        rep STOSB
        add dx,320
        mov di,dx
        dec bh
        jnz rect_ta7t

        ret
Draw_Tabia endp
Navigate proc

    mov ah,0
    int 16h ;w=up,s=down,a=left,d=right
    ;if al == ascii of any of these letters
    ;it should do a distinct reaction
    ;al == d (right)
    cmp al,'d';;read ascii of 'd' from al
    jz cond_go_right
    cmp al,'a'
    jz cond_go_left
    cmp al,'w'
    jz cond_go_up
    cmp al,'s'
    jz cond_l_go_down
    
    exitt: ret

    cond_go_right:
    mov direction,1
    cmp sq_cursor_h,7
    jz exitt
    jmp start_nav

    cond_go_left:
    mov direction,2
    cmp sq_cursor_h,0 
    jz exitt
    jmp start_nav

    cond_go_up:
    mov direction,3
    cmp sq_cursor_v,0
    jz exitt
    jmp start_nav

    cond_l_go_down:
    mov direction,4
    cmp sq_cursor_v,7
    jz exitt
    jmp start_nav

    
    start_nav:
    push ax

    mov ax,0
    mov al,sq_cursor_h
    mul step_size_row
    mov di,ax

    mov ax,0
    mov al,sq_cursor_v
    mul step_size_col
    add di,ax

    push di
    draw_rect color1
    mov al,color1
    mov bl,color2
    xchg al,bl
    mov color1,al
    mov color2,bl
    pop di

    
    pop ax
    cmp direction,1;;read ascii of 'd' from al
    jz go_right
    cmp direction,2
    jz go_left
    cmp direction,3
    jz go_up
    cmp direction,4
    jz l_go_down
    ;;;;;;;;;;;;;;;;;;;;;;
    go_right:
    cmp sq_cursor_h,7
    jz jump

    inc global_cursor

    inc sq_cursor_h
    add di,40d
    push di
    draw_rect sel_color
    pop di
    jump:jmp end_nav
    l_go_down: jmp go_down
    ;;;;;;;;;;;;;;;;;;;;;;;;;;
    go_left:
    cmp sq_cursor_h,0
    jz jump
    dec global_cursor

    dec sq_cursor_h
    sub di,40d
    push di
    draw_rect sel_color
    pop di
    jmp end_nav
    ;;;;;;;;;;;;;;;;;;;;;;;;
    go_up:
    cmp sq_cursor_v,0
    jz jump

    sub global_cursor,8
    dec sq_cursor_v
    sub di,6400d
    push di
    draw_rect sel_color
    pop di
    jmp end_nav
    ;;;;;;;;;;;;;;;;;;;;;;;;
    go_down:
    cmp sq_cursor_v,7
    jz end_nav

    add global_cursor,8

    inc sq_cursor_v
    add di,6400d
    push di
    draw_rect sel_color
    pop di
    end_nav:
    ret
Navigate endp
end main