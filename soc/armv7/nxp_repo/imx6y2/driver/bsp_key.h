/**********************************************************************
 * FilePath: 
 * Author: 
 * Date: 
 * Version: 
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/

#ifndef _BSP_KEY_H_
#define _BSP_KEY_H_

#include "MCIMX6Y2.h"

/* 定义按键值 */
enum keyvalue{
    KEY_NONE   = 0,
    KEY0_VALUE,
    KEY1_VALUE,
    KEY2_VALUE,
};

/* 函数声明 */
void key_init(void);
int key_getvalue(void);


#endif	/* _BSP_KEY_H_ */
