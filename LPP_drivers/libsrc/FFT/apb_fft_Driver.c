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


FFT_Device* openFFT(int count)
{
    FFT_Device* FFT0;
    FFT0 = (FFT_Device*) apbgetdevice(LPP_FFT,VENDOR_LPP,count);
    return FFT0;
}


int FftInput(int * Tbl,FFT_Device* fft)
{
    int i;
    printf("\nFftInput\n\n");

    while((fft->ConfigReg & FFT_Full) != FFT_Full) // full a 0
    {
        printf("\nWrite\n\n");
        for (i = 0 ; i < 256 ; i++)
        {
            fft->RWDataReg = Tbl[i];
            if((fft->ConfigReg & FFT_Full) == FFT_Full) // full a 1
            {
                printf("\nBreak\n\n");
                break;
            }
        }
    }

    printf("\nFULL\n\n");
    return 0;
}


int FftOutput(int * Tbl, FFT_Device* fft)
{
    int i;
    printf("\nFftOutput\n\n");

    while((fft->ConfigReg & FFT_Empty) != FFT_Empty) // empty a 0
    {
        printf("\nRead\n\n");
        for (i = 0 ; i < 256 ; i++)
        {
            //printf("\noutFor%d\n\n",i);
            Tbl[i] = fft->RWDataReg;
            if((fft->ConfigReg & FFT_Empty) == FFT_Empty) // empty a 1
            {
                printf("\nBreak\n\n");
                break;
            }
        }
    }
    printf("\nEMPTY\n\n");
    return 0;
}










