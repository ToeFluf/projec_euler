--generatePalindrome :: Int -> [(Int, Int)]


--filters all non palindromes from a list of Int by seeing if the value reversed is the same going forward
makePalList :: [Int] -> [Int]
makePalList [] = []
makePalList xs = filter (\ x -> (reverseInt x) == (read . show $ x)) xs

generateDivisors :: Int -> Int -> [Int] -> [Int] -> [(Int, Int)]
generateDivisors m n ys [] = generateDivisors m (n - 1) ys ys
generateDivisors _ _ [] _ = []
generateDivisors m n ys (x:xs)  | (x `mod` n == 0) && (x `div` n < m) = (n,x `div` n) : generateDivisors m n ys xs
                                | toRational n < (toRational m) * 9 / 10 = []
                                | otherwise = generateDivisors m n ys xs

maxT :: [(Int, Int)] -> Int
maxT xs = foldr (f) 0 (map (\ (x,y) -> x*y) xs)

f :: Int -> Int -> Int
f x y   | x < y = y
        | otherwise = x

reverseInt :: Int -> Int
reverseInt x | x < 0     = 0 - (read . reverse . tail . show $ x)
             | otherwise = read . reverse . show $ x

largestPalofNDigit :: Int -> Int
largestPalofNDigit n = maxT (generateDivisors (10^n) ((10^n) - 1) (makePalList [(floor ((9)*10^((2*n)-1)))..(((10^(2*n))-1)-1)]) [])
