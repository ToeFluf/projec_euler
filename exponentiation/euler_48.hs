{-
Author: Daniel Schmidt
Date: 08/10/2020
Project Euler 48
Background:

The series, 1^1 + 2^2 + 3^3 + ... + 10^10 = 10405071317.

Find the last ten digits of the series, 1^1 + 2^2 + 3^3 + ... + 1000^1000.

Solving:

a^i = mq + b => where b = a^i mod b
a(a^i) = amq + ab
a^i+1 = m(aq)+ ab => So basically a*b == a^i+1 mod m

-}
import System.Environment

main = do
    [m, x] <- getArgs
    putStrLn $ "The sum from 1^1 to " ++ x ++ "^" ++ x ++ " mod " ++ m ++ " is:"
    print $ modFold (read m) (read x)

modPowers :: Integer -> Integer -> Integer -> Integer
modPowers _ _ 0 = 1
modPowers m x k = x * mod (modPowers m x (k-1)) m

modFold :: Integer -> Integer -> Integer
modFold m x = go [1..x]
    where
        go [] = 0
        go (x:xs) = mod ((modPowers m x x) + (go xs)) m
