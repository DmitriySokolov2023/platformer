module World
  ( Screen(..)
  , Difficulty(..)
  , InputState(..)
  , App(..)
  , initialApp
  , startPlaying
  , goTitle
  , goLeaderboard
  , stepWorld
  , menuMove
  , menuAdjustDifficulty
  , togglePause
  , pauseMove
  , pauseActivate
  , nameAddChar
  , nameBackspace
  , nameConfirm
  , menuStartIx
  , menuDifficultyIx
  , menuLeaderboardIx
  , menuLoadIx
  , menuExitIx
  , menuMaxIx
  , isSupported
  , goLoadGame
  , slotMove
  , requestSaveSlot
  , requestLoadSlot
  , applySaveRow
  ) where

import Config (GenConfig(..), SpeedRule(..), difficultyLevel)
import Data.Char (isAlphaNum, isAscii)
import Data.List (find)
import Database (ScoreRow, SaveRow(..))
import Game.Constants
import Generator (ensureChunks, generateChunk)
import Geometry
  ( Interval(..)
  , Rect(..)
  , intervalContains
  , rectIntersects
  , rectLeft
  , rectRight
  , rectTop
  )

data Screen
  = Title
  | Controls
  | Playing
  | Paused
  | GameOver
  | Leaderboard
  | LoadGame
  | SaveGame
  | NameEntry
  deriving (Eq, Show)

data Difficulty
  = Easy
  | Normal
  | Hard
  deriving (Eq, Show, Enum, Bounded)

data InputState = InputState
  { inputLeft :: Bool
  , inputRight :: Bool
  , inputJump :: Bool
  }
  deriving (Eq, Show)

resetInput :: InputState
resetInput =
  InputState
    { inputLeft = False
    , inputRight = False
    , inputJump = False
    }

data App = App
  { appScreen :: Screen
  , appDifficulty :: Difficulty
  , menuIx :: Int
  , pauseIx :: Int
  , appInput :: InputState
  , appShowDebug :: Bool
  , appConfig :: GenConfig
  , appDbPath :: FilePath
  , appLeaderboard :: [ScoreRow]
  , appPendingLbLoad :: Bool
  , appPendingScoreSave :: Bool
  , appNotice :: Maybe String
  , appPlayerName :: String
  , appNameInput :: String
  , appSlotIx :: Int
  , appSaves :: [SaveRow]
  , appPendingSavesLoad :: Bool
  , appPendingSaveSlot :: Maybe Int
  , appPendingLoadSlot :: Maybe Int
  , worldScroll :: Float
  , playerOffsetX :: Float
  , playerY :: Float
  , playerVY :: Float
  , playerLives :: Int
  , playerInvTimer :: Float
  , worldHoles :: [Interval]
  , worldPlatforms :: [Rect]
  , worldSpikes :: [Rect]
  , worldMedkits :: [Rect]
  , nextChunkIx :: Int
  , viewW :: Int
  , viewH :: Int
  }
  deriving (Eq, Show)

menuStartIx :: Int
menuStartIx = 0

menuDifficultyIx :: Int
menuDifficultyIx = 1

menuLeaderboardIx :: Int
menuLeaderboardIx = 2

menuLoadIx :: Int
menuLoadIx = 3

menuExitIx :: Int
menuExitIx = 4

menuMaxIx :: Int
menuMaxIx = 4

initialApp :: GenConfig -> FilePath -> App
initialApp cfg dbPath =
  App
    { appScreen = Title
    , appDifficulty = Normal
    , menuIx = menuStartIx
    , pauseIx = 0
    , appInput = resetInput
    , appShowDebug = False
    , appConfig = cfg
    , appDbPath = dbPath
    , appLeaderboard = []
    , appPendingLbLoad = False
    , appPendingScoreSave = False
    , appNotice = Nothing
    , appPlayerName = defaultPlayerName
    , appNameInput = defaultPlayerName
    , appSlotIx = 0
    , appSaves = []
    , appPendingSavesLoad = False
    , appPendingSaveSlot = Nothing
    , appPendingLoadSlot = Nothing
    , worldScroll = 0
    , playerOffsetX = 0
    , playerY = playerStartY
    , playerVY = 0
    , playerLives = maxLives
    , playerInvTimer = 0
    , worldHoles = []
    , worldPlatforms = []
    , worldSpikes = []
    , worldMedkits = []
    , nextChunkIx = 0
    , viewW = windowWidth
    , viewH = windowHeight
    }

