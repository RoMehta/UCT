#include <stdio.h>
#include <stdlib.h>
#include <math.h>

# define TITLE "DECIMAL TO RADIX-n converter"
# define AUTHOR "Ronak Mehta"
# define YEAR 2018

//Global Variables
int dec;
int radix;
double log_value;
int remainder_value;
int int_result;
int loop = 0;
int num_of_digits;

char* Dec2RadixN(int decValue, int radValue);  // Declaring the Function

int main ()
{
   printf("****************************\n");
   printf("%s \n",TITLE);
   printf("Written by: %s \n",AUTHOR);
   printf("Date: %d \n",YEAR);
   printf("****************************\n");

   while(1){    //When True; this code will be implemented
      printf("Enter a decimal number: ");
      scanf("%d", &dec);

      if (dec < 0){
         printf("EXIT\n");
         break;
      }

      printf("The number you have entered is %d\n",dec);
      printf("Enter a radix for the converter between 2 and 16: ");
      scanf("%d", &radix);
      printf("The radix you have entered is %d\n", radix);

      log_value = log(dec)/log(2);
      printf("The log2 of the number is %.2f\n", log_value);

      int_result = dec / radix;
      printf("The integer result of the number divided by %d is %d\n", radix, int_result);

      remainder_value = dec % radix;
      printf("The remainder is %d\n",remainder_value);
      printf("The radix-%d value is ",radix);

      num_of_digits = ceil((log(dec))/(log(radix)))+1;   // Use of ceil to round up the value

      for(loop = 0; loop < num_of_digits; loop++) {  // Generates results until the limiting condition is met
      printf("%c", Dec2RadixN(dec,radix)[loop]);   // Call to the function
      }
      printf("\n");
   }
   return 0;
}   // End of Main Function

char* Dec2RadixN(int decValue, int radValue)   // Function being defined
{
   int n = num_of_digits;
   char radix_value[num_of_digits];
   int_result = decValue;
   char digits[] = {'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
   char* solution;

   while (n>0)
   {
      remainder_value = int_result%radValue;
      int_result = int_result/radValue;
      radix_value[--n] = digits[remainder_value];
   }

   solution = radix_value;
   return solution;
}
// End of Program
