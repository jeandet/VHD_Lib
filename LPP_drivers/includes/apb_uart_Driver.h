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
#ifndef APB_UART_DRIVER_H
#define APB_UART_DRIVER_H


#define BaudGenOnDuty 0
#define DataSended 0x10
#define NewData 0x100

/*===================================================
        T Y P E S     D E F
====================================================*/

struct UART_Driver
{
    int ConfigReg;
    int DataWReg;
    int DataRReg;
};

typedef struct UART_Driver UART_Device;


/*===================================================
        F U N C T I O N S
====================================================*/


UART_Device* openUART(int count);
void uartputc(UART_Device* dev,char c);
void uartputs(UART_Device* dev,char* s);
char uartgetc(UART_Device* dev);
void uartgets(UART_Device* dev,char* s);


#endif
