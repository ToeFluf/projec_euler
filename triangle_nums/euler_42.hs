import System.Environment
{-
Date: 07/12/10
Challege:

The nth term of the sequence of triangle numbers is given by, tn = ½n(n+1);

By converting each letter in a word to a number corresponding to its alphabetical position and adding these values we form a word value. For example, the word value for SKY is 19 + 11 + 25 = 55 = t10. If the word value is a triangle number then we shall call the word a triangle word.

how many are triangle words are in p042_words.txt?

ANS: 162
-}
main = do
    args <- getArgs
    file <- readFile $ args !! 0
    putStr "The number of triangle worsd in the file is: "
    print $ run file

run = length . filter_tri_nums . map count_letters . words

char_pos :: Char -> Int
char_pos x  | x == 'A' = 1
            | x == 'B' = 2
            | x == 'C' = 3
            | x == 'D' = 4
            | x == 'E' = 5
            | x == 'F' = 6
            | x == 'G' = 7
            | x == 'H' = 8
            | x == 'I' = 9
            | x == 'J' = 10
            | x == 'K' = 11
            | x == 'L' = 12
            | x == 'M' = 13
            | x == 'N' = 14
            | x == 'O' = 15
            | x == 'P' = 16
            | x == 'Q' = 17
            | x == 'R' = 18
            | x == 'S' = 19
            | x == 'T' = 20
            | x == 'U' = 21
            | x == 'V' = 22
            | x == 'W' = 23
            | x == 'X' = 24
            | x == 'Y' = 25
            | otherwise = 26

count_letters :: [Char] -> Int
count_letters = foldr (+) 0 . map char_pos

filter_tri_nums :: [Int] -> [Int]
filter_tri_nums = filter (\x -> isInt $ (/) ((-1) + sqrt(1 + 8 * fromIntegral x)) 2)

isInt x = x == fromInteger (round x)
