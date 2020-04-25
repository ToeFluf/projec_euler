
data Conv a = Empty
            | Frac a (Conv a)
            | Add a (Conv a)
            -- | Inner (Conv a b) (Conv a b)
            deriving (Show, Ord, Eq)

loadConv :: [a] -> [a] -> Bool -> Conv a
loadConv [] _ _ = Empty
loadConv _ (y:[]) _ = Frac y Empty
loadConv (x:[]) (y:_) _ = Frac y Empty
loadConv (x:l:xs) (y:ys) t  | t = Add x (Frac l (loadConv xs (y:ys) False))
                            | otherwise = Add y (Frac x (loadConv (l:xs) ys t))

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
genSolutionList :: Integer -> Integer -> [(String, String)]
genSolutionList n c = map (\m -> conv_to_string $ eval $ loadConv ([1 | l <- [1..(m+2)]]) ([c | p <- [1..m]]) True)  [1..n]

-- Takes a Fraction pair and puts the numerator on the left and denominaotr on the right
conv_to_string :: Conv Integer -> (String,String)
conv_to_string (Empty) = ("?","?")
conv_to_string (Frac x Empty) = (show x, "1")
conv_to_string (Frac x (Frac y Empty)) = (show x, show y)


compareSizes :: [(String, String)] -> Int
compareSizes [] = 0
compareSizes ((x,y):ws) | length x > length y = 1 + (compareSizes ws)
                        | otherwise = compareSizes ws
