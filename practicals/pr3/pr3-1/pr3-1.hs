import System.Environment (getArgs)
import System.Exit (die)
import Data.Maybe (fromMaybe)

differLines :: [String] -> [String] -> [(Int, Maybe String, Maybe String)]
differLines = go 1
  where
    go _ []     []     = []
    go n (x:xs) (y:ys) = (n, Just x, Just y) : go (n + 1) xs ys
    go n []     (y:ys) = (n, Nothing, Just y) : go (n + 1) [] ys
    go n (x:xs) []     = (n, Just x, Nothing) : go (n + 1) xs []

filterDifferLines :: [(Int, Maybe String, Maybe String)]
                  -> [(Int, Maybe String, Maybe String)]
filterDifferLines = filter (\(_, a, b) -> a /= b)

formatDiff :: (Int, Maybe String, Maybe String) -> String
formatDiff (n, a, b) =
  "Строка " ++ show n ++ " отличается:\n"
  ++ "< " ++ fromMaybe "(нет строки)" a ++ "\n"
  ++ "> " ++ fromMaybe "(нет строки)" b ++ "\n"

main :: IO ()
main = do
  args <- getArgs
  case args of
    [file1, file2] -> do
      content1 <- readFile file1
      content2 <- readFile file2

      let list1 = lines content1
          list2 = lines content2
          diffs = filterDifferLines (differLines list1 list2)

      if null diffs
        then putStrLn "Файлы совпадают построчно."
        else mapM_ putStrLn (map formatDiff diffs)

    _ -> die "Ошибка: требуется ровно 2 аргумента"