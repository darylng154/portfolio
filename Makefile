CC= gcc
CFLAGS= -g -Wall
LIBS = 

OBJS = networks.o gethostbyname.o pollLib.o safeUtil.o pdu.o handleTable.o

all:   cclient server

cclient: cclient.c $(OBJS)
	$(CC) $(CFLAGS) -o cclient cclient.c $(OBJS) $(LIBS)

server: server.c $(OBJS)
	$(CC) $(CFLAGS) -o server server.c $(OBJS) $(LIBS)

.c.o:
	gcc -c $(CFLAGS) $< -o $@ $(LIBS)

cleano:
	rm -f *.o

clean:
	rm -f server cclient *.o

server1:
	./server 5678

client1:
	./cclient Bob localhost 5678

client2:
	./cclient Sally localhost 5678

client3:
	./cclient Alice localhost 5678


server2:
	./server 8989

client21:
	./cclient s2_first unix3.csc.calpoly.edu 8989

client22:
	./cclient s2_second unix3.csc.calpoly.edu 8989

client23:
	./cclient s2_third unix3.csc.calpoly.edu 8989


server3:
	./server 9898

client31:
	./cclient s3_first unix3.csc.calpoly.edu 9898

client32:
	./cclient s3_second unix3.csc.calpoly.edu 9898

client33:
	./cclient s3_third unix3.csc.calpoly.edu 9898


