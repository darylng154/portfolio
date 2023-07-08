#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "job.h"

int verbose;

void initJob(Job* job)
{
    job->number = -1;
    job->run = -1;
    job->arrival = -1;
    job->current_run = 0;

    job->submission = -1;
    job->completion = -1;

    job->turnaround = -1;
    job->wait = -1;
}

void initJobs(Jobs* jobs, int length)
{
    jobs->numJobs = 0;
    // jobs->numQueued = 0;

    int i = 0;
    for(i = 0; i < length; i++)
    {
        initJob(&jobs->list[i]);
    }

    // for(i = 0; i < length*burst; i++)
    // {
    //     initJob(&jobs->queue[i]);
    // }
}

void printJobFields(const Job job, int printDetails)
{
    printf("number: %- 3d | run: %- 2i | arrival: %- 2i | current_run: %- 2i ", job.number, job.run, job.arrival, job.current_run);

    if(printDetails)
        printf("| submission: %- 3i | completion: %- 3i | turnaround: %- 3i | wait: %- 3i \n", job.submission, job.completion, job.turnaround, job.wait);
    else
        printf("\n");
}

void printJobList(const Job* list, int length, int printDetails)
{
    int i = 0;
    for(i = 0; i < length; i++)
    {
        printf("job[%- 3d]: ", i);
        printJobFields(list[i], printDetails);
    }
}

void printJobs(const Jobs* jobs, int printQueue, int printDetails)
{
    printf("\n\n#################################  JOBS Table  #################################\n");
    printf("| numJobs: %d | numQueued: %d\n", jobs->numJobs, jobs->numQueued);
    printf("----------------------------------  JOBS LIST  ---------------------------------\n");
    printJobList(jobs->list, jobs->numJobs, printDetails);
    // if(printQueue)
    // {
    //     printf("----------------------------------  JOBS QUEUE  ---------------------------------\n");
    //     printJobList(jobs->queue, jobs->numQueued, printDetails);
    // }
    printf("################################################################################\n\n\n");
}

void printResults(const Jobs* jobs)
{
    int i = 0;
    for(i = 0; i < jobs->numJobs; i++)
        printf("Job %3d -- Turnaround %3.2f  Wait %3.2f\n", jobs->list[i].number, (float)jobs->list[i].turnaround, (float)jobs->list[i].wait);

    printf("Average -- Turnaround %3.2f  Wait %3.2f\n", avgTurnaroundTime(jobs), avgWaitTime(jobs));
}

void jobswap(Job* dest, Job* src)
{
    Job temp = *dest;
    *dest = *src;
    *src = temp;
}

void sortJobsByArrival(Job* list, int length)
{
    int i = 0, j = 0, k = 0, min_index = 0;
    for(i = 0; i < length-1; i++)
    {
        min_index = i;
        for(j = i + 1; j < length; j++)
        {
            if(list[j].arrival < list[min_index].arrival)
                min_index = j;
        }
        
        if(min_index != i)
        {
            for(k = min_index; k > i; k--)
            {
                jobswap(&list[k], &list[k-1]);
            }
        }
    }
}

void setJobNumber(Job* list, int length)
{
    int i = 0;
    for(i = 0; i < length; i++)
    {
        list[i].number = i;
    }
}

void scheduleQueue(Jobs* jobs, const char* algorithm, const int quantum)
{
    if(!strcmp(algorithm, "SRTN"))
    {
        if(verbose)
            printf("Running SRTN\n");
        runSRTN(jobs);
    }
    else if(!strcmp(algorithm, "FIFO"))
    {
        if(verbose)
            printf("Running FIFO\n");
        runFIFO(jobs);
    }
    else if(!strcmp(algorithm, "RR"))
    {
        if(verbose)
            printf("Running RR\n");
        runRR(jobs, quantum);
    }
    else
    {
        perror("#ERROR: scheduleQueue algorithm not found!");
        exit(EXIT_FAILURE);
    }
}

