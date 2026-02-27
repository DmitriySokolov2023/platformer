getList :: Int -> [Int]
getList n = [x^2 | x <- [0 .. n]]

lenList :: [Int] -> Int
lenList [] = 0
lenList (_:xs) = 1 + lenList xs

main :: IO ()
main = do
    let myList = getList 5
    print $ myList
