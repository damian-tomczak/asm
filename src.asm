    processor 6502
    include "vcs.h"
    include "macro.h"
    seg.u Variables
    org $80

JetXPos byte
JetYPos byte
BomberXPos byte
BomberYPos byte
JetSpritePtr word
JetColorPtr word
BomberSpritePtr word
BomberColorPtr word
JET_HEIGHT = 9
BOMBER_HEIGHT = 9

    seg Code
    org $FF00

    include "assets.h"
Reset:
    CLEAN_START
    lda #10
    sta JetYPos
    lda #60
    sta JetXPos
    lda #83
    sta BomberYPos
    lda #54
    sta BomberXPos

    lda #<JetSprite
    sta JetSpritePtr
    lda #>JetSprite
    sta JetSpritePtr+1

    lda #<JetColor
    sta JetColorPtr
    lda #>JetColor
    sta JetColorPtr+1

    lda #<BomberSprite
    sta BomberSpritePtr
    lda #>BomberSprite
    sta BomberSpritePtr+1

    lda #<BomberColor
    sta BomberColorPtr
    lda #>BomberColor
    sta BomberColorPtr+1

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

    ldx #96
.GameLineLoop:
.AreWeInsideJetSprite:
    txa
    sec
    sbc JetYPos
    cmp JET_HEIGHT
    bcc .DrawSpriteP0
    lda #0
.DrawSpriteP0
    tay
    lda (JetSpritePtr),Y
    sta WSYNC
    sta GRP0
    lda (JetColorPtr),Y
    sta COLUP0

.AreWeInsideBomberSprite
    txa
    sec
    sbc BomberYPos
    cmp BOMBER_HEIGHT
    bcc .DrawSpriteP1
    lda #0
.DrawSpriteP1
    tay
    lda #%00000101
    sta NUSIZ1
    lda (BomberSpritePtr),Y
    sta WSYNC
    sta GRP1
    lda (BomberColorPtr),Y
    sta COLUP1

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