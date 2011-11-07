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
#include "apb_fifo_Driver.h"
#include <stdio.h>


FIFO_Device* openFIFO(int count)
{
    FIFO_Device* fifo0;
    fifo0 = (FIFO_Device*) apbgetdevice(LPP_FIFO,VENDOR_LPP,count);
    return fifo0;
}


int FillFifo(FIFO_Device* dev,int Tbl[],int A)
{
    int i=0;
    while(i <= A)
    {
        dev->rwdata = Tbl[i];
        i++;
    }

    return 0;
}
