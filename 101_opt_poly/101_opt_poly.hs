import Data.List (find)

data Polynomial a b c = Empty | Constant a | Term a b c | Poly (Polynomial a b c) (Polynomial a b c)
    deriving (Ord, Eq, Show)

data Op = Add | Sub | None
    deriving (Ord, Eq, Show)

rref :: (Eq a, Fractional a)  => [[a]] -> [[a]]
rref m = f m 0 [0 .. rows - 1]
  where rows = length m
        cols = length $ head m

        f m _    []              = m
        f m lead (r : rs)
            | indices == Nothing = m
            | otherwise          = f m' (lead' + 1) rs
          where indices = find p l
                p (col, row) = m !! row !! col /= 0
                l = [(col, row) |
                    col <- [lead .. cols - 1],
                    row <- [r .. rows - 1]]

                Just (lead', i) = indices
                newRow = map (/ m !! i !! lead') $ m !! i

                m' = zipWith g [0..] $
                    replace r newRow $
                    replace i (m !! r) m
                g n row
                    | n == r    = row
                    | otherwise = zipWith h newRow row
                  where h = subtract . (* row !! lead')

replace :: Int -> a -> [a] -> [a]
{- Replaces the element at the given index. -}
replace n e l = a ++ e : b
  where (a, _ : b) = splitAt n l

{-
un = 1 − n + n2 − n3 + n4 − n5 + n6 − n7 + n8 − n9 + n10
(1,n) = 1
(2,n) = 1, 683
(3,n) = 1, 683, 44287
...
-}

leading_term :: (Polynomial Double Int Op) -> Int
leading_term (Empty) = minBound
leading_term (Constant _) = 0
leading_term (Term _ x _) = x
leading_term (Poly (Term _ b _) p)  |  b > (leading_term p) = b
                                    | otherwise = leading_term p

poly_length :: (Polynomial Double Int Op) -> Int
poly_length (Empty) = 0
poly_length (Constant _) = 1
poly_length (Term _ _ _) = 1
poly_length (Poly (Term _ _ _) p) = 1 + (poly_length p)

eval_poly :: (Polynomial Double Int Op) -> Int -> Double
eval_poly Empty _ = 0
eval_poly (Constant a) _ = a
eval_poly (Term a b c) x    | c == Add = (a * ((fromIntegral x) ^ b))
                            | c == Sub = ((-1)* a * ((fromIntegral x) ^ b))
eval_poly (Poly (Term a b c) p) x   | c == Add = (a * ((fromIntegral x) ^ b)) + (eval_poly p x)
                                    | c == Sub = ((-1)* a * ((fromIntegral x) ^ b)) + (eval_poly p x)

build_fit_matrix :: (Polynomial Double Int Op) -> Int -> [Double] -> [[Double]]
build_fit_matrix Empty _ _ = [[]]
build_fit_matrix p x ys | x < 1 = [[]]
                        | let t = (leading_term p), x > t = append_solution_space (map (\f -> resize_matrix_row x $ build_matrix_row p f) (map fromIntegral [1..t])) ys
                        | otherwise = append_solution_space (map (\f -> resize_matrix_row x $ build_matrix_row p f) (map fromIntegral [1..x])) ys

append_solution_space :: [[Double]] -> [Double] -> [[Double]]
append_solution_space _ [] = [[]]
append_solution_space [[]] ys = [[]]
append_solution_space (x:xs) (y:ys) = (x ++ (y:[])) : (append_solution_space xs ys)

resize_matrix_row :: Int -> [Double] -> [Double]
resize_matrix_row _ [] = []
resize_matrix_row n xs  | n > (length xs) = xs ++ (take (n - (length xs)) (repeat 0))
                        | otherwise = xs

build_matrix_row :: (Polynomial Double Int Op) -> Int -> [Double]
build_matrix_row Empty _ = []
build_matrix_row (Constant _) _ = 1:[]
build_matrix_row p@(Term _ b c) x = (eval_poly p x):[]
build_matrix_row (Poly p1 pn) x = (eval_poly p1 x):(build_matrix_row pn x)

generator :: Int -> Int -> Polynomial Double Int Op
generator i f   | f - i < 0 = Empty
                | f - i == 0 = (Poly (Term 1.0 f (power f)) Empty)
                | otherwise = (Poly (Term 1.0 i (power i)) (generator (i+1) f))

power :: Int -> Op
power f | even f = Add
        | otherwise = Sub

eval_deg :: Int -> Int -> Polynomial Double Int Op -> Double
eval_deg i f (Poly p1 pn)   | let l = leading_term p1, l >= i || l <= f = (eval_poly p1 f) + (eval_deg i f pn)
                            | otherwise = 0 + eval_deg i f pn
eval_deg _ _ Empty = 0

--bop xs

make_poly :: [[Double]] -> Int -> Polynomial Double Int Op
make_poly [[]] _ = Empty
make_poly ([]:xs) _ = Empty
make_poly (x:xs) y  | y < length x = Poly (Term (last x) y Add) (make_poly xs $ y + 1)
                    | length xs < 1 = Poly (Term (last x) y Add) Empty

run :: Int -> [[Double]]
run d = rref $ init m'
        where   m' = append_solution_space possible soln
                --pal = generator 0 10
                pal = (Term 1.0 3 Add)
                soln = map (eval_poly pal) [1..d]
                possible = map (\x -> resize_matrix_row d $ take x soln) [1..d]






--summation_generator
thing :: Polynomial Double Int Op
thing = (Poly (Term 1.0 0 Add) (Poly (Term 1.0 1 Sub) (Poly (Term 1.0 2 Add) (Poly (Term 1.0 3 Sub) (Poly (Term 1.0 4 Add) (Poly (Term 1.0 5 Sub) (Poly (Term 1.0 6 Add) (Poly (Term 1.0 7 Sub) (Poly (Term 1.0 8 Add) (Poly (Term 1.0 9 Sub) (Poly (Term 1.0 10 Add) Empty)))))))))))
thing2 :: Polynomial Double Int Op
thing2 = (Poly (Term 1.0 0 Add) (Poly (Term 1.0 1 Sub) (Poly (Term 1.0 2 Add) (Poly (Term 1.0 3 Sub) Empty))))
--gen_poly :: (Int -> Int) -> Int -> Int
gen_poly f n = map (\x -> 1 - x + x^2 - x^3 + x^4 - x^5 + x^6 - x^7 + x^8 - x^9 + x^10) [1..10]
