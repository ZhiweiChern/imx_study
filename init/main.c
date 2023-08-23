/**********************************************************************
 * FilePath: main.c
 * Author: 
 * Date: 2023-8-23 15:58:18
 * Version: 
 * Brief: 
 * Note: 
 * Remarks: 
 **********************************************************************/

#include "board_init.h"


/*
 * @description	: main函数
 * @param 		: 无
 * @return 		: 无
 */
int main(void)
{
	int ret = board_init();

	while (ret);

	return 0;
}

/******************** end of file ********************/
