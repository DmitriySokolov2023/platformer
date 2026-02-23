import Data.Char (isDigit)

isLatinAndNum :: Char -> Bool
isLatinAndNum c =
  isDigit c ||
  ('a' <= c && c <= 'z') ||
  ('A' <= c && c <= 'Z')

printTokens :: [String] -> IO ()
printTokens [] = putStrLn ""
printTokens (t:ts) = do
    putStr (t ++ " ")
    printTokens ts

main :: IO ()
main = do
  let fileName = "C:/users/User/Desktop/platformer/practicals/pr2/pr2-1.txt"
  content <- readFile fileName
  let cleaned = map (\c -> if isLatinAndNum c then c else ' ') content
      tokens  = words cleaned
  putStrLn "Результат обработки:"
  printTokens tokens