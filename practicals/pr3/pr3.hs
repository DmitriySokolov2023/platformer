import Text.XHtml (content)
import Text.Read (readMaybe)

parseRow :: String -> Maybe [Int]
parseRow = mapM readMaybe . words

main :: IO ()
main = do
	content <- readFile "matrix.txt"
	let rows = lines content

	print rows
    