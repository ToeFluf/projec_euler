
main = do   putStrLn "Enter an integer to find the sum of all primes before it:"
            n <- getLine
            print $ sumPrimesUnderN $ read n

genPrimes :: [Int] -> [Int]
genPrimes [] = []
genPrimes (x:xs) = x : (genPrimes $ filter (\m-> m `mod` x /= 0) xs)

sumPrimesUnderN :: Int -> Int
sumPrimesUnderN n   | n < 2 = 0
                    | otherwise = foldr (+) 0 (genPrimes $ genOdd n)

genOdd :: Int -> [Int]
genOdd n = 2:[x | x <- [3..n], odd x]