resetKeepingViewAndDifficulty :: App -> App
resetKeepingViewAndDifficulty old =
  (initialApp (appConfig old) (appDbPath old))
    { viewW = viewW old
    , viewH = viewH old
    , appDifficulty = appDifficulty old
    , appShowDebug = appShowDebug old
    , appPlayerName = appPlayerName old
    , appNameInput = appPlayerName old
    }

startPlaying :: App -> App
startPlaying app =
  case appScreen app of
    Title -> (resetKeepingViewAndDifficulty app) {appScreen = Controls}
    Controls ->
      (resetKeepingViewAndDifficulty app)
        { appScreen = NameEntry
        , appNameInput = ""
        , appNotice = Nothing
        }
    NameEntry ->
      (resetKeepingViewAndDifficulty app)
        { appScreen = Playing
        }
    GameOver ->
      (resetKeepingViewAndDifficulty app)
        { appScreen = Playing
        }
    _ -> app

goTitle :: App -> App
goTitle app =
  (resetKeepingViewAndDifficulty app)
    { appScreen = Title
    }

goLeaderboard :: App -> App
goLeaderboard app =
  app
    { appScreen = Leaderboard
    , appPendingLbLoad = True
    , appNotice = Nothing
    }

goLoadGame :: App -> App
goLoadGame app =
  app
    { appScreen = LoadGame
    , appSlotIx = 0
    , appPendingSavesLoad = True
    , appNotice = Nothing
    }

goSaveGame :: App -> App
goSaveGame app =
  app
    { appScreen = SaveGame
    , appInput = resetInput
    , pauseIx = 0
    , appSlotIx = 0
    , appPendingSavesLoad = True
    , appNotice = Nothing
    }

slotMove :: Int -> App -> App
slotMove delta app =
  case appScreen app of
    LoadGame -> step
    SaveGame -> step
    _ -> app
  where
    step =
      app
        { appSlotIx =
            clampInt 0 (saveSlotsCount - 1) (appSlotIx app + delta)
        }

requestSaveSlot :: App -> App
requestSaveSlot app =
  case appScreen app of
    SaveGame ->
      app
        { appPendingSaveSlot = Just (appSlotIx app + 1)
        , appNotice = Nothing
        }
    _ -> app

requestLoadSlot :: App -> App
requestLoadSlot app =
  case appScreen app of
    LoadGame ->
      app
        { appPendingLoadSlot = Just (appSlotIx app + 1)
        , appNotice = Nothing
        }
    _ -> app

menuMove :: Int -> App -> App
menuMove delta app
  | appScreen app == Title =
      app {menuIx = clampInt 0 menuMaxIx (menuIx app + delta)}
  | otherwise =
      app

menuAdjustDifficulty :: Int -> App -> App
menuAdjustDifficulty delta app
  | appScreen app == Title && menuIx app == menuDifficultyIx =
      app {appDifficulty = stepDifficulty delta (appDifficulty app)}
  | otherwise =
      app

stepDifficulty :: Int -> Difficulty -> Difficulty
stepDifficulty delta d =
  toEnum ix
  where
    lo = fromEnum (minBound :: Difficulty)
    hi = fromEnum (maxBound :: Difficulty)
    n = hi - lo + 1
    cur = fromEnum d - lo
    ix = lo + ((cur + delta) `mod` n)

runSpeedFor :: GenConfig -> Difficulty -> Int -> Float
runSpeedFor cfg d lvl =
  max 0 (speedBase rule + speedGrowth rule * fromIntegral lvl)
  where
    rule =
      case d of
        Easy -> cfgEasySpeed cfg
        Normal -> cfgNormalSpeed cfg
        Hard -> cfgHardSpeed cfg

togglePause :: App -> App
togglePause app =
  case appScreen app of
    Playing ->
      app
        { appScreen = Paused
        , appInput = resetInput
        , pauseIx = 0
        }
    Paused ->
      app
        { appScreen = Playing
        , appInput = resetInput
        }
    _ -> app

