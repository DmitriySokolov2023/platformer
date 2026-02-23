import System.Environment (getArgs)
import Data.Char (toUpper, toLower)

main :: IO ()
main = do
  args <- getArgs
  case args of
    [fileName, mode] -> do
      content <- readFile fileName
      case mode of
        "u" -> putStrLn (map toUpper content)
        "l" -> putStrLn (map toLower content)
        _ -> putStrLn "Ошибка: режим должен быть 'u' (upper) или 'l' (lower)"
    _ -> putStrLn "Введите команду в формате: ИМЯ_ФАЙЛА РЕЖИМ"