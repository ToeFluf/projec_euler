{-
Euler 17: Number letter counts
Author: Daniel Schmidt
Date: June 23, 2020

Decription and challenge: (from https://projecteuler.net/problem=17)
If the numbers 1 to 5 are written out in words: one, two, three, four, five, then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.

If all the numbers from 1 to 1000 (one thousand) inclusive were written out in words, how many letters would be used?

I know this is more computationally expensive then just using the letter count, but at least i can visualize otherwise

NOTE: This won't work right for numbers over 1000 b/c of the "and" of british counting
-}
num_to_word :: Int -> String
num_to_word n   | n >= 1000 = (num_to_word (div n 1000))    ++ " thousand "      ++ (num_to_word (mod n 1000))
                | n >=  100  = (num_to_word (div n 100))     ++ " hundred " ++ if (mod n 100 == 0) then [] else " and "   ++ (num_to_word (mod n 100))
                | n < 100 && n >= 90 = "ninety " ++ (num_to_word (mod n 10))
                | n < 90  && n >= 80 = "eighty " ++ (num_to_word (mod n 10))
                | n < 80  && n >= 70 = "seventy " ++ (num_to_word (mod n 10))
                | n < 70  && n >= 60 = "sixty " ++ (num_to_word (mod n 10))
                | n < 60  && n >= 50 = "fifty " ++ (num_to_word (mod n 10))
                | n < 50  && n >= 40 = "forty " ++ (num_to_word (mod n 10))
                | n < 40  && n >= 30 = "thirty " ++ (num_to_word (mod n 10))
                | n < 30  && n >= 20 = "twenty " ++ (num_to_word (mod n 10))
                | n == 19           = "nineteen"
                | n == 18           = "eighteen"
                | n == 17           = "seventeen"
                | n == 16           = "sixteen"
                | n == 15           = "fifteen"
                | n == 14           = "fourteen"
                | n == 13           = "thirteen"
                | n == 12           = "twelve"
                | n == 11           = "eleven"
                | n == 10           = "ten"
                | n == 9            = "nine"
                | n == 8            = "eight"
                | n == 7            = "seven"
                | n == 6            = "six"
                | n == 5            = "five"
                | n == 4            = "four"
                | n == 3            = "three"
                | n == 2            = "two"
                | n == 1            = "one"
                | otherwise         = ""

letters_to_count :: String -> Int
letters_to_count xs = foldr (+) 0 $ map length $ words xs

number_letter_count :: Int -> Int -> Int
number_letter_count i f = foldr (+) 0 $ map (letters_to_count . num_to_word) [i..f]
