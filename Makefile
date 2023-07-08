CC = gcc
CFLAGS = -g -Wall -Werror
OBJS = job.o
HEADER = job.h
ALG = FIFO
QUANTUM = 4
# < 1: if round-robin, else ignore

all:  schedSim

schedSim: schedSim.c ${OBJS}
	$(CC) $(CFLAGS) -o schedSim schedSim.c ${OBJS}

run: clean schedSim
	./schedSim testcases/job.txt -p ${ALG} -q ${QUANTUM}

ver: clean schedSim
#	./schedSim job.txt -p ${ALG} -q ${QUANTUM} -v
	./schedSim testcases/job.txt -q ${QUANTUM} -p ${ALG} -v

srtn: clean schedSim
	./schedSim testcases/srtn.txt -q ${QUANTUM} -p SRTN

fifo: clean schedSim
	./schedSim testcases/fifo.txt -q ${QUANTUM} -p FIFO

rr: clean schedSim
	./schedSim testcases/rr.txt -q ${QUANTUM} -p RR


clean:
	rm -f schedSim
	rm -f *.out	
	rm -f *.o

diff:

