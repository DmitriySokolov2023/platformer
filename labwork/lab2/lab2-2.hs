sumPow :: Integer -> Integer
sumPow n = sum ([x*x | x <- [1..n]])

sumPowRec :: Integer -> Integer
sumPowRec 0 = 0
sumPowRec n = n*n + sumPowRec(n-1)