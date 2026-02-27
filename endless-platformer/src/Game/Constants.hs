module Game.Constants
  ( windowTitle
  , windowWidth
  , windowHeight
  , windowPos
  , backgroundColor
  , fps
  , titleText
  , titleX
  , titleY
  , titleScale
  , titleColor
  , hintText
  , hintX
  , hintY
  , hintScale
  , hintColor
  , playingText
  , playingX
  , playingY
  , playingScale
  , playingColor
  , playingHintText
  , playingHintX
  , playingHintY
  , playingHintScale
  , playingHintColor
  , playerWidth
  , playerHeight
  , playerY
  , playerColor
  , moveSpeed
  , groundY
  , groundHeight
  , groundColor
  ) where

import Graphics.Gloss (Color, greyN, makeColorI)

windowTitle :: String
windowTitle = "Endless Platformer"

windowWidth :: Int
windowWidth = 960

windowHeight :: Int
windowHeight = 540

windowPos :: (Int, Int)
windowPos = (100, 100)

backgroundColor :: Color
backgroundColor = greyN 0.1

fps :: Int
fps = 60

titleText :: String
titleText = "Endless Platformer"

titleX :: Float
titleX = -260

titleY :: Float
titleY = 40

titleScale :: Float
titleScale = 0.4

titleColor :: Color
titleColor = makeColorI 240 240 240 255

hintText :: String
hintText = "Press Enter  (Esc to quit)"

hintX :: Float
hintX = -220

hintY :: Float
hintY = -40

hintScale :: Float
hintScale = 0.2

hintColor :: Color
hintColor = makeColorI 200 200 200 255

playingText :: String
playingText = "Hold A/D or Left/Right to move"

playingX :: Float
playingX = -300

playingY :: Float
playingY = 200

playingScale :: Float
playingScale = 0.2

playingColor :: Color
playingColor = makeColorI 240 240 240 255

playingHintText :: String
playingHintText = "Backspace: title  |  Esc: quit"

playingHintX :: Float
playingHintX = -260

playingHintY :: Float
playingHintY = 160

playingHintScale :: Float
playingHintScale = 0.2

playingHintColor :: Color
playingHintColor = makeColorI 200 200 200 255

playerWidth :: Float
playerWidth = 40

playerHeight :: Float
playerHeight = 60

playerY :: Float
playerY = -140

playerColor :: Color
playerColor = makeColorI 255 200 80 255

moveSpeed :: Float
moveSpeed = 260

groundY :: Float
groundY = -200

groundHeight :: Float
groundHeight = 20

groundColor :: Color
groundColor = makeColorI 80 170 80 255