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
#include "apb_uart_Driver.h"
#include "lpp_apb_functions.h"
#include <stdio.h>


UART_Device* openUART(int count)
{
    UART_Device* uart0;
    uart0 = (UART_Device*) apbgetdevice(LPP_UART,VENDOR_LPP,count);
    uart0->ConfigReg = BaudGenOnDuty;
    return uart0;
}


void uartputc(UART_Device* dev,char c)
{
    //while (!(dev->ConfigReg & (1<<5)));
    while (!((dev->ConfigReg & DataSended) == DataSended));
    dev->DataWReg = c;
}

void uartputs(UART_Device* dev,char* s)
{
    while (*s) uartputc(dev,*(s++));
}

char uartgetc(UART_Device* dev)
{
    //while (!((dev->ConfigReg & (1<<2))));
    while (!((dev->ConfigReg & NewData) == NewData));
    return dev->DataRReg;
}

void uartgets(UART_Device* dev,char* s)
{
    while (*s && (*s!=0xd)) *s++ = uartgetc(dev);
}

