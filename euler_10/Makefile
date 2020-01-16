#euler_10: main.o
#	g++ -std=c++17 -g -Wall main.o -o euler_10

#main.o: main.cpp
#	g++ -std=c++17 -g -Wall -c main.cpp

#clean_bin:
#	rm *.o

#clean:
#	rm *.o euler_10

euler_10 : euler_10.hs
	ghc -o euler_10 euler_10.hs

clean_bin:
	rm *.o *.hi

clean:
	rm *.o *.hi euler_10
