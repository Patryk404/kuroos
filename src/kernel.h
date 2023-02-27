#include <stdint.h>

#ifndef KERNEL_H
#define KERNEL_H
#define VGA_DISPLAY_ADDRESS 0xb8000
#define GREEN_VGA_COLOUR 0x02

void kernel_main();
int terminal_buffer = 0;
#endif