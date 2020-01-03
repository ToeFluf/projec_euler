# projec_euler

## Background
This repository contains all for my code for any attempt at a Project Euler challenge.
The Master branch contains all of my completed challenges and the Development branch contains all attempts, completed or not.

The information for a given challenge can be found at the [Project Euler Archives](https://projecteuler.net/archives) page. The URL for a given challenge follows the format : https://projecteuler.net/problem=N where N is the problem number.

I do not have the best documentation, so I am sorry if some of the code gets confusing. I am working to refactor a lot of my code for readability.

## Languages Used
I primarily use C++ and Haskell to complete the challenges.

I  use C++ for its memory management, especially in regards to arrays. Many of matrix based or computationally heavy challenges will be done in C++.

I use Haskell because it is a functional programming language, and many of the challenges are easier to solve recursively (which is pure Haskell) and I find Haskell allows me to use mathematical problem solving skills more often than C++, and it is often quicker to write. It's pattern matching and list comprehension make function definitions very straight forward.

## Viewing a Challenge Solution
I usually have the exact solution to a problem written in the top of the file being used. If not, run the program using the guidelines in the file, or simply type in the information directly.

To run a C++ Program, change to the correct directory and run `make` and then just run the compiled program. EX: `./euler_1`

For C++ I use the gcc compiler and C++ 17. For Haskell I use the Stack package manage with the most updated GHCI interpreter. Download information can be found at [haskellstack.org](haskellstack.org).

To run a Haskell Program, change to the correct directory and run `stack ghci --name of file--`. This will load the file into the interpreter so you can use it.
