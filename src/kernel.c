#include "kernel.h"

void kernel_main()
{
    uint8_t *p = (uint8_t *)0xb8000;
    *p = 'D';
    p++;
    *p = 2;
}