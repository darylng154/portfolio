#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "lwp.h"

#define WORDSIZE 4
#define BBP_ADDR 0xDEADBEEF

lwp_context lwp_ptable[LWP_PROC_LIMIT];     /* the process table           */
int lwp_procs = 0;                          /* the current number of LWPs  */
int lwp_running = -1;                        /* the index of the currently running LWP */
ptr_int_t* og_esp = 0;                       // original stack pointer before function call
schedfun scheduler = round_robin;

/*
new_lwp(function, argument, stacksize):
    Creates a new lightweight process whose functionality is defined by the given function with the given argument. 
    The new LWP’s stack will be stacksize words. The LWP’s process table entry will include:

        pid - A unique integer process id
        stack - A pointer to the lowest address of the memory region for this thread’s stack
        stacksize - The size of this thread’s stack in words
        sp - This thread’s current stack pointer (top of stack)

    new_lwp() returns the LWP process id of the newly allocated thread, or -1 if more than LWP_PROC_LIMIT threads already exist.
*/
int new_lwp(lwpfun function, void* argument, size_t stacksize)
{    
    ptr_int_t* bbp = NULL;
    int i = 0;

    if(lwp_procs > LWP_PROC_LIMIT)
        return -1;

    lwp_ptable[lwp_procs].pid = lwp_getpid();

    lwp_ptable[lwp_procs].stack = (ptr_int_t*)malloc(stacksize * WORDSIZE);

    lwp_ptable[lwp_procs].stacksize = stacksize;

    // top of stack = stack address + stacksize
    lwp_ptable[lwp_procs].sp = lwp_ptable[lwp_procs].stack + stacksize;

    // push argument onto thread stack
    lwp_ptable[lwp_procs].sp --;
    *(lwp_ptable[lwp_procs].sp) = (ptr_int_t)argument;

    // push lwp_exit() as return address
    lwp_ptable[lwp_procs].sp --;
    *(lwp_ptable[lwp_procs].sp) = (ptr_int_t)lwp_exit;

    // push function address
    lwp_ptable[lwp_procs].sp --;
    *(lwp_ptable[lwp_procs].sp) = (ptr_int_t)function;

    // push bbp = 0
    lwp_ptable[lwp_procs].sp --;
    bbp = lwp_ptable[lwp_procs].sp; // set bbp to point to bbp on stack
    *(lwp_ptable[lwp_procs].sp) = BBP_ADDR;

    // push 6 arbitrary words
    for(i = 0; i < 6; i++)
    {
        lwp_ptable[lwp_procs].sp --;
        *(lwp_ptable[lwp_procs].sp) = i+10;
    }

    // push &bbp
    lwp_ptable[lwp_procs].sp --;
    *(lwp_ptable[lwp_procs].sp) = (ptr_int_t)bbp;

    lwp_procs++;

    return lwp_ptable[lwp_procs - 1].pid;
}


/*
lwp_getpid():
    Returns the pid of the calling LWP. The return value of lwp_getpid() is undefined if not called by a LWP.
*/
int lwp_getpid()
{
    return (int)getpid();
}

/*
lwp_yield():
    Yields control to another thread. Which thread depends on the scheduler. Saves the current thread’s context (on its stack), 
    schedules the next thread, restores that thread’s context, and returns.
*/
void lwp_yield()
{
    SAVE_STATE();
    GetSP(lwp_ptable[lwp_running].sp);

    lwp_running = scheduler();

    SetSP(lwp_ptable[lwp_running].sp);   // set esp to top of the stack
    RESTORE_STATE();
}

/*
lwp_exit():
    Terminates the current LWP, removes it from the process table, and moves all the other’s up in the table. If no threads remain, 
    it should restore the current stack pointer and return to that context.
*/
void lwp_exit()
{
    SAVE_STATE();
    GetSP(lwp_ptable[lwp_running].sp);

    int i = 0;

    for(i = 0; i < lwp_procs-1; i++)
    {
        lwp_ptable[i] = lwp_ptable[i+1];
    }

    lwp_procs--;

    if(lwp_procs == 0)
    {
        lwp_stop();
    }
    else
    {
        SetSP(lwp_ptable[lwp_running].sp);
        RESTORE_STATE();  
    }
}

/*
lwp_start():
    Starts (or resumes) the LWP system. Saves the original context and stack pointer (for lwp_stop or lwp_exit to use later), 
    schedules an LWP, and starts it running. Returns immediately if there are no LWPs.
*/
void lwp_start()
{
    if(lwp_procs == 0)
        return;

    SAVE_STATE();
    GetSP(og_esp);

    lwp_running = scheduler();

    SetSP(lwp_ptable[lwp_running].sp);
    RESTORE_STATE();
}

/*
lwp_stop():
    Stops the LWP system, restores the original stack pointer and returns to that context (wherever lwp_start() was called from). 
    lwp_stop() does not destroy any existing contexts, and thread processing will be restarted by a call to lwp_start().
*/
void lwp_stop()
{
    SAVE_STATE();
    GetSP(lwp_ptable[lwp_running].sp);

    SetSP(og_esp);
    RESTORE_STATE();
}

int round_robin()
{
    lwp_running++;

    if(lwp_running >= lwp_procs || lwp_running == -1)
        lwp_running = 0;

    return lwp_running;
}

/*
lwp_set_scheduler(scheduler):
    Causes the LWP library to use the function scheduler to choose the next LWP to run. (*scheduler)() must return an integer in the 
    range 0…lwp_procs-1. If scheduler is NULL, or never been set, the library should do round robin scheduling.
*/
void lwp_set_scheduler(schedfun sched)
{
    if(sched != NULL)
        scheduler = sched;
    else
        scheduler = round_robin;
}