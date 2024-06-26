    org $F000

Digits:
    .byte %01110111
    .byte %01010101
    .byte %01010101
    .byte %01010101
    .byte %01110111

    .byte %00010001
    .byte %00010001
    .byte %00010001
    .byte %00010001
    .byte %00010001

    .byte %01110111
    .byte %00010001
    .byte %01110111
    .byte %01000100
    .byte %01110111

    .byte %01110111
    .byte %00010001
    .byte %00110011
    .byte %00010001
    .byte %01110111

    .byte %01010101
    .byte %01010101
    .byte %01110111
    .byte %00010001
    .byte %00010001

    .byte %01110111
    .byte %01000100
    .byte %01110111
    .byte %00010001
    .byte %01110111

    .byte %01110111
    .byte %01000100
    .byte %01110111
    .byte %01010101
    .byte %01110111

    .byte %01110111
    .byte %00010001
    .byte %00010001
    .byte %00010001
    .byte %00010001

    .byte %01110111
    .byte %01010101
    .byte %01110111
    .byte %01010101
    .byte %01110111

    .byte %01110111
    .byte %01010101
    .byte %01110111
    .byte %00010001
    .byte %01110111

    .byte %00100010
    .byte %01010101
    .byte %01110111
    .byte %01010101
    .byte %01010101

    .byte %01110111
    .byte %01010101
    .byte %01100110
    .byte %01010101
    .byte %01110111

    .byte %01110111
    .byte %01000100
    .byte %01000100
    .byte %01000100
    .byte %01110111

    .byte %01100110
    .byte %01010101
    .byte %01010101
    .byte %01010101
    .byte %01100110

    .byte %01110111
    .byte %01000100
    .byte %01110111
    .byte %01000100
    .byte %01110111

    .byte %01110111
    .byte %01000100
    .byte %01100110
    .byte %01000100
    .byte %01000100

DIGITS_HEIGHT = 5

JetSprite:
    .byte #%00000000
    .byte #%00010100
    .byte #%01111111
    .byte #%00111110
    .byte #%00011100
    .byte #%00011100
    .byte #%00001000
    .byte #%00001000
    .byte #%00001000

JET_HEIGHT = . - JetSprite

JetSpriteTurn:
    .byte #%00000000
    .byte #%00001000
    .byte #%00111110
    .byte #%00011100
    .byte #%00011100
    .byte #%00011100
    .byte #%00001000
    .byte #%00001000
    .byte #%00001000

BomberSprite:
    .byte #%00000000
    .byte #%00001000
    .byte #%00001000
    .byte #%00101010
    .byte #%00111110
    .byte #%01111111
    .byte #%00101010
    .byte #%00001000
    .byte #%00011100

BOMBER_HEIGHT = . - BomberSprite

JetColor:
    .byte #$00
    .byte #$FE
    .byte #$0C
    .byte #$0E
    .byte #$0E
    .byte #$04
    .byte #$BA
    .byte #$0E
    .byte #$08

JetColorTurn:
    .byte #$00
    .byte #$FE
    .byte #$0C
    .byte #$0E
    .byte #$0E
    .byte #$04
    .byte #$0E
    .byte #$0E
    .byte #$08

BomberColor:
    .byte #$00
    .byte #$32
    .byte #$32
    .byte #$0E
    .byte #$40
    .byte #$40
    .byte #$40
    .byte #$40
    .byte #$40
