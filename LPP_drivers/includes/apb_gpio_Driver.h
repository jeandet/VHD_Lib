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
#ifndef APB_GPIO_DRIVER_H
#define APB_GPIO_DRIVER_H

/*! \file apb_gpio_Driver.h
    \brief Gaisler GPIO driver.

    This library is written to work with Gaisler GPIO VHDL module.

    \author Martin Morlot  martin.morlot@lpp.polytechnique.fr
*/

/*===================================================
        T Y P E S     D E F
====================================================*/
/*! \struct GPIO_REG
    \brief Sturcture representing the gpio registers
*/
struct GPIO_REG
{
    int Din;    /**< \brief Input GPIO register */
    int Dout;   /**< \brief Output GPIO register */
    int oen;    /**< \brief Enable GPIO register */
};

typedef volatile struct GPIO_REG GPIO_Device;

/*===================================================
        F U N C T I O N S
====================================================*/
/*! \fn GPIO_Device* openGPIO(int count);
    \brief Return count GPIO.

    This Function scans APB devices table and returns count GPIO.

    \param count The number of the GPIO you whant to get. For example if you have 3 GPIOs on your SOC you want
    to use GPIO1 so count = 1.
    \return The pointer to the device.
*/
GPIO_Device* openGPIO(int count);


#endif
