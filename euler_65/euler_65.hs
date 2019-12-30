
gen_e_converge_seq :: Int -> [[Integer]]
gen_e_converge_seq k =  [ [1,2*x,1] | x <- [1..(floor (k`div`3))]]

gen_e_converge_seq1 :: Int -> [Int]
gen_e_converge_seq1 k = map t [1..k]
--(gen_n_lowercase_strings $ n - 1)

t n  | (n-2) `mod` 3 == 0 = n
        | otherwise = 1
