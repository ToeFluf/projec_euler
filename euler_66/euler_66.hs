
isSquare :: Int -> Bool
isSquare x = a == (fromIntegral $ floor a)
    where
        a = sqrt $ fromIntegral x

incFunction :: Int -> Int -> Int
incFunction r d | isSquare $ p1 + p2 = d*r + 1
                | isSquare $ p1 - p2 = d*r - 1
                | otherwise = incFunction (r + 1) d
    where
        p1 = r*r*d
        p2 = r*2

soln_set :: Int -> Int
soln_set u = maximum $ map (incFunction 1) [i | i<-[2..u], not $ isSquare i]
