// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 50. Finds the sum of most consecutive primes less than one mil

#include <iostream>
#include <vector>
using namespace std;

int main(){
    vector<int> primeHolder(1,2);
    int n = 0;
    int sum = 0;

    cout << primeHolder.size() << endl;

    cout << "What is the ceiling of the primes to be summed?: ";
    cin >> n;

    int i = 3;
    while(i < n){
        for(int j = 0; j < primeHolder.size(); j++){
            if(i % primeHolder.at(j) == 0){
                break;
            }
            if(j == primeHolder.size() - 1){
                primeHolder.push_back(i);
                sum += i;
            }
        }
        i+=2;
    }

    cout << sum << endl;

    return (0);
}
