import Data.Char
import Data.Bits

--data Key a b = Empty |

-- ANSWER TO THE CHALLENGE : 129448
{-

NOTE: This does not give you the correct string, it gives you possible string. You must then inspect the list of strings to find the correct answer.
Then you copy and paste the correct string into the ascii sum function to get the correct value.
Reference this link to see challenge: https://projecteuler.net/problem=59

***READ***
How to run program:
for encoded file use 59_ciph.txt
for length of lowercase strings use 3
for common word file use common_words.txt
for number of common words to look for, use 20

-}
run = do {
            putStr "Input encoded file: ";
            enc_file <- getLine;
            enc_file_cont <- readFile enc_file;
            print (take_csv_input enc_file_cont);
            --putStr "Input key file: ";
            --key_file <- getLine;
            --key_file_cont <- readFile key_file;
            --print (words key_file_cont);
            --print (map char_to_int (words key_file_cont));
            putStr "Input length of lowercase strings to generate: ";
            key_length <- getLine;
            putStr "Input common words file: ";
            com_file <- getLine;
            com_file_cont <- readFile com_file;
            print (words com_file_cont);
            putStr "How many instances of common words should I look for? (Integer above 0): ";
            x <- getLine;
            print $ map (\(m, k) -> ("Sum of ascii values for message: "  ++ show (ascii_sum m), "Key: " ++ k, "Mesage: " ++ m)) $
                analyze_sets
                    (gen_decoded_set (take_csv_input enc_file_cont) (map char_to_int (gen_n_lowercase_strings $ read key_length)))
                    (words com_file_cont)
                    $ read x ;
    }

{-
take_csv_input
param[in] x [Char] : a list of integer characters which seperated by spaces
return [Int] : A list of the integers that were seperated by spaces
-}
take_csv_input :: [Char] -> [Int]
take_csv_input x = map (read :: [Char] -> Int) (words (csv_to_list x))

{-
csv_to_list (rudimentary function)
param[in] s String : a string that contains csv data
return [Char] : A list of charcters seperated by spaces
-}
csv_to_list :: String -> [Char]
csv_to_list [] = []
csv_to_list s = map (test_com) s

{-
test_com (rudimentary function)
param[in] x Char : a character to check if it's a ',' or '\n' char
return Char : A space char if above, otherwise the input character
-}
test_com :: Char -> Char
test_com x  | x == ',' = ' '
            | x == '\n' = ' '
            | otherwise = x


{-
char_to_int
param[in] xs [Int] : list of characters (String)
return [Int] : the list of integers, ascii character value list
-}
char_to_int::[Char]->[Int]
char_to_int xs = map (ord) xs

{-
int_to_char
param[in] xs [Int] : list of integers to be returned to characters
return [Int] : converts each number into an ascii character
-}
int_to_char::[Int]->[Char]
int_to_char xs = map (chr) xs


{-
xor_transformation_interface
param[in] xs [Int] : list of ascii numbers representing the message to be transformed
param[in] ys [Int] : list of ascii numbers representing the message key
return [Int] : the xor_transformation function
-}
xor_transformation_interface :: [Int] -> [Int] -> [Int]
xor_transformation_interface [] _ = []
xor_transformation_interface _ [] = []
xor_transformation_interface xs ys = xor_transformation xs ys ys

{-
xor_transformation
param[in] xs [Int] : list of ascii numbers representing the message to be transformed
param[in] ys [Int] : list of ascii numbers representing the message key
param[in] cs [Int] : same list as ys (This is used to refill the arguments when ys runs out)
return [Int] : the list of integers that are XOR-ed togther (transformed)
description : this function xor's the contents of the message against the key. If the key is shorter than the message, than the key is cyclically repeated for the length of the message
-}
xor_transformation::[Int]->[Int]->[Int]->[Int]
xor_transformation [] _ _ = []
xor_transformation xs [] cs = xor_transformation xs cs cs
xor_transformation (x:xs) (y:ys) cs = (xor x y) : (xor_transformation xs ys cs)

{-
gen_3letter_permutations
return [String] : A list of all 3 letter lowercase string permutations
-}
gen_3letter_permutations :: [String]
gen_3letter_permutations = [[x,y,z] | x <- ['a'..'z'], y <- ['a'..'z'], z <- ['a'..'z']]


