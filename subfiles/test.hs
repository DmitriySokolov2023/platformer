{-# OPTIONS_GHC -Wno-tabs #-}
f :: (Eq a1, Num a1, Num a2) => a1 -> a2
f 0 = 1
f 1 = 5
f 2 = 2
f _ = -1

factor :: Integer -> Integer
factor 0 = 1
factor n = n * factor(n - 1)

len :: [a] -> Int
len [] = 0
len (_:xs) = 1 + len xs


main :: IO ()
main = do
	putStrLn "Hello"
	print $ f 1
	print $ f 2
	print $ f 3
	print $ factor 6
	print $ len [1,2,3,4,5,6]