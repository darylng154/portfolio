/*
Specifically, your simulator should:
1. Read in a list of jobs from a plaintext file, which are described by their run and arrival times 
    (in generic “time units,” which shall only be represented as integers).
2. Assign jobs a number according to their arrival time; i.e. the job that arrives first should receive job 
    number 0, the next job to arrive should receive job number 1, and so on.
3. Based on the selected scheduling algorithm, count time units forward, make the correct scheduling decisions,
    and track the statistics necessary for computing turnaround and wait times. Note: this is a simulator, 
    meaning it should not synchronize with any units of real, wall-clock time.
4. Output a list of increasing job numbers, with their corresponding turnaround and wait times. The result for 
    each job should be printed on its own line, and formatted as:
    Job %3d -- Turnaround %3.2f  Wait %3.2f
5. Finally, compute and display the average turnaround and wait times for all simulated jobs, printed on its own line, and formatted as:
    Average -- Turnaround %3.2f  Wait %3.2f

The usage of the simulator is this:
schedSim <job-file.txt> -p <ALGORITHM> -q <QUANTUM>

- job-file.txt contains a list of job run and arrival times, given as a pair of integers, each on their own line. 
    Note: There should be no restrictions on how jobs appear in job-file.txt; e.g. jobs may be written out of order 
    and may arrive at the same time. Job files are formatted as a tuple of run arrival times:
    8 0
    3 3
    12 1
    6 4
    3 4

- ALGORITHM is a string that defines the scheduling algorithm the simulator will use. Your scheduler should 
    support shortest-remaining job next, first-in first-out, and round-robin, selected by the arguments: 
    SRTN, FIFO, and RR, respectively. The default algorithm should be FIFO, and should be used if an invalid 
    algorithm is given.

- QUANTUM is the length of time, given as an integer, when round-robin is used. The default value should be 1. 
    The quantum can be ignored if any algorithm other than round-robin is given.
- Options (i.e. -p and -q) should be able to  be taken in any order. You may assume the job file will always 
    be the first argument.
*/

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#include "job.h"

#define NUMARGS 6 //(5 args + 1 argv[0])

extern int verbose;
int verbose = 0;

FILE* openFile(char* filename)
{
    FILE* infile;

    if(filename == NULL)
    {
        perror("#ERROR: openFile filename is NULL");
        exit(EXIT_FAILURE);
    }
    else
    {
        if( !(infile = fopen(filename, "r")) )
        {
            perror("Opening File* Failed");
            exit(EXIT_FAILURE);
        }
    }

    return infile;
}

void printoptions(int argc, char* argv[])
{
    int n = 0;
    printf("-----------argv[] options-----------\n");
    printf("optind:%i, argc:%i\n", optind, argc);
    for(n = 1; n < argc; n++)
    {
        printf("argv[%d]: %s\n", n, argv[n]);
    }
    printf("------------------------------------\n");
}

void parseOpt(char** jobFile, char** algorithm, int* quantum, int argc, char* argv[])
{
    if(argc < NUMARGS)
    {
        perror("#ERROR: Too many arguments!");
        exit(EXIT_FAILURE);
    }

    //get arguments
    char c = 0;
    while( (c = getopt(argc, argv, "p:q:v::")) != -1)
    {
        switch(c)
        {
            case 'v':
                printf("option v: %s \n", optarg);  // v has no option => optarg == NULL
                verbose = 1;
                break;

            case 'p': 
                if(verbose)
                    printf("option p: %s \n", optarg);
                *algorithm = optarg;
                break;

            case 'q':
                if(verbose)
                    printf("option q: %s \n", optarg);
                *quantum = atoi(optarg);
                break;

            default:
            printf("#ERROR: Invalid optional argument(s) \n");
            exit(EXIT_FAILURE);
            break;
        }
    }

    *jobFile = argv[optind];
    
    if(verbose)
    {
        printf("option optind(%i): %s (%s)\n", optind, argv[optind], *jobFile);
        printoptions(argc, argv);
    }
}

int readFile(FILE* file, Jobs* jobs)
{
    int i = 0;
    int j = 0;
    int count = 0;
    int quit = -1;
    char c = '\0';

    char line[MAXSIZE] = {'\0'};

    for(i = 0; (c = getc(file)) != EOF; i++)
    {
        if(count >= MAXSIZE)
        {
            perror("readfile buffer ran out!");
            exit(EXIT_FAILURE);
        }

        if(c == ' ')
        {
            jobs->list[count].run = atoi(line);

            // if(verbose)
            //     printf(" = line:%s, run:%i \t|\t ", line, jobs->list[count].run);

            memset(line, '\0', MAXSIZE);
            j = 0;
        }
        else if(c == '\n')
        {
            jobs->list[count].arrival = atoi(line);

            if(verbose)
                printf(" = line:%s, arrival:%i\n", line, jobs->list[count].arrival);

            memset(line, '\0', MAXSIZE);
            j = 0;
            count++;
        }
        else
        {
            if(verbose)
                printf("%c", c);

            line[j++] = c;
        }
    }
    
    // parse last arrival time
    jobs->list[count].arrival = atoi(line);

    if(verbose)
        printf(" = line:%s, arrival:%i\n", line, jobs->list[count].arrival);

    jobs->numJobs = ++count;
    jobs->numQueued = count;
  
    if(c == EOF)
        quit = 1;
    else
    {
        perror("readfile not EOF!");
        exit(EXIT_FAILURE);
    }

    return quit;
}

int main(int argc, char* argv[])
{
    char* algorithm = NULL;
    int quantum = 0; 
    char* job_file = NULL;
    FILE* job_fd = NULL;

    Jobs* jobsTable = (Jobs*) calloc(1, sizeof(Jobs));
    initJobs(jobsTable, MAXSIZE);

    parseOpt(&job_file, &algorithm, &quantum, argc, argv);

    if(verbose)
        printf("parsed job_file: %s | algorithm: %s | quantum %d \n", job_file, algorithm, quantum);

    job_fd = openFile(job_file);
    readFile(job_fd, jobsTable);

    if(verbose)
        printJobs(jobsTable, 1, 1);

    sortJobsByArrival(jobsTable->list, jobsTable->numJobs);
    setJobNumber(jobsTable->list, jobsTable->numJobs);

    if(verbose)
        printJobs(jobsTable, 0, 0);

    scheduleQueue(jobsTable, algorithm, quantum);

    if(verbose)
        printJobs(jobsTable, 1, 0);

    setTimes(jobsTable);

    if(verbose)
        printJobs(jobsTable, 0, 1);

    printResults(jobsTable);

    free(jobsTable);
    return 0;
}