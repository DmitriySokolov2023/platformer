import Text.Read (readMaybe)

getMatrix :: Int -> Int -> [[Int]]
getMatrix n m
    | n <= 1 || m <= 1 = error "Строк и столбцов должно быть больше 1"
    | otherwise = replicate n [1..m]

getPositiveInt :: String -> IO Int
getPositiveInt prompt = do
    putStrLn prompt
    input <- getLine
    case readMaybe input of
        Just n | n > 1 -> return n
        _ -> do
            putStrLn "Ошибка: введите целое число больше 1"
            getPositiveInt prompt

main :: IO()
main = do
    n <- getPositiveInt "Введите количество строк (n > 1):"
    m <- getPositiveInt "Введите количество столбцов (m > 1):"
    
    let matrix = getMatrix n m
    putStrLn $ "Сгенерированная матрица " ++ show n ++ "x" ++ show m ++ ":"
    mapM_ print matrix