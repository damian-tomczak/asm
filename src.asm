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
JetAnimOffset byte
Random byte

    seg Code
    org $FF00

    include "assets.h"
Reset:
    CLEAN_START
    lda #68
    sta JetXPos
    lda #10
    sta JetYPos
    lda #62
    sta BomberXPos
    lda #83
    sta BomberYPos
    lda #%11010100
    sta Random

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
    lda JetXPos
    ldy #0
    jsr SetObjectXPos
    lda BomberXPos
    ldy #1
    jsr SetObjectXPos
    sta WSYNC
    sta HMOVE

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
    clc
    adc JetAnimOffset
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

    lda #0
    sta JetAnimOffset
    sta WSYNC

    lda #2
    sta VBLANK
    REPEAT 30
        sta WSYNC
    REPEND
    lda #0
    sta VBLANK

CheckP0Up:
    lda #%00010000
    bit SWCHA
    bne CheckP0Down
    inc JetYPos
    lda #0
    sta JetAnimOffset
CheckP0Down:
    lda #%00100000
    bit SWCHA
    bne CheckP0Left
    dec JetYPos
    lda #0
    sta JetAnimOffset
CheckP0Left:
    lda #%01000000
    bit SWCHA
    bne CheckP0Right
    dec JetXPos
    lda JET_HEIGHT
    sta JetAnimOffset
CheckP0Right
    lda #%10000000
    bit SWCHA
    bne EndInputCheck
    inc JetXPos
    lda JET_HEIGHT
    sta JetAnimOffset

EndInputCheck:

UpdateBomberPosition:
    lda BomberYPos
    clc
    cmp #0
    bmi .ResetBomberPosition
    dec BomberYPos
    jmp EndPositionUpdate
.ResetBomberPosition
    jsr GetRandomBomberPos

EndPositionUpdate:

    jmp StartFrame

SetObjectXPos subroutine
    sta WSYNC
    sec
.Div15Loop
    sbc #15
    bcs .Div15Loop
    eor #7
    asl
    asl
    asl
    asl
    sta HMP0,Y
    STA RESP0,Y
    rts

GetRandomBomberPos subroutine
    lda Random
    asl
    eor Random
    asl
    eor Random
    asl
    asl
    eor Random
    asl
    rol Random

    lsr
    lsr
    sta BomberXPos
    lda #30
    adc BomberXPos
    sta BomberXPos
    lda #96
    sta BomberYPos
    rts


    org $FFFC
    word Reset
    word Reset