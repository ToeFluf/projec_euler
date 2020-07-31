{-
Author: Daniel Schmidt
Date: 06/04/2020
Project Euler 39
Background:

If p is the perimeter of a right angle triangle with integral length sides, {a,b,c}, there are exactly three solutions for p = 120.

{20,48,52}, {24,45,51}, {30,40,50}

For which value of p ≤ 1000, is the number of solutions maximised?

HOW I SOLVED:
used the function i am importing to solve constraint problems.
only even perimeters allowed, start at p = 12 (3,4,5)

-}
import System.Environment

main :: IO ()
main = do
    args <- getArgs
    let m = read (args !! 0) :: Int
    if m < 12 then
        error "Cannot have a perfect right triangle with perimeter less than 12"
    else
        putStrLn $ "Perimeter with the greatest number of pythagorean triples: \n" ++ (show $ find_max_soln $ perimeter_list m)
    return ()

pythag_constraint_solns :: Int -> Int -> [(Int, Int, Int)]
pythag_constraint_solns m' b
            | skip t        = pythag_constraint_solns m' (b - 1)
            | a_bigger_b t  = []
            | otherwise     = t : (pythag_constraint_solns m' (b - 1))
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

perimeter_list :: Int -> [[(Int, Int, Int)]]
perimeter_list x = filter (not . null) $ map (\l -> checkList $ pythag_constraint_solns l ((div l 2) - 1)) [i | i <- [12..x], even i]

checkList :: [(Int, Int, Int)] -> [(Int, Int, Int)]
checkList = filter (\(a,_,_) -> a /= 0)

find_max_soln :: [[(Int, Int, Int)]] -> (Int, [(Int, Int, Int)])
find_max_soln = (\a -> ((\(w,y,z) -> w + y + z) $ head a, a)) . maxPair . map (\a -> (length a, a))

maxPair :: [(Int, [a])] -> [a]
maxPair [] = []
maxPair ((_,as):[]) = as
maxPair ((a,as):(b,bs):cs)  | a > b = maxPair $ (a,as):cs
                            | otherwise = maxPair $ (b,bs):cs
