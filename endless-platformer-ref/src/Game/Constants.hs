module Game.Constants
  (
    windowTitle, windowWidth, windowHeight, windowPos,
    backgroundColor, fps,

    titleText, titleX, titleY, titleScale, titleColor,
    menuItemX, menuItemY0, menuItemY1, menuItemY2, menuItemY3, menuItemY4,
    menuItemScale, menuItemColor, menuSelectedColor,
    menuHintText, menuHintX, menuHintY, menuHintScale, menuHintColor,

    playerWidth, playerHeight, playerStartY, playerBaseX,
    steerRange, invBlinkHz, moveSpeed,
    runSpeedEasy, runSpeedNormal, runSpeedHard,
    metersPerPixel, gravity, jumpVelocity,
    playerSpritePxW, playerSpritePxH, playerRunFrameStep,

    groundY, groundHeight, groundTopY, groundColor,
    markSpacing, markColor, distanceColor,
    deathY, maxLives, invincibilityDuration,

    chunkWidth, spawnAhead, despawnBehind,
    holeWidth, spikeW, spikeH, platformW, platformH, platformLift,
    platformEdgeInset,
    spikeColor, platformColor,
    bridgeChanceEasy, bridgeChanceNormal, bridgeChanceHard,
    bridgeMinSpacing, bridgeMaxSpacing,
    bridgeMinLen, bridgeMaxLen,
    extraPlatformChance,
    medkitW, medkitH, medkitLift, medkitColor, medkitCrossColor,

    gameOverTitleText, gameOverTitleX, gameOverTitleY,
    gameOverTitleScale, gameOverTitleColor,
    gameOverHintText, gameOverHintX, gameOverHintY,
    gameOverHintScale, gameOverHintColor,

    pauseTitleText,
    pausePanelW, pausePanelH, pausePanelColor, pausePanelBorderColor,
    pauseTitleScale, pauseTitleColor,
    pauseItemScale, pauseItemSelectedColor, pauseItemColor,
    pauseHintText, pauseHintScale, pauseHintColor,
    pauseItem3Y,

    dbFileName, leaderboardLimit,
    defaultPlayerName, playerNameMaxLen,
    scoreSavedText,
    saveSlotsCount,
    defaultSaveSeed
  ) where

import Graphics.Gloss (Color, makeColorI)
import Config (SpeedRule(..))

windowTitle :: String
windowTitle = "Endless Platformer"

windowWidth :: Int
windowWidth = 960

windowHeight :: Int
windowHeight = 540

windowPos :: (Int, Int)
windowPos = (60, 40)

backgroundColor :: Color
backgroundColor = makeColorI 20 20 28 255

fps :: Int
fps = 60

titleText :: String
titleText = "ENDLESS PLATFORMER"

titleX :: Float
titleX = -300

titleY :: Float
titleY = 140

titleScale :: Float
titleScale = 0.42

titleColor :: Color
titleColor = makeColorI 200 255 0 255

menuItemX :: Float
menuItemX = -70

menuItemY0, menuItemY1, menuItemY2, menuItemY3, menuItemY4 :: Float
menuItemY0 = 40
menuItemY1 = 5
menuItemY2 = -30
menuItemY3 = -65
menuItemY4 = -100

menuItemScale :: Float
menuItemScale = 0.26

menuItemColor :: Color
menuItemColor = makeColorI 200 215 230 255

menuSelectedColor :: Color
menuSelectedColor = makeColorI 200 255 0 255

menuHintText :: String
menuHintText =
  "Up/Down: choose  |  Left/Right: LEVEL  |  Enter: select  |  Esc: exit"

menuHintX :: Float
menuHintX = -440

menuHintY :: Float
menuHintY = -170

menuHintScale :: Float
menuHintScale = 0.18

menuHintColor :: Color
menuHintColor = makeColorI 200 215 230 255

playerWidth, playerHeight :: Float
playerWidth = 40
playerHeight = 50

playerStartY :: Float
playerStartY = 60

playerBaseX :: Float
playerBaseX = 220

steerRange :: Float
steerRange = 180

invBlinkHz :: Float
invBlinkHz = 12

moveSpeed :: Float
moveSpeed = 240

runSpeedEasy :: SpeedRule
runSpeedEasy = SpeedRule {speedBase = 180, speedGrowth = 1.2}

runSpeedNormal :: SpeedRule
runSpeedNormal = SpeedRule {speedBase = 220, speedGrowth = 1.6}

runSpeedHard :: SpeedRule
runSpeedHard = SpeedRule {speedBase = 260, speedGrowth = 2.1}

metersPerPixel :: Float
metersPerPixel = 0.1

