module Render (drawAppIO) where

import Assets (Assets (..))
import Data.List (sortOn)
import Game.Constants
import Geometry
  ( Interval (..)
  , Rect (..)
  , intervalContains
  , intervalOverlaps
  , rectBottom
  , rectLeft
  , rectRight
  , rectTop
  )
import Graphics.Gloss
import World (App (..), Screen (..))

drawAppIO :: Assets -> App -> IO Picture
drawAppIO assets app = pure (drawApp assets app)

drawApp :: Assets -> App -> Picture
drawApp assets app =
  case appScreen app of
    Title -> drawMenu app
    Controls -> drawControls app
    Playing -> drawPlaying assets app
    Paused -> drawPaused assets app
    Leaderboard -> drawStub app "Leaderboard" "Not implemented yet."
    LoadGame -> drawStub app "Load Game" "Not implemented yet."
    GameOver -> drawGameOver assets app

drawMenu :: App -> Picture
drawMenu app =
  pictures
    [ translate titleX titleY
        $ scale titleScale titleScale
        $ color titleColor
        $ Text titleText
    , drawMenuItem app 0 "Start Game" menuItemY0
    , drawMenuItem app 1 ("Difficulty: " ++ show (appDifficulty app)) menuItemY1
    , drawMenuItem app 2 "Leaderboard" menuItemY2
    , drawMenuItem app 3 "Load Game" menuItemY3
    , drawMenuItem app 4 "Exit" menuItemY4
    , translate menuHintX menuHintY
        $ scale menuHintScale menuHintScale
        $ color menuHintColor
        $ Text menuHintText
    ]

drawMenuItem :: App -> Int -> String -> Float -> Picture
drawMenuItem app ix label y =
  translate menuItemX y
    $ scale menuItemScale menuItemScale
    $ color (menuItemColorBy app ix)
    $ Text label

menuItemColorBy :: App -> Int -> Color
menuItemColorBy app ix =
  if menuIx app == ix then menuSelectedColor else menuItemColor

drawStub :: App -> String -> String -> Picture
drawStub app title msg =
  pictures
    [ translate (-240) 80
        $ scale 0.45 0.45
        $ color (makeColorI 240 240 240 255)
        $ Text title
    , translate (-320) 10
        $ scale 0.22 0.22
        $ color (makeColorI 220 220 220 255)
        $ Text msg
    , translate (-420) (-100)
        $ scale 0.20 0.20
        $ color (makeColorI 200 200 200 255)
        $ Text "Backspace: menu  |  P: pause only in game  |  Esc: exit"
    , drawExitTopRight app
    ]

drawControls :: App -> Picture
drawControls app =
  pictures
    [ translate (-160) 80
        $ scale 0.45 0.45
        $ color (makeColorI 240 240 240 255)
        $ Text "Controls"
    , translate (-420) 10
        $ scale 0.20 0.20
        $ color (makeColorI 230 230 230 255)
        $ Text "A/D or Left/Right: steer"
    , translate (-420) (-20)
        $ scale 0.20 0.20
        $ color (makeColorI 230 230 230 255)
        $ Text "Space/W/Up: jump"
    , translate (-420) (-50)
        $ scale 0.20 0.20
        $ color (makeColorI 230 230 230 255)
        $ Text "P: pause"
    , translate (-420) (-100)
        $ scale 0.20 0.20
        $ color (makeColorI 200 200 200 255)
        $ Text "Enter: start  |  Backspace: menu  |  Esc: exit"
    , drawExitTopRight app
    ]

drawPlaying :: Assets -> App -> Picture
drawPlaying assets app =
  pictures
    [ drawWorld assets app
    , drawHudPlaying app
    ]

drawPaused :: Assets -> App -> Picture
drawPaused assets app =
  pictures
    [ drawWorld assets app
    , drawHudPlaying app
    , drawOverlay app
    , drawPauseMenu app
    ]

drawGameOver :: Assets -> App -> Picture
drawGameOver assets app =
  pictures
    [ drawWorld assets app
    , drawOverlay app
    , drawGameOverText app
    ]

drawWorld :: Assets -> App -> Picture
drawWorld assets app =
  translate (-cameraX) 0 $
    pictures
      [ drawGroundWithHoles app cameraX holes
      , drawGroundMarks app cameraX holes
      , drawPlatforms plats
      , drawSpikes spikes
      , drawMedkits meds
      , drawPlayer assets app
      ]
  where
    cameraX = worldScroll app - playerBaseX
    holes = worldHoles app
    plats = worldPlatforms app
    spikes = worldSpikes app
    meds = worldMedkits app

