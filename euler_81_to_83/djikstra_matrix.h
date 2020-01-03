#include <climits>
#include <algorithm>
#include <vector>
#include <exception>
#include <iostream>
//#include <ctime>

class Djikstra_matrix{
    private:
        int** vertex_matrix;
        int size;
        int* dist;
        bool* seen;
        int dist_size;
        std::vector<std::vector<int>> pred;
        int remaining;
        int cur_row;
        int cur_col;
        bool* flags;

        void find_min_u();
        //throws exception if incorrect bounds are given
        void find_shortest_path(int startRow, int startCol, int endRow, int endCol);

    public:
        Djikstra_matrix(int** arr, int arr_size);
        ~Djikstra_matrix();
        int min_top_l_to_bot_r();
        int min_l_to_r();
        int min_pt1_to_pt2(int startRow, int startCol, int endRow, int endCol);
        void reset_state();
};
