/*
 * Prac4.cpp
 * 
 * Originall written by Stefan Schröder and Dillion Heald
 * 
 * Adapted for EEE3096S 2019 by Keegan Crankshaw
 * 
 * This file is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 */

#include "Prac4.h"
#include <pthread.h>
#include <sched.h>

using namespace std;

int chan = 0;
bool playing = true; // should be set false when paused
bool stopped = false; // If set to true, program should close

unsigned char buffer[2][BUFFER_SIZE][2];

int buffer_location = 0;
bool bufferWriting = 0; //using this to switch between column 0 and 1 - the first column
bool bufferReading = 0;
bool threadReady = false; //using this to finish writing the first column at the start of the song, before the column is played

//debouncing
long last_interrupt_time = 0; 

// Configure your interrupts here.
// Don't forget to use debouncing.
void play_pause_isr(void){
    long interrupt_time = millis();
    if(interrupt_time-last_interrupt_time>200){
        // Write your logic here
        cout<<"paused"<<endl;
        playing = !playing; 

    }
    last_interrupt_time = interrupt_time;
    
}

void stop_isr(void){
    long interrupt_time = millis();
    if(interrupt_time-last_interrupt_time>200){
        // Write your logic here
        cout<<"stopped"<<endl;
        stopped = true;  

    }
    last_interrupt_time = interrupt_time;
    
}

/*
 * Setup Function. Called once 
 */
int setup_gpio(void){
    cout<< "setting up" << endl;
    //Set up wiring Pi
    wiringPiSetup();
    
    //setting up the buttons
    pullUpDnControl(PLAY_BUTTON, PUD_DOWN);
    pullUpDnControl(PLAY_BUTTON, PUD_UP);
    pinMode(PLAY_BUTTON, INPUT);
    pinMode(STOP_BUTTON, INPUT);
    wiringPiISR(PLAY_BUTTON, INT_EDGE_FALLING, play_pause_isr);
    wiringPiISR(STOP_BUTTON, INT_EDGE_FALLING, stop_isr);

    //setting upt the SPI interface
    wiringPiSPISetup(SPI_CHAN, SPI_SPEED); //defined in prac4.h 
    

    cout << "setup complete" << endl<< endl;
    return 0;
}

/* 
 * Thread that handles writing to SPI
 * 
 * You must pause writing to SPI if not playing is true (the player is paused)
 * When calling the function to write to SPI, take note of the last argument.
 * You don't need to use the returned value from the wiring pi SPI function
 * You need to use the buffer_location variable to check when you need to switch buffers
 */
void *playThread(void *threadargs){
    // If the thread isn't ready, don't do anything
    while(!threadReady){
        cout<< "not ready ... buffering" << endl;
        continue;
    }
    buffer_location = 0;
    //You need to only be playing if the stopped flag is false
    while(!stopped){
        
        //Code to suspend playing if paused
        while(!playing){
            continue;
        }

       /* if(bufferReading == bufferWriting && (buffer_location==0)){
            cout<< "buffering ......" << endl;
            continue;

        }*/
        //Write the buffer out to SPI
        wiringPiSPIDataRW(0, buffer[bufferReading][buffer_location], 2);
        //cout<<"data sent"<<endl;


        //Do some maths to check if you need to toggle buffers
        buffer_location++;
        if(buffer_location >= BUFFER_SIZE) {
            buffer_location = 0;
            bufferReading   = !bufferReading; // switches column one it finishes one column
        }
        
    }
    
    pthread_exit(NULL);
}
pthread_t thread_id;
int initialize_thread_priority(int p){
    pthread_attr_t tattr;
    
    int ret;
    int newprio = p;
    sched_param param;

    /* initialized with default attributes */
    ret = pthread_attr_init (&tattr);

    /* safe to get existing scheduling param */
    ret = pthread_attr_getschedparam (&tattr, &param);

    /* set the priority; others are unchanged */
    param.sched_priority = newprio;

    /* setting the new scheduling param */
    ret = pthread_attr_setschedparam (&tattr, &param);

    /* with new priority specified */
    return  pthread_create (&thread_id, &tattr, playThread, (void*)1); // not sure what value to pass as the last argument so I just used &ret 

}

int main(){
    // Call the setup GPIO function
	if(setup_gpio()==-1){
        return 0;
    }
    
    /* Initialize thread with parameters
     * Set the play thread to have a 99 priority
     * Read https://docs.oracle.com/cd/E19455-01/806-5257/attrib-16/index.html
     */ 
    initialize_thread_priority(99);

    
    /*
     * Read from the file, character by character
     * You need to perform two operations for each character read from the file
     * You will require bit shifting
     * 
     * buffer[bufferWriting][counter][0] needs to be set with the control bits
     * as well as the first few bits of audio
     * 
     * buffer[bufferWriting][counter][1] needs to be set with the last audio bits
     * 
     * Don't forget to check if you have pause set or not when writing to the buffer
     * 
     */
     
    // Open the file
    //ifstream soundfile;
    //soundfile.open("sound_16k_8bit.raw", std::ifstream::in);
    
    FILE *soundfile;
    printf("%s\n", FILENAME);
    soundfile = fopen(FILENAME, "r"); // read mode

    if (soundfile == NULL) {
        perror("Error while opening the file.\n");
        exit(EXIT_FAILURE);
    }
    else{
        cout<<"file opened successfully" << endl;

    }

    //set initial control bits
    int counter = 0;
    char control = 0b01110000;
    char data_read; //8bits of data
    

    
    
    
    cout << "test" << endl;
    // Have a loop to read from the file
    bufferWriting = 0;
    
    while((data_read = fgetc(soundfile)) != EOF){
        while(threadReady && (bufferWriting==bufferReading) && (counter==0)){
            //waits in here after it has written to a side, and the thread is still reading from the other side
            //cout << "waiting" << endl;
            continue;
        }
        //soundfile.read(&data_read, 1); 
        //data_read = fgetc(soundfile);   
        //cout << data_read << endl;
       // printf("%x \n", data_read);
        buffer[bufferWriting][counter][0] = control; // first 8 bits
        buffer[bufferWriting][counter][0] |= (data_read) >> 6;
        buffer[bufferWriting][counter][1] = (data_read) << 2;
        
        //printf("%x \n",buffer[bufferWriting][counter][0]);
        //printf("%x \n\n", buffer[bufferWriting][counter][1]);

        counter++;
        if(counter >= BUFFER_SIZE){
            if(!threadReady){
                threadReady = true;
            }

            counter = 0;
            bufferWriting = !bufferWriting;
            //playThread((void *)1);
        }//finsih loading first buffer
    } //end of file
    
    

    // Close the file
    //soundfile.close();
    fclose(soundfile);
    //Join and exit the playthread
    printf("Complete reading"); 
	 
    //Join and exit the playthread
	pthread_join(thread_id, NULL); 
    pthread_exit(NULL);

    return 0;
    
    
    
}

