powersOfTwo :: Int -> [Integer]
powersOfTwo n =
  case n of
    0 -> []
    k | k > 0 -> take k (map (2^) [0..])
    _ -> error "Кол-во элементов не должно быть отрицательным"