{-
Title: Euler 16
Author: Daniel Schmidt
Solved: 07/29/2020

Problem: What is the sum of the digits of the number 2^1000?
Answer: 1366

Haskell Arbitary Precision Integers makes this a no brainer
-}

import System.Environment

main = do
    [num] <- getArgs
    print $ power_digit_sum num

power_digit_sum :: String -> Int
power_digit_sum x = foldr ((+) . read . (:[])) 0 x
