 """
Name: Ronak Mehta 
Student Number: MHTRON001
Prac: 01
Date: 29/07/2019
"""

# import Relevant Librares
import RPi.GPIO as GPIO
from itertools import product
import time

# Logic that you write
z=0
mylist = list(product([0,1],repeat = 3))  # Creates all possible combinations of the output

# Sets inputs and outputs pins
GPIO.setmode(GPIO.BOARD)
GPIO.setup(11, GPIO.OUT)                  # LEDs (Outputs) are connected to Board pins 11, 13 and 15
GPIO.setup(13, GPIO.OUT)                  # Push buttons (Input) are connected to Board pins 16 and 18
GPIO.setup(15, GPIO.OUT)
GPIO.setup(16, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setup(18, GPIO.IN, pull_up_down = GPIO.PUD_UP)
GPIO.setwarnings(False)

def main():
    global z
    GPIO.output([11, 13, 15], mylist[z])  # Assigns the output combinations to the output pins

def my_first_callback(channel):           # this is an edge event callback function
    global z
    if z >= 7:
        z = 0
    else:
        z += 1		      		# Increments the value of z by 1 everytime the if condition is not met
    print("Button 1 pressed")
    print(mylist)
    print(mylist[z][0])			# Gives a three bit binary representation of the output digital number
    print(mylist[z][1])
    print(mylist[z][2])

def my_second_callback(channel):
    global z
    if z <= 0:
        z = 7
    else:
        z -= 1				# Decrements the value of z by 1 everytime the if condition is not met
    print("Button 2 pressed")
    print(mylist)
    print(mylist[z][0])			# Gives a three bit binary representation of the output digital number
    print(mylist[z][1])
    print(mylist[z][2])

# adds falling edge detection on the channel
GPIO.add_event_detect(16, GPIO.FALLING, callback = my_first_callback, bouncetime = 400) 
GPIO.add_event_detect(18, GPIO.FALLING, callback = my_second_callback, bouncetime = 400)

# Only run the functions if 
if __name__ == "__main__":
    # Make sure the GPIO is stopped correctly
    try:
        while True:
            main()
    except KeyboardInterrupt:
        print("Exiting gracefully")
        # Turn off your GPIOs here
        GPIO.cleanup()
    except Exception as e:
        GPIO.cleanup()
        print("Some other error occurred")
        print(e.message)
