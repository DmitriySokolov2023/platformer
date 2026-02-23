import Text.Read (readMaybe) 

calculate :: String -> Double -> Double -> Maybe Double

calculate "+" x y = Just (x + y)
calculate "-" x y = Just (x - y)
calculate "*" x y = Just (x * y)
calculate "/" x y = if y /= 0 then Just (x / y) else Nothing
calculate _ _ _ = Nothing   


main :: IO ()
main = do
    print $ calculate "%" 5 6