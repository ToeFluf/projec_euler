// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 11. Finds the largest length n adjacent product for an n by n number grid

#include <iostream>
#include <fstream>
#include <ctime>
#include "djikstra_matrix.h"
using namespace std;

int** gen2d_arr(int n){
    int** arr = new int*[n];
    srand (time(0));
    for(int i = 0; i < n; i++){
        arr[i] = new int[n];
        for(int j = 0; j < n; j++){
            arr[i][j] = rand() % 1000;
            cout << arr[i][j] << '\t';
        }
        cout << endl;
    }
    return arr;
}

void test(){
    int** arr = nullptr;

    for(int m = 3; m < 25; m++){
        arr = gen2d_arr(m);
        Djikstra_matrix* dm = new Djikstra_matrix(arr, m);

        cout << endl << "Time start" << endl;
    	time_t start = std::clock();

    	cout << dm->min_top_l_to_bot_r() << endl;

    	cout << "Time elapsed: " << (( std::clock() - start ) / (double) CLOCKS_PER_SEC);

        delete dm;
        for(int i = 0; i < m; i++){
            delete[] arr[i];
        }
        delete[] arr;
    }
}

int main(){
    //test();
    //return 0;
    string filename = "";
    cout << "Enter filename: ";
    cin >> filename;

    ifstream inFile;
    inFile.open(filename);
    if(!inFile.is_open()){
        cout << "Improper file entry" << endl;
        return -1;
    }

    int size = 0;

    inFile >> size;

    int** numBlock = new int*[size];
    for(int i = 0; i < size; i++){
        numBlock[i] = new int[size];
        for(int j = 0; j < size && !inFile.eof(); j++){
            inFile >> numBlock[i][j];
            cout << numBlock[i][j] << "\t";
        }
        cout << endl;
    }

    inFile.close();

    Djikstra_matrix* dm = new Djikstra_matrix(numBlock, size);
    cout << endl << "Time start : minimal sum top left to bottom right" << endl;
	time_t start = std::clock();

	cout << dm->min_top_l_to_bot_r() << endl;
	cout << "Time elapsed: " << (( std::clock() - start ) / (double) CLOCKS_PER_SEC) << endl;

    dm->reset_state();

    cout << endl << "Time start : minimal sum left side to right side path" << endl;
	start = std::clock();

	cout << dm->min_l_to_r() << endl;
	cout << "Time elapsed: " << (( std::clock() - start ) / (double) CLOCKS_PER_SEC) << endl;

    dm->reset_state();

    cout << endl << "Time start : minimal sum any position to any position" << endl;
	start = std::clock();

	cout << dm->min_pt1_to_pt2(0,0,size - 1, size - 1) << endl;
	cout << "Time elapsed: " << (( std::clock() - start ) / (double) CLOCKS_PER_SEC) << endl;

    delete dm;
    for(int i = 0; i < size; i++){
        delete[] numBlock[i];
    }
    delete[] numBlock;

    return 0;
}
