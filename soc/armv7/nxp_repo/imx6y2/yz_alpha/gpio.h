/**********************************************************************
 * FilePath: gpio.h
 * Author: 
 * Date: 2023-8-23 15:39:19
 * Version: V1
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/
#ifndef _GPIO_H_
#define _GPIO_H_


#ifdef __cplusplus
extern "C" {
#endif

int pins_iomux_init(void);
void gpio_init(void);
void key0_irqhandler(void);

#ifdef __cplusplus
}
#endif

#endif  /* _GPIO_H_ */

/******************** end of file ********************/
