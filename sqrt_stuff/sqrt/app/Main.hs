module Main where

import Data.Number.BigFloat -- hackage pacakge numbers
import System.Environment
import Data.List
import ContinuedFraction

--Sorry Professor Gill, this is not my best work. EECS 448 and finals took a whole bunch of my time

{-
Description of project:
    I was working through another Project Euler and I had to make a simply DSL to evaluate continued fractions for approximations of various numbers.
    This module us used to comple euler 57, 80, and another one

    Continued fractions are used to given approximation of square roots by means of its rational approximation, and can also be used to make an approximation of e
    More information can be seen here: https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Continued_fraction_expansion

    There are a couple functions that are specific to completing the euler problems that i will give explanations for

    You can use the file convergence_e.txt to see the contFracFile command. It will print the 100th converge of e

-- The main part of this program is that I can show you the sqrt of a number with precision up to 110 decimals (including left of the decimal)
-- You input the number n and the number of iterations i you want to calculate

-- help : displays options
-- sqrt n i : calc square root of n with i decimals of accuracy
-- rationalSqrt n i : calculates the nearest rational approximation of the square root of n with i decimals of accuracy
-- contFracFile filePath : calculates the continued fraction for a file with 2 lines
                            where the 1st line is the sequence of numbers left of the addition sign
                            and the 2nd line is the sequence of number right of the addition sign
EACH NUMBER SHOULD BE: space delimited and a new line sqhould seperate the lines

-}

help_message = do
    putStrLn "help : displays options"
    putStrLn "sqrt n i : calc square root of n with i decimals of accuracy."
    putStrLn "\tNOTE: This cannot go over 110 iterations due to type contraints (I couldn't figure out how to do dynamic types)"
    putStrLn "rationalSqrt n i : calculates the nearest rational approximation of the square root of n with i decimals of accuracy"
    putStrLn "contFracFile filePath : calculates the continued fraction for a file with 2 lines"
    putStrLn "\twhere the 1st line is the sequence of numbers left of the addition sign"
    putStrLn "\tand the 2nd line is the sequence of number right of the addition sign"
    putStrLn "\tEACH NUMBER SHOULD BE: space delimited and a new line should seperate the lines"
    return ()


main :: IO ()
main = do
    xs <- getArgs
    case (xs !! 0) of
        "help" -> help_message
        "sqrt" -> if (length xs) - 1 >= 2
            then do
                let n = read $ xs !! 1
                let i = read $ xs !! 2
                let conv = buildContFraction (toInteger n) (toInteger (2 * i)) --this is excessive, but there is error in this calculation, so taking 2x the iterations guaruntees accuracy
                let d = divideConv $ conv
                let sigDec = getSigDecimals i d
                putStrLn $ "This is the sqrt of " ++ (show n) ++ " for " ++ (show i) ++ " iterations:\n" ++ sigDec
            else
                print ("Incorrect arguments")

        "rationalSqrt" ->
            if (length xs) - 1 < 2
            then do
                let n = (read $ xs !! 1)
                let i = (read $ xs !! 2)
                let conv = buildContFraction (toInteger n) (toInteger (2 * i)) --this is excessive, but there is error in this calculation, so taking 2x the iterations guaruntees accuracy
                let d = divideConv $ conv
                let sigDec = getSigDecimals i d
                print $ "This is the continued fraction for " ++ (show i) ++ " iterations of " ++ (show n) ++ ":\n" ++ sigDec
            else
                print ("Incorrect arguments")
        "contFracFile" -> do
            if (length xs) - 1 < 1
            then
                print ("Incorrect arguments")
            else
                do
                    contents <- readFile (xs !! 1)
                    let lists = take 2 $ map words $ lines contents
                    let list2 = map (map (\x -> (read x)::Integer)) $ lists --turn the lists of character numbers into lists Integers
                    putStrLn "This is the convergence based on the input file: (read Frac 1 / Frac 2)"
                    print $ eval $ convByList (list2 !! 0) (list2 !! 1) True
        _ -> error "Unknown pattern"

type Prec110 = BigFloat (PrecPlus20 (PrecPlus20 (PrecPlus20 Prec50)))

-- function that does the actual division
divideConv :: Conv Integer -> Prec110
divideConv Empty = 0
divideConv (Frac x Empty) = fromIntegral x
divideConv (Frac x (Frac y Empty)) = (/) ((realToFrac . fromIntegral $ x) :: (Prec110)) ((realToFrac . fromIntegral $ y) :: (Prec110))
divideConv _ = error "Unknown pattern"

-- x is the iterations to use
-- y is the 110 decimal length number, so drop what doesn't matter
getSigDecimals :: Int -> Prec110 -> [Char]
getSigDecimals x y  | x > 110  = take (110 + 1) $ show y
                    | otherwise = take (110 + 1 - (110 - x)) $ show y

-- Counts the digits of a number turned into a character
countDigits :: [Char] -> Int
countDigits = foldr (\x -> (+) . read $ [x]) 0

-- gets the digit sum of the sqrt of a list of numbers, couting up till the number i
decimalDigitSum :: Int -> [Int] -> [(Int, Int)]
decimalDigitSum i = run i . filter remTest
            where
                remTest n = if (n - a^2) /= 0 then True else False
                    where
                        a = floor $ sqrt $ fromIntegral n
                run :: Int -> [Int] -> [(Int, Int)]
                run it = map $ \ n -> (n , countDigits $ delete '.' $ getSigDecimals it $ divideConv $ buildContFraction (toInteger n) (toInteger (2 * it)))

--sums the pairs of the function above
sumAllPairs :: [(Int, Int)] -> Int
sumAllPairs = foldr (\(_,y) -> (+) y) 0

-- Builds the convergent sequence for e : [2,1,2,1,1,4,1,..,1,2k,1..]
-- If a value is divisible by by then use the 2k pattern
-- if the value is the first value of the sequence, the f flag is true, and that value becomes 2 instead of 1
build_e_seq :: Integer -> Integer -> Bool-> [Integer]
build_e_seq n k f   | n > 0 && f = 2 : (build_e_seq n 1 False)
                    | n == 1 = []
                    | n `mod` 3 == 0 = (2 * k) : (build_e_seq (n - 1) (k + 1) f)
                    | otherwise = 1 : (build_e_seq (n - 1) k f)

-- build the convergence of e up to n digits length
conv_of_e :: Integer -> Conv Integer
conv_of_e m = eval $ convByList ([1 | l <- [1..(m+2)]]) (build_e_seq m 1 True) True
