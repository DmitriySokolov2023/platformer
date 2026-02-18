add :: int -> int -> int
add x y = x + y

main :: IO ()
main = do
		let result = add 5 3
		putStrLn ("The result of adding 5 and 3 is: " ++ show result)