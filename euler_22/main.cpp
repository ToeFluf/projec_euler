// Filename: main.cpp
// Author: ToeFluf
// Description: Euler project 22. Finds the sum of most consecutive primes less than one mil

//INPUT FILE MUST BE SPACE DELIMITED WITH NO CHARACTERS OTHER THAN A-Z, a-z
/*
============
+ Strategy +
============
 - Use external sorting to sort a large amount of information and then recompile it for usage
    - Used merge sort for sorting strategy
    - Used priority queue to merge the sorted information to a single output file

==============
+ Limitation +
==============
 - The data loader is easy to break, I forced it to only have the stuff you wanted to sorted and delimited by spaces
 - Speed is bottlenacked by the merging process for the output file

===============
+ Known Error +
===============
 -  There is an error that occurs at the merging process where duplicates are created. This appears to only occur at the end of the files.
    I think this is due to memory being left over after a file is closed, or there is an incorrect read from the input file (i think \n causes errors)

*/

#include <string>
#include <vector>
#include <queue>
#include <iostream>
#include <fstream>
#include <tuple>

using namespace std;

bool cmp_ltr(string left, string right){
    int i = 0;
    //cout << left << " " << right << endl;

    while(i < left.size() && i < right.size()){
        //cout << left.at(i) << " " << right.at(i) << endl;
        if(left.at(i) == right.at(i)) i++;
        else if((int)left.at(i) < (int)right.at(i)) return true;
        else return false;
    }
    if(left.size() <= right.size()) return true;

    return false;
}

//from https://www.geeksforgeeks.org/external-sorting/

void merge(vector<string>& arr, int l, int m, int r){
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;

    /* create temp arrays */
    string L[n1], R[n2];

    /* Copy data to temp arrays L[] and R[] */
    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];

    /* Merge the temp arrays back into arr[l..r]*/
    // Initial index of first subarray
    i = 0;

    // Initial index of second subarray
    j = 0;

    // Initial index of merged subarray
    k = l;
    while (i < n1 && j < n2) {
        if (cmp_ltr(L[i], R[j]))
            arr[k++] = L[i++];
        else
            arr[k++] = R[j++];
    }

    /* Copy the remaining elements of L[],
        if there are any */
    while (i < n1)
        arr[k++] = L[i++];

    /* Copy the remaining elements of R[],
        if there are any */
    while (j < n2)
        arr[k++] = R[j++];
}

void mergeSort(vector<string>& arr, int l, int r){
    if (l < r) {
        // Same as (l+r)/2, but avoids overflow for
        // large l and h
        int m = l + (r - l) / 2;

        // Sort first and second halves
        mergeSort(arr, l, m);
        mergeSort(arr, m + 1, r);

        merge(arr, l, m, r);
    }
}

class mycomparison
{
  bool reverse;
public:
  mycomparison(const bool& revparam=false)
    {reverse=revparam;}
  bool operator() (const tuple<int,string>& lhs, const tuple<int,string>&rhs) const
  {
    if (reverse) return !cmp_ltr(get<1>(lhs), get<1>(rhs));
    else return cmp_ltr(get<1>(lhs), get<1>(rhs));
  }
};

void mergeFiles(int fcount, string out_name){
    priority_queue<tuple<int,string>, std::vector<tuple<int,string>>, mycomparison> heap(mycomparison(true));
    char name[12];
    ifstream ifs[fcount];
    ofstream output(out_name);
    string word;
    for(int i = 0; i < fcount; i++){
        sprintf(name, "tempo%d.txt", i+1);
        ifs[i].open(name);
        ifs[i] >> word;
        heap.push(make_tuple(i, word));
    }

    int file_num;
    while(!heap.empty()){
        //trying to add the heap adders
        file_num = get<0>(heap.top());
        //cout << file_num << " " <<  get<1>(heap.top()) << endl;
        output << get<1>(heap.top()) << '\n';
        heap.pop();
        if(ifs[file_num].eof()) {
            ifs[file_num].close();
        }
        /*else if(heap.size() <= 1){
            if(heap.size() == 0) break;

            file_num = get<0>(heap.top());
            output << get<1>(heap.top()) << '\n';
            heap.pop();

            while(!ifs[file_num].eof()){
                ifs[file_num] >> word;

                output << word << '\n';
            }
            ifs[file_num].close();
        }*/
        else{
            //getline(ifs[file_num], word, ' ');
            ifs[file_num] >> word;
            heap.push(make_tuple(file_num, word)); //bug with the last couple values, it is beacuse of the space
        }
    }

    output.close();
}

int main(int argc, char* argv[]){

    const int run_size = 512;

    vector<string> arr;
    arr.reserve(run_size);

    ifstream inFile;
    ofstream outFile;
    inFile.open("p022_names.txt");

    int file_count = 0;
    int item_count = 0;
    int counter;
    string in;
    string prev_in = "";
    while(!inFile.eof()){
        arr.clear();
        file_count++;
        counter = 0;
        while(counter < run_size && !inFile.eof()){
            inFile >> in;

            if(in[0] == '\n') continue;
            arr.push_back(in);

            /*cout << arr.front() << endl;
            for(auto it = arr.begin(); it != arr.end(); ++it)
                cout << *it << " ";

            cout << endl;*/

            counter++;
        }
        //while((int)arr.back().back() < 65 || (int)arr.back().back() > 90) arr.back().pop_back();
        item_count += counter;
        cout << "Test counter: " << item_count << endl;
        //arr.back().pop_back();
        //cout << arr[arr.size() - 1] << endl;

        mergeSort(arr, 0, arr.size()-1);

        char name[12];
        sprintf(name, "tempo%d.txt", file_count);
        cout << name << endl;
        outFile.open(name);

        if(!outFile.is_open()){ cout << "Open Failure"; return 0;}

        for(int i = 0; i < arr.size(); i++){
            if(prev_in == arr.at(i)) continue;

            outFile << arr.at(i) << " ";
            prev_in = arr.at(i);
        }
        //outFile << arr.at(arr.size() - 1);

        outFile.close();
        prev_in = "";
    }
    inFile.close();

    mergeFiles(file_count, "outfile.txt");
    inFile.open("outfile.txt");

    counter = 1;
    string word;
    int word_val;
    unsigned int sum = 0;
    string prev = "";
    while(counter <= item_count){
        inFile >> word;
        word_val = 0;
        if(word == prev){
            cout << "Equality found: line " << counter << endl << "Words: " << word << endl;
            counter--; //decrease since we found a duplicate
        }
        else{
            for(int i = 0; i < word.size(); i++) {
                word_val += word[i] - 64; //A := 65
            }
            sum += counter*word_val;
        }
        counter++;
        prev = move(word);
    }
    inFile.close();

    cout << "The count is: " << counter - 1 << endl;
    cout << "The word value for this file is: " << sum << endl;
    return 0;
}
