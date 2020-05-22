module Usage where

import Data.Number.BigFloat
import Data.Number.Fixed
import Data.List
import ContinuedFraction

--setPrecision :: Epsilon e => Int -> Epsilon e
setPrecision p  | p < 1     = Eps1
                | p < 20    = EpsDiv10 $ setPrecision (p - 1)
                | otherwise = PrecPlus20 $ setPrecision (p - 20)

--getPrecision :: Epsilon e => Epsilon e -> Int
getPrecision (PrecPlus20 p) = (+) 20 $ getPrecision p
getPrecision (EpsDiv10 p)   = (+) 1  $ getPrecision p
getPrecision  Eps1          = 0
{-
divideConv :: Epsilon e => Conv Integer -> Epsilon e -> BigFloat e
divideConv Empty _ = 0
divideConv (Frac x Empty) _ = fromIntegral x
divideConv (Frac x (Frac y Empty))  = (/) ((realToFrac . fromIntegral $ x) :: (e)) ((realToFrac . fromIntegral $ y) :: (e))
divideConv _ _ = error "Unknown pattern"
-}
