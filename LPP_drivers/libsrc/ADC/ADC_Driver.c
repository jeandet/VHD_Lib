/*------------------------------------------------------------------------------
--  This file is a part of the LPP VHDL IP LIBRARY
--  Copyright (C) 2009 - 2010, Laboratory of Plasmas Physic - CNRS
--
--  This program is free software; you can redistribute it and/or modify
--  it under the terms of the GNU General Public License as published by
--  the Free Software Foundation; either version 3 of the License, or
--  (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with this program; if not, write to the Free Software
--  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
-------------------------------------------------------------------------------
--                      Author : Martin Morlot
--                     Mail : martin.morlot@lpp.polytechnique.fr
-----------------------------------------------------------------------------*/
#include "ADC_Driver.h"
#include <stdio.h>

unsigned char   packetNumber = 0;

void flushFIFO(FIFO_Device*fifo,GPIO_Device* adcResetPin)
{
    adcResetPin->Dout = 0x0;
    int trash;
    while((fifo->FIFOreg[(2*0)+FIFO_Ctrl] & FIFO_Empty) != FIFO_Empty){ // TANT QUE  empty a 0  ALORS
        trash = fifo->FIFOreg[(2*0)+FIFO_RWdata];
        trash = fifo->FIFOreg[(2*1)+FIFO_RWdata];
        trash = fifo->FIFOreg[(2*2)+FIFO_RWdata];
        trash = fifo->FIFOreg[(2*3)+FIFO_RWdata];
        trash = fifo->FIFOreg[(2*4)+FIFO_RWdata];
    }

    adcResetPin->Dout = 0x1;
}

void getPacket(FIFO_Device*fifo,unsigned short*CH1,unsigned short*CH2,unsigned short*CH3,unsigned short*CH4,unsigned short*CH5,int packetSize)
{
    int i=0;
    for(i=0;i<packetSize;i++)
    {
        while((fifo->FIFOreg[(2*0)+FIFO_Ctrl] & FIFO_Empty) == FIFO_Empty);
        CH1[i] = (fifo->FIFOreg[(2*0)+FIFO_RWdata] & Mask);
        CH2[i] = (fifo->FIFOreg[(2*1)+FIFO_RWdata] & Mask);
        CH3[i] = (fifo->FIFOreg[(2*2)+FIFO_RWdata] & Mask);
        CH4[i] = (fifo->FIFOreg[(2*3)+FIFO_RWdata] & Mask);
        CH5[i] = (fifo->FIFOreg[(2*4)+FIFO_RWdata] & Mask);
    }
}

void mkfakePacket(FIFO_Device*fifo,unsigned short*CH1,unsigned short*CH2,unsigned short*CH3,unsigned short*CH4,unsigned short*CH5,int packetSize)
{
    int i=0;
    for(i=0;i<packetSize;i++)
    {
        CH1[i] = (unsigned short)(i);
        CH2[i] = (unsigned short)(i+10);
        CH3[i] = (unsigned short)(i+20);
        CH4[i] = (unsigned short)(i+30);
        CH5[i] = (unsigned short)(i+40);
    }
}


void sendPacket(UART_Device* uart0,unsigned short*CH1,unsigned short*CH2,unsigned short*CH3,unsigned short*CH4,unsigned short*CH5,int packetSize)
{
        int i=0;

		for(i=0;i<packetSize;i++)
		{
		    uartputc(uart0,0xa5);
            uartputc(uart0,0x0f);
            uartputc(uart0,packetNumber++);
            uartputc(uart0,(char)(CH1[i]>>8));
            uartputc(uart0,(char)CH1[i]);
            uartputc(uart0,(char)(CH2[i]>>8));
            uartputc(uart0,(char)CH2[i]);
            uartputc(uart0,(char)(CH3[i]>>8));
            uartputc(uart0,(char)CH3[i]);
            uartputc(uart0,(char)(CH4[i]>>8));
            uartputc(uart0,(char)CH4[i]);
            uartputc(uart0,(char)(CH5[i]>>8));
            uartputc(uart0,(char)CH5[i]);
            uartputc(uart0,0xf0);
            uartputc(uart0,0x5a);
		}

}
