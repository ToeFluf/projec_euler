-- Builds the convergent sequence for e : [2,1,2,1,1,4,1,..,1,2k,1..]
-- If a value is divisible by by then use the 2k pattern
-- if the value is the first value of the sequence, the f flag is true, and that value becomes 2 instead of 1
build_e_seq :: Integer -> Integer -> Bool-> [Integer]
build_e_seq n k f   | n > 0 && f = 2 : (build_e_seq n 1 False)
                    | n == 1 = []
                    | n `mod` 3 == 0 = (2 * k) : (build_e_seq (n - 1) (k + 1) f)
                    | otherwise = 1 : (build_e_seq (n - 1) k f)

{-

Solution to challenge: number score of the 100th convergent = 272
value is 6963524437876961749120273824619538346438023188214475670667
for the numerator
-}

data Conv a = Empty
                | Frac a (Conv a)
                | Add a (Conv a)
                -- | Inner (Conv a b) (Conv a b)
                deriving (Show, Ord, Eq)

loadConv :: [a] -> [a] -> Conv a
loadConv [] _ = Empty
loadConv _ (y:[]) = Frac y Empty
loadConv (x:[]) (y:_) = Frac y Empty
loadConv (x:xs) (y:ys) = Add y (Frac x (loadConv xs ys))

-- must use Integer because the values will get larger than Haskell Int bound
-- Simplification rules for fractions
eval :: Conv Integer -> Conv Integer
--if empty remain empty
eval (Empty) = Empty
--if a single value with no denom, remain same
eval (Frac x Empty) = Frac x Empty
-- If a fraction exists (2 nested fractions) remain the same
eval (Frac x (Frac y Empty)) = Frac x (Frac y Empty)
-- if a three level fraction, cross multiply the top most value by the bottom most and make the center the denominator
eval (Frac x (Frac y (Frac z Empty))) = Frac (x * z) (Frac (y) Empty)
-- IF adding a denominator of fraction, cross multiply denom with add value and make a fraction
eval (Add x (Frac y (Frac z Empty))) = Frac ((z * x) + y) (Frac z Empty)
-- if just an add and fraction with no denom, just add as a fraction
eval (Add x (Frac y Empty)) = Frac (x+y) Empty
-- if a fraction and adding in denom, just add denom and keep as fraction
eval (Frac x (Add y (Frac z Empty))) = Frac x (Frac (y + z) Empty)
-- evaluate lower branches of add then re-evaluate expression
eval (Add x s) = eval (Add x (eval s))
-- evaluate lower branches then re-evaluate expression
eval (Frac x s) = eval (Frac x (eval s))

-- Int n = number of iterations
-- Int n = number for convergents
-- Makes a list of String tuples holding the numerators and denominators for the convergents
-- it maps the iteration number to a function that loads the nucessary number of list elements for the iteration, then it evalues(sinplifies) the fraction set, then makes string tuples of the num and denom of an interation
genSolutionList :: Integer -> [(String, String)]
genSolutionList n = map (\m -> conv_to_string $ eval $ loadConv ([1 | l <- [1..(m+2)]]) (build_e_seq m 1 True))  [1..n]


genSpecificConv :: Integer -> (String, String)
genSpecificConv n = conv_to_string $ eval $ loadConv ([1 | l <- [1..(n+2)]]) (build_e_seq n 1 True)


-- Takes a Fraction pair and puts the numerator on the left and denominaotr on the right
conv_to_string :: Conv Integer -> (String,String)
conv_to_string (Empty) = ("?","?")
conv_to_string (Frac x Empty) = (show x, "1")
conv_to_string (Frac x (Frac y Empty)) = (show x, show y)

--Calculate the sum of the digits for a numerator of a given Tuple
calcNumerScore :: ([Char],[Char]) -> Integer
calcNumerScore (x,_) = foldr (+) 0 (map (read . (:[])) x)

compareSizes :: [(String, String)] -> Int
compareSizes [] = 0
compareSizes ((x,y):ws) | length x > length y = 1 + (compareSizes ws)
                        | otherwise = compareSizes ws
