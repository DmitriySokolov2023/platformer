import Text.XHtml (content)
import Text.Read (readMaybe)

parseRow :: String -> Maybe [Int]
parseRow x = mapM readMaybe (words x)

main :: IO ()
main = do
    content <- readFile "matrix.txt"
    let rows = lines content

    case traverse parseRow rows of
        Nothing -> putStrLn "Ошибка в данных матрицы"
        Just matrix -> do
            putStrLn "Матрица:"
            mapM_ print matrix

            let diag = [matrix !! i !! i | i <- [0 .. length matrix - 1]]
            putStrLn $ "Диагональные элементы: " ++ show diag
            putStrLn $ "Сумма диагональных элементов = " ++ show (sum diag)
