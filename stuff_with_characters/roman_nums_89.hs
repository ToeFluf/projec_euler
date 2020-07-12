{-
The answer to this puzzle is 743 characters char_saved

to run: load the file, put `run` into the interpreter and simply supply the file rom_num.txt to the prompt
-}
run = do {
            putStr "Input Roman Numeral File: ";
            enc_file <- getLine;
            enc_file_cont <- readFile enc_file;
            print $ "The number of characters saved by reformatting is: " ++ show (char_saved (words enc_file_cont) $ reformat_roman $ words enc_file_cont);
    }

--takes a string and reformats it to a simplified form
reformat_roman :: [String] -> [String]
reformat_roman [] = []
reformat_roman xs = map (int_to_valid_rom . roman_to_int . roman_map) xs

roman_map :: [Char] -> [Int]
roman_map xs = map roman_eq xs

-- Assumes valid roman input
-- converts a roman number list to a value with preceding lower value check
roman_to_int :: [Int] -> Int
roman_to_int [] = 0
roman_to_int (x:[]) = x
roman_to_int (x:y:zs)   | x >= y = x + (roman_to_int (y:zs))
                        | otherwise = (y - x) + (roman_to_int zs)

can_be_before :: Int -> Int -> Bool
can_be_before 1 x = (x == 10) || (x == 5)

--roman_to_int xs = foldr (+) 0 (map roman_eq xs)

-- roman integer equivalency
roman_eq :: Char -> Int
roman_eq x  | x == 'I' = 1
            | x == 'V' = 5
            | x == 'X' = 10
            | x == 'L' = 50
            | x == 'C' = 100
            | x == 'D' = 500
            | x == 'M' = 1000
            | otherwise = 0

-- takes a given number and converts it to roman numerals
int_to_valid_rom :: Int -> String
int_to_valid_rom 0 = []
int_to_valid_rom x  | x >= 1000 = 'M':(int_to_valid_rom $ x - 1000)
                    | (x < 1000) && (x >= 900) = 'C':'M':(int_to_valid_rom $ x - 900)
                    | x >= 500 = 'D':(int_to_valid_rom $ x - 500)
                    | (x < 500) && (x >= 400) = 'C':'D':(int_to_valid_rom $ x - 400)
                    | x >= 100 = 'C':(int_to_valid_rom $ x - 100)
                    | (x < 100) && (x >= 90) = 'X':'C':(int_to_valid_rom $ x - 90)
                    | x >= 50 = 'L':(int_to_valid_rom $ x - 50)
                    | (x < 50) && (x >= 40) = 'X':'L':(int_to_valid_rom $ x - 40)
                    | x >= 10 = 'X':(int_to_valid_rom $ x - 10)
                    | x == 9 = 'I':'X':[]
                    | x >= 5 = 'V':(int_to_valid_rom $ x - 5)
                    | x == 4 = 'I':'V':[]
                    | otherwise = 'I':(int_to_valid_rom $ x - 1)

--counts how many characters are saved by correct formatting. original form is xs and reformatted is ys
char_saved :: [String] -> [String] -> Int
char_saved [] [] = 0
char_saved (x:xs) (y:ys) = ((length x) - (length y)) + char_saved xs ys
