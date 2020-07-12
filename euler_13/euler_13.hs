-- Simple challege, find the first tend digits of the sum of the numbers in the file
-- Since Haskell has arbitrary precision Integers, really simple

import System.Environment

main = do
    file <- getArgs
    fileInfo <- readFile (file !! 0)
    let ns = map (toInteger . read) $ words fileInfo
    print $ foldr (+) 0 ns
