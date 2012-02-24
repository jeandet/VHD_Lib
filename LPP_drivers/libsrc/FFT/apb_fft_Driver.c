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
#include "apb_fft_Driver.h"
#include "lpp_apb_functions.h"
#include <stdio.h>
#include "apb_delay_Driver.h"


FFT_Device* openFFT(int count)
{
    FFT_Device* FFT0;
    FFT0 = (FFT_Device*) apbgetdevice(LPP_FFT,VENDOR_LPP,count);
    return FFT0;
}


int FftInput(int * Tbl,FFT_Device* fft,DELAY_Device* delay)
{
    int i=0;

    while((fft->ConfigReg & FFT_Fill) == FFT_Fill) // fill a 1
    {
        fft->RWDataReg = Tbl[i];
        i++;
        Delay_us(delay,1);
    }

    return 0;
}


int FftOutput(int * Tbl, FFT_Device* fft)
{
    int i=0;
    int data;

    while((fft->ConfigReg & FFT_Ready) == FFT_Ready) // ready a 1
    {
         data = fft->RWDataReg;
         Tbl[i] = (data >> 16) & Mask;
         Tbl[i+1] = data & Mask;
         i = i+2;
    }

    return i;
}