pauseMove :: Int -> App -> App
pauseMove delta app =
  case appScreen app of
    Paused -> app {pauseIx = clampInt 0 2 (pauseIx app + delta)}
    _ -> app

pauseActivate :: App -> App
pauseActivate app =
  case appScreen app of
    Paused ->
      case pauseIx app of
        0 -> app {appScreen = Playing, appInput = resetInput}
        1 -> goSaveGame app
        _ -> goTitle app
    _ -> app

stepWorld :: Float -> App -> App
stepWorld dt app
  | appScreen app == Playing = stepPlaying dt app
  | otherwise = app

stepPlaying :: Float -> App -> App
stepPlaying dt app0 =
  if died
    then toGameOver app0
    else appFinal
  where
    scroll0 = worldScroll app0
    cfg = appConfig app0
    lvl = difficultyLevel cfg scroll0

    speed = runSpeedFor cfg (appDifficulty app0) lvl
    scroll1 = scroll0 + speed * dt

    holes0 = worldHoles app0
    plats0 = worldPlatforms app0
    spikes0 = worldSpikes app0
    meds0 = worldMedkits app0
    ix0 = nextChunkIx app0

    (ix1, holes1, plats1, spikes1, meds1) =
      ensureChunks cfg scroll1 ix0 holes0 plats0 spikes0 meds0

    holes2 = pruneHoles (scroll1 - despawnBehind) holes1
    plats2 = pruneRects (scroll1 - despawnBehind) plats1
    spikes2 = pruneRects (scroll1 - despawnBehind) spikes1
    meds2 = pruneRects (scroll1 - despawnBehind) meds1

    inp0 = appInput app0
    left = inputLeft inp0
    right = inputRight inp0
    jumpNow = inputJump inp0

    xOff0 = playerOffsetX app0
    xOff1 =
      clampFloat (-steerRange) steerRange
        ( xOff0
            + (if right then 1 else 0)
            - (if left then 1 else 0)
            * moveSpeed
            * dt
        )

    pxWorld = playerBaseX + scroll1 + xOff1
    vy0 = playerVY app0
    y0 = playerY app0

    inv0 = playerInvTimer app0
    inv1 = max 0 (inv0 - dt)

    (vy1, y0a) =
      if jumpNow && isSupported pxWorld y0 plats2 holes2
        then (jumpVelocity, y0)
        else (vy0, y0)

    inp1 =
      if jumpNow
        then inp0 {inputJump = False}
        else inp0

    vy2 = vy1 - gravity * dt
    y1 = y0a + vy2 * dt

    (y2, vy3) = resolvePlatforms pxWorld y0a y1 vy2 plats2

    (y3, vy4) =
      if isOverHole pxWorld holes2
        then (y2, vy3)
        else
          if y2 < deathY
            then (y2, vy3)
            else applyGroundCollision y2 vy3

    (lives1, inv2) = applySpikeDamage inv1 (playerLives app0) pxWorld y3 spikes2

    medRects = pickupRects meds2
    pickedMed = any (rectIntersects (playerRect pxWorld y3)) medRects

    lives2 =
      if pickedMed
        then min maxLives (lives1 + 1)
        else lives1

    meds3 =
      if pickedMed
        then filter (not . rectIntersects (playerRect pxWorld y3)) meds2
        else meds2

    died = lives2 <= 0

    appFinal =
      app0
        { worldScroll = scroll1
        , playerOffsetX = xOff1
        , playerY = y3
        , playerVY = vy4
        , appInput = inp1
        , playerInvTimer = inv2
        , playerLives = lives2
        , worldHoles = holes2
        , worldPlatforms = plats2
        , worldSpikes = spikes2
        , worldMedkits = meds3
        , nextChunkIx = ix1
        }

toGameOver :: App -> App
toGameOver app =
  app
    { appScreen = GameOver
    , appInput = resetInput
    , appPendingScoreSave = True
    , appNotice = Nothing
    }

playerRect :: Float -> Float -> Rect
playerRect px py =
  Rect
    { rectX = px
    , rectY = py
    , rectW = playerWidth
    , rectH = playerHeight
    }

pickupRects :: [Rect] -> [Rect]
pickupRects = id

applySpikeDamage :: Float -> Int -> Float -> Float -> [Rect] -> (Int, Float)
applySpikeDamage inv lives px py spikes =
  if inv > 0
    then (lives, inv)
    else
      if hitSpike (playerRect px py) spikes
        then (lives - 1, invincibilityDuration)
        else (lives, 0)

