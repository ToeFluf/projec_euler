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

class Primes{
    private:
        bool go;
        std::vector<int> primeVector;
    public:
        Primes(int input);
        Primes(std::string filename);
        ~Primes();
        void run();
        void printMenu();
        void printVector();
        bool isPrime(int input);
        void allPrimesUnderN(int upper);
        void primesToOutFile();
        void sumOfPrimes();
};

#endif
