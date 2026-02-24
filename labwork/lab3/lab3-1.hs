srGm :: [Double] -> Double
srGm [] = error "Пустой список"
srGm arr =
  let (prod, n) = foldr (\x (p, k) -> (x * p, k + 1)) (1.0, 0) arr
  in prod ** (1 / fromIntegral n)
