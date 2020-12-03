{-
Author: Daniel Schmidt
Date: 08/01/2020
Project Euler 122
Background:

The most naive way of computing n15 requires fourteen multiplications:

n × n × ... × n = n15

But using a "binary" method you can compute it in six multiplications:

n × n = n2
n2 × n2 = n4
n4 × n4 = n8
n8 × n4 = n12
n12 × n2 = n14
n14 × n = n15

However it is yet possible to compute it in only five multiplications:

n × n = n2
n2 × n = n3
n3 × n3 = n6
n6 × n6 = n12
n12 × n3 = n15

We shall define m(k) to be the minimum number of multiplications to compute nk; for example m(15) = 5.

For 1 ≤ k ≤ 200, find ∑ m(k).

HOW I SOLVED:
Well, this is a recursive problem at its finest, based on the factorization of k
It is most efficient when k is highly composite and thus has many factors.

Better examples is n^24, there are multiple ways to solve. I am choosing the recursive form
n * n = n2
n2 * n = n3
n3 * n3 = n6
n6 * n6 = n12
n12 * n12 = n24
Notice: 1,2,3,6,12 are all factors of 24
So this can be solved by asking: What is the efficient exponent for the largest factor of k? and then recursing

If k is prime, then use k - 1

-}

sieve_aroth :: [Int] -> [Int]
sieve_aroth [] = []
sieve_aroth (y:ys) = y : (sieve_aroth $ filter (\m -> (mod m y) /= 0) ys)

sumThing :: Int -> Int
sumThing x  | x <= 1 = 0
            | otherwise = foldr ((+) . efficientExpCount (sieve_aroth [2..x])) 0 [2..x]

efficientExpCount :: [Int] -> Int -> Int
efficientExpCount ps k  | k == 2 = 1
                        | otherwise = (+) 1 $ efficientExpCount ps $ k - (nextLargestFactor ps k)

prime_factorization :: Int -> [Int] -> [Int]
prime_factorization _ [] = []
prime_factorization x (y:ys)    | x == 1 = []
                                | (mod x y) /= 0 = prime_factorization x ys
                                | otherwise = y : (prime_factorization (div x y) (y:ys))

nextLargestFactor :: [Int] -> Int -> Int
nextLargestFactor xs k = if 1 == length fs then 1 else foldr (*) 1 $ tail fs
    where
        fs = prime_factorization k xs