drawHudPlaying :: App -> Picture
drawHudPlaying app =
  pictures
    [ drawDistanceTopLeft app
    , drawLivesBelowDistance app
    , drawExitTopRight app
    ]

drawOverlay :: App -> Picture
drawOverlay app =
  color (makeColorI 0 0 0 140) $
    rectangleSolid (fromIntegral (viewW app)) (fromIntegral (viewH app))

drawPauseMenu :: App -> Picture
drawPauseMenu app =
  pictures
    [ translate 0 0 $
        pictures
          [ color pausePanelColor $ rectangleSolid pausePanelW pausePanelH
          , color pausePanelBorderColor $ rectangleWire pausePanelW pausePanelH
          ]
    , translate pauseTitleX pauseTitleY
        $ scale pauseTitleScale pauseTitleScale
        $ color pauseTitleColor
        $ Text pauseTitleText
    , drawPauseItem app 0 "Resume" pauseItem1Y
    , drawPauseItem app 1 "Quit to Title" pauseItem2Y
    , translate pauseHintX pauseHintY
        $ scale pauseHintScale pauseHintScale
        $ color pauseHintColor
        $ Text pauseHintText
    ]

drawPauseItem :: App -> Int -> String -> Float -> Picture
drawPauseItem app ix label y =
  translate pauseItemX y $
    scale pauseItemScale pauseItemScale $
      color (pauseItemClr app ix) $
        Text label

pauseItemClr :: App -> Int -> Color
pauseItemClr app ix =
  if pauseIx app == ix then pauseItemSelectedColor else pauseItemColor

pauseTitleX :: Float
pauseTitleX = -90

pauseTitleY :: Float
pauseTitleY = 55

pauseItemX :: Float
pauseItemX = -150

pauseItem1Y :: Float
pauseItem1Y = 10

pauseItem2Y :: Float
pauseItem2Y = -28

pauseHintX :: Float
pauseHintX = -250

pauseHintY :: Float
pauseHintY = -78

-- ===== Existing HUD/world drawing (unchanged) =====

drawGameOverText :: App -> Picture
drawGameOverText app =
  pictures
    [ translate gameOverTitleX gameOverTitleY
        $ scale gameOverTitleScale gameOverTitleScale
        $ color gameOverTitleColor
        $ Text gameOverTitleText
    , translate (-260) (gameOverTitleY - 70)
        $ scale 0.22 0.22
        $ color distanceColor
        $ Text ("Distance: " ++ show meters ++ " m")
    , translate gameOverHintX gameOverHintY
        $ scale gameOverHintScale gameOverHintScale
        $ color gameOverHintColor
        $ Text gameOverHintText
    ]
  where
    meters = floor (worldScroll app * metersPerPixel) :: Int

drawDistanceTopLeft :: App -> Picture
drawDistanceTopLeft app =
  translate (screenLeft app + 10) (screenTop app - 30) $
    scale 0.20 0.20 $
      color distanceColor $
        Text ("Distance: " ++ show meters ++ " m")
  where
    meters = floor (worldScroll app * metersPerPixel) :: Int

drawLivesBelowDistance :: App -> Picture
drawLivesBelowDistance app =
  pictures [drawHeart i | i <- [1 .. maxLives]]
  where
    baseX = screenLeft app + 20
    baseY = screenTop app - 65

    drawHeart i =
      translate (baseX + dx i) baseY $
        color (heartColor i) $
          rectangleSolid heartW heartH

    dx i = fromIntegral (i - 1) * heartSpacing

    heartColor i =
      if i <= playerLives app
        then heartFullColor
        else heartEmptyColor

drawExitTopRight :: App -> Picture
drawExitTopRight app =
  translate (screenRight app - 60) (screenTop app - 30) $
    scale 0.20 0.20 $
      color (makeColorI 240 240 240 255) $
        Text "Exit"

drawGroundWithHoles :: App -> Float -> [Interval] -> Picture
drawGroundWithHoles app cameraX holes =
  pictures (map drawSeg segs)
  where
    (leftX, rightX) = visibleRange app cameraX
    hs =
      sortOn intA $
        filter (intervalOverlaps leftX rightX) holes
    segs = buildSegments leftX rightX hs

drawSeg :: (Float, Float) -> Picture
drawSeg (x1, x2) =
  translate cx groundY $
    color groundColor $
      rectangleSolid w groundHeight
  where
    w = x2 - x1
    cx = (x1 + x2) / 2

buildSegments :: Float -> Float -> [Interval] -> [(Float, Float)]
buildSegments leftX rightX holes =
  go leftX holes
  where
    go cursor [] =
      if cursor < rightX then [(cursor, rightX)] else []
    go cursor (h : hs)
      | intA h >= rightX = if cursor < rightX then [(cursor, rightX)] else []
      | intB h <= cursor = go cursor hs
      | otherwise =
          let segEnd = min (intA h) rightX
              cursor' = max cursor (intB h)
              segsHere = if cursor < segEnd then [(cursor, segEnd)] else []
           in segsHere ++ go cursor' hs

drawGroundMarks :: App -> Float -> [Interval] -> Picture
drawGroundMarks app cameraX holes =
  pictures [drawMark x | x <- marks, not (isInHole x holes)]
  where
    (leftX, rightX) = visibleRange app cameraX
    k0 = floor (leftX / markSpacing) :: Int
    k1 = ceiling (rightX / markSpacing) :: Int
    marks = [fromIntegral k * markSpacing | k <- [k0 .. k1]]

isInHole :: Float -> [Interval] -> Bool
isInHole x holes = any (intervalContains x) holes

drawMark :: Float -> Picture
drawMark x =
  translate x (groundY + groundHeight / 2 - markH / 2) $
    color markColor $
      rectangleSolid markW markH
  where
    markW = 10
    markH = 8

drawPlatforms :: [Rect] -> Picture
drawPlatforms plats =
  pictures (map drawPlat plats)
  where
    drawPlat r =
      translate (rectX r) (rectY r) $
        color platformColor $
          rectangleSolid (rectW r) (rectH r)

drawSpikes :: [Rect] -> Picture
drawSpikes spikes =
  pictures (map drawSpike spikes)

drawSpike :: Rect -> Picture
drawSpike r =
  color spikeColor $
    polygon
      [ (rectLeft r, rectBottom r)
      , (rectRight r, rectBottom r)
      , (rectX r, rectTop r)
      ]

drawMedkits :: [Rect] -> Picture
drawMedkits meds =
  pictures (map drawMedkit meds)

drawMedkit :: Rect -> Picture
drawMedkit r =
  translate (rectX r) (rectY r) $
    pictures
      [ color medkitColor $ rectangleSolid w h
      , color medkitCrossColor $ rectangleSolid (w * 0.65) (h * 0.18)
      , color medkitCrossColor $ rectangleSolid (w * 0.18) (h * 0.65)
      ]
  where
    w = rectW r
    h = rectH r

drawPlayer :: Assets -> App -> Picture
drawPlayer assets app =
  translate px (playerY app) $
    scale s s $
      color (makeColorI 255 255 255 alpha) playerPic
  where
    px = worldScroll app + playerOffsetX app
    s = spriteScale
    playerPic =
      if playerIsInAir app
        then assetsPlayerJump assets
        else pickRunFrame assets app

    alpha =
      if playerInvTimer app > 0 && blinkOff (playerInvTimer app)
        then 120
        else 255

spriteScale :: Float
spriteScale =
  min (playerWidth / playerSpritePxW) (playerHeight / playerSpritePxH)

pickRunFrame :: Assets -> App -> Picture
pickRunFrame assets app =
  assetsPlayerRun assets !! ix
  where
    n = length (assetsPlayerRun assets)
    ix = (floor (worldScroll app / playerRunFrameStep) :: Int) `mod` n

blinkOff :: Float -> Bool
blinkOff inv =
  odd (floor (inv * invBlinkHz) :: Int)

playerIsInAir :: App -> Bool
playerIsInAir app =
  playerVY app /= 0 || (playerY app - playerHeight / 2) > groundTopY + 0.01

visibleRange :: App -> Float -> (Float, Float)
visibleRange app cameraX =
  (cameraX - halfW - margin, cameraX + halfW + margin)
  where
    halfW = fromIntegral (viewW app) / 2
    margin = 200

screenLeft :: App -> Float
screenLeft app = -fromIntegral (viewW app) / 2

screenRight :: App -> Float
screenRight app = fromIntegral (viewW app) / 2

screenTop :: App -> Float
screenTop app = fromIntegral (viewH app) / 2