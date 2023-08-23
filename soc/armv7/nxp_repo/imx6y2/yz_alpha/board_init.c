/**********************************************************************
 * FilePath: board_init.c
 * Author: 
 * Date: 2023-8-23 15:40:20
 * Version: 
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/

#include "gpio.h"
#if 0
#include "mem_config.h"
#endif
#include "clock_config.h"
#include "MCIMX6Y2.h"


static void delay(void);


int board_init(void)
{
    pins_iomux_init();
    BOARD_BootClockRUN();

#if 0
    BOARD_InitMemory();
    BOARD_InitDebugConsole();
#endif

    SystemInitIrqTable();
    gpio_init();

    while(1) {
        delay();
    }

    return 0;
}

static void delay(void)
{
    volatile uint32_t i = 0;
    for (i = 0; i < 1000000; ++i)
    {
        __NOP(); /* delay */
    }
}

/******************** end of file ********************/
