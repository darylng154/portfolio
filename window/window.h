#ifndef WINDOW_H
#define WINDOW_H

#include <stdint.h>

#define MAXBUFSIZE 1400

typedef struct window Window;

struct buffer
{
    uint8_t valid;
    uint32_t sequenceNum;
    uint8_t data[MAXBUFSIZE];
};

struct window
{
	int current;
    int lower;
    int upper;
    
    int16_t buffersize;
    uint32_t windowsize;
    struct buffer* buffers;
};

void initWindow(Window* window, uint32_t windowsize, int16_t buffersize);
void cleanup(Window* window);
int getCurrent(Window* window);
void setCurrent(Window* window, int current);
int getLower(Window* window);
void setLower(Window* window, int rrNum);
int getUpper(Window* window);
struct buffer* getIndex(Window* window, int index);
void addToWindow(Window* window, uint8_t* dataBuffer, int dataLen, int index);
void printWindowFields(Window* window);
void printBufferFields(Window* window, int index);
void printWindow(Window* window);
void copyDataAtIndex(uint8_t* dataBuffer, Window* window, int index);
void setValid(Window* window, int index, uint8_t valid);
uint8_t getValid(Window* window, int index);
void setSequenceNum(Window* window, int index, uint32_t sequenceNum);
uint8_t getSequenceNum(Window* window, int index);

#endif