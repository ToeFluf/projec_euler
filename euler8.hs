
removeWhiteSpace :: String -> String
removeWhiteSpace [] = []
removeWhiteSpace xs = filter (\ x -> x /= ' ' && x /= '\t' && x /= '\n') xs

convertToInt :: [Char] -> [Int]
convertToInt [] = []
convertToInt xs = map (read . (:"")) xs

makeAdjacentList :: Int -> [Int] -> [Int]
makeAdjacentList _ [] = []
makeAdjacentList n (x:xs)   | 1 + (length xs) < n = []
                            | otherwise =  (foldr (*) 1 (take n (x:xs))) : (makeAdjacentList n xs)

findMax :: Int -> [Int] -> Int
findMax m [] = m
findMax (-1) (x:xs) = findMax x xs
findMax m (x:xs)    | m > x = findMax m xs
                    | otherwise = findMax x xs

findLargestAdjProd :: Int -> String -> Int
findLargestAdjProd _ [] = 0
findLargestAdjProd m xs | m < 1 = 0
                        | (length xs) < m = 0
                        | otherwise = findMax (-1) (makeAdjacentList m (convertToInt (removeWhiteSpace xs)))
