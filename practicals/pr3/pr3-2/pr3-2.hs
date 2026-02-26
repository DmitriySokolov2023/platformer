import System.Environment (getArgs)
import System.Exit (die)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [file] -> do
      content <- readFile file
      let ls = lines content
      mapM_ putStrLn (zipWith formatLine [1..] ls)
    _ -> die "Ошибка: требуется 1 аргумент — имя файла. Пример: :main file.txt"

formatLine :: Int -> String -> String
formatLine n line = show n ++ ": " ++ line