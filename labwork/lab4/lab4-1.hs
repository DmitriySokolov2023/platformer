twoPow :: Int -> [Double]
twoPow 0 = []
twoPow n = twoPow (n - 1) ++ [2 ^ (n-1)]

twoPowUpgrade :: Int -> [Double]
twoPowUpgrade n = 
	case n of
		0 -> []
		k | k > 0 -> twoPowUpgrade(k - 1) ++ [2 ^ (k - 1)]
		_-> []