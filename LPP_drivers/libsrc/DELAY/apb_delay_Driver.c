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
#include "lpp_apb_functions.h"
#include "apb_delay_Driver.h"
#include <stdio.h>


DELAY_Device* openDELAY(int count)
{
    DELAY_Device* delay0;
    delay0 = (DELAY_Device*) apbgetdevice(LPP_DELAY,VENDOR_LPP,count);
    return delay0;
}

int Setup(DELAY_Device* dev,int X)
{
    dev->Fboard = X;
    return dev->Fboard;
}


int Delay_s(DELAY_Device* dev,int T)
{
    dev->Timer = dev->Fboard * T;
    dev->Cfg = 0x11;
    while(dev->Cfg != Delay_End);
    dev->Cfg = 0x01;
    return dev->Cfg;
}


int Delay_ms(DELAY_Device* dev,int T)
{
    dev->Timer = (dev->Fboard / 1000) * T;
    dev->Cfg = 0x11;
    while(dev->Cfg != Delay_End);
    dev->Cfg = 0x01;
    return dev->Cfg;
}


int Delay_us(DELAY_Device* dev,int T)
{
    dev->Timer = (dev->Fboard / 1000000) * T;
    dev->Cfg = 0x11;
    while(dev->Cfg != Delay_End);
    dev->Cfg = 0x01;
    return dev->Cfg;
}










