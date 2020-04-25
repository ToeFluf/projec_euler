module Main where

import Data.Number.BigFloat
import System.Environment
import Data.List
import ContinuedFraction

main :: IO ()
main = do
    xs <- getArgs
    let n = (read $ xs !! 0)
    let i = (read $ xs !! 1)
    let conv = buildContFraction (toInteger n) (toInteger i)
    let d = divideConv $ conv
    let sigDec = getSigDecimals i d
    putStr $ (++) (show d) ['\n']
    putStr $ (++) sigDec ['\n']
    --putStr $ (++) (drop 2 sigDec) ['\n']
    print $ length $ drop ((+) 1 $ length . show $ n) sigDec

type Prec110 = BigFloat (PrecPlus20 (PrecPlus20 (PrecPlus20 Prec50)))

divideConv :: Conv Integer -> Prec110
divideConv Empty = 0
divideConv (Frac x Empty) = fromIntegral x
divideConv (Frac x (Frac y Empty)) = (/) ((realToFrac . fromIntegral $ x) :: (Prec110)) ((realToFrac . fromIntegral $ y) :: (Prec110))
divideConv _ = error "Unknown pattern"

getSigDecimals :: Int -> Prec110 -> [Char]
getSigDecimals x y = take (110 + 1 - (110 - x)) $ show y

countDigits :: [Char] -> Int
countDigits = foldr (\x -> (+) . read $ [x]) 0

decimalDigitSum :: Int -> [Int] -> [(Int, Int)]
decimalDigitSum i = run i . filter remTest
            where
                remTest n = if (n - a^2) /= 0 then True else False
                    where
                        a = floor $ sqrt $ fromIntegral n
                run :: Int -> [Int] -> [(Int, Int)]
                run it = map $ \ n -> (n , countDigits $ delete '.' $ getSigDecimals it $ divideConv $ buildContFraction (toInteger n) (toInteger (2 * it)))

sumAllPairs :: [(Int, Int)] -> Int
sumAllPairs = foldr (\(_,y) -> (+) y) 0
