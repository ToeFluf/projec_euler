import Data.Bits

-- finds the longest collatz chain under the number n
-- to use, run the sequence max_collatz_pair $ to_collatz $ [750000..1000000]
-- answer for under 1 mil is 525
-- if you want to find another ceiling, use 3/4 of n as the lower argument and n-1 as the upper argument

collatz :: Int -> Int
collatz 1 = 1
collatz n   | 1 == ((.&.) n (setBit zeroBits 0)) = 1 + (collatz (3 * n + 1))
            | otherwise = 1 + (collatz (n `div` 2))

genPrimes :: [Int] -> [Int]
genPrimes [] = []
genPrimes (x:xs) = x : (genPrimes $ filter (\m-> m `mod` x /= 0) xs)

to_collatz :: [Int] -> [(Int,Int)]
to_collatz [] = []
to_collatz (x:xs) = (x, collatz x) : (to_collatz xs)

max_collatz_pair :: [(Int, Int)] -> (Int, Int)
max_collatz_pair [] = (0,0)
max_collatz_pair ((x,y):[]) = (x,y)
max_collatz_pair ((x,y):(z,q):xs)   | y > q = max_collatz_pair $ (x,y):xs
                                    | otherwise = max_collatz_pair $ (z,q):xs
