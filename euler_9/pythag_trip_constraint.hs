{-
Author: Daniel Schmidt
Date: 06/04/2020
Project Euler 9
Background:

A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
a^2 + b^2 = c^2
There exists exactly one Pythagorean triplet for which a + b + c = 1000.
Find the product abc.

Let us do some rearranging. a + b + c = m, for some m {Natural Nums}

b^2 = c^2 - a^2 => b^2 = (c-a)(c+a)

m - b = (c + a) substitution yields => b^2 = (c-a)(m-b)

so we know (m-b)|b^2
let's rename (m-b) to s and (c-a) to r
so b^2 = rs, some factors r and s where (m-b) divides b^2

note, s - r = 2a => (m-b) - (c-a) = 2a

we now know what a is, so we can trivially find c by c = m - a - b

Now for searching. The max value of c is m/2, so the max value of b is (m/2) - 1.
b will be our search value. We will count down from this value and will stop once b <= a

NOTE: It does not make sense to have an odd m, the system will die in doing so.
Example of basic math
if a = odd and b = odd then a^2 + b^2 = even
if a = even and b = odd then a^2 + b^2 = odd
if a = even and b = even then a^2 + b^2 = even

odd + odd = even
even + odd = odd
even + even = even

let a & b even, then c is even => a + b + c is even
if a is even and b is odd, then c is odd => but since (a + b) is odd and c is odd then a + b + c = even
if a is odd and b is odd, then c is even => but since (a + b) is even and c is even then a + b + c = even

THEREFOR: the input constaint m, in a + b + c = m, must be even.
-}

import System.Environment

main :: IO ()
main = do
    args <- getArgs
    let m = read (args !! 0) :: Int
    let upper = if odd m then error "Cannot have an odd constraint" else (-) (div m 2) 1
    --putStrLn $ show $ upper
    let solnList = checkList $ testVal m upper
    putStrLn $ "Solution list: \n" ++ (show solnList)
    putStrLn $ "Product list: \n" ++ (show $ getProduct solnList)
    return ()

testVal :: Int -> Int -> [(Int, Int, Int)]
testVal m' b| skip t        = testVal m' (b - 1)
            | a_bigger_b t  = []
            | otherwise     = t : (testVal m' (b - 1))
            where
                skip x = case x of
                    (0,0,0) -> True
                    _       -> False
                a_bigger_b (x,y,_) = if (y > x) then False else True
                s = m' - b
                r = div (b*b) s
                a = div (s - r) 2
                val = if r*s == b*b then
                        if 2*a == (s - r) then
                            (a,b,(m' - b - a))
                        else -- if 2 doesn't divide (s - r), then skip loop
                            (0,0,0)
                    else -- If doesn't divide, keep going
                        (0,0,0)
                t = if r*s == b*b then
                        if 2*a == (s - r) then
                            (a,b,(m' - b - a))
                        else -- if 2 doesn't divide (s - r), then skip loop
                            (0,0,0)
                    else -- If doesn't divide, keep going
                        (0,0,0)

checkList :: [(Int, Int, Int)] -> [(Int, Int, Int)]
checkList = filter (\(a,b,c) -> (a*a) + (b*b) == (c*c))

getProduct :: [(Int, Int, Int)] -> [Int]
getProduct = map (\(a,b,c) -> a*b*c)
