
data PhoneBook a b = Empty | Node a b (PhoneBook a b) (PhoneBook a b)
 deriving Show

phoneBook :: PhoneBook String String
phoneBook = 
  Node "Bob" "789-012"
    (Node "Alice" "123-456" Empty Empty)
    (Node "Charlie" "345-678" Empty Empty)

find :: Ord a => a -> PhoneBook a b -> Maybe b
find _ Empty = Nothing
find key (Node k v left right)
  | key == k  = Just v
  | key < k   = find key left
  | otherwise = find key right

main :: IO()
main = do 
  let result = find "Bob" phoneBook
  case result of
    Nothing -> putStrLn "Не найден"
    Just number -> putStrLn $ "Номер боба" ++ number
