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
  , playerStartY
  , playerBaseX
  , steerRange
  , playerColor
  , moveSpeed
  , runSpeed
  , metersPerPixel
  , gravity
  , jumpVelocity
  , groundY
  , groundTopY
  , groundHeight
  , groundColor
  , markSpacing
  , markColor
  , distanceX
  , distanceY
  , distanceScale
  , distanceColor
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
playingText = "A/D or Left/Right steer | Space/W/Up jump | Auto-run"

playingX :: Float
playingX = -360

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

playerColor :: Color
playerColor = makeColorI 255 200 80 255

-- Runner tuning ------------------------------------------------

playerBaseX :: Float
playerBaseX = -300

steerRange :: Float
steerRange = 140

moveSpeed :: Float
moveSpeed = 260

runSpeed :: Float
runSpeed = 320

metersPerPixel :: Float
metersPerPixel = 0.10

-- Physics ------------------------------------------------------

gravity :: Float
gravity = 1200

jumpVelocity :: Float
jumpVelocity = 520

-- Ground -------------------------------------------------------

groundY :: Float
groundY = -200

groundHeight :: Float
groundHeight = 20

groundTopY :: Float
groundTopY = groundY + groundHeight / 2

playerStartY :: Float
playerStartY = groundTopY + playerHeight / 2

groundColor :: Color
groundColor = makeColorI 80 170 80 255

markSpacing :: Float
markSpacing = 120

markColor :: Color
markColor = makeColorI 120 220 120 255

-- HUD ----------------------------------------------------------

distanceX :: Float
distanceX = -440

distanceY :: Float
distanceY = 240

distanceScale :: Float
distanceScale = 0.18

distanceColor :: Color
distanceColor = makeColorI 240 240 240 255