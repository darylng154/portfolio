#ifndef JOB_H
#define JOB_H

#define MAXSIZE 100

typedef struct job Job;
typedef struct jobs Jobs;

struct job
{
    int number;
    int run;
    int arrival;
    int current_run;

    int submission;
    int completion;

    int turnaround;
    int wait;
};

struct jobs
{
    int numJobs;
    Job list[MAXSIZE];

    int numQueued;
    // Job queue[MAXSIZE];
};

void initJob(Job* job);
void initJobs(Jobs* jobs, int length);
void printJobFields(const Job job, int printDetails);
void printJobList(const Job* list, int length, int printDetails);
void printJobs(const Jobs* jobs, int printQueue, int printDetails);
void printResults(const Jobs* jobs);
void jobswap(Job* dest, Job* src);
void sortJobsByArrival(Job* list, int length);
void setJobNumber(Job* list, int length);
void scheduleQueue(Jobs* jobs, const char* algorithm, const int quantum);
void runSRTN(Jobs* jobs);
void runFIFO(Jobs* jobs);
void runRR(Jobs* jobs, int quantum);
int turnaroundTime(Job* job);
int waitTime(Job* job);
void setTimes(Jobs* jobs);
float avgTurnaroundTime(const Jobs* jobs);
float avgWaitTime(const Jobs* jobs);
Job* findShorestRemainingJob(Job* list, int length);
Jobs getAvailableJobs(Job* list, int length, int current_time);

#endif