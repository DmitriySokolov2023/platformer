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
  , menuItemX
  , menuItemY0
  , menuItemY1
  , menuItemY2
  , menuItemY3
  , menuItemY4
  , menuItemScale
  , menuItemColor
  , menuSelectedColor
  , menuHintText
  , menuHintX
  , menuHintY
  , menuHintScale
  , menuHintColor
  , playerWidth
  , playerHeight
  , playerStartY
  , playerBaseX
  , steerRange
  , invBlinkHz
  , moveSpeed
  , runSpeedEasy
  , runSpeedNormal
  , runSpeedHard
  , metersPerPixel
  , gravity
  , jumpVelocity
  , groundY
  , groundTopY
  , groundHeight
  , groundColor
  , markSpacing
  , markColor
  , distanceColor
  , deathY
  , maxLives
  , invincibilityDuration
  , heartW
  , heartH
  , heartSpacing
  , heartFullColor
  , heartEmptyColor
  , chunkWidth
  , spawnAhead
  , despawnBehind
  , holeWidth
  , platformW
  , platformH
  , platformLift
  , platformEdgeInset
  , platformColor
  , spikeW
  , spikeH
  , spikeColor
  , medkitW
  , medkitH
  , medkitLift
  , medkitColor
  , medkitCrossColor
  , gameOverTitleText
  , gameOverTitleX
  , gameOverTitleY
  , gameOverTitleScale
  , gameOverTitleColor
  , gameOverHintText
  , gameOverHintX
  , gameOverHintY
  , gameOverHintScale
  , gameOverHintColor
  , playerSpritePxW
  , playerSpritePxH
  , playerRunFrameStep
  , pauseTitleText
  , pausePanelW
  , pausePanelH
  , pausePanelColor
  , pausePanelBorderColor
  , pauseTitleScale
  , pauseTitleColor
  , pauseItemScale
  , pauseItemSelectedColor
  , pauseItemColor
  , pauseHintText
  , pauseHintScale
  , pauseHintColor
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
titleY = 120

titleScale :: Float
titleScale = 0.4

titleColor :: Color
titleColor = makeColorI 240 240 240 255

menuItemX :: Float
menuItemX = -220

menuItemY0 :: Float
menuItemY0 = 40

menuItemY1 :: Float
menuItemY1 = 5

menuItemY2 :: Float
menuItemY2 = -30

menuItemY3 :: Float
menuItemY3 = -65

menuItemY4 :: Float
menuItemY4 = -100

menuItemScale :: Float
menuItemScale = 0.26

menuItemColor :: Color
menuItemColor = makeColorI 180 180 180 255

menuSelectedColor :: Color
menuSelectedColor = makeColorI 255 255 255 255

menuHintText :: String
menuHintText =
  "Up/Down: choose  |  Left/Right: difficulty  |  Enter: select  |  Esc: exit"

menuHintX :: Float
menuHintX = -440

menuHintY :: Float
menuHintY = -170

menuHintScale :: Float
menuHintScale = 0.18

menuHintColor :: Color
menuHintColor = makeColorI 200 200 200 255

playerWidth :: Float
playerWidth = 40

playerHeight :: Float
playerHeight = 60

invBlinkHz :: Float
invBlinkHz = 12

playerBaseX :: Float
playerBaseX = -300

steerRange :: Float
steerRange = 140

moveSpeed :: Float
moveSpeed = 260

runSpeedEasy :: Float
runSpeedEasy = 280

runSpeedNormal :: Float
runSpeedNormal = 320

runSpeedHard :: Float
runSpeedHard = 380

metersPerPixel :: Float
metersPerPixel = 0.10

gravity :: Float
gravity = 1200

jumpVelocity :: Float
jumpVelocity = 520

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

distanceColor :: Color
distanceColor = makeColorI 240 240 240 255

deathY :: Float
deathY = -300

maxLives :: Int
maxLives = 3

invincibilityDuration :: Float
invincibilityDuration = 0.8

heartW :: Float
heartW = 18

heartH :: Float
heartH = 14

heartSpacing :: Float
heartSpacing = 24

heartFullColor :: Color
heartFullColor = makeColorI 220 80 80 255

heartEmptyColor :: Color
heartEmptyColor = makeColorI 70 70 70 255

chunkWidth :: Float
chunkWidth = 700

spawnAhead :: Float
spawnAhead = 2000

despawnBehind :: Float
despawnBehind = 800

holeWidth :: Float
holeWidth = 160

platformW :: Float
platformW = 180

platformH :: Float
platformH = 18

platformLift :: Float
platformLift = 50

platformEdgeInset :: Float
platformEdgeInset = 0

platformColor :: Color
platformColor = makeColorI 120 120 220 255

spikeW :: Float
spikeW = 40

spikeH :: Float
spikeH = 35

spikeColor :: Color
spikeColor = makeColorI 220 80 80 255

medkitW :: Float
medkitW = 26

medkitH :: Float
medkitH = 26

medkitLift :: Float
medkitLift = 70

medkitColor :: Color
medkitColor = makeColorI 80 200 120 255

medkitCrossColor :: Color
medkitCrossColor = makeColorI 240 240 240 255

gameOverTitleText :: String
gameOverTitleText = "Game Over"

gameOverTitleX :: Float
gameOverTitleX = -170

gameOverTitleY :: Float
gameOverTitleY = 80

gameOverTitleScale :: Float
gameOverTitleScale = 0.5

gameOverTitleColor :: Color
gameOverTitleColor = makeColorI 255 220 220 255

gameOverHintText :: String
gameOverHintText = "Enter: restart  |  Backspace: menu  |  Esc: quit"

gameOverHintX :: Float
gameOverHintX = -360

gameOverHintY :: Float
gameOverHintY = 10

gameOverHintScale :: Float
gameOverHintScale = 0.2

gameOverHintColor :: Color
gameOverHintColor = makeColorI 240 240 240 255

playerSpritePxW :: Float
playerSpritePxW = 180

playerSpritePxH :: Float
playerSpritePxH = 180

playerRunFrameStep :: Float
playerRunFrameStep = 28

pauseTitleText :: String
pauseTitleText = "Paused"

pausePanelW :: Float
pausePanelW = 360

pausePanelH :: Float
pausePanelH = 200

pausePanelColor :: Color
pausePanelColor = makeColorI 30 30 30 235

pausePanelBorderColor :: Color
pausePanelBorderColor = makeColorI 220 220 220 255

pauseTitleScale :: Float
pauseTitleScale = 0.35

pauseTitleColor :: Color
pauseTitleColor = makeColorI 245 245 245 255

pauseItemScale :: Float
pauseItemScale = 0.24

pauseItemSelectedColor :: Color
pauseItemSelectedColor = makeColorI 255 255 255 255

pauseItemColor :: Color
pauseItemColor = makeColorI 180 180 180 255

pauseHintText :: String
pauseHintText = "Up/Down: choose  |  Enter: select  |  P: resume"

pauseHintScale :: Float
pauseHintScale = 0.14

pauseHintColor :: Color
pauseHintColor = makeColorI 160 160 160 255

dbFileName :: FilePath
dbFileName = "game.db"

leaderboardLimit :: Int
leaderboardLimit = 10

defaultPlayerName :: String
defaultPlayerName = "Player"

scoreSavedText :: String
scoreSavedText = "Score saved to leaderboard."