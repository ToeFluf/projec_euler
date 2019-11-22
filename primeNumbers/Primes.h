/* File Name: DMV.h
 * Author: Daniel Schmidt
 * Assignment: Lab 11
 * Description: Initialization of all constructors, methods, and member variables for DMV class
 * Date Last Modified: 12/01/18
 * */

#ifndef PRIMES_H
#define PRIMES_H
#include <vector>
#include <string>
#include <time.h>

class Primes{
    private:
        bool go;
        std::vector<int> primeVector;
        clock_t t;
    public:
        Primes(int input);
        Primes(std::string filename);
        ~Primes();
        void run();
        void printMenu();
        void printVector();
        bool isPrime(int input, bool output);
        void allPrimesUnderN(int upper);
        void largestConsecutivePrimesUnderN();
        void primesToOutFile();
        void sumOfPrimes();
};

#endif