gravity :: Float
gravity = 900

jumpVelocity :: Float
jumpVelocity = 360

playerSpritePxW, playerSpritePxH :: Float
playerSpritePxW = 320
playerSpritePxH = 320

playerRunFrameStep :: Float
playerRunFrameStep = 120

groundY :: Float
groundY = -170

groundHeight :: Float
groundHeight = 120

groundTopY :: Float
groundTopY = groundY + groundHeight / 2

groundColor :: Color
groundColor = makeColorI 80 160 80 255

markSpacing :: Float
markSpacing = 60

markColor :: Color
markColor = makeColorI 200 200 200 255

distanceColor :: Color
distanceColor = makeColorI 240 240 240 255

deathY :: Float
deathY = -260

maxLives :: Int
maxLives = 3

invincibilityDuration :: Float
invincibilityDuration = 2.0

chunkWidth :: Float
chunkWidth = 720

spawnAhead :: Float
spawnAhead = 1600

despawnBehind :: Float
despawnBehind = 800

holeWidth :: Float
holeWidth = 140

platformW, platformH, platformLift :: Float
platformW = 180
platformH = 18
platformLift = 50

platformEdgeInset :: Float
platformEdgeInset = 0

platformColor :: Color
platformColor = makeColorI 120 120 220 255

spikeW, spikeH :: Float
spikeW = 40
spikeH = 35

spikeColor :: Color
spikeColor = makeColorI 220 80 80 255

medkitW, medkitH, medkitLift :: Float
medkitW = 26
medkitH = 26
medkitLift = 70

medkitColor, medkitCrossColor :: Color
medkitColor = makeColorI 80 200 120 255
medkitCrossColor = makeColorI 240 240 240 255

bridgeChanceEasy :: Float
bridgeChanceEasy = 0.8

bridgeChanceNormal :: Float
bridgeChanceNormal = 0.65

bridgeChanceHard :: Float
bridgeChanceHard = 0.55

bridgeMinSpacing :: Float
bridgeMinSpacing = 220

bridgeMaxSpacing :: Float
bridgeMaxSpacing = 360

bridgeMinLen :: Float
bridgeMinLen = 160

bridgeMaxLen :: Float
bridgeMaxLen = 320

extraPlatformChance :: Float
extraPlatformChance = 0.22

gameOverTitleText :: String
gameOverTitleText = "GAME OVER"

gameOverTitleX :: Float
gameOverTitleX = -150

gameOverTitleY :: Float
gameOverTitleY = 80

gameOverTitleScale :: Float
gameOverTitleScale = 0.60

gameOverTitleColor :: Color
gameOverTitleColor = makeColorI 255 80 80 255

gameOverHintText :: String
gameOverHintText = "Backspace: menu  |  Enter: restart  |  Esc: exit"

gameOverHintX :: Float
gameOverHintX = -280

gameOverHintY :: Float
gameOverHintY = -40

gameOverHintScale :: Float
gameOverHintScale = 0.22

gameOverHintColor :: Color
gameOverHintColor = makeColorI 230 230 230 255

pauseTitleText :: String
pauseTitleText = "PAUSED"

pausePanelW :: Float
pausePanelW = 520

pausePanelH :: Float
pausePanelH = 380

pausePanelColor :: Color
pausePanelColor = makeColorI 0 0 0 150

pausePanelBorderColor :: Color
pausePanelBorderColor = makeColorI 200 255 0 255

pauseTitleScale :: Float
pauseTitleScale = 0.6

pauseTitleColor :: Color
pauseTitleColor = makeColorI 200 255 0 255

pauseItemScale :: Float
pauseItemScale = 0.35

pauseItemSelectedColor :: Color
pauseItemSelectedColor = makeColorI 200 255 0 255

pauseItemColor :: Color
pauseItemColor = makeColorI 240 240 240 255

pauseHintText :: String
pauseHintText = "Up/Down: choose  |  Enter: select  |  Q: menu  |  Esc: exit"

pauseHintScale :: Float
pauseHintScale = 0.20

pauseHintColor :: Color
pauseHintColor = makeColorI 200 200 200 255

pauseItem3Y :: Float
pauseItem3Y = -60

dbFileName :: FilePath
dbFileName = "game.db"

leaderboardLimit :: Int
leaderboardLimit = 10

defaultPlayerName :: String
defaultPlayerName = "Player"

playerNameMaxLen :: Int
playerNameMaxLen = 16

scoreSavedText :: String
scoreSavedText = "Score saved to leaderboard."

saveSlotsCount :: Int
saveSlotsCount = 3

defaultSaveSeed :: Int
defaultSaveSeed = 0
