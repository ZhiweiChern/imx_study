/**************************************************************

**************************************************************/

// #include "board_init.h"

extern int board_init(void);


/*
 * @description	: main函数
 * @param 		: 无
 * @return 		: 无
 */
int main(void)
{
	int ret = board_init();

	while (1);

	return 0;
}
