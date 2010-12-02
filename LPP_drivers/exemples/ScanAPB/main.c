#include "stdio.h"
#include "lpp_apb_functions.h"



int main()
{
    int d=0;
    while(d!=10)
    {
        scanf("%d",&d);
        switch(d)
        {
        case 0:
            printf("cursor OFF        \n");
            break;
        case 1:
            printf("cursor ON       \n");
            break;
        case 2:
            break;
        case 3:
            apbprintdeviceslist();
            break;
        case 10:
            return 0;
            break;
        default:
            break;
        }
    }
    return 0;
}
