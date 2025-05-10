// ASCON_System_Opcodes Library
    `define     ASCON_ENC_DATA                      6'h01
    `define     ASCON_ENC_DATA_LAST                 6'h02
    `define     ASCON_ENC_TEXT                      6'h03
    `define     ASCON_ENC_TEXT_LAST                 6'h04
    `define     ASCON_A_ENC_DATA                    6'h05
    `define     ASCON_A_ENC_DATA_LAST               6'h06
    `define     ASCON_A_ENC_TEXT                    6'h07
    `define     ASCON_A_ENC_TEXT_LAST               6'h08

    `define     ASCON_HASH_MESSAGE                  6'h09
    `define     ASCON_SQUEEZE_HASH                  6'h0A
    `define     ASCON_INIT_SQUEEZE_HASH             6'h0B
    `define     ASCON_A_HASH_MESSAGE                6'h0C
    `define     ASCON_A_SQUEEZE_HASH                6'h0D
    `define     ASCON_A_INIT_SQUEEZE_HASH           6'h0E

    `define     ASCON_DEC_DATA                      6'h0F
    `define     ASCON_DEC_DATA_LAST                 6'h10
    `define     ASCON_DEC_TEXT                      6'h11
    `define     ASCON_DEC_TEXT_LAST                 6'h12
    `define     ASCON_A_DEC_DATA                    6'h13
    `define     ASCON_A_DEC_DATA_LAST               6'h14
    `define     ASCON_A_DEC_TEXT                    6'h15
    `define     ASCON_A_DEC_TEXT_LAST               6'h16

    `define     ASCON_A_TAG_CALC_ENC                6'h17
    `define     ASCON_TAG_CALC_ENC                  6'h18
    `define     ASCON_A_TAG_CALC_DEC                6'h19
    `define     ASCON_TAG_CALC_DEC                  6'h1A

    `define     ASCON_A_HASH_INIT                   6'h1B
    `define     ASCON_HASH_INIT                     6'h1C

    `define     ASCON_A_INIT                        6'h1D
    `define     ASCON_INIT                          6'h1E

    `define     ASCON_DATA_FIFO_PUSH                6'h1F
    `define     ASCON_TEXT_IN_FIFO_PUSH             6'h20
    `define     ASCON_TEXT_OUT_FIFO_PULL            6'h21
    `define     ASCON_TEXT_OUT_FIFO_PULL_DEC        6'h22

    `define     KEY_LOAD                            6'h23
    `define     NONCE_LOAD                          6'h24
    `define     EXP_TAG_LOAD                        6'h25
    //`define     DATA_BLK_LOAD                       6'h26
    //`define     TXT_BLK_LOAD                        6'h27
    `define     END_OF_SESSION                      6'h3F
    `define     RESET                               6'h00