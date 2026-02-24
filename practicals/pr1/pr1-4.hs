powNum :: Float -> Int -> Float
powNum _ 0 = 1
powNum num pow = num * powNum num (pow - 1)

factorialNum :: Int -> Int
factorialNum 0 = 1
factorialNum n = n * factorialNum (n - 1)

fibonacciNum :: Int -> Int
fibonacciNum 0 = 0
fibonacciNum 1 = 1
fibonacciNum n = fibonacciNum (n-1) + fibonacciNum (n-2)