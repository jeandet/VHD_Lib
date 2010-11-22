#include "stdio.h"
#include "lpp_apb_functions.h"
#include "apb_lcd_driver.h"


int main()
{
    lcd_device* lcd0;
    struct apbdevinfo lcd0info;
    lcd0 = lcdopen(0);
    char message[lcdCharCnt+1];
    if(lcd0!= NULL)
    {
        apbgetdeviceinfofromid(LPP_LCD_CTRLR,VENDOR_LPP,0,&lcd0info);
        printf("find lcd device @ %8x\n",(int)lcd0);
        apbprintdeviceinfo(lcd0info);
    }

    printf("hello\n");
    lcdclear(lcd0);
    int d=0;
    while(d!=10)
    {
        scanf("%d",&d);
        switch(d)
        {
        case 0:
            lcdsendcmd(lcd0,CursorOFF&lcd_100us);
            printf("cursor OFF        \n");
            sprintf(message,"cursor OFF %d",d);
            lcdprint(lcd0,0,message);
            break;
        case 1:
            lcdsendcmd(lcd0,CursorON&lcd_100us);
            printf("cursor ON       \n");
            sprintf(message,"cursor ON %d    ",d);
            lcdprint(lcd0,0,message);
            break;
        case 2:
            sprintf(message,"Test line 2_%d\nline2",d);
            lcdprint(lcd0,0,message);
            break;
        case 3:
            apbprintdeviceslist();
            break;
        case 10:
            sprintf(message,"QUIT %d     ",d);
            lcdprint(lcd0,0,message);
            return 0;
            break;
        default:
            sprintf(message,"Not a CMD %d     ",d);
            lcdprint(lcd0,0,message);
            break;
        }
    }
    return 0;
}
