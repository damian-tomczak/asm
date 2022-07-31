    processor 6502
    include "vcs.h"
    include "macro.h"
    seg.u Variables
    org $80

JetXPos byte
JetYPos byte
BomberXPos byte
BomberYPos byte
    seg Code
    org $F000

Reset:
    CLEAN_START
    lda #10
    sta JetYPos
    lda #60
    sta JetXPos

StartFrame:
    lda #2
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
    sta VBLANK

GameVisibleLine:
    lda #$84
    sta COLUBK
    lda #$C2
    sta COLUPF
    lda #%00000001
    sta CTRLPF
    lda #$F0
    sta PF0
    lda #$FC
    sta PF1
    lda #0
    sta PF2

    ldx #192
.GameLineLoop:
    sta WSYNC
    dex
    bne .GameLineLoop

    lda #2
    sta VBLANK
    REPEAT 30
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK

    jmp StartFrame

    org $FFFC
    word Reset
    word Reset