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
#include "apb_dac_Driver.h"
#include "lpp_apb_functions.h"
#include <stdio.h>


DAC_Device* openDAC(int count)
{
    DAC_Device* dac0;
    dac0 = (DAC_Device*) apbgetdevice(LPP_CNA,VENDOR_LPP,count);
    dac0->ConfigReg = DAC_enable;
    return dac0;
}

/*int DacConst()
{
    DAC_Device* dac3;
    int Value = 0x1FFF;
    dac3 = (DAC_Device*)0x80000800;
    dac3->configReg = DAC_enable;
    while(1)
    {
        printf("\nEntrer une valeur entre 4096 et 8191 : ");
        scanf("%d",&Value);
        dac3->dataReg = Value;
    }
    return 0;
} */

