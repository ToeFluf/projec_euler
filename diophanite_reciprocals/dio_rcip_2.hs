{-
problem: (1/x) + (1/y) = 1/n
where x,y,n are all natural numbers

find the n value such that there are 1000 distinct x,y pairs

x and y must be greater than n so =>
let x = n + s and y = n + r; n,s,r <- Nat
(1/(n+s)) + (1/(n+r)) = 1/n =
n(n + s + n + r) = n^2 + ns + nr + sr
n^2 = sr

rs are any factors such that equal n^2

so, basically we need to count the number of factors of n^2, this guaruntees a solution to dio recip eq

The prime factorization can be written like: a_1^p_1 * ... * a_m^p_m = x
Using prime factorizations, the number of possible pairs equals

if x is not square: Product i=1 to m:   p_i
            else: (Product i=1 to m : p_i) + 1
-}


import  Data.List           (group, sort, sortBy, (\\))
import  Control.Applicative (liftA2)
import  System.Environment

main = do
    args <- getArgs
    let pairs = (read $ args !! 0) :: Int
    let upperPairs = ((2 * pairs) - 1)
    let plist = gen_prime_list upperPairs
    let upperSearch = (read $ args !! 1) :: Int
    --putStrLn (show plist)
    let mList = [j | j <- [upperPairs..upperSearch], odd j]
    --putStrLn $ show mList
    let solList = appendAndReverse $ toExponentList $ possibleFactors plist mList
    --putStrLn $ show solList
    --putStrLn $ show $ map (\s -> map toInteger $ (++) s [0::Int | j <- [1 .. ((-) (length plist) (length s))]]) solList
    print $ evalAndCompare $ combineToPowers plist solList


evalAndCompare = minimum . map (foldr (*) 1)

combineToPowers :: [Int] -> [[Int]] -> [[Integer]]
combineToPowers ps ss = map (\s -> combineLists (^) (map toInteger ps) . map toInteger $ (reverse s) ++ [0::Int | j <- [1 .. ((-) (length ps) (length ss))]]) ss
--possibleFactors :: [Int] -> [Int]] -> [[(Int, Int)]]
possibleFactors ps = filter (not . null) . map (\n -> count $ func n $ drop 1 ps)
--toExponentList :: [[(Int, Int)]] -> [[[Int]]]
toExponentList = fmap $ fmap (\ (i, m)-> [div (i - 1) 2 | j <- [1..m]])
--appendAndReverse :: [[[Int]]] -> [[Int]]
appendAndReverse = (reverse . map (foldr (++) []))
--mapToLeast :: [[Int]] -> [[Int]] -> [[Int]]
mapToLeast ps ms = liftA2 (\ p m -> p^m) ps (ms ++ [0 | j <- [1 .. ((-) (length ps) (length ms))]])

combineLists :: (a -> b -> c) -> [a] -> [b] -> [c]
combineLists _ [] [] = []
combineLists _ [] _ = []
combineLists _ _ [] = []
combineLists f (a:as) (b:bs) = (f a b) : combineLists f as bs

func :: Int -> [Int] -> [Int]
func x ms = try
    where
        go = sequence $ factorization x ms
        try = case go of
            (Just ls) -> ls
            Nothing -> []

sieve_aroth :: [Int] -> [Int]
sieve_aroth [] = []
sieve_aroth (y:ys) = y : (sieve_aroth $ filter (\m -> (mod m y) /= 0) ys)

sg :: Ord a => [a] -> [[a]]
sg = group . sort

lh :: [a] -> (a, Int)
lh = liftA2 (,) head length

count :: Ord a => [a] -> [(a, Int)]
count = map lh . sg

factorization :: Int -> [Int] -> [Maybe Int]
factorization _ [] = Nothing : []
factorization x (y:ys)  | x == 1 = []
                        | (mod x y) /= 0 = factorization x ys
                        | otherwise = (Just y) : (factorization (div x y) (y:ys))

get_recip_dio_solns :: [Int] -> Int
get_recip_dio_solns = foldr (*) 1

gen_prime_list :: Int -> [Int]
gen_prime_list x = take m $ sieve_aroth [2..n]
    where
        m = ceiling $ logBase (fromIntegral 3) (fromIntegral x)
        n = (+) 1 ((floor $ sqrt $ fromIntegral x) :: Int)