hitSpike :: Rect -> [Rect] -> Bool
hitSpike pr spikes =
  any (rectIntersects pr) spikes

isOverHole :: Float -> [Interval] -> Bool
isOverHole px holes =
  any (intervalContains px) holes

isSupported :: Float -> Float -> [Rect] -> [Interval] -> Bool
isSupported px py plats holes =
  isOnGround px py holes || isOnPlatform px py plats

isOnGround :: Float -> Float -> [Interval] -> Bool
isOnGround px py holes =
  py <= groundY + 0.5 && not (isOverHole px holes)

isOnPlatform :: Float -> Float -> [Rect] -> Bool
isOnPlatform px py plats =
  any (playerFullyInside px py) plats

applyGroundCollision :: Float -> Float -> (Float, Float)
applyGroundCollision y vy =
  if y < groundY
    then (groundY, 0)
    else (y, vy)

resolvePlatforms :: Float -> Float -> Float -> Float -> [Rect] -> (Float, Float)
resolvePlatforms px y0 y1 vy plats =
  case find (playerFullyInside px y1) plats of
    Nothing -> (y1, vy)
    Just p ->
      let top = rectTop p + platformEdgeInset
       in if y0 >= top
            then (top, 0)
            else (y1, vy)

playerFullyInside :: Float -> Float -> Rect -> Bool
playerFullyInside px py r =
  px > rectLeft r + platformEdgeInset
    && px < rectRight r - platformEdgeInset
    && py <= rectTop r + 0.5
    && py >= rectTop r - 15

pruneHoles :: Float -> [Interval] -> [Interval]
pruneHoles minX holes =
  filter (\(Interval a b) -> b > minX) holes

pruneRects :: Float -> [Rect] -> [Rect]
pruneRects minX rs =
  filter (\r -> rectRight r > minX) rs

clampInt :: Int -> Int -> Int -> Int
clampInt lo hi x
  | x < lo = lo
  | x > hi = hi
  | otherwise = x

clampFloat :: Float -> Float -> Float -> Float
clampFloat lo hi x
  | x < lo = lo
  | x > hi = hi
  | otherwise = x

applySaveRow :: SaveRow -> App -> Either String App
applySaveRow row old = do
  let new =
        (resetKeepingViewAndDifficulty old)
          { appScreen = Playing
          , appNotice = Nothing
          , appInput = resetInput
          , worldScroll = saveWorldScroll row
          , playerLives = saveLives row
          , nextChunkIx = 0
          , worldHoles = []
          , worldPlatforms = []
          , worldSpikes = []
          , worldMedkits = []
          }
  let (hs, ps, ss, ms) = generateChunk (appConfig old) 0
  pure
    new
      { worldHoles = hs
      , worldPlatforms = ps
      , worldSpikes = ss
      , worldMedkits = ms
      }

nameAddChar :: Char -> App -> App
nameAddChar c app
  | appScreen app /= NameEntry = app
  | not (isAllowedNameChar c) = app
  | length (appNameInput app) >= playerNameMaxLen = app
  | otherwise =
      app {appNameInput = appNameInput app ++ [c]}

nameBackspace :: App -> App
nameBackspace app
  | appScreen app /= NameEntry = app
  | null (appNameInput app) = app
  | otherwise =
      app {appNameInput = init (appNameInput app)}

nameConfirm :: App -> App
nameConfirm app
  | appScreen app /= NameEntry = app
  | otherwise =
      app
        { appPlayerName = finalName
        , appNameInput = finalName
        , appScreen = Playing
        , appInput = resetInput
        , appNotice = Nothing
        }
  where
    trimmed = trimSpaces (appNameInput app)
    finalName =
      if null trimmed then defaultPlayerName else trimmed

isAllowedNameChar :: Char -> Bool
isAllowedNameChar c =
  isAscii c
    && (isAlphaNum c || c == ' ' || c == '_' || c == '-')

trimSpaces :: String -> String
trimSpaces = dropWhile (== ' ') . dropWhileEndSpace

dropWhileEndSpace :: String -> String
dropWhileEndSpace s =
  reverse (dropWhile (== ' ') (reverse s))
