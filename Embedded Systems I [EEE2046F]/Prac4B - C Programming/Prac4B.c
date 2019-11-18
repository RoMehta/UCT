
// INCLUDE FILES
//====================================================================
#include "lcd_stm32f0.h"
#include "stm32f0xx_conf.h"
#include <stdint.h>
#include <stdio.h>
//====================================================================
// SYMBOLIC CONSTANTS
//====================================================================
#define SW0 GPIO_IDR_0
#define SW1 GPIO_IDR_1
#define SW2 GPIO_IDR_2
#define SW3 GPIO_IDR_3

int DELAY1 = 1000;
int DELAY2 = 3000;
uint16_t bitpattern = 0b00000000;
//====================================================================
// GLOBAL VARIABLES
//====================================================================
char value1;
int toggle = 1;
char flag;
//====================================================================
// FUNCTION DECLARATIONS
//====================================================================
void InitPorts(void);
void Delay(void);
void CountUp(char value);
void CountDown(char value);
//====================================================================
// MAIN FUNCTION
//====================================================================
void main (void)
{
	init_LCD();							// Initialise lcd
	lcd_putstring("RONAK MEHTA");	    // Display string on line 1
	lcd_command(LINE_TWO);				// Move cursor to line 2
	lcd_putstring("MHTRON001");			// Display string on line 2

	while ((GPIOA->IDR & SW0) != 0){
	value1 = 0;
	}

	flag = 1;

	do{
		if((GPIOA->IDR & SW1) == 0){
			flag=1;
		}
		else if ((GPIOA->IDR & SW2) == 0){
			flag=2;
		}
		if(flag=1){
			GPIOB->ODR = CountUp(value1);
			value1++;
		}
		else if (flag=2){
			GPIOB->ODR = CountDown(value1);
			value1--;
		}
		Delay();
	}
	while (toggle = 1);					// Loop Forever
}										// End of main

//====================================================================
// FUNCTION DEFINITIONS
//====================================================================
void Delay(void){
	for(int i=0; i<DELAY1; i++){
		for (int j = 0; j < DELAY2; ++j) {
		}
	}
}

void InitPorts(void){
// enable clock for push buttons
RCC->AHBENR |= RCC_AHBENR_GPIOAEN;

// set pins A0-A3 to GPIO inputs
GPIOA->MODER &=    ~(GPIO_MODER_MODER0|
					 GPIO_MODER_MODER1|
					 GPIO_MODER_MODER2);

// enable pull up resistors
GPIOA->PUPDR |=    (GPIO_PUPDR_PUPDR0_0|
				    GPIO_PUPDR_PUPDR1_0|
					GPIO_PUPDR_PUPDR2_0);

// Enable clock for LEDs
RCC->AHBENR |= RCC_AHBENR_GPIOBEN;

// set pins B0-B7, B10 and B11 to GPIO Outputs
GPIOB->MODER |=    (GPIO_MODER_MODER0_0|
					GPIO_MODER_MODER1_0|
					GPIO_MODER_MODER2_0|
					GPIO_MODER_MODER3_0|
					GPIO_MODER_MODER4_0|
					GPIO_MODER_MODER5_0|
					GPIO_MODER_MODER6_0|
					GPIO_MODER_MODER7_0);

//To turn the LEDs off at the start of the program, we set the ODR to 0
GPIOB->ODR = bitpattern;
}

char CountUp(char value){
	if (value < 256){
		GPIOB->ODR = value;		// displays value
		value++; 				// increments the value by 1 each time
	}
	else {
		value = 0;				// resets to 0 when value is greater than 256
		GPIOB->ODR = value;
	}
	return(value);
	Delay();
}

char CountDown(char value){
	if (value != 0){
		GPIOB->ODR = value;		// displays value
		value--; 				// decrements the value by 1 each time
	}
	else {
		value = 255;			// gives back value 255 if less than 0
		GPIOB->ODR = value;
	}
	return(value);
	Delay();
}
//********************************************************************
// END OF PROGRAM
//********************************************************************

