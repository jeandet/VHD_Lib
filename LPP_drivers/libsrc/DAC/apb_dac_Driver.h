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
#ifndef APB_CNA_DRIVER_H
#define APB_CNA_DRIVER_H

#define DAC_ready 3
#define DAC_enable 1
#define DAC_disable 0


/*===================================================
        T Y P E S     D E F
====================================================*/

struct DAC_Driver
{
    int configReg;
    int dataReg;
};

typedef struct DAC_Driver DAC_Device;

/*===================================================
        F U N C T I O N S
====================================================*/

DAC_Device* DacOpen(int count);

//DAC_Device* DacClose(int count);

int DacTable();

int DacConst();



#endif
