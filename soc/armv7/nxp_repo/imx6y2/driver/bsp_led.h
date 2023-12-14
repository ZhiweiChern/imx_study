/**********************************************************************
 * FilePath: 
 * Author: 
 * Date: 
 * Version: 
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/

#ifndef __BSP_LED_H
#define __BSP_LED_H
// #include "imx6ul.h"

#include "MCIMX6Y2.h"


#define ON 		1
#define OFF		0

#define LED0	0

/* 函数声明 */
void led_init(void);
void led_switch(int led, int status);
#endif

