// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 11. Finds the largest length n adjacent product for an n by n number grid

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;

//returns the maximum of two integers
int max(int x, int y){
    return ((x > y) ? x : y);
}

//returns a recursive product. if n = 0, multiply by 1, otherwise multiply by the value in the array position to the right
int ltr_recProduct(int n, int* arr){
    return ((n == 0)? 1 : ((*arr) * ltr_recProduct(n - 1, arr + 1)));
}

//returns the maximum of the above recursive product for a given row
int ltr_adjacentProduct(int adjNum, int* arr, int size){
    if(size < adjNum) return 0;

    return max(ltr_adjacentProduct(adjNum, arr + 1, size - 1), ltr_recProduct(adjNum, arr));
}

// returns a recursive product at a given column number by multiplying by the value in the same column in the array "above it" in array position. returns 1 if value the recursive down-counter is 0
int ud_recProduct(int n, int col, int* arr[]){
    return ((n == 0)? 1 : ((*arr)[col] * ud_recProduct(n - 1, col, arr + 1)));
}

// returns the maximum of the up down recursive product for a given column.
int ud_adjacentProduct(int adjNum, int* arr[], int col, int rowCount){
    if(rowCount < adjNum) return 0;

    return max(ud_adjacentProduct(adjNum, arr + 1, col, rowCount - 1), ud_recProduct(adjNum, col, arr));
}

/*
adjNum = 3
arr
arr[0] =>  [0]  2   1   2   third   arr + (adjNum - 2 - 1) = 0  [adjNum - 1 - 2] = 0
            7  [3]  4   5   second  arr + (adjNum - 1 - 1) = 1  [adjNum - 1 - 1] = 1
            8   8  [8]  0   first   arr + (adjNum - 0 - 1) = 2  [adjNum - 1 - 0] = 2
            8   9   1   3


*/

int rdiag_recProduct(int n, int row, int col, int** arr){
    return ((n == 0)? 1 : (arr[row][col] * rdiag_recProduct(n - 1, row - 1, col + 1, arr)));
}

//begins at top left goes to bottom right
//This function takes the diagonal product for each row, then column. Scaling a diagonal of length adjNum
//returns the maximum value of these operations
//works from left to right diagonal
int rdiag_adjacentProduct(int adjNum, int** arr, int size){ //int rowStart, int colStart, int rowSize){
    if(size < adjNum) return 0;

    int val = 1;
    int max = 0;
    for(int m = 0; m <= size - adjNum; m++){
        for(int l = 0; l <= size - adjNum; l++){
            val = 1;
            if(m + adjNum - 1 + l < size){
                for(int i = m; i <= (m + adjNum - 1); i++){
                    val *= arr[i][i + l];
                }
                if(max < val){ max = val; }
                //cout << val << endl;
            }
        }
    }

    //int ret_val = max(max(rdiag_adjacentProduct(adjNum, arr, size, rowStart + 1, colStart, rowSize), val), rdiag_adjacentProduct(adjNum, arr, size - 1, rowStart, colStart + 1, rowSize));
    //cout << ret_val << endl;
    return max;
}

/*
adjNum = 3
arr
arr[0] =>   0   2   1  [2]   third   arr + (adjNum - 2 - 1) = 0  [rowSize - (adjNum - 1 - 2)] = 3
            7   3  [4]  5   second  arr + (adjNum - 1 - 1) = 1  [rowSize - (adjNum - 1 - 1)] = 2
            8  [8]  8   0   first   arr + (adjNum - 0 - 1) = 2  [rowSize - (adjNum - 1 - 0)] = 1
            8   9   1   3


*/


int ldiag_recProduct(int n, int row, int col, int** arr){
    return ((n == 0)? 1 : (arr[row][col] * ldiag_recProduct(n - 1, row - 1, col - 1, arr)));
}

//begins at top left goes to bottom right
//This function takes the diagonal product for each row, then column. Scaling a diagonal of length adjNum. This begins with the bottom-most for each row and works up-diagonal right for adjNum values
//returns the maximum value of these operations
//works from right to left on the diagonal
int ldiag_adjacentProduct(int adjNum, int** arr, int size){ //, int rowStart, int colStart, int rowSize){
    if(size < adjNum) return 0;

    int val = 1;
    int max = 0;
    for(int m = 0; m <= size - adjNum; m++){
        for(int l = size - 1; l >= adjNum - 1; l--){
            val = 1;
            if(m + l < size){
                for(int i = l; i >= l - (adjNum - 1); i--){
                    val *= arr[m + (l - i)][i];
                }
                if(max < val){ max = val;}
                //cout << val << endl;
            }
        }
    }

    //int ret_val = max(max(ldiag_adjacentProduct(adjNum, arr, size, rowStart + 1, colStart, rowSize), val), ldiag_adjacentProduct(adjNum, arr, size - 1, rowStart, colStart - 1, rowSize));
    //cout << ret_val << endl;
    return max;
}

int main(){
    string filename = "";
    cout << "Enter filename: ";
    cin >> filename;

    ifstream inFile;
    inFile.open(filename);
    if(!inFile.is_open()){
        cout << "Improper file entry" << endl;
        return -1;
    }

    int adjNum, rows = 0;

    inFile >> adjNum >> rows;

    if(rows < adjNum){
        cout << "Improper row/adjacency count" << endl;
        return -1;
    }

    vector<int> prod_list;

    int** numBlock = new int*[rows];
    for(int i = 0; i < rows; i++){
        numBlock[i] = new int[rows];
        for(int j = 0; j < rows && !inFile.eof(); j++){
            inFile >> numBlock[i][j];
            cout << numBlock[i][j] << "\t";
        }
        cout << endl;
        prod_list.push_back(ltr_adjacentProduct(adjNum, numBlock[i], rows));
    }

    inFile.close();

    cout << "left to right" << endl;
    for (vector<int>::iterator it = prod_list.begin() ; it != prod_list.end(); ++it){
        cout << *it << '\n';
    }

    for(int j = 0; j < rows; j++){
        cout << "up down: " << j << endl;
        prod_list.push_back(ud_adjacentProduct(adjNum, numBlock, j, rows));
        cout << prod_list.back() << endl << endl;
    }

    cout << "rdiag: " << endl;
    prod_list.push_back(rdiag_adjacentProduct(adjNum, numBlock, rows));
    cout << prod_list.back() << endl << endl;

    cout << "ldiag: " << endl;
    prod_list.push_back(ldiag_adjacentProduct(adjNum, numBlock, rows));
    cout << prod_list.back() << endl << endl;

    int max = prod_list.front();

    for (vector<int>::iterator it = prod_list.begin() ; it != prod_list.end(); ++it){
        if(*it > max) max = *it;
    }

    cout << "Max value: " << max << endl;

    for(int i = 0; i < rows; i++){
        delete[] numBlock[i];
    }

    delete[] numBlock;

    return (max);
}
