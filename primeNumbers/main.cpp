// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 10. Finds the sum of all primes under 2 mil

#include <iostream>
#include <string>
#include "Primes.h"
using namespace std;

int main(){
    int input = 0;
    string filename = "";
    cout << "This is a program that does prime stuff. \n1) Input a number to search for primes under\n2) Input a filename to read primes from\nEnter Choice: ";
    cin >> input;

    while(cin.fail() || input < 1 || input > 2){
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << "Your input was not an integer, or was not 1 or 2. Try again: ";
        cin >> input;
    }
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    cout << endl;

    if(input == 1){
        cout << "Enter an integer greater than 2: ";
        cin >> input;

        while(cin.fail() || input < 2){
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Your input was not an integer, or was not 1 or 2. Try again: ";
            cin >> input;
        }
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << endl;
        Primes primeStuff(input);
        primeStuff.run();
    }
    else{
        cout << "Enter a filename: ";
        cin >> filename;

        while(cin.fail()){
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Your input was not a string. Try again: ";
            cin >> filename;
        }
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << endl;

        Primes primeStuff(filename);
        primeStuff.run();
    }

	return 0;
}

    /*vector<int> primeHolder(1,2);
    int n = 0;
    long long int sum = 2;

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
}*/
