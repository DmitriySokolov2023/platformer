removeEmpty :: [String] -> [String]
removeEmpty lst = filter (\x -> x /= "") lst

removeEmptyShort :: [String] -> [String]
removeEmptyShort = filter (/= "")