Exercise1:main.o Primes.o
	g++ -std=c++11 -g -Wall main.o Primes.o -o Exercise1

main.o:main.cpp Primes.h
	g++ -std=c++11 -g -Wall -c main.cpp

Primes.o: Primes.cpp Primes.h
	g++ -std=c++11 -g -Wall -c Primes.cpp

clean:
	rm *.o Exercise1
