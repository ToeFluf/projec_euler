path_sums: djikstra_matrix.o main.o
	g++ -std=c++17 -g -Wall djikstra_matrix.o main.o -o path_sums

djikstra_matrix.o: djikstra_matrix.cpp djikstra_matrix.h
	g++ -std=c++17 -g -Wall -c djikstra_matrix.cpp

main.o: main.cpp djikstra_matrix.h
	g++ -std=c++17 -g -Wall -c main.cpp

clean:
	rm *.o path_sums
