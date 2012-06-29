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
#ifndef ADC_DRIVER_H
#define ADC_DRIVER_H

#include "apb_fifo_Driver.h"
#include "apb_uart_Driver.h"
#include "apb_gpio_Driver.h"

#define samplecnt   4096
#define Mask        0x0000FFFF

/*===================================================
        F U N C T I O N S
====================================================*/

void flushFIFO(FIFO_Device*,GPIO_Device*);
void getPacket(FIFO_Device*,unsigned short*,unsigned short*,unsigned short*,unsigned short*,unsigned short*,int);
void mkfakePacket(FIFO_Device*,unsigned short*,unsigned short*,unsigned short*,unsigned short*,unsigned short*,int);
void sendPacket(UART_Device*,unsigned short*,unsigned short*,unsigned short*,unsigned short*,unsigned short*,int);

#endif
