#include "djikstra_matrix.h"
using namespace std;

Djikstra_matrix::Djikstra_matrix(int** arr, int arr_size){
    vertex_matrix = arr;
    /*new int*[arr_size];
    for(int i = 0; i < arr_size; i++){
        arr[i] = new int[arr_size];
        for(int j = 0; j < arr_size; j++){
            vertex_matrix[i][j] = arr[i][j];
        }
    }*/
    size = arr_size;
    dist_size = size * size;
    remaining = dist_size;
    pred.resize(dist_size);
    dist = new int[dist_size];
    seen = new bool[dist_size];
    for(int i = 0; i < dist_size; i++){
        dist[i] = INT_MAX;
        seen[i] = false;
    }
    flags = new bool[2];
    flags[0] = false;
    flags[1] = false;
    cur_row = -1;
    cur_col = -1;
};

Djikstra_matrix::~Djikstra_matrix(){
    delete[] dist;
    delete[] seen;
    delete[] flags;
};

void Djikstra_matrix::find_min_u(){
    int min = INT_MAX;

    for(int i = 0; i < size; i++){
        for(int j = 0; j < size; j++){
            if(!seen[i*size + j]){
                if(dist[i*size + j] != -1 && dist[i*size + j] < min){
                    min = dist[i*size + j];
                    cur_row = i;
                    cur_col = j;
                }
            }
            //cout << "(" << i << " , " << j << ")" << '\t' << dist[i*size + j] << '\t' << seen[i*size + j] << " " << min << " " << cur_row << " " << cur_col << endl;
        }
        //cout << endl;
    }
    /*for(int i = 0; i < dist_size; i++){
        cout << "dist[" << i << "] : " << dist[i] << endl;
    }
    cout << "min u : (" << cur_row << ", " << cur_col << ")" << endl;*/
    remaining--;
}

//djikstra's algorithm : https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
void Djikstra_matrix::find_shortest_path(int startRow, int startCol, int endRow = -1, int endCol = -1){ //endRow and endCol can be -1, meaning they do not need to be specified
    if(startRow >= size || startRow < 0 || startCol >= size || startCol < 0 || endRow >= size || endRow < -1 || endCol < -1 || endCol >= size){
        cur_row = -1;
        cur_col = -1;
        throw(std::runtime_error("Incorrect Bounds for finding a shortest path"));
    }
    dist[startRow * size + startCol] = vertex_matrix[startRow][startCol];
    pred[startRow * size + startCol].push_back(-1);

    int alt = 0;
    cur_row = startRow;
    cur_col = startCol;

    while(remaining > 0){

        find_min_u(); // find min dist[u] in vertex_matrix

        if(cur_row == endRow && cur_col == endCol){ //if u is end pos, end algo
            break;
        }

        seen[cur_row * size + cur_col] = true; //remove u from Q

        if(cur_row + 1 < size){
            alt = dist[cur_row * size + cur_col] + vertex_matrix[cur_row + 1][cur_col];
            //cout << "alt : " << alt << " dist[" <<  (cur_row + 1) * size + cur_col << "] : " << dist[(cur_row + 1) * size + cur_col] << endl;
            if(alt < dist[(cur_row + 1) * size + cur_col]){
                dist[(cur_row + 1) * size + cur_col] = alt;
                pred[(cur_row + 1) * size + cur_col].push_back(cur_row * size + cur_col);
            }
        }

        if(cur_col + 1 < size){
            alt = dist[cur_row * size + cur_col] + vertex_matrix[cur_row][cur_col + 1];
            //cout << "alt : " << alt << " dist[" <<  (cur_row + 1) * size + cur_col << "] : " << dist[cur_row * size + cur_col + 1] << endl;
            if(alt < dist[cur_row * size + cur_col + 1]){
                dist[cur_row * size + cur_col + 1] = alt;
                pred[cur_row * size + cur_col + 1].push_back(cur_row * size + cur_col + 1);
            }
        }

        if(flags[0]){ //if down is enabled
            if(cur_row - 1 >= 0){
                alt = dist[cur_row * size + cur_col] + vertex_matrix[cur_row - 1][cur_col];
                //cout << "alt : " << alt << " dist[" <<  (cur_row + 1) * size + cur_col << "] : " << dist[cur_row * size + cur_col + 1] << endl;
                if(alt < dist[(cur_row - 1) * size + cur_col]){
                    dist[(cur_row - 1) * size + cur_col] = alt;
                    pred[(cur_row - 1) * size + cur_col].push_back((cur_row - 1)* size + cur_col);
                }
            }

            if(flags[1]){ // if all cardinal directions enabled
                if(cur_col - 1 >= 0){
                    alt = dist[cur_row * size + cur_col] + vertex_matrix[cur_row][cur_col - 1];
                    //cout << "alt : " << alt << " dist[" <<  (cur_row + 1) * size + cur_col << "] : " << dist[cur_row * size + cur_col + 1] << endl;
                    if(alt < dist[cur_row * size + cur_col - 1]){
                        dist[cur_row * size + cur_col - 1] = alt;
                        pred[cur_row * size + cur_col - 1].push_back(cur_row * size + cur_col - 1);
                    }
                }
            }
        }

    }

    /*int c = 0;
    for (vector<vector<int>>::iterator it = pred.begin() ; it != pred.end(); ++it){
        cout << "(" << c/size << ", " << c % size << ") pred : ";
        for(vector<int>::iterator it1 = (*it).begin(); it1 != (*it).end(); ++it1){
            cout << (*it1) << " ";
        }
        cout << endl;
        c++;
    }*/

    /*

    1  S ← empty sequence
    2  u ← target
    3  if prev[u] is defined or u = source:          // Do something only if the vertex is reachable
    4      while u is defined:                       // Construct the shortest path with a stack S
    5          insert u at the beginning of S        // Push the vertex onto the stack
    6          u ← prev[u]                           // Traverse from target to source

    */

}


