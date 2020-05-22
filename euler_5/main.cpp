// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 5. Find the largest number evenly divisible by all integers within a range 1 to n.

#include <iostream>
using namespace std;

int main(){
    int searchRange = 0;

    do{
        cout << "What is the top of the search range for evenly divisible numbers, must be > 1 (ex. evenly divisible inside 1 - 10 exclusively)?: ";
        cin >> searchRange;
    }while(searchRange < 2);

    bool numberFound = 0;
    int n = searchRange;

    do{
        int i = 2;
        while(i <= searchRange){
            if(i == searchRange){
                numberFound = 1;
                cout << n << endl;
            }
            if(n % i == 0){
                i++;
            }
            else{
                i = searchRange + 1;
            }
        }
        n += searchRange;
    }while(!numberFound);

    return (0);
}
