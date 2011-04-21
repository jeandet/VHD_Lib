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
#ifndef APB_UART_DRIVER_H
#define APB_UART_DRIVER_H

/*! \file apb_uart_Driver.h
    \brief LPP Uart driver.
    
    This library is written to work with LPP_APB_UART VHDL module from LPP's FreeVHDLIB. It help you to print and get 
    char or strings over uart.
    
    \todo Continue documentation
    \author Martin Morlot
*/



#define BaudGenOnDuty 0
#define DataSended 0x10
#define NewData 0x100

/*===================================================
        T Y P E S     D E F
====================================================*/

struct UART_Driver
{
    int ConfigReg;
    int DataWReg;
    int DataRReg;
};

typedef struct UART_Driver UART_Device;


/*===================================================
        F U N C T I O N S
====================================================*/

/*! \fn UART_Device* openUART(int count);
    \brief Return counth UART.
    
    This Function scans APB devices table and returns counth UART.
    
    \param count The number of the UART you whant to get. For example if you have 3 UARTS on your SOC you whant 
    to use UART1 so count = 2.
    \return The pointer to the device.
*/
UART_Device* openUART(int count);

/*! \fn void uartputc(UART_Device* dev,char c);
    \brief Print char over given UART.
    
    This Function puts the given char over the given UART.
    
    \param dev The UART pointer.
    \param c The char you whant to print.
*/
void uartputc(UART_Device* dev,char c);

/*! \fn void uartputs(UART_Device* dev,char* s);
    \brief Print string over given UART.
    
    This Function puts the given string over the given UART.
    
    \param dev The UART pointer.
    \param s The string you whant to print.
*/
void uartputs(UART_Device* dev,char* s);

/*! \fn char uartgetc(UART_Device* dev);
    \brief Get char from given UART.
    
    This Function get char from the given UART.
    
    \param dev The UART pointer.
    \return The read char.
*/
char uartgetc(UART_Device* dev);

/*! \fn void uartgets(UART_Device* dev,char* s);
    \brief Get string from given UART.
    
    This Function get string from the given UART.
    
    \param dev The UART pointer.
    \param s The read string.
*/
void uartgets(UART_Device* dev,char* s);


#endif
