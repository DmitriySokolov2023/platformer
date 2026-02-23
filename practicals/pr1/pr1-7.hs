spiskvat :: Int -> [Int]
spiskvat n = [x*x | x <- [1..n]]

factorial :: Int -> Int
factorial 0 = 1
factorial n = n * factorial (n - 1)

spisfact :: Int -> [Int]
spisfact n = [factorial x | x <- [1..n]]

spisstepdvoik :: Int -> [Int]
spisstepdvoik n = [2^x | x <- [1..n]]

treugferma :: Int -> [Int]
treugferma n = [x*(x+1) `div` 2 | x <- [1..n]]

piramferma :: Int -> [Int]
piramferma n = [x*(3*x-1) `div` 2 | x <- [1..n]]