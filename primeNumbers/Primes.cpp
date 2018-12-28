/* File Name: Primes.cpp
 * Author: Daniel Schmidt
 * Description: Code for various things you can do with primes. For Project Euler
 * Date Last Modified: 12/24/18
 * */

#include <iostream>
#include <limits>
#include <vector>
#include <fstream>
#include <string>
#include "Primes.h"
using namespace std;

Primes::Primes(int input){
    go = 1;
    primeVector.push_back(2);
    Primes::allPrimesUnderN(input);
}

Primes::Primes(std::string filename){
    go = 1;
    int size = 0;
    int input = 0;
    ifstream inFile;
    inFile.open(filename);
    if(inFile.is_open()){
        inFile >> size;
        for(int i = 1; i <= size; i++){
            inFile >> input;
            primeVector.push_back(input);
        }
    }
    else{
        cout << "File could not be opened, exiting" << endl;
        go = 0;
    }
    inFile.close();
}

Primes::~Primes(){

}

void Primes::printMenu(){
    int choice = 0;
    int input = 0;

    cout << "Select an option:\n1) Check if a number is prime\n2) Print prime numbers\n3) Find the sum of primes in a range\n4) Output all primes to a file\n5) Find all Primes under N\n6) Find n number of primes\n7) Quit\nEnter your choice: ";
    cin >> choice;

    while(cin.fail() || choice < 0 || choice > 7){
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << "Your input was not an integer, was less than 0, or was greater than 6. Try again: ";
        cin >> choice;
    }
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    cout << endl;

    if(choice == 1){
        Primes::isPrime();
    }
    else if(choice == 2){
        Primes::printVector();
    }
    else if(choice == 3){
        cout << "What is the ceiling integer of your summation? (must be >= 2):";
        cin >> input;

        while(cin.fail() || choice < 2){
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Your input was not an integer, or was not one or two. Try again: ";
            cin >> choice;
        }
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << endl;

    }
    else if(choice == 4){
        Primes::primesToOutFile();
    }
    else if(choice == 5){
        cout << "What is the integer you want to find the primes under (>= 2): ";
        cin >> input;

        while(cin.fail() || input < 2){
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Your input was not an integer, or was not one or two. Try again: ";
            cin >> choice;
        }
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << endl;
        Primes::allPrimesUnderN(input);
    }
    else if(choice == 6){
    /*    int i = 0;
        int size = primeVector.size();
        cout << size << endl;
        if(primeVector.at(size-1) == 2){
            i = 3;
        }
        else{
            i = primeVector.at(size-1) + 2;
        }

        while(i < upper){
            for(int j = 0; j < primeVector.size(); j++){
                if(i % primeVector.at(j) == 0){
                    break;
                }
                if(j == primeVector.size() - 1){
                    primeVector.push_back(i);
                }
            }
            i+=2;
        }
        return;*/
    }
    else{
        go = 0;
    }

    return;
}

void Primes::isPrime(){
    int input = 0;
    cout << "Enter a non-negative integer greater than one to see if it is prime: ";
    cin >> input;

    while(cin.fail() || input < 2){
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << "Your input was not an integer or was less than 2. Try again: ";
        cin >> input;
    }
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    cout << endl;

    if(primeVector.back() < input){
        allPrimesUnderN(input+1);
    }

}

void Primes::printVector(){
    int choice = 0;
    int input = 0;
    int input2 = 0;
    cout << "Would you like to:\n1) Print whole vector (" << primeVector.size() << " entries long)\n2) Print a certain position\n3) Print all vectors within an inclusize range\nEnter Choice: ";
    cin >> choice;

    while(cin.fail() || choice < 1 || choice > 3){
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << "Your input was not an integer, less than 1, or greater than 3. Try again: ";
        cin >> input;
    }
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    cout << endl << "If you want bigger primes than the size, you need to use the allPrimesUnder function inputing the desired ceiling." << endl;;

    if(choice == 1){
        for(std::vector<int>::iterator it = primeVector.begin(); it != primeVector.end(); ++it){
            std::cout << *it << endl;
        }
    }
    else if(choice == 2){
        cout << "What position do you want to print: ";
        cin >> input;

        while(cin.fail() || input < 1 || input > primeVector.size()){
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Your input was not an integer, less than 1, or greater than " << primeVector.size() << ". Try again: ";
            cin >> input;
        }
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << endl;

        cout << "The prime at position " << input << " is " << primeVector.at(input) << endl;
    }
    else{
        cout << "What is the lower range: ";
        cin >> input;

        while(cin.fail() || input < 1 || input > primeVector.size()){
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Your input was not an integer, less than 1, or greater than " << primeVector.size() << ". Try again: ";
            cin >> input;
        }
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << endl;

        cout << "What is the upper range: ";
        cin >> input2;

        while(cin.fail() || input2 < input || input2 > primeVector.size()){
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Your input was not an integer, less than input one, or greater than " << primeVector.size() << ". Try again: ";
            cin >> input2;
        }
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << endl;

        for(int i = input; i < input2+1; i++){
            cout << "Position " << i << " = " << primeVector.at(i) << endl;
        }
    }

    return;
}

void Primes::primesToOutFile(){
    ofstream outFile;
    outFile.open("prime_file.txt");
    outFile << primeVector.size() << endl;
    for(vector<int>::iterator it = primeVector.begin(); it != primeVector.end(); ++it){
        outFile << *it << endl;
    }
    outFile.close();
    cout << "Output file finished." << endl;
}

void Primes::allPrimesUnderN(int upper){
    int i = 0;
    int size = primeVector.size();
    cout << size << endl;
    if(primeVector.at(size-1) == 2){
        i = 3;
    }
    else{
        i = primeVector.at(size-1) + 2;
    }

    while(i < upper){
        for(int j = 0; j < primeVector.size(); j++){
            if(i % primeVector.at(j) == 0){
                break;
            }
            if(j == primeVector.size() - 1){
                primeVector.push_back(i);
            }
        }
        i+=2;
    }
    return;
}

void Primes::sumOfPrimes(){

    long int sum = 0;
    int input = 0;
    int choice = 0;
    cout << "Do you want to: \n1) Find the sum of all numbers in the vector (" << primeVector.size() << " entries large)\n2) Find the sum of all integers under a ceiling\nEnter Choice: ";
    cin >> choice;

    while(cin.fail() || choice > 2 || choice < 1){
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << "Your input was not an integer, or neither one or two. Try again: ";
        cin >> choice;
    }
    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    cout << endl;

    if(choice == 1){
        for(int i = 1; i <= primeVector.size(); i++){
            sum += primeVector.at(i);
        }
        cout << "The sum of primes under " << primeVector.at(primeVector.size()) << " is " << sum << endl;
    }

    else{
        cout << "Enter the ceiling to sum under (>= 2): ";
        cin >> input;
        while(cin.fail() || input < 2){
            cin.clear();
            cin.ignore(numeric_limits<streamsize>::max(), '\n');
            cout << "Your input was not an integer or less than two. Try again: ";
            cin >> input;
        }
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
        cout << endl;

        for(int i = 1; i <= primeVector.size(); i++){
            if(input > primeVector.at(i)){
                sum += primeVector.at(i);
            }
            else{
                break;
            }
        }
        cout << "The sum of primes under " << input << " is " << sum << endl;
    }
}

void Primes::run(){
    while(go){
        Primes::printMenu();
    }
    return;
}
