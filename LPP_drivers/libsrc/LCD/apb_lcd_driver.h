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
/*--                  Author : Alexis Jeandet
--                     Mail : alexis.jeandet@lpp.polytechnique.fr
----------------------------------------------------------------------------*/
#ifndef APB_LCD_DRIVER_H
#define APB_LCD_DRIVER_H

#define readyFlag 1024
#define lcdCharCnt 80


/** @todo implemente some shift functions */


/*===================================================
        T Y P E S     D E F
====================================================*/



/** error type used for most of lcd functions */
typedef int lcd_err;

/** lcd error ennum for higher abstraction level when error decoding */
 enum lcd_error
{
    lcd_error_no_error,         /**< no error append while function execution */
    lcd_error_not_ready,        /**< the lcd isn't available*/
    lcd_error_not_openned,      /**< the device guiven to the function isn't opened*/
    lcd_error_too_long          /**< the string guiven to the lcd is bigger than the lcd frame buffer memory */
};


/** for each command sended to the lcd driver a time should be guiven according to the lcd datasheet */
 enum lcd_CMD_time
{
    lcd_4us     = 0x0FF,
    lcd_100us   = 0x1FF,
    lcd_4ms     = 0x2FF,
    lcd_20ms    = 0x3FF
};

/** list of availiable lcd commands use whith an AND mask whith cmd time */
 enum lcd_CMD
{
    CursorON    = 0xF0E,
    CursorOFF   = 0xF0C
};

/** structure representing the lcd registers */
struct lcd_driver
{
    int cfg_reg;                    /**< Configuration register composed of Ready flag [10], CMD time Value [9:8], CMD to send [7:0]*/
    int Frame_buff[lcdCharCnt];     /**< Frame Buffer space each address corresponds to a char on the lcd screen */
};

typedef struct lcd_driver lcd_device;

/*===================================================
        F U N C T I O N S
====================================================*/

/** says if the lcd is busy */
int lcdbusy(lcd_device * lcd);

/** Opens and returns the counth lcd found on APB bus else NULL */
lcd_device* lcdopen(int count);

/** Sends a command to the given device, don't forget to guive the time of the cmd */
lcd_err lcdsendcmd(lcd_device* lcd,int cmd);

/** Sets a char on the given device at given position */
lcd_err lcdsetchar(lcd_device* lcd,int position,const char value);

/** Prints a message on the given device at given position, "\n" is understood but for others use sprintf before */
lcd_err lcdprint(lcd_device* lcd,int position,const char* value);

/** Writes space character on each adress of the lcd screen */
lcd_err lcdclear(lcd_device* lcd);

#endif
