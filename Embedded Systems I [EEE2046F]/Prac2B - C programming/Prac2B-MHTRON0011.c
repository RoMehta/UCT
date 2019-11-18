
// INCLUDE FILES
//====================================================================
#include "lcd_stm32f0.h"
#include "stm32f0xx_conf.h"
#include <stdint.h>
//====================================================================
// SYMBOLIC CONSTANTS
//====================================================================
int DELAY1 = 1000;
int DELAY2 = 3000;
uint8_t bitpattern1 = 0;
uint8_t bitpattern2 = 0b11111111;
uint8_t bitpattern3 = 0b10101010;
uint8_t bitpatternx = 1;
//====================================================================
// GLOBAL VARIABLES
//====================================================================
//====================================================================
// FUNCTION DECLARATIONS
//====================================================================
void init_GPIOB(void);
void Delay(void);
//====================================================================
// MAIN FUNCTION
//====================================================================
void main (void)
{
	init_GPIOB();
	init_LCD();							// Initialise lcd
	lcd_putstring("RONAK MEHTA");	// Display string on line 1
	lcd_command(LINE_TWO);				// Move cursor to line 2
	lcd_putstring("MHTRON001");	// Display string on line 2
	for(;;)
	{

		if (bitpatternx == 0) {			// Once bitpatternx value reaches 0, It resets to 1 and continues the loop
			bitpatternx = 1;
		}
		GPIOB->ODR = bitpatternx;		// Giving ODR value of bitpatternx
		bitpatternx = bitpatternx<<1;	// Shifting 1 value to the left
		Delay();						// Gives a 1 second delay

	}									// Loop Forever

}										// End of main

//====================================================================
// FUNCTION DEFINITIONS
//====================================================================
void init_GPIOB(void)
{
	RCC  ->AHBENR |= 1<<18;
	GPIOB->MODER  |= 0x00505555;
	GPIOB->ODR     = 0b0000010000001111;
}

void Delay(void){
	for(int i=0; i<DELAY1; i++){
		for (int j = 0; j < DELAY2; ++j) {

		}

	}

}
//********************************************************************
// END OF PROGRAM
//********************************************************************
