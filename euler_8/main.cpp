// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 8. Finds the largest consective sum of an input and an input file

#include <iostream>
#include <fstream>
#include <string>
using namespace std;

int main(){
    int consecutive = 0;
    ifstream inFile;
    string filename = "";
    int* numArray = nullptr;
    int* tempArray = nullptr;

    do{
        cout << "Enter a filename holding a large number: ";
        cin >> filename;
        inFile.open(filename);
    }while(!inFile.is_open());

    do{
        cout << "How many consecutive numbers do you want to sum?: ";
        cin >> consecutive;
    }while(consecutive < 0);

    //cout << itoa(inFile.get());

    inFile.seekg (0, inFile.end);
    int length = inFile.tellg();
    inFile.seekg (0, inFile.beg);
    length -= 20;

    numArray = new int[length];
    int count = 0;

    do{
        string potato = "";
        inFile >> potato;
        //cout << potato << " " << potato.size();
        int assign = 0;
        char okay = '\0';
        for(int i = 0; i < potato.size(); i++){
            okay = potato.at(i);
            assign = atoi(&okay);
            numArray[i+count] = assign;
            cout << numArray[i+count];
        }
        count += potato.size();
        cout << endl << count << endl;
    }while(count != length);

    inFile.close();

    tempArray = new int[consecutive];

    for(int i = 0; i < consecutive; i++){
        tempArray[i] = 1;
    }

    int largest = 0;
    int currentProduct = 1;
    int temp = 0;
    int i = 0;

    while(i < length){
        for(int j = 1; j < consecutive; j++){
            temp = numArray[j];
            numArray[j-1] = temp;
        }

        tempArray[consecutive-1] = numArray[i];
        cout << tempArray[consecutive-1] << endl;

        if(i <= consecutive - 1){
            for(int j = 0; j < consecutive; j++){
                currentProduct *= tempArray[j];
            }
        }

        if(currentProduct > largest){
            largest = currentProduct;
        }
        currentProduct = 1;
        i++;
    }

    cout << "The largest consecutive product of " << consecutive << " numbers is: " << largest << endl;

    delete[] numArray;
    delete[] tempArray;

    return (0);
}
