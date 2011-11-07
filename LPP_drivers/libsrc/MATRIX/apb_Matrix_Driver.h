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
#ifndef APB_MATRIX_DRIVER_H
#define APB_MATRIX_DRIVER_H

/*! \file apb_Matrix_Driver.h
    \brief LPP MATRIX driver.

    This library is written to work with LPP_APB_MATRIX VHDL module from LPP's FreeVHDLIB.

    \author Martin Morlot  martin.morlot@lpp.polytechnique.fr
*/


/*===================================================
        T Y P E S     D E F
====================================================*/
/*! \struct APB_MATRIX_REG
    \brief Sturcture representing the Matrix registers
*/
struct APB_MATRIX_REG
{
    int Statu;  /**< \brief Statu register, To know wich matrix calcul is doing */
};

typedef volatile struct  APB_MATRIX_REG MATRIX_Device;

/*===================================================
        F U N C T I O N S
====================================================*/
/*! \fn MATRIX_Device* openMatrix(int count);
    \brief Return count Matrix.

    This Function scans APB devices table and returns count Matrix.

    \param count The number of the Matrix you whant to get. For example if you have 3 Matrixs on your SOC you want
    to use Matrix0 so count = 0.
    \return The pointer to the device.
*/
MATRIX_Device* openMatrix(int count);




#endif
