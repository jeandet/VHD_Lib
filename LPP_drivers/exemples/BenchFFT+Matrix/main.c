#include <stdio.h>
#include "lpp_apb_functions.h"
#include "apb_fifo_Driver.h"
#include "apb_uart_Driver.h"

int main()
{
    int i=0;
    int data;
    char temp[256];

    int TblSinA[256] = {0x0000,0x0142,0x0282,0x03C2,0x04FF,0x0638,0x076E,0x08A0,0x09CC,0x0AF2,0x0C11,0x0D29,0x0E39,0x0F40,0x103E,0x1131,0x121A,0x12F8,0x13CA,0x1490,0x1549,0x15F5,0x1694,0x1724,0x17A7,0x181B,0x187F,0x18D5,0x191C,0x1953,0x197A,0x1992,0x199A,0x1992,0x197A,0x1953,0x191C,0x18D5,0x187F,0x181B,0x17A7,0x1724,0x1694,0x15F5,0x1549,0x1490,0x13CA,0x12F8,0x121A,0x1131,0x103E,0x0F40,0x0E39,0x0D29,0x0C11,0x0AF2,0x09CC,0x08A0,0x076E,0x0638,0x04FF,0x03C2,0x0282,0x0142,0x0000,0xFEBE,0xFD7E,0xFC3E,0xFB01,0xF9C8,0xF892,0xF760,0xF634,0xF50E,0xF3EF,0xF2D7,0xF1C7,0xF0C0,0xEFC2,0xEECF,0xEDE6,0xED08,0xEC36,0xEB70,0xEAB7,0xEA0B,0xE96C,0xE8DC,0xE859,0xE7E5,0xE781,0xE72B,0xE6E4,0xE6AD,0xE686,0xE66E,0xE666,0xE66E,0xE686,0xE6AD,0xE6E4,0xE72B,0xE781,0xE7E5,0xE859,0xE8DC,0xE96C,0xEA0B,0xEAB7,0xEB70,0xEC36,0xED08,0xEDE6,0xEECF,0xEFC2,0xF0C0,0xF1C7,0xF2D7,0xF3EF,0xF50E,0xF634,0xF760,0xF892,0xF9C8,0xFB01,0xFC3E,0xFD7E,0xFEBE,0x0000,0x0142,0x0282,0x03C2,0x04FF,0x0638,0x076E,0x08A0,0x09CC,0x0AF2,0x0C11,0x0D29,0x0E39,0x0F40,0x103E,0x1131,0x121A,0x12F8,0x13CA,0x1490,0x1549,0x15F5,0x1694,0x1724,0x17A7,0x181B,0x187F,0x18D5,0x191C,0x1953,0x197A,0x1992,0x199A,0x1992,0x197A,0x1953,0x191C,0x18D5,0x187F,0x181B,0x17A7,0x1724,0x1694,0x15F5,0x1549,0x1490,0x13CA,0x12F8,0x121A,0x1131,0x103E,0x0F40,0x0E39,0x0D29,0x0C11,0x0AF2,0x09CC,0x08A0,0x076E,0x0638,0x04FF,0x03C2,0x0282,0x0142,0x0000,0xFEBE,0xFD7E,0xFC3E,0xFB01,0xF9C8,0xF892,0xF760,0xF634,0xF50E,0xF3EF,0xF2D7,0xF1C7,0xF0C0,0xEFC2,0xEECF,0xEDE6,0xED08,0xEC36,0xEB70,0xEAB7,0xEA0B,0xE96C,0xE8DC,0xE859,0xE7E5,0xE781,0xE72B,0xE6E4,0xE6AD,0xE686,0xE66E,0xE666,0xE66E,0xE686,0xE6AD,0xE6E4,0xE72B,0xE781,0xE7E5,0xE859,0xE8DC,0xE96C,0xEA0B,0xEAB7,0xEB70,0xEC36,0xED08,0xEDE6,0xEECF,0xEFC2,0xF0C0,0xF1C7,0xF2D7,0xF3EF,0xF50E,0xF634,0xF760,0xF892,0xF9C8,0xFB01,0xFC3E,0xFD7E,0xFEBE};
    int TblSinAB[256] = {0x0000,0x0D53,0x17CB,0x1D3C,0x1CA5,0x1676,0x0C6D,0x0131,0xF7B2,0xF273,0xF2F6,0xF95F,0x046D,0x11C2,0x1E77,0x27C5,0x2BB4,0x298C,0x2203,0x1712,0x0B7D,0x022B,0xFD78,0xFEA5,0x058D,0x10AC,0x1D7E,0x2913,0x30C2,0x32CD,0x2EC3,0x25A3,0x199A,0x0D80,0x0431,0xFFD9,0x0175,0x0898,0x1381,0x1F89,0x29C1,0x2FA4,0x2FAF,0x29BF,0x1F15,0x120E,0x0591,0xFC64,0xF880,0xFA9D,0x0205,0x0CBE,0x1805,0x20F3,0x252D,0x2371,0x1BE6,0x100E,0x0270,0xF5FB,0xED58,0xEA48,0xED39,0xF530,0x0000,0x0AD0,0x12C7,0x15B8,0x12A8,0x0A05,0xFD90,0xEFF2,0xE41A,0xDC8F,0xDAD3,0xDF0D,0xE7FB,0xF342,0xFDFB,0x0563,0x0780,0x039C,0xFA6F,0xEDF2,0xE0EB,0xD641,0xD051,0xD05C,0xD63F,0xE077,0xEC7F,0xF768,0xFE8B,0x0027,0xFBCF,0xF280,0xE666,0xDA5D,0xD13D,0xCD33,0xCF3E,0xD6ED,0xE282,0xEF54,0xFA73,0x015B,0x0288,0xFDD5,0xF483,0xE8EE,0xDDFD,0xD674,0xD44C,0xD83B,0xE189,0xEE3E,0xFB93,0x06A1,0x0D0A,0x0D8D,0x084E,0xFECF,0xF393,0xE98A,0xE35B,0xE2C4,0xE835,0xF2AD,0x0000,0x0D53,0x17CB,0x1D3C,0x1CA5,0x1676,0x0C6D,0x0131,0xF7B2,0xF273,0xF2F6,0xF95F,0x046D,0x11C2,0x1E77,0x27C5,0x2BB4,0x298C,0x2203,0x1712,0x0B7D,0x022B,0xFD78,0xFEA5,0x058D,0x10AC,0x1D7E,0x2913,0x30C2,0x32CD,0x2EC3,0x25A3,0x199A,0x0D80,0x0431,0xFFD9,0x0175,0x0898,0x1381,0x1F89,0x29C1,0x2FA4,0x2FAF,0x29BF,0x1F15,0x120E,0x0591,0xFC64,0xF880,0xFA9D,0x0205,0x0CBE,0x1805,0x20F3,0x252D,0x2371,0x1BE6,0x100E,0x0270,0xF5FB,0xED58,0xEA48,0xED39,0xF530,0x0000,0x0AD0,0x12C7,0x15B8,0x12A8,0x0A05,0xFD90,0xEFF2,0xE41A,0xDC8F,0xDAD3,0xDF0D,0xE7FB,0xF342,0xFDFB,0x0563,0x0780,0x039C,0xFA6F,0xEDF2,0xE0EB,0xD641,0xD051,0xD05C,0xD63F,0xE077,0xEC7F,0xF768,0xFE8B,0x0027,0xFBCF,0xF280,0xE666,0xDA5D,0xD13D,0xCD33,0xCF3E,0xD6ED,0xE282,0xEF54,0xFA73,0x015B,0x0288,0xFDD5,0xF483,0xE8EE,0xDDFD,0xD674,0xD44C,0xD83B,0xE189,0xEE3E,0xFB93,0x06A1,0x0D0A,0x0D8D,0x084E,0xFECF,0xF393,0xE98A,0xE35B,0xE2C4,0xE835,0xF2AD};
    int TblSinB[256] = {0x0000,0x0C11,0x1549,0x197A,0x17A7,0x103E,0x04FF,0xF892,0xEDE6,0xE781,0xE6E4,0xEC36,0xF634,0x0282,0x0E39,0x1694,0x199A,0x1694,0x0E39,0x0282,0xF634,0xEC36,0xE6E4,0xE781,0xEDE6,0xF892,0x04FF,0x103E,0x17A7,0x197A,0x1549,0x0C11,0x0000,0xF3EF,0xEAB7,0xE686,0xE859,0xEFC2,0xFB01,0x076E,0x121A,0x187F,0x191C,0x13CA,0x09CC,0xFD7E,0xF1C7,0xE96C,0xE666,0xE96C,0xF1C7,0xFD7E,0x09CC,0x13CA,0x191C,0x187F,0x121A,0x076E,0xFB01,0xEFC2,0xE859,0xE686,0xEAB7,0xF3EF,0x0000,0x0C11,0x1549,0x197A,0x17A7,0x103E,0x04FF,0xF892,0xEDE6,0xE781,0xE6E4,0xEC36,0xF634,0x0282,0x0E39,0x1694,0x199A,0x1694,0x0E39,0x0282,0xF634,0xEC36,0xE6E4,0xE781,0xEDE6,0xF892,0x04FF,0x103E,0x17A7,0x197A,0x1549,0x0C11,0x0000,0xF3EF,0xEAB7,0xE686,0xE859,0xEFC2,0xFB01,0x076E,0x121A,0x187F,0x191C,0x13CA,0x09CC,0xFD7E,0xF1C7,0xE96C,0xE666,0xE96C,0xF1C7,0xFD7E,0x09CC,0x13CA,0x191C,0x187F,0x121A,0x076E,0xFB01,0xEFC2,0xE859,0xE686,0xEAB7,0xF3EF,0x0000,0x0C11,0x1549,0x197A,0x17A7,0x103E,0x04FF,0xF892,0xEDE6,0xE781,0xE6E4,0xEC36,0xF634,0x0282,0x0E39,0x1694,0x199A,0x1694,0x0E39,0x0282,0xF634,0xEC36,0xE6E4,0xE781,0xEDE6,0xF892,0x04FF,0x103E,0x17A7,0x197A,0x1549,0x0C11,0x0000,0xF3EF,0xEAB7,0xE686,0xE859,0xEFC2,0xFB01,0x076E,0x121A,0x187F,0x191C,0x13CA,0x09CC,0xFD7E,0xF1C7,0xE96C,0xE666,0xE96C,0xF1C7,0xFD7E,0x09CC,0x13CA,0x191C,0x187F,0x121A,0x076E,0xFB01,0xEFC2,0xE859,0xE686,0xEAB7,0xF3EF,0x0000,0x0C11,0x1549,0x197A,0x17A7,0x103E,0x04FF,0xF892,0xEDE6,0xE781,0xE6E4,0xEC36,0xF634,0x0282,0x0E39,0x1694,0x199A,0x1694,0x0E39,0x0282,0xF634,0xEC36,0xE6E4,0xE781,0xEDE6,0xF892,0x04FF,0x103E,0x17A7,0x197A,0x1549,0x0C11,0x0000,0xF3EF,0xEAB7,0xE686,0xE859,0xEFC2,0xFB01,0x076E,0x121A,0x187F,0x191C,0x13CA,0x09CC,0xFD7E,0xF1C7,0xE96C,0xE666,0xE96C,0xF1C7,0xFD7E,0x09CC,0x13CA,0x191C,0x187F,0x121A,0x076E,0xFB01,0xEFC2,0xE859,0xE686,0xEAB7,0xF3EF};
    int TblSinBC[256] = {0x0000,0x0E94,0x1A48,0x20E8,0x2173,0x1C4F,0x1338,0x08CF,0x0000,0xFB4B,0xFC2D,0x02CA,0x0DDB,0x1B02,0x2755,0x300E,0x3333,0x300E,0x2755,0x1B02,0x0DDB,0x02CA,0xFC2D,0xFB4B,0x0000,0x08CF,0x1338,0x1C4F,0x2173,0x20E8,0x1A48,0x0E94,0x0000,0xF16C,0xE5B8,0xDF18,0xDE8D,0xE3B1,0xECC8,0xF731,0x0000,0x04B5,0x03D3,0xFD36,0xF225,0xE4FE,0xD8AB,0xCFF2,0xCCCD,0xCFF2,0xD8AB,0xE4FE,0xF225,0xFD36,0x03D3,0x04B5,0x0000,0xF731,0xECC8,0xE3B1,0xDE8D,0xDF18,0xE5B8,0xF16C,0x0000,0x0E94,0x1A48,0x20E8,0x2173,0x1C4F,0x1338,0x08CF,0x0000,0xFB4B,0xFC2D,0x02CA,0x0DDB,0x1B02,0x2755,0x300E,0x3333,0x300E,0x2755,0x1B02,0x0DDB,0x02CA,0xFC2D,0xFB4B,0x0000,0x08CF,0x1338,0x1C4F,0x2173,0x20E8,0x1A48,0x0E94,0x0000,0xF16C,0xE5B8,0xDF18,0xDE8D,0xE3B1,0xECC8,0xF731,0x0000,0x04B5,0x03D3,0xFD36,0xF225,0xE4FE,0xD8AB,0xCFF2,0xCCCD,0xCFF2,0xD8AB,0xE4FE,0xF225,0xFD36,0x03D3,0x04B5,0x0000,0xF731,0xECC8,0xE3B1,0xDE8D,0xDF18,0xE5B8,0xF16C,0x0000,0x0E94,0x1A48,0x20E8,0x2173,0x1C4F,0x1338,0x08CF,0x0000,0xFB4B,0xFC2D,0x02CA,0x0DDB,0x1B02,0x2755,0x300E,0x3333,0x300E,0x2755,0x1B02,0x0DDB,0x02CA,0xFC2D,0xFB4B,0x0000,0x08CF,0x1338,0x1C4F,0x2173,0x20E8,0x1A48,0x0E94,0x0000,0xF16C,0xE5B8,0xDF18,0xDE8D,0xE3B1,0xECC8,0xF731,0x0000,0x04B5,0x03D3,0xFD36,0xF225,0xE4FE,0xD8AB,0xCFF2,0xCCCD,0xCFF2,0xD8AB,0xE4FE,0xF225,0xFD36,0x03D3,0x04B5,0x0000,0xF731,0xECC8,0xE3B1,0xDE8D,0xDF18,0xE5B8,0xF16C,0x0000,0x0E94,0x1A48,0x20E8,0x2173,0x1C4F,0x1338,0x08CF,0x0000,0xFB4B,0xFC2D,0x02CA,0x0DDB,0x1B02,0x2755,0x300E,0x3333,0x300E,0x2755,0x1B02,0x0DDB,0x02CA,0xFC2D,0xFB4B,0x0000,0x08CF,0x1338,0x1C4F,0x2173,0x20E8,0x1A48,0x0E94,0x0000,0xF16C,0xE5B8,0xDF18,0xDE8D,0xE3B1,0xECC8,0xF731,0x0000,0x04B5,0x03D3,0xFD36,0xF225,0xE4FE,0xD8AB,0xCFF2,0xCCCD,0xCFF2,0xD8AB,0xE4FE,0xF225,0xFD36,0x03D3,0x04B5,0x0000,0xF731,0xECC8,0xE3B1,0xDE8D,0xDF18,0xE5B8,0xF16C};
    int TblSinC[256] = {0x0000,0x0282,0x04FF,0x076E,0x09CC,0x0C11,0x0E39,0x103E,0x121A,0x13CA,0x1549,0x1694,0x17A7,0x187F,0x191C,0x197A,0x199A,0x197A,0x191C,0x187F,0x17A7,0x1694,0x1549,0x13CA,0x121A,0x103E,0x0E39,0x0C11,0x09CC,0x076E,0x04FF,0x0282,0x0000,0xFD7E,0xFB01,0xF892,0xF634,0xF3EF,0xF1C7,0xEFC2,0xEDE6,0xEC36,0xEAB7,0xE96C,0xE859,0xE781,0xE6E4,0xE686,0xE666,0xE686,0xE6E4,0xE781,0xE859,0xE96C,0xEAB7,0xEC36,0xEDE6,0xEFC2,0xF1C7,0xF3EF,0xF634,0xF892,0xFB01,0xFD7E,0x0000,0x0282,0x04FF,0x076E,0x09CC,0x0C11,0x0E39,0x103E,0x121A,0x13CA,0x1549,0x1694,0x17A7,0x187F,0x191C,0x197A,0x199A,0x197A,0x191C,0x187F,0x17A7,0x1694,0x1549,0x13CA,0x121A,0x103E,0x0E39,0x0C11,0x09CC,0x076E,0x04FF,0x0282,0x0000,0xFD7E,0xFB01,0xF892,0xF634,0xF3EF,0xF1C7,0xEFC2,0xEDE6,0xEC36,0xEAB7,0xE96C,0xE859,0xE781,0xE6E4,0xE686,0xE666,0xE686,0xE6E4,0xE781,0xE859,0xE96C,0xEAB7,0xEC36,0xEDE6,0xEFC2,0xF1C7,0xF3EF,0xF634,0xF892,0xFB01,0xFD7E,0x0000,0x0282,0x04FF,0x076E,0x09CC,0x0C11,0x0E39,0x103E,0x121A,0x13CA,0x1549,0x1694,0x17A7,0x187F,0x191C,0x197A,0x199A,0x197A,0x191C,0x187F,0x17A7,0x1694,0x1549,0x13CA,0x121A,0x103E,0x0E39,0x0C11,0x09CC,0x076E,0x04FF,0x0282,0x0000,0xFD7E,0xFB01,0xF892,0xF634,0xF3EF,0xF1C7,0xEFC2,0xEDE6,0xEC36,0xEAB7,0xE96C,0xE859,0xE781,0xE6E4,0xE686,0xE666,0xE686,0xE6E4,0xE781,0xE859,0xE96C,0xEAB7,0xEC36,0xEDE6,0xEFC2,0xF1C7,0xF3EF,0xF634,0xF892,0xFB01,0xFD7E,0x0000,0x0282,0x04FF,0x076E,0x09CC,0x0C11,0x0E39,0x103E,0x121A,0x13CA,0x1549,0x1694,0x17A7,0x187F,0x191C,0x197A,0x199A,0x197A,0x191C,0x187F,0x17A7,0x1694,0x1549,0x13CA,0x121A,0x103E,0x0E39,0x0C11,0x09CC,0x076E,0x04FF,0x0282,0x0000,0xFD7E,0xFB01,0xF892,0xF634,0xF3EF,0xF1C7,0xEFC2,0xEDE6,0xEC36,0xEAB7,0xE96C,0xE859,0xE781,0xE6E4,0xE686,0xE666,0xE686,0xE6E4,0xE781,0xE859,0xE96C,0xEAB7,0xEC36,0xEDE6,0xEFC2,0xF1C7,0xF3EF,0xF634,0xF892,0xFB01,0xFD7E};

    UART_Device* uart0     = openUART(0);
    FIFO_Device* fifotry   = openFIFO(0);
    FIFO_Device* fifoIn    = openFIFO(1);
    FIFO_Device* fifoOut   = openFIFO(2);

    printf("\nDebut Main\n\n");

    FillFifo(fifoIn,0,TblSinA,256);
    fifoIn->FIFOreg[(2*0)+FIFO_Ctrl] = (fifoIn->FIFOreg[(2*0)+FIFO_Ctrl] | FIFO_ReUse);

    FillFifo(fifoIn,1,TblSinAB,256);
    fifoIn->FIFOreg[(2*1)+FIFO_Ctrl] = (fifoIn->FIFOreg[(2*1)+FIFO_Ctrl] | FIFO_ReUse);

    FillFifo(fifoIn,2,TblSinB,256);
    fifoIn->FIFOreg[(2*2)+FIFO_Ctrl] = (fifoIn->FIFOreg[(2*2)+FIFO_Ctrl] | FIFO_ReUse);

    FillFifo(fifoIn,3,TblSinBC,256);
    fifoIn->FIFOreg[(2*3)+FIFO_Ctrl] = (fifoIn->FIFOreg[(2*3)+FIFO_Ctrl] | FIFO_ReUse);

    FillFifo(fifoIn,4,TblSinC,256);
    fifoIn->FIFOreg[(2*4)+FIFO_Ctrl] = (fifoIn->FIFOreg[(2*4)+FIFO_Ctrl] | FIFO_ReUse);


    while((fifoOut->FIFOreg[(2*0)+FIFO_Ctrl] & FIFO_Full) != FIFO_Full); // TANT QUE  full a 0  RIEN
    printf("\nFull 1\n");
    while((fifoOut->FIFOreg[(2*1)+FIFO_Ctrl] & FIFO_Full) != FIFO_Full); // TANT QUE  full a 0  RIEN
    printf("\nFull 2\n");

    while(1){

        sprintf(temp,"PONG A\n\r");
        uartputs(uart0,temp);

   while(i<257){
        data = (fifoOut->FIFOreg[(2*0)+FIFO_RWdata]);
        i++;
        sprintf(temp,"%d\n\r",data);
        uartputs(uart0,temp);
        }

        i=0;
        sprintf(temp,"PONG B\n\r");
        uartputs(uart0,temp);

    while(i<257){
        data = (fifoOut->FIFOreg[(2*1)+FIFO_RWdata]);
        i++;
        sprintf(temp,"%d\n\r",data);
        uartputs(uart0,temp);
        }

        i=0;
    }
    printf("\nFin Main\n\n");
    return 0;
}
