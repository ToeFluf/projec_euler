// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 5. Find the largest number evenly divisible within a range 0 to n.

#include <iostream>
using namespace std;

int main(){
    int searchRange = 0;

    do{
        cout << "What is the top of the search range for evenly divisible numbers, must be > 0 (ex. evenly divisible inside 1 - 10 exclusively)?: ";
        cin >> searchRange;
    }while(searchRange < 1);

    bool numberFound = 0;
    int n = 0;

    while(!numberFound){
        n++;
        for(int i = 1; i < searchRange; i++){
            if(n % i != 0){
                break;
            }
            if(i == searchRange){
                numberFound = 1;
                cout << n;
            }
        }
    }

    return (0);
}
