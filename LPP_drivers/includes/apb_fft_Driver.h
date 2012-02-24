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
#ifndef APB_FFT_DRIVER_H
#define APB_FFT_DRIVER_H
#include "apb_delay_Driver.h"

/*! \file apb_fft_Driver.h
    \brief LPP FFT driver.

    This library is written to work with LPP_APB_FFT VHDL module from LPP's FreeVHDLIB. It calculate a fast fourier transforms,
    from an input data table.

    \author Martin Morlot  martin.morlot@lpp.polytechnique.fr
*/

#define FFT_Fill    0x00000001
#define FFT_Ready   0x00000010
#define Mask        0x0000FFFF


/*===================================================
        T Y P E S     D E F
====================================================*/
/*! \struct FFT_Driver
    \brief Sturcture representing the fft registers
*/
struct FFT_Driver
{
    int ConfigReg;
    int RWDataReg;
};

typedef struct FFT_Driver FFT_Device;


/*===================================================
        F U N C T I O N S
====================================================*/
/*! \fn FFT_Device* openFFT(int count);
    \brief Return count FFT.

    This Function scans APB devices table and returns count FFT.

    \param count The number of the FFT you whant to get. For example if you have 3 FFTS on your SOC you want
    to use FFT1 so count = 1.
    \return The pointer to the device.
*/
FFT_Device* openFFT(int count);
int FftInput(int Tbl[],FFT_Device*,DELAY_Device*);
int FftOutput(int Tbl[],FFT_Device*);


#endif
