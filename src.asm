    processor 6502
    include "vcs.h"
    include "macro.h"
    seg.u Variables
    org $80

JetXPos         byte
JetYPos         byte
BomberXPos      byte
BomberYPos      byte
MissileXPos      byte
MissileYPos      byte
Score           byte
Timer           byte
Temp            byte
OnesDigitOffset word
TensDigitOffset word
JetSpritePtr    word
JetColorPtr     word
BomberSpritePtr word
BomberColorPtr  word
JetAnimOffset   byte
Random          byte
ScoreSprite     byte
TimerSprite     byte
TerrainColor    byte
RiverColor      byte

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
    lda #0
    sta Score
    sta Timer

    MAC DRAW_MISSILE
        lda #%00000000
        cpx MissileYPos
        bne .SkipMissileDraw
.DrawMissile
        lda #%00000010
        inc MissileYPos
.SkipMissileDraw
        sta ENAM0
    ENDM

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
    REPEAT 33
        sta WSYNC
    REPEND

    lda JetXPos
    ldy #0
    jsr SetObjectXPos
    lda BomberXPos
    ldy #1
    jsr SetObjectXPos
    lda MissileXPos
    ldy #2
    jsr SetObjectXPos

    jsr CalculateDigitOffset
    sta WSYNC
    sta HMOVE
    lda #0
    sta VBLANK

    lda #0
    sta COLUBK
    sta PF0
    sta PF1
    sta PF2
    sta GRP0
    sta GRP1
    sta CTRLPF

    lda #$1E
    sta COLUPF

    ldx #DIGITS_HEIGHT

.ScoreDigitLoop:
    ldy TensDigitOffset
    lda Digits,Y
    and #$F0
    sta ScoreSprite

    ldy OnesDigitOffset
    lda Digits,Y
    and #$0F
    ora ScoreSprite
    sta ScoreSprite
    sta WSYNC
    sta PF1

    ldy TensDigitOffset+1
    lda Digits,Y
    and #$F0
    sta TimerSprite

    ldy OnesDigitOffset+1
    lda Digits,Y
    and #$0F
    ora TimerSprite
    sta TimerSprite

    jsr Sleep12Cycles
    sta PF1
    ldy ScoreSprite
    sta WSYNC
    sty PF1

    inc TensDigitOffset
    inc TensDigitOffset+1
    inc OnesDigitOffset
    inc OnesDigitOffset+1

    jsr Sleep12Cycles

    dex
    sta PF1
    bne .ScoreDigitLoop

    lda #0
    sta PF0
    sta PF1
    sta PF2

    sta WSYNC
    sta WSYNC
    sta WSYNC

GameVisibleLine:
    lda TerrainColor
    sta COLUPF
    lda RiverColor
    sta COLUBK
    lda #%00000001
    sta CTRLPF
    lda #$F0
    sta PF0
    lda #$FC
    sta PF1
    lda #0
    sta PF2

    ldx #85
.GameLineLoop:
    DRAW_MISSILE

.AreWeInsideJetSprite:
    txa
    sec
    sbc JetYPos
    cmp #JET_HEIGHT
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
    cmp #BOMBER_HEIGHT
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
    lda JetYPos
    cmp #70
    bpl CheckP0Down
.P0UpPressed:
    inc JetYPos
    lda #0
    sta JetAnimOffset
CheckP0Down:
    lda #%00100000
    bit SWCHA
    bne CheckP0Left
    lda JetYPos
    cmp #5
    bmi CheckP0Left
.P0DownPressed:
    dec JetYPos
    lda #0
    sta JetAnimOffset
CheckP0Left:
    lda #%01000000
    bit SWCHA
    bne CheckP0Right
    lda JetXPos
    cmp #35
    bmi CheckP0Right
.P0LeftPressed:
    dec JetXPos
    lda #JET_HEIGHT
    sta JetAnimOffset
CheckP0Right
    lda #%10000000
    bit SWCHA
    bne CheckButtonPressed
    lda JetXPos
    cmp #100
    bpl CheckButtonPressed
.P0RightPressed:
    inc JetXPos
    lda #JET_HEIGHT
    sta JetAnimOffset

CheckButtonPressed:
    lda #%10000000
    bit INPT4
    bne EndInputCheck
.ButtonPressed:
    lda JetXPos
    clc
    adc #5
    sta MissileXPos
    lda JetYPos
    clc
    adc #8
    sta MissileYPos

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

.SetScoreValues:
    sed
    lda Timer
    clc
    adc #1
    sta Timer
    cld

EndPositionUpdate:

CheckCollisionP0P1:
    lda #%10000000
    bit CXPPMM
    bne .P0P1Collided
    jsr SetTerrainRiverColor
    jmp CheckCollisionM0P1
.P0P1Collided:
    jsr GameOver

CheckCollisionM0P1:
    lda #%10000000
    bit CXM0P
    bne .M0P1Collided
    jmp EndCollisionCheck
.M0P1Collided:
    sed
    lda Score
    clc
    adc #1
    sta Score
    cld
    lda #0
    sta MissileYPos

EndCollisionCheck:
    sta CXCLR

    jmp StartFrame

SetTerrainRiverColor subroutine
    lda #$C2
    sta TerrainColor
    lda #$84
    sta RiverColor
    rts

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

GameOver subroutine
    lda #$30
    sta TerrainColor
    sta RiverColor
    lda #0
    sta Score
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

CalculateDigitOffset subroutine
    ldx #1
.PrepareScoreLoop
    lda Score,X
    and #$0F
    sta Temp
    asl
    asl
    adc Temp
    sta OnesDigitOffset,X
    lda Score,x
    and #$F0
    lsr
    lsr
    sta Temp
    lsr
    lsr
    adc Temp
    sta TensDigitOffset,X
    dex
    bpl .PrepareScoreLoop
    rts

Sleep12Cycles subroutine
    rts

    org $FFFC
    word Reset
    word Reset