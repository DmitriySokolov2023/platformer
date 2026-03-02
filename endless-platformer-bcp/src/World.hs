module World
  ( Screen (..)
  , Difficulty (..)
  , InputState (..)
  , App (..)
  , initialApp
  , startPlaying
  , goTitle
  , stepWorld
  , menuMove
  , menuAdjustDifficulty
  , togglePause
  , pauseMove
  , pauseActivate
  , menuStartIx
  , menuDifficultyIx
  , menuLeaderboardIx
  , menuLoadIx
  , menuExitIx
  , menuMaxIx
  ,isSupported 
  ) where
import Debug.Trace (trace)
import Config (GenConfig (..), SpeedRule (..), difficultyLevel)
import Game.Constants
  ( deathY
  , despawnBehind
  , gravity
  , groundTopY
  , invincibilityDuration
  , jumpVelocity
  , maxLives
  , moveSpeed
  , platformEdgeInset
  -- , playerBaseX
  , playerHeight
  , playerStartY
  , playerWidth
  , steerRange
  , windowHeight
  , windowWidth
  )
import Generator (ensureChunks)
import Geometry
  ( Interval (..)
  , Rect (..)
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
  | Leaderboard
  | LoadGame
  | GameOver
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
  , appConfig :: GenConfig
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

initialApp :: GenConfig -> App
initialApp cfg =
  App
    { appScreen = Title
    , appDifficulty = Normal
    , menuIx = menuStartIx
    , pauseIx = 0
    , appInput = resetInput
    , appConfig = cfg
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
  (initialApp (appConfig old))
    { viewW = viewW old
    , viewH = viewH old
    , appDifficulty = appDifficulty old
    }

startPlaying :: App -> App
startPlaying app =
  case appScreen app of
    Title -> (resetKeepingViewAndDifficulty app) {appScreen = Controls}
    Controls -> (resetKeepingViewAndDifficulty app) {appScreen = Playing}
    GameOver -> (resetKeepingViewAndDifficulty app) {appScreen = Playing}
    _ -> app

goTitle :: App -> App
goTitle app = (resetKeepingViewAndDifficulty app) {appScreen = Title}

menuMove :: Int -> App -> App
menuMove delta app =
  case appScreen app of
    Title -> app {menuIx = clampInt 0 menuMaxIx (menuIx app + delta)}
    _ -> app

menuAdjustDifficulty :: Int -> App -> App
menuAdjustDifficulty delta app =
  case appScreen app of
    Title
      | menuIx app == menuDifficultyIx ->
          app {appDifficulty = stepDifficulty delta (appDifficulty app)}
    _ -> app

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
    Paused -> app {pauseIx = clampInt 0 1 (pauseIx app + delta)}
    _ -> app

pauseActivate :: App -> App
pauseActivate app =
  case appScreen app of
    Paused ->
      if pauseIx app == 0
        then app {appScreen = Playing, appInput = resetInput}
        else goTitle app
    _ -> app

stepWorld :: Float -> App -> App
stepWorld dt app =
  case appScreen app of
    Title -> app
    Controls -> app
    Leaderboard -> app
    LoadGame -> app
    GameOver -> app
    Paused -> app
    Playing -> stepPlaying dt app

stepPlaying :: Float -> App -> App
stepPlaying dt app0 =
  if died
    then toGameOver app4
    else app4
  where
    inp0 = appInput app0

    scroll0 = worldScroll app0
    cfg = appConfig app0
    lvl = difficultyLevel cfg scroll0
    speed = runSpeedFor cfg (appDifficulty app0) lvl
    scroll1 = scroll0 + speed * dt

    dir = boolToFloat (inputRight inp0) - boolToFloat (inputLeft inp0)
    offX0 = playerOffsetX app0
    offX1 = clamp (-steerRange) steerRange (offX0 + dir * moveSpeed * dt)

    pxWorld = scroll1 + offX1

    (chunkIx1, holes1, plats1, spikes1, meds1) =
      ensureChunks cfg scroll1 (nextChunkIx app0) (worldHoles app0)
        (worldPlatforms app0) (worldSpikes app0) (worldMedkits app0)

    holes2 = pruneHoles scroll1 holes1
    plats2 = pruneRects scroll1 plats1
    spikes2 = pruneRects scroll1 spikes1
    meds2 = pruneRects scroll1 meds1

    y0 = playerY app0
    vy0 = playerVY app0

    supported = isSupported pxWorld y0 vy0 holes2 plats2
    jumpNow = inputJump inp0 && supported
    vy1 = if jumpNow then jumpVelocity else vy0

    inp1 =
      if jumpNow
        then inp0 {inputJump = False}
        else inp0

    vy2 = vy1 - gravity * dt
    y1 = y0 + vy2 * dt

    (y2, vy3) = resolvePlatforms pxWorld y0 y1 vy2 plats2

    (y3, vy4) =
      if isOverHole pxWorld holes2
        then (y2, vy3)                    
        else if y2 < deathY                 
             then (y2, vy3)
             else applyGroundCollision y2 vy3

    inv0 = playerInvTimer app0
    inv1 = max 0 (inv0 - dt)

    pr = playerRect pxWorld y3

    (picked, meds3) = pickupRects pr meds2
    lives0 = playerLives app0
    lives1 = clampInt 0 maxLives (lives0 + length picked)

    (lives2, inv2) = applySpikeDamage inv1 lives1 pr spikes2

    app4 =
      app0
        { appInput = inp1
        , worldScroll = scroll1
        , playerOffsetX = offX1
        , playerY = trace ("app4.playerY = " ++ show y3) y3
        , playerVY = vy4
        , playerLives = lives2
        , playerInvTimer = inv2
        , worldHoles = holes2
        , worldPlatforms = plats2
        , worldSpikes = spikes2
        , worldMedkits = meds3
        , nextChunkIx = chunkIx1
        }

    died = trace ("y3 = " ++ show y3 ++ ", deathY = " ++ show deathY) 
           (y3 < deathY || lives2 <= 0)

toGameOver :: App -> App
toGameOver app =
  app
    { appScreen = GameOver
    , appInput = resetInput
    }

playerRect :: Float -> Float -> Rect
playerRect x y =
  Rect
    { rectX = x
    , rectY = y
    , rectW = playerWidth
    , rectH = playerHeight
    }

pickupRects :: Rect -> [Rect] -> ([Rect], [Rect])
pickupRects pr =
  foldr step ([], [])
  where
    step r (picked, rest) =
      if rectIntersects pr r
        then (r : picked, rest)
        else (picked, r : rest)

applySpikeDamage :: Float -> Int -> Rect -> [Rect] -> (Int, Float)
applySpikeDamage inv lives pr spikes =
  if inv > 0
    then (lives, inv)
    else
      if hitSpike pr spikes
        then (max 0 (lives - 1), invincibilityDuration)
        else (lives, inv)

hitSpike :: Rect -> [Rect] -> Bool
hitSpike pr spikes =
  any (rectIntersects pr) spikes

isOverHole :: Float -> [Interval] -> Bool
isOverHole x holes =
  any (intervalContains x) holes

isSupported :: Float -> Float -> Float -> [Interval] -> [Rect] -> Bool
isSupported px y vy holes plats =
  (not (isOverHole px holes) && isOnGround y vy) || isOnPlatform px y vy plats

isOnGround :: Float -> Float -> Bool
isOnGround y vy =
  bottomY <= groundTopY + 0.001 && vy <= 0
  where
    bottomY = y - playerHeight / 2

isOnPlatform :: Float -> Float -> Float -> [Rect] -> Bool
isOnPlatform px y vy plats =
  any (onOne px bottomY vy) plats
  where
    bottomY = y - playerHeight / 2
    eps = 2.0

    onOne x b v r =
      v <= 0.01
        && playerFullyInside x r
        && abs (b - rectTop r) <= eps

applyGroundCollision :: Float -> Float -> (Float, Float)
applyGroundCollision y vy =
  if bottomY < groundTopY
    then (groundTopY + playerHeight / 2, 0)
    else (y, vy)
  where
    bottomY = y - playerHeight / 2

resolvePlatforms :: Float -> Float -> Float -> Float -> [Rect] -> (Float, Float)
resolvePlatforms px y0 y1 vy plats =
  case bestTop of
    Nothing -> (y1, vy)
    Just topY -> (topY + playerHeight / 2, 0)
  where
    y0Bottom = y0 - playerHeight / 2
    y1Bottom = y1 - playerHeight / 2

    candidates =
      [ rectTop r
      | r <- plats
      , vy <= 0
      , playerFullyInside px r
      , y0Bottom >= rectTop r
      , y1Bottom <= rectTop r
      ]

    bestTop =
      if null candidates then Nothing else Just (maximum candidates)

playerFullyInside :: Float -> Rect -> Bool
playerFullyInside px r =
  (px - halfPW) >= rectLeft r + platformEdgeInset
    && (px + halfPW) <= rectRight r - platformEdgeInset
  where
    halfPW = playerWidth / 2

pruneHoles :: Float -> [Interval] -> [Interval]
pruneHoles scroll =
  filter (\h -> intB h > scroll - despawnBehind)

pruneRects :: Float -> [Rect] -> [Rect]
pruneRects scroll =
  filter (\r -> rectRight r > scroll - despawnBehind)

boolToFloat :: Bool -> Float
boolToFloat b =
  if b then 1 else 0

clamp :: Float -> Float -> Float -> Float
clamp lo hi x
  | x < lo = lo
  | x > hi = hi
  | otherwise = x

clampInt :: Int -> Int -> Int -> Int
clampInt lo hi x
  | x < lo = lo
  | x > hi = hi
  | otherwise = x