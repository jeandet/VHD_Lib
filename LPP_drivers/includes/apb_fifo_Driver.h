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
#ifndef APB_FIFO_DRIVER_H
#define APB_FIFO_DRIVER_H



/*===================================================
        T Y P E S     D E F
====================================================*/

/** Structure repr�sentant le registre du FIFO */
struct APB_FIFO_REG
{
    int rwdata;   /**< Registre de configuration: Flag Ready [1] ; Flag Enable [0] */
    int raddr;     /**< Registre de donn�e sur 16 bits */
    int cfgreg;
    int dummy0;
    int dummy1;
    int waddr;
};

typedef struct APB_FIFO_REG APB_FIFO_Device;

/*===================================================
        F U N C T I O N S
====================================================*/

/** Ouvre l'acc� au FIFO */
APB_FIFO_Device* apbfifoOpen(int count);




#endif