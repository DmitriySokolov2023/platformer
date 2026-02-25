import Data.Char (isAlpha) -- предикат определяющий является ли символ буквой
listString = ["Hello", "World!", "abc", "123", "a_b", "", "Привет1", "Hi"] -- входной список (сделал статическим для удобства)

onlyLetters:: [String] -> [String] 
onlyLetters lst = filter (\x -> not (null x) && all isAlpha x) lst -- здесь применяется функция filter к каждому элементу lst (мой список) и применяет к ним следующие условия: 1 элемент не пустой (\x -> not (null x)) и 2 все символы в элементе буквы (all isAlpha x)

main :: IO() --главная функция
main = do
  print $ onlyLetters listString -- вывод результата возврата функции onlyLetters, при передаче в нее listString 