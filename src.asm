    processor 6502

    include "vcs.h"
    include "macro.h"

    seg.u Variables
    org $80
P0Height .byte
P1Height .byte

    seg code
    org $F000

Reset:
    CLEAN_START
    ldx #$80
    stx COLUBK
    lda #$1C
    sta COLUPF
    lda #10
    sta P0Height
    sta P1Height
    lda #$48
    sta COLUP0
    lda #$C6
    sta COLUP1
    ldy #%00000010
    sty CTRLPF

StartFrame:
    lda #02
    sta VBLANK
    sta VSYNC
    REPEAT 3
        sta WSYNC
    REPEND
    lda #0
    sta VSYNC
    REPEAT 37
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
VisibleScanlines:
    REPEAT 10
        sta WSYNC
    REPEND
    ldy #0
ScoreboardLoop:
    lda NumberBitmap,Y
    sta PF1
    sta WSYNC
    iny
    cpy #10
    bne ScoreboardLoop
    lda #0
    sta PF1
    REPEAT 50
        sta WSYNC
    REPEND
    ldy #0
Player0Loop:
    lda PlayerBitmap,Y
    sta GRP0
    sta WSYNC
    iny
    cpy P0Height
    bne Player0Loop
    lda #0
    sta GRP0
    ldy #0
Player1Loop:
    lda PlayerBitmap,Y
    sta GRP1
    sta WSYNC
    iny
    cpy P1Height
    bne Player1Loop
    lda #0
    sta GRP1
    REPEAT 102
        sta WSYNC
    REPEND

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    REPEAT 30
        sta WSYNC
    REPEND

    jmp StartFrame

    org $FFE8
PlayerBitmap:
    .byte #%01111110
    .byte #%11111111
    .byte #%10011001
    .byte #%11111111
    .byte #%11111111
    .byte #%11111111
    .byte #%10111101
    .byte #%11000011
    .byte #%11111111
    .byte #%01111110
    org $FFF2
NumberBitmap:
    .byte #%00001110
    .byte #%00001110
    .byte #%00000010
    .byte #%00000010
    .byte #%00001110
    .byte #%00001110
    .byte #%00001000
    .byte #%00001000
    .byte #%00001110
    .byte #%00001110

    org $FFFC
    .word Reset
    .word Reset