{-
gen_n_lowercase_strings
param[in] n Int : the number of lowercase letters per string
return [String] : A list of all n letter lowercase strings
-}
gen_n_lowercase_strings :: Int ->  [String]
gen_n_lowercase_strings n   | n < 1 = []
                            | otherwise = [ c : s | s <- "" : (gen_n_lowercase_strings $ n - 1), c <- ['a'..'z']]


{-
gen_decoded_set
param[in] x [Int] : the ascii values of a message to be tested against possible keys
param[in] ys [[Int]] : a list key strings that were converted to their corresponding ascii values
return [(String, String)] : A list of tuples with the form (XORed_message_string, key_string)
-}
gen_decoded_set :: [Int] -> [[Int]] -> [(String, String)]
gen_decoded_set x ys = map (\k -> (int_to_char (xor_transformation_interface x k), (int_to_char k))) ys

{-
analyze_sets
param[in] xs [(String, String)] : a list of string tuples with of the form (message_str, key_str)
param[in] ys [String] : a list of search words to be found within the decoded strings
param[in] n : sensitivity factor => how many words should be detected if it to saved for inspection
return [(String, String)] : A list of decoded strings that have at least n occurrences of the words within the search list
-}
analyze_sets :: [(String,String)] -> [String] -> Int -> [(String,String)]
analyze_sets [] _ _= []
analyze_sets ls [] _ = ls
analyze_sets ((x, k):ls) ys n   | (contains_real_word_counter (words x) ys) >= n = (x, k) : (analyze_sets ls ys n)
                                | otherwise = analyze_sets ls ys n


{-
contains_real_word
param[in] xs [String] : a transformed string, atomized into individual "words"
param[in] ys [String] : list of strings to check if they are present within the transformed strings
return Bool :   if empty => False
                if not empty => true if a single string matches, otherwise False
description : takes the words for a given transformed string and checks if there is a single string that matches list of search strings
-}
contains_real_word :: [String] -> [String] -> Bool
contains_real_word [] _ = False
contains_real_word _ [] = False
contains_real_word (x:xs) ys = (foldr (same_string_bool x) (False) ys) || contains_real_word xs ys

{-
same_string_bool
param[in] x String : 1st string to compare
param[in] y String : 2nd string to compare
return (Bool -> Bool) : a function that takes the result of the equality and returns an OR function with the equality as one argument. Is used by foldr in contains_real_word
-}
same_string_bool :: String -> String -> Bool -> Bool
same_string_bool x y = ((x == y) || )

{-
contains_real_word_counter
param[in] xs [String] : a transformed string, atomized into individual "words"
param[in] ys [String] : list of strings to check if they are present within the transformed strings
return Int :   if empty => 0
                if not empty => increment count by one, otherwise add 0
description :   Takes the words for a given transformed string and checks if there is a single string that matches list of search strings.
                If the string is found, it increments the number of times any search string is found within the transformed string
-}
contains_real_word_counter :: [String] -> [String] -> Int
contains_real_word_counter [] _ = 0
contains_real_word_counter _ [] = 0
contains_real_word_counter (x:xs) ys = (foldr (same_string_cnt x) (0) ys) + contains_real_word_counter xs ys

{-
same_string_cnt
param[in] x String : 1st string to compare
param[in] y String : 2nd string to compare
return (Int -> Int) : a function that returns (1 + ) if the strings are equal, otherwise (0 + ). Is used by foldr in contains_real_word_counter
-}
same_string_cnt :: String -> String -> Int -> Int
same_string_cnt x y | x == y = (1 + )
                    | otherwise = (0 + )

{-
encode
param[in] x String : message string to be xor encoded
param[in] y String : key string to be xor against
return [Int] : the list of encoded ascii numbers after the xor_transformation of message and key
-}
encode :: String -> String -> [Int]
encode [] _ = []
encode _ [] = []
encode x y = xor_transformation_interface (char_to_int x) (char_to_int y)

{-
decode
param[in] xs [Int] : an encoded ascii number list
param[in] ys [Int] : an ascii list representing a key
return String : The corresponding string after the encoded string is XOR-ed against the key list
-}
decode :: [Int] -> [Int] -> String
decode [] _ = []
decode _ [] = []
decode xs ys = int_to_char (xor_transformation_interface xs ys)

{-
ascii_sum
param[in] x String : a string to converted to ascii values. From there, the list is of numbers is summed together
return Int : the ascii value sum for a string
-}
ascii_sum :: String -> Int
ascii_sum "" = 0
ascii_sum x = foldr (+) 0 (char_to_int x)
