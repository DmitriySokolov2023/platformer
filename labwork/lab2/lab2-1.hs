tenPow :: Int -> [Integer]
tenPow n = if n >= 0 then [10^x | x <- [1..n]] else []