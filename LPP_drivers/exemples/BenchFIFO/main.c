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
-------------------------------------------------------------------------------*/
#include "stdio.h"
#include "lpp_apb_functions.h"
#include "apb_fifo_Driver.h"



int main()
{
    int d=0;
    int i=0;
    FIFO_Device* FIFO0;
    FIFO0 = openFIFO(0);

    for(i=0;i<1024;i++)
    {
        FIFO0->rwdata = i;
    }

    for(i=0;i<1024;i++)
    {
        printf("%x",FIFO0->rwdata);
    }


    return 0;
}
