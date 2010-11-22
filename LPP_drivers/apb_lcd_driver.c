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




