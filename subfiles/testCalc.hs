import Text.Read (readMaybe)

calculate :: String -> Double -> Double -> Maybe Double
calculate op x y = do
    result <- case op of
        "+" -> Just(x + y)
        "-" -> Just(x - y)
        "*" -> Just(x * y)
        "/" -> if y /= 0 then Just (x / y) else Nothing
        _ -> Nothing
    return result   

readDouble :: String -> Maybe Double
readDouble = readMaybe

main :: IO ()
main = do
    putStrLn "=== Простой калькулятор ==="
    putStrLn "Введите первое число:"
    input1 <- getLine

    case readDouble input1 of
        Nothing -> do
            putStrLn "Ошибка! Не число."
            main
        Just num1 -> do
            putStrLn "Введите оператор (+, -, *, /):"
            op <- getLine
            putStrLn "Введите второе число:"
            input2 <- getLine
            case readDouble input2 of
                Nothing -> do
                    putStrLn "Ошибка! Не число."
                    main
                Just num2 -> do
                    case calculate op num1 num2 of
                        Nothing -> do
                            putStrLn "Неверный оператор или деление на 0!"
                            main
                        Just result -> do
                            putStrLn ("Результат: " ++show result)
                            main
                
