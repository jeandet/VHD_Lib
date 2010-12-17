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
#ifndef APB_CNA_DRIVER_H
#define APB_CNA_DRIVER_H

#define DAC_ready 3
#define DAC_enable 1
#define DAC_disable 0


/*===================================================
        T Y P E S     D E F
====================================================*/

/** Structure représentant le registre du CNA */
struct DAC_Driver
{
    int configReg;   /**< Registre de configuration: Flag Ready [1] ; Flag Enable [0] */
    int dataReg;     /**< Registre de donnée sur 16 bits */
};

typedef struct DAC_Driver DAC_Device;

/*===================================================
        F U N C T I O N S
====================================================*/

/** Ouvre l'accé au CNA */
DAC_Device* DacOpen(int count);

//DAC_Device* DacClose(int count);

/** Les données sont lus a partir d'un tableau pour obtenir le signal de CAL (10Khz + 625hz) */
int DacTable();

/** Les données sont entrée par l'utilisateur, la conversion se fait a chaque nouvelle donnée */
int DacConst();



#endif
