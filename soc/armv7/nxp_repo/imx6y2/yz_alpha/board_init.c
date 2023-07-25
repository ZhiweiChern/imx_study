/**************************************************************

**************************************************************/

#include "MCIMX6Y2.h"

int board_init(void)
{
#if 0
	volatile int a = 0;
	a++;
	unsigned char state = OFF;
#endif

#if 0
	int_init();
	imx6u_clkinit();	/* 初始化系统时钟 			*/
	clk_enable();		/* 使能所有的时钟 			*/
	led_init();			/* 初始化led 			*/
	beep_init();		/* 初始化beep	 		*/
	key_init();			/* 初始化key 			*/
	exit_init();		/* 初始化按键中断			*/

	while(1)			
	{	
		state = !state;
		led_switch(LED0, state);
		delay(500);
	}
#endif
	return 0;
}
