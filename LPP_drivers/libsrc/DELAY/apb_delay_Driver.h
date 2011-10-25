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
#ifndef APB_FIFO_DRIVER_H
#define APB_FIFO_DRIVER_H


#define Delay_End 0x111

/*===================================================
        T Y P E S     D E F
====================================================*/

struct DELAY_REG
{
    int Cfg;
    int Fboard;
    int Timer;
};

typedef volatile struct DELAY_REG DELAY_Device;

/*===================================================
        F U N C T I O N S
====================================================*/

DELAY_Device* openDELAY(int count);
int Delay_us(DELAY_Device* dev,int T);
int Delay_ms(DELAY_Device* dev,int T);
int Delay_s(DELAY_Device* dev,int T);
int Setup(DELAY_Device* dev,int X);


#endif
