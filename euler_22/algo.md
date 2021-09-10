To complete this let us use an external sorting algorithm

+--------+
| Inputs |
+--------+
- input file
- run size := r
- number of runs (optional)
- output file name

Algo outline

 - Open File
 - while not end of input file
     - Load r items into an array, or till file end
     - run merge sort
     - output array to the i-th temp file
- create min heap
- open all i files & output file
    - insert the first element from each file to minheap; tuple (element, file)
- while min heap not empty
    - pop min item and add to output
    - add new element from the same file as the node just output
    - continue till each file is empty

libraries:
<cstdio>
<iostream>
<fstream>
<priority_queue>
<tuple>