int Djikstra_matrix::min_top_l_to_bot_r(){
    try{
        find_shortest_path(0,0, size - 1, size - 1);
        return dist[dist_size - 1];
    }catch(std::exception& err){
        std::cerr << std::endl << err.what() << std::endl;
    }
    return (-2);
}

int Djikstra_matrix::min_l_to_r(){
    vector<int> temp;
    for(int i = 0; i < size; i++){
        flags[0] = true;
        //cout << endl << "Time start" << endl;

    	//time_t start = std::clock();
        try{
            find_shortest_path(i, 0);
            //cout << "Time elapsed: " << (( std::clock() - start ) / (double) CLOCKS_PER_SEC);
            for(int j = 0; j < size; j++){
                temp.push_back(dist[(j+1)*size - 1]);
            }
        }catch(std::exception& err){
            std::cerr << std::endl << err.what() << std::endl;
        }

        reset_state();
    }
    int min = INT_MAX;
    for (vector<int>::iterator it = temp.begin() ; it != temp.end(); ++it){
        min = std::min((*it), min);
    }
    return min;
}

int Djikstra_matrix::min_pt1_to_pt2(int startRow, int startCol, int endRow, int endCol){
    flags[0] = true;
    flags[1] = true;

    try{
        find_shortest_path(startRow, startCol, endRow, endCol);
        return ((cur_row < 0 || cur_col < 0) ? -1 : dist[cur_row*size + cur_col]);
    }catch(std::exception& err){
        std::cerr << std::endl << err.what() << std::endl;
    }
    return (-2);

}

void Djikstra_matrix::reset_state(){
    remaining = dist_size;
    for (vector<vector<int>>::iterator it = pred.begin() ; it != pred.end(); ++it){
        (*it).clear();
    }
    for(int i = 0; i < dist_size; i++){
        dist[i] = INT_MAX;
        seen[i] = false;
    }
    flags[0] = false;
    flags[1] = false;
    cur_row = -1;
    cur_col = -1;
}
