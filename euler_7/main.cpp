// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 7. Finds the 10,001 st prime number

#include <iostream>
using namespace std;

int main(){
    int searchNumber = 0;

    do{
        cout << "What prime number do you want to find? Must be greater than 0 (ex. the 41st): ";
        cin >> searchNumber;
    }while(searchNumber < 0);

    int count = 1;
    int* primeArray = new int[searchNumber];
    primeArray[0] = 2;
    int i = 3;

    while(searchNumber > count){
        for(int j = 0; j < count; j++){
            if(i % primeArray[j] == 0){
                break;
            }
            if(j==count - 1){
                primeArray[count] = i;
                count++;
            }
        }
        i += 2;
    }

    /*for(int j = 0; j < searchNumber; j++){
        cout << primeArray[j] << endl;
    }*/

    cout << primeArray[searchNumber - 1] <<endl;

    delete[] primeArray;

    return (0);
}
