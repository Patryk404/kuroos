#include "kernel.h"

void clear_screen();
int strlen();
void put_char(char c, char colour);

void print(const char *string, int length);
void kernel_main()
{
    clear_screen();
    put_char('A', GREEN_VGA_COLOUR);
    put_char('B', GREEN_VGA_COLOUR);

    // print("siema siema", strlen("siema siema"));
}

void clear_screen()
{
    uint8_t *screen_ptr = (uint8_t *)VGA_DISPLAY_ADDRESS;
    for (int i = 0; i < 2048; i++)
    {
        screen_ptr[i] = 0;
    }
}

void print(const char *string, int length)
{
    uint8_t *screen_ptr = (uint8_t *)VGA_DISPLAY_ADDRESS;
    // screen_ptr[0] = 'a';
    // screen_ptr[1] = 2;
    screen_ptr[0] = *string;
    screen_ptr[1] = 2;
    // int screen_ptr_counter = 0;
    for (int i = 0; i < 12; i++)
    {
        // screen_ptr[screen_ptr_counter] = (uint8_t)string[i];
        // screen_ptr_counter++;
        // screen_ptr[screen_ptr_counter] = 2;
        // screen_ptr_counter++;
    }
}

void put_char(char c, char colour)
{
    uint8_t *screen_ptr = (uint8_t *)VGA_DISPLAY_ADDRESS;
    screen_ptr[terminal_buffer] = c;
    screen_ptr[terminal_buffer + 1] = colour;
    terminal_buffer += 2;
}

int strlen(const char *string)

{
    int len = 0;
    for (int i = 0; string[i] != '\0'; i++)
    {
        len++;
    }
    return len;
}
