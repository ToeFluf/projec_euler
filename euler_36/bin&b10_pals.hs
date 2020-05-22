--generatePalindrome :: Int -> [(Int, Int)]

{-main = do   putStrLn "How many digits do you want to see the palindrom product of (number 0 - 4): "
            val <- getLine
            if ( (read val) <= 4) then print . largestPalofNDigit $ read val else putStrLn "Any integer above 4 will take too long to solve and 1 digit palindrome. This number is 10^4 * 10^4, so anything greater is magnitudes longer"
--filters all non palindromes from a list of Int by seeing if the value reversed is the same going forward
-}
toBinary :: Integer -> [Bool]
toBinary 0 = False:[]
toBinary 1 = True:[]
toBinary x  | x `mod` 2 == 1 = True : (toBinary $ x `div` 2)
            | otherwise = False : (toBinary $ x `div` 2)

isPal :: (Eq a) => [a] -> Bool
isPal [] = True
isPal xs    | xs == (reverse xs) = True
            | otherwise = False

makeBin_Int_Tuple :: Integer -> ([Bool], Integer)
makeBin_Int_Tuple x = (toBinary x, x)

gen_pal_list :: Integer -> [Integer]
gen_pal_list n = [i | i <- [1..(n - 1)], isPal $ show i]

find_pal_sum_lg2_lg10 :: Integer -> Integer
find_pal_sum_lg2_lg10 n = foldr (+) 0 $ filter (isPal . toBinary) $ gen_pal_list n
