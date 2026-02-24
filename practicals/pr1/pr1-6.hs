spisnat :: Int -> [Int]
spisnat 0 = []
spisnat n = [x | x <- [1..n] ]

spischet :: Int -> [Int]
spischet n = [2,4..n]

spisnechet :: Int -> [Int]
spisnechet n = [1,3..n]