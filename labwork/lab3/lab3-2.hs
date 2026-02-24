isSumPowFoldr :: Int -> Int
isSumPowFoldr n = foldr (\x acc -> acc + x^2) 0 [1..n]


isSumPowMap :: Int -> Int
isSumPowMap n = sum (map (\x -> x^2) [1..n]) 