void runSRTN(Jobs* jobs)
{
    int current_time = 0;
    Job* current_job = NULL;
    Jobs ready;

    while(jobs->numQueued != 0)
    {
        ready = getAvailableJobs(jobs->list, jobs->numJobs, current_time);

        if(ready.list[0].number == -1)
        {
            if(verbose)
                printf("job[%- 3d]:\n", ready.list[0].number);

            current_time++;
            continue;
        }
        
        current_job = findShorestRemainingJob(ready.list, ready.numJobs);
        current_job = &jobs->list[current_job->number];

        if(verbose)
            printf("job[%- 3d]:", current_job->number);

        if(current_time >= current_job->arrival)
        {
            if(verbose)
                printf(" | add to queue[%- 2i]", current_time);

            if(current_job->current_run == 0)
                current_job->submission = current_time;

            current_job->current_run++;
        }
        current_time++;

        if(current_job->current_run == current_job->run)
        {
            current_job->completion = current_time;
            jobs->numQueued--;
        }

        if(verbose)
            printf("\n");
    }
}

void runFIFO(Jobs* jobs)
{
    int i = 0, current_time = 0;
    Job* current_job = NULL;
    for(i = 0; i < jobs->numJobs; i++)
    {
        current_job = &jobs->list[i];

        if(verbose)
            printf("job[%- 3d]:", i);

        for(current_job->current_run = 0; current_job->current_run < current_job->run; current_time++)
        {
            if(current_time >= current_job->arrival)
            {
                if(verbose)
                    printf(" | add to queue[%- 2i]", current_time);

                if(current_job->current_run == 0)
                    current_job->submission = current_time;

                // jobs->queue[current_time] = *current_job;
                // jobs->numQueued++;
                current_job->current_run++;
            }
        }
        current_job->completion = current_time;

        if(verbose)
            printf("\n");
    }
}

void runRR(Jobs* jobs, int quantum)
{
    int i = 0, j = 0, current_time = 0;
    Job* current_job = &jobs->list[0];
    for(i = 0; jobs->numQueued != 0; i++)
    {
        if(i == jobs->numJobs)
            i = 0;

        current_job = &jobs->list[i];

        if(current_job->current_run == current_job->run)
            continue;

        if(verbose)
            printf("job[%- 3d]:", i);

        for(j = 0; j < quantum && current_job->current_run != current_job->run; j++, current_time++)
        {
            if(current_time >= current_job->arrival)
            {
                if(verbose)
                    printf(" | add to queue[%- 2i]", current_time);

                if(current_job->current_run == 0)
                    current_job->submission = current_time;

                current_job->current_run++;
            }
        }

        if(current_job->current_run == current_job->run)
        {
            current_job->completion = current_time;
            jobs->numQueued--;
        }

        if(verbose)
            printf("\n");
    }
}

int turnaroundTime(Job* job)
{
    return job->completion - job->arrival;
}

int waitTime(Job* job)
{
    return job->turnaround - job->run;
}

void setTimes(Jobs* jobs)
{
    int i = 0;
    Job* current_job = NULL;
    for(i = 0; i < jobs->numJobs; i++)
    {
        current_job = &jobs->list[i];
        
        current_job->turnaround = turnaroundTime(current_job);
        current_job->wait = waitTime(current_job);

        // if(verbose)
        //     printf("job[%- 3d]: submission:%d | completion: %d \n", i, submissionTime(jobs, current_job->number), completionTime(jobs, current_job->number));
    }
}

float avgTurnaroundTime(const Jobs* jobs)
{
    int sum = 0;
    int i = 0;
    for(i = 0; i < jobs->numJobs; i++)
    {
        sum += jobs->list[i].turnaround;
    }

    return (float)sum/(float)jobs->numJobs;
}

float avgWaitTime(const Jobs* jobs)
{
    int sum = 0;
    int i = 0;
    for(i = 0; i < jobs->numJobs; i++)
    {
        sum += jobs->list[i].wait;
    }
    
    return (float)sum/(float)jobs->numJobs;
}

// still broken after 1st job[2] is added to queue
Job* findShorestRemainingJob(Job* list, int length)
{
    int i = 0, j = 0, min_index = 0;
    for(i = 0; i < length-1; i++)
    {
        for(j = i + 1; j < length; j++)
        {
            if(list[j].run - list[j].current_run < list[min_index].run - list[min_index].current_run)
                min_index = j;
        }
    }

    return &list[min_index];
}

Jobs getAvailableJobs(Job* list, int length, int current_time)
{
    Jobs result[length];
    int i = 0;

    initJobs(result, length);
    for(i = 0; i < length; i++)
    {
        if(current_time >= list[i].arrival && list[i].current_run < list[i].run)
        {
            result->list[result->numJobs] = list[i];
            result->numJobs++;
        }
    }

    return *result;
}