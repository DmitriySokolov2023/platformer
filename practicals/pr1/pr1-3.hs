kvad :: Num a => a -> a
kvad x = x * x

kvadvyr :: Num a => a -> a -> a -> a -> a
kvadvyr a b c x = a * kvad x + b * x + c