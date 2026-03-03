{-# LANGUAGE OverloadedStrings #-}

module Render (drawAppIO) where

import Assets (Assets (..))
import Config (GenConfig (..), SpeedRule (..), difficultyLevel, objectChance)
import Data.List (find, sortOn)
import Game.Constants hiding (pauseItem3Y)
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
import World (App (..), Difficulty (..), Screen (..), isSupported)
import Database (ScoreRow(..), SaveRow(..))

txt :: Float -> Float -> Float -> Color -> String -> Picture
txt x y s clr str =
  translate x y
    $ scale s s
    $ color clr
    $ Text str

drawAppIO :: Assets -> App -> IO Picture
drawAppIO assets app = pure (drawApp assets app)

drawApp :: Assets -> App -> Picture
drawApp assets app =
  case appScreen app of
    Title -> drawMenu app
    Controls -> drawControls app
    Playing -> drawPlaying assets app
    Paused -> drawPaused assets app
    Leaderboard -> drawLeaderboard app
    LoadGame -> drawLoadGame app
    GameOver -> drawGameOver assets app
    NameEntry -> drawNameEntry app
    SaveGame -> drawSaveGame app

drawMenu :: App -> Picture
drawMenu app =
  pictures
    [ txt titleX titleY titleScale titleColor titleText
    , drawMenuItem app 0 "START" menuItemY0
    , drawMenuItem app 1 ("LEVEL: " ++ show (appDifficulty app)) menuItemY1
    , drawMenuItem app 2 "TOP" menuItemY2
    , drawMenuItem app 3 "Load Game" menuItemY3
    , drawMenuItem app 4 "Exit" menuItemY4
    , txt menuHintX menuHintY menuHintScale menuHintColor menuHintText
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

drawControls :: App -> Picture
drawControls app =
  pictures
    [ txt (-160) 80 0.45 (makeColorI 240 240 240 255) "Controls"
    , txt (-420) 10 0.20 (makeColorI 230 230 230 255) "A/D or Left/Right: steer"
    , txt (-420) (-20) 0.20 (makeColorI 230 230 230 255) "Space/W/Up: jump"
    , txt (-420) (-50) 0.20 (makeColorI 230 230 230 255) "P: pause"
    , txt (-420) (-80) 0.20 (makeColorI 230 230 230 255) "T: debug overlay"
    , txt (-420) (-130) 0.20 (makeColorI 200 200 200 255) "Enter: continue  |  Q: menu  |  Esc: exit"
    , drawExitTopRight app
    ]

drawPlaying :: Assets -> App -> Picture
drawPlaying assets app =
  pictures
    [ drawWorld assets app
    , drawHudPlaying app
    , drawNotice app (-420) (-210)
    ]

drawPaused :: Assets -> App -> Picture
drawPaused assets app =
  pictures
    [ drawWorld assets app
    , drawOverlay app
    , drawPauseMenu app
    , drawNotice app (-260) (pauseTitleY - 160)
    , drawExitTopRight app
    ]

drawGameOver :: Assets -> App -> Picture
drawGameOver assets app =
  pictures
    [ drawWorld assets app
    , drawOverlay app
    , drawGameOverText app
    , drawNotice app (-260) (gameOverTitleY - 105)
    ]

drawWorld :: Assets -> App -> Picture
drawWorld assets app =
  translate (-cameraX) 0
    $ pictures
      [ drawGroundWithHoles app cameraX holes
      , drawGroundMarks app cameraX holes
      , drawPlatforms app cameraX plats
      , drawSpikes app cameraX spikes
      , drawMedkits app cameraX meds
      , drawPlayer assets app cameraX
      ]
  where
    cameraX = worldScroll app
    holes = worldHoles app
    plats = worldPlatforms app
    spikes = worldSpikes app
    meds = worldMedkits app

drawHudPlaying :: App -> Picture
drawHudPlaying app =
  pictures
    [ drawDistanceTopLeft app
    , drawLivesBelowDistance app
    , if appShowDebug app then drawDebugBelowLives app else Blank
    ]

drawOverlay :: App -> Picture
drawOverlay app =
  translate (-cameraX) 0
    $ color (makeColorI 0 0 0 120)
    $ rectangleSolid (fromIntegral (viewW app)) (fromIntegral (viewH app))
  where
    cameraX = worldScroll app

drawPauseMenu :: App -> Picture
drawPauseMenu app =
  pictures
    [ drawPausePanel
    , translate pauseTitleX pauseTitleY
        $ scale pauseTitleScale pauseTitleScale
        $ color pauseTitleColor
        $ Text pauseTitleText
    , drawPauseItem app 0 "Resume" pauseItem1Y
    , drawPauseItem app 1 "Save Game" pauseItem2Y
    , drawPauseItem app 2 "Menu" pauseItem3Y
    , translate pauseHintX pauseHintY
        $ scale pauseHintScale pauseHintScale
        $ color pauseHintColor
        $ Text pauseHintText
    ]
  where
    drawPausePanel =
      pictures
        [ color pausePanelColor
            $ rectangleSolid pausePanelW pausePanelH
        , color pausePanelBorderColor
            $ rectangleWire pausePanelW pausePanelH
        ]

drawPauseItem :: App -> Int -> String -> Float -> Picture
drawPauseItem app ix label y =
  translate pauseItemX y
    $ scale pauseItemScale pauseItemScale
    $ color (pauseItemClr app ix)
    $ Text label

pauseItemClr :: App -> Int -> Color
pauseItemClr app ix =
  if pauseIx app == ix then pauseItemSelectedColor else pauseItemColor

pauseTitleX :: Float
pauseTitleX = -70

pauseTitleY :: Float
pauseTitleY = 90

pauseItemX :: Float
pauseItemX = -70

pauseItem1Y :: Float
pauseItem1Y = 20

pauseItem2Y :: Float
pauseItem2Y = -20

pauseItem3Y :: Float
pauseItem3Y = -60

pauseHintX :: Float
pauseHintX = -260

pauseHintY :: Float
pauseHintY = -120

drawGameOverText :: App -> Picture
drawGameOverText app =
  pictures
    [ translate gameOverTitleX gameOverTitleY
        $ scale gameOverTitleScale gameOverTitleScale
        $ color gameOverTitleColor
        $ Text gameOverTitleText
    , translate gameOverHintX gameOverHintY
        $ scale gameOverHintScale gameOverHintScale
        $ color gameOverHintColor
        $ Text gameOverHintText
    , translate (-260) (gameOverHintY - 60)
        $ scale 0.20 0.20
        $ color (makeColorI 200 200 200 255)
        $ Text ("Distance: " ++ show meters ++ " m")
    ]
  where
    meters = floor (worldScroll app * metersPerPixel) :: Int

drawDistanceTopLeft :: App -> Picture
drawDistanceTopLeft app =
  translate (-460) 220
    $ scale 0.22 0.22
    $ color distanceColor
    $ Text ("Distance: " ++ show meters ++ " m")
  where
    meters = floor (worldScroll app * metersPerPixel) :: Int

drawLivesBelowDistance :: App -> Picture
drawLivesBelowDistance app =
  translate (-460) 190
    $ scale 0.22 0.22
    $ color (makeColorI 240 240 240 255)
    $ Text ("Lives: " ++ show (playerLives app))

drawDebugBelowLives :: App -> Picture
drawDebugBelowLives app =
  translate (-460) 130
    $ scale 0.14 0.14
    $ color (makeColorI 255 255 0 255)
    $ Text (unlines (debugLines app))

debugLines :: App -> [String]
debugLines app =
  [ "difficulty: " ++ show lvl
  , "speed: " ++ show1 speed
  , "platforms: " ++ show (length (worldPlatforms app))
  , "holes: " ++ show (length (worldHoles app))
  , "spikes: " ++ show (length (worldSpikes app))
  , "medkits: " ++ show (length (worldMedkits app))
  , "inv: " ++ show1 (playerInvTimer app)
  ]
  where
    cfg = appConfig app
    lvl = difficultyLevel cfg (worldScroll app)
    speed = speedAtLevel cfg (appDifficulty app) lvl

speedAtLevel :: GenConfig -> Difficulty -> Int -> Float
speedAtLevel cfg d lvl =
  max 0 (speedBase rule + speedGrowth rule * fromIntegral lvl)
  where
    rule =
      case d of
        Easy -> cfgEasySpeed cfg
        Normal -> cfgNormalSpeed cfg
        Hard -> cfgHardSpeed cfg

show1 :: Float -> String
show1 x = pct (fromIntegral (round (x * 10)) / 10)

pct :: Float -> String
pct x =
  if x == fromIntegral (round x)
    then show (round x :: Int)
    else show x

drawGroundWithHoles :: App -> Float -> [Interval] -> Picture
drawGroundWithHoles app cameraX holes =
  pictures
    [ translate x groundY
        $ color groundColor
        $ rectangleSolid w groundHeight
    | let w = fromIntegral (viewW app) + 400
    , let x = cameraX + w / 2
    , null holes
    ]
    <> pictures
      [ pictures
          [ translate (x1 + w1 / 2) groundY
              $ color groundColor
              $ rectangleSolid w1 groundHeight
          , translate (x2 + w2 / 2) groundY
              $ color groundColor
              $ rectangleSolid w2 groundHeight
          ]
      | Interval a b <- holes
      , let x0 = cameraX - 200
      , let x3 = cameraX + fromIntegral (viewW app) + 200
      , let x1 = x0
      , let w1 = max 0 (a - x0)
      , let x2 = b
      , let w2 = max 0 (x3 - b)
      ]

drawGroundMarks :: App -> Float -> [Interval] -> Picture
drawGroundMarks app cameraX holes =
  pictures
    [ translate x (groundY + groundHeight / 2)
        $ color markColor
        $ rectangleSolid 3 groundHeight
    | i <- [0 .. n]
    , let x = cameraX - 200 + fromIntegral i * markSpacing
    , not (any (intervalContains x) holes)
    ]
  where
    n = floor ((fromIntegral (viewW app) + 400) / markSpacing) :: Int

drawPlatforms :: App -> Float -> [Rect] -> Picture
drawPlatforms _ _ plats =
  pictures
    [ translate (rectX r) (rectY r)
        $ color platformColor
        $ rectangleSolid (rectW r) (rectH r)
    | r <- plats
    ]

drawSpikes :: App -> Float -> [Rect] -> Picture
drawSpikes _ _ spikes =
  pictures
    [ translate (rectX r) (rectY r)
        $ color spikeColor
        $ rectangleSolid (rectW r) (rectH r)
    | r <- spikes
    ]

drawMedkits :: App -> Float -> [Rect] -> Picture
drawMedkits _ _ meds =
  pictures
    [ pictures
        [ translate (rectX r) (rectY r)
            $ color medkitColor
            $ rectangleSolid (rectW r) (rectH r)
        , translate (rectX r) (rectY r)
            $ color medkitCrossColor
            $ pictures
              [ rectangleSolid 4 (rectH r * 0.7)
              , rectangleSolid (rectW r * 0.7) 4
              ]
        ]
    | r <- meds
    ]

drawPlayer :: Assets -> App -> Float -> Picture
drawPlayer assets app cameraX =
  translate px py
    $ scale s s
    $ playerPic
  where
    px = cameraX + playerBaseX + playerOffsetX app
    py = playerY app + playerHeight / 2
    s = playerWidth / playerSpritePxW
    onGround =
      isSupported
        (cameraX + playerBaseX + playerOffsetX app)
        (playerY app)
        (worldPlatforms app)
        (worldHoles app)
    frameIx =
      floor (worldScroll app / playerRunFrameStep)
        `mod` length (assetsPlayerRun assets)

    blink =
      playerInvTimer app > 0
        && floor (playerInvTimer app * invBlinkHz) `mod` 2 == 0

    playerPic
      | blink = Blank
      | onGround = assetsPlayerRun assets !! frameIx
      | otherwise = assetsPlayerJump assets

drawExitTopRight :: App -> Picture
drawExitTopRight app =
  translate (x0 - 120) (y0 - 30)
    $ scale 0.18 0.18
    $ color (makeColorI 220 220 220 255)
    $ Text "Esc: exit"
  where
    x0 = fromIntegral (viewW app) / 2
    y0 = fromIntegral (viewH app) / 2

drawLoadGame :: App -> Picture
drawLoadGame app =
  pictures
    [ translate (-220) 120
        $ scale 0.45 0.45
        $ color (makeColorI 240 240 240 255)
        $ Text "Load Game"
    , translate (-420) 82
        $ scale 0.20 0.20
        $ color (makeColorI 200 200 200 255)
        $ Text "Up/Down: slot  |  Enter: load  |  Backspace: back"
    , drawSaveSlots app
    , drawNotice app (-420) (-180)
    , drawExitTopRight app
    ]

drawSaveGame :: App -> Picture
drawSaveGame app =
  pictures
    [ translate (-220) 120
        $ scale 0.45 0.45
        $ color (makeColorI 240 240 240 255)
        $ Text "Save Game"
    , translate (-420) 82
        $ scale 0.20 0.20
        $ color (makeColorI 200 200 200 255)
        $ Text "Up/Down: slot  |  Enter: save  |  Backspace: back"
    , drawSaveSlots app
    , drawNotice app (-420) (-180)
    , drawExitTopRight app
    ]

drawSaveSlots :: App -> Picture
drawSaveSlots app =
  pictures
    [ drawSlotLine i
    | i <- [0 .. saveSlotsCount - 1]
    ]
  where
    drawSlotLine i =
      translate (-420) (y0 - dy * fromIntegral i)
        $ scale 0.20 0.20
        $ color
          ( if appSlotIx app == i
              then makeColorI 200 255 0 255
              else makeColorI 230 230 230 255
          )
        $ Text (formatSlot i)

    y0 = 40
    dy = 35

    formatSlot i =
      case find (\r -> saveSlot r == i + 1) (appSaves app) of
        Nothing -> "Slot " ++ show (i + 1) ++ ": (empty)"
        Just r ->
          "Slot "
            ++ show (i + 1)
            ++ ": "
            ++ show meters
            ++ "m  lives "
            ++ show (saveLives r)
            ++ "  "
            ++ saveCreatedAt r
          where
            meters = floor (saveWorldScroll r * metersPerPixel) :: Int

drawLeaderboard :: App -> Picture
drawLeaderboard app =
  pictures
    [ translate (-180) 120
        $ scale 0.45 0.45
        $ color (makeColorI 200 255 0 255)
        $ Text "Leaderboard"
    , translate (-420) 60
        $ scale 0.20 0.20
        $ color (makeColorI 200 255 0 255)
        $ Text "Top 10 (Backspace: menu)"
    , drawLeaderboardRows app
    , drawNotice app (-420) (-180)
    , drawExitTopRight app
    ]

drawLeaderboardRows :: App -> Picture
drawLeaderboardRows app =
  pictures
    [ translate (-420) (y0 - dy * fromIntegral i - 30)
        $ scale 0.18 0.18
        $ color (makeColorI 230 230 230 255)
        $ Text (formatRow (i + 1) row)
    | (i, row) <- zip [0 :: Int ..] (appLeaderboard app)
    ]
  where
    y0 = 50
    dy = 22

    formatRow rank row =
      show rank
        ++ ". "
        ++ scorePlayerName row
        ++ "  "
        ++ show (scoreDistance row)
        ++ "m  "
        ++ scoreDifficulty row
        ++ "  "
        ++ scoreCreatedAt row

drawNotice :: App -> Float -> Float -> Picture
drawNotice app x y =
  case appNotice app of
    Nothing -> Blank
    Just msg ->
      translate x y
        $ scale 0.16 0.16
        $ color (makeColorI 255 200 200 255)
        $ Text msg

drawNameEntry :: App -> Picture
drawNameEntry app =
  pictures
    [ txt (-220) 110 0.42 (makeColorI 240 240 240 255) "Enter Name"
    , txt (-420) 50 0.20 (makeColorI 220 220 220 255)
        ("Max " ++ show playerNameMaxLen ++ " chars. Allowed: A-Z 0-9 space _ -")
    , txt (-420) 10 0.28 (makeColorI 255 255 255 255) (appNameInput app ++ "_")
    , txt (-420) (-60) 0.20 (makeColorI 200 200 200 255)
        "Type to edit  |  Backspace: delete  |  Enter: start  |  Q: menu"
    , drawExitTopRight app
    ]
