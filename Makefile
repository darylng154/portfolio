PLAT=$(shell uname -i)
LWP-EX=liblwp-$(PLAT).a
SN-EX=libsnakes-$(PLAT).a
LWP=liblwp.a
32Flag=-m32

all: $(LWP) numbersmain
examples: numbersmain-ex snakemain-ex hungrymain-ex
tests: numbersmain snakemain hungrymain

snakemain: snakemain.c snakes.h $(LWP) $(SN-EX)
	gcc -Wall -Werror -g -o $@ $< $(LWP) $(SN-EX) -lncurses

snakemain-ex: snakemain.c snakes.h $(LWP-EX) $(SN-EX)
	gcc -Wall -Werror -g -o $@ $< $(LWP-EX) $(SN-EX) -lncurses

hungrymain: hungrymain.c snakes.h $(LWP) $(SN-EX)
	gcc -Wall -Werror -g -o $@ $< $(LWP) $(SN-EX) -lncurses

hungrymain-ex: hungrymain.c snakes.h $(LWP-EX) $(SN-EX)
	gcc -Wall -Werror -g -o $@ $< $(LWP-EX) $(SN-EX) -lncurses

numbersmain: numbersmain.c lwp.h $(LWP)
	gcc -Wall ${32Flag} -Werror -g -o $@ $< $(LWP)

numbersmain-ex: numbersmain.c lwp.h $(LWP-EX)
	gcc -Wall -Werror -g -o $@ $< $(LWP-EX)

test: test.c lwp.h $(LWP)
	gcc -Wall ${32Flag} -g -o $@ $< $(LWP)

$(LWP): lwp.o
	ar r $@ lwp.o
	ranlib $@

lwp.o: lwp.c lwp.h
	gcc -Wall ${32Flag} -Werror -g -c -o $@ $<
	gcc -S $<

clean:
	-rm -f numbersmain snakemain hungrymain $(LWP) lwp.o liblwp.o numbersmain-ex snakemain-ex hungrymain-ex
	-rm -f lwp.s
