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


import           Data.List           (group, sort, sortBy, (\\))
import           Control.Applicative (liftA2)

sieve_aroth :: [Int] -> [Int]
sieve_aroth [] = []
sieve_aroth (y:ys) = y : (sieve_aroth $ filter (\m -> (mod m y) /= 0) ys)

prime_factorization :: Int -> [Int] -> [Int]
prime_factorization _ [] = []
prime_factorization x (y:ys)    | x == 1 = []
                                | (mod x y) /= 0 = prime_factorization x ys
                                | otherwise = y : (prime_factorization (div x y) (y:ys))

get_prime_powers :: [Int] -> [(Int, Int)]
get_prime_powers = count

sg :: Ord a => [a] -> [[a]]
sg = group . sort

lh :: [a] -> (a, Int)
lh = liftA2 (,) head length

count :: Ord a => [a] -> [(a, Int)]
count = map lh . sg

--Since the each n we check is square, then the prime factors of n are squared
-- number of solns is this

square_factor_exponents :: [(Int, Int)] -> [Int]
square_factor_exponents = map (\ (_,b)-> 2*b + 1)

get_recip_dio_solns :: [Int] -> Int
get_recip_dio_solns = (foldr (*) 1)

number_of_solns :: Int -> [Int] -> Int
number_of_solns n ps =   flip div 2
                        $ (+) 1 $ get_recip_dio_solns
                        $ square_factor_exponents
                        $ get_prime_powers
                        $ prime_factorization n ps

find_dio_recip_gt :: Int -> Int -> [Int] -> Int
find_dio_recip_gt s i ps    | s < number_of_solns i ps = i
                            | otherwise = find_dio_recip_gt s (i + 2) ps

store_dio_recip_trend :: Int -> Int -> [Int] -> [(Int, Int)]
store_dio_recip_trend s i ps =  if s < x
                                then (x, i):[]
                                else (x,i) : (store_dio_recip_trend s (i + 4) ps)
                                    where  x = number_of_solns i ps
