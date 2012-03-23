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

#define FFT_Fill    0x00000001
#define FFT_Ready   0x00000010
#define Mask        0x0000FFFF


/*===================================================
        T Y P E S     D E F
====================================================*/

struct FFT_Driver
{
    int ConfigReg;
    int RWDataReg;
};

typedef struct FFT_Driver FFT_Device;


/*===================================================
        F U N C T I O N S
====================================================*/

FFT_Device* openFFT(int count);
int FftInput(int Tbl[],FFT_Device*,DELAY_Device*);
int FftOutput(int Tbl[],FFT_Device*);



#endif
