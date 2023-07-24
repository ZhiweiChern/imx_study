/**************************************************************

**************************************************************/

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
