aBetweenBC :: (Num a, Ord a, Eq a) => a -> a -> a -> Bool
aBetweenBC ab bc ac =
  ab > 0 && ac > 0 && bc > 0 && bc == ab + ac