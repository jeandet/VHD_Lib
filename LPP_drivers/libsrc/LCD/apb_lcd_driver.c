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
#include "apb_lcd_driver.h"
#include "lpp_apb_functions.h"
#include "lpp_apb_functions.h"
#include <stdio.h>

int lcdbusy(lcd_device* lcd)
{
   return (!(lcd->cfg_reg&readyFlag)==readyFlag);
}


lcd_device* lcdopen(int count)
{
    lcd_device* dev;
    dev = (lcd_device*) apbgetdevice(LPP_LCD_CTRLR,VENDOR_LPP,count);
    return dev;
    //* scan APB bus an return the count(th) lcd controler */

}



lcd_err lcdsendcmd(lcd_device* lcd,int cmd)
{
    lcd_err err;
    err = lcd_error_no_error;
    if (lcd!=NULL)
    {
        while(lcdbusy(lcd));
        lcd->cfg_reg = cmd;
        return err;
    }
    else
    {
        err = lcd_error_not_openned ;
        return err;
    }
}



lcd_err lcdsetchar(lcd_device* lcd,int position,const char value)
{
    lcd_err err;
    err = lcd_error_no_error;
    return err;
}



lcd_err lcdprint(lcd_device* lcd,int position,const char* value)
{
    lcd_err err;
    err = lcd_error_no_error;
    if (lcd!=NULL)
    {
        int i = position;
        int n = 0;
        while(value[n]!= '\0' && i<lcdCharCnt)
        {
                if(value[n] == '\n')
                {
                    i=40;n++;
                }
                lcd->Frame_buff[i++] = value[n++];
        }
        return err;
    }
    else
    {
        err = lcd_error_not_openned ;
        return err;
    }
}



lcd_err lcdclear(lcd_device* lcd)
{
    lcd_err err;
    err = lcd_error_no_error;
    if (lcd!=NULL)
    {
        int i=0;
        for(i=0;i<lcdCharCnt;i++)
        {
         lcd->Frame_buff[i] = ' ';
        }
        return err;
    }
    err = lcd_error_not_openned ;
   return err;
}




