import System.Environment (getArgs)
import System.Exit (die)
import Text.Read (readMaybe)
import Data.List (transpose)

parseLine :: String -> Maybe [Int]
parseLine s = traverse readMaybe (words s)

parseMatrix :: String -> Either String [[Int]]
parseMatrix content =
  let ls = filter (not . null) (lines content)  
  in case traverse parseLine ls of
      Nothing -> Left "Ошибка: в матрице должны быть только целые числа, разделённые пробелами."
      Just m
        | null m -> Left "Ошибка: файл пустой."
        | not (isRect m) ->
            Left "Ошибка: строки матрицы имеют разную длину (матрица должна быть прямоугольной)."
        | otherwise -> Right m

isRect :: [[a]] -> Bool
isRect [] = True
isRect (r:rs) = all ((== length r) . length) rs

main :: IO ()
main = do
    content <- readFile "matrix.txt"
    case parseMatrix content of 
        Left err -> die err
        Right matrix -> do
            let colSums = map sum (transpose matrix)
            putStrLn "Суммы столбцов"
            mapM_ print colSums
