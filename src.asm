    processor 6502

    include "vcs.h"
    include "macro.h"

    seg code
    org $F000

START:
    CLEAN_START

    lda #$1E
    sta COLUBK

    jmp START

    org $FFFC
    .word START
    .word START