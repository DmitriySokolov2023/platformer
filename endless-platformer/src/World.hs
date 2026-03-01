module World
  ( Screen (..)
  , InputState (..)
  , App (..)
  , initialApp
  , startPlaying
  , goTitle
  , stepWorld
  ) where

import Game.Constants
  ( gravity
  , groundTopY
  , jumpVelocity
  , moveSpeed
  , playerHeight
  , playerStartY
  , runSpeed
  , steerRange
  )

data Screen
  = Title
  | Playing
  deriving (Eq, Show)

data InputState = InputState
  { inputLeft :: Bool
  , inputRight :: Bool
  , inputJump :: Bool
  }
  deriving (Eq, Show)

data App = App
  { appScreen :: Screen
  , appInput :: InputState
  , worldScroll :: Float
  , playerOffsetX :: Float
  , playerY :: Float
  , playerVY :: Float
  }
  deriving (Eq, Show)

initialApp :: App
initialApp =
  App
    { appScreen = Title
    , appInput = resetInput
    , worldScroll = 0
    , playerOffsetX = 0
    , playerY = playerStartY
    , playerVY = 0
    }

startPlaying :: App -> App
startPlaying app =
  case appScreen app of
    Title ->
      app
        { appScreen = Playing
        , appInput = resetInput
        , worldScroll = 0
        , playerOffsetX = 0
        , playerY = playerStartY
        , playerVY = 0
        }
    Playing -> app

goTitle :: App -> App
goTitle app =
  case appScreen app of
    Playing ->
      app
        { appScreen = Title
        , appInput = resetInput
        }
    Title -> app

resetInput :: InputState
resetInput =
  InputState
    { inputLeft = False
    , inputRight = False
    , inputJump = False
    }

stepWorld :: Float -> App -> App
stepWorld dt app =
  case appScreen app of
    Title -> app
    Playing -> stepPlaying dt app

stepPlaying :: Float -> App -> App
stepPlaying dt app =
  app
    { appInput = inp1
    , worldScroll = scroll1
    , playerOffsetX = offX1
    , playerY = y2
    , playerVY = vy3
    }
  where
    inp0 = appInput app

    scroll0 = worldScroll app
    scroll1 = scroll0 + runSpeed * dt

    dir = boolToFloat (inputRight inp0) - boolToFloat (inputLeft inp0)
    offX0 = playerOffsetX app
    offX1 = clamp (-steerRange) steerRange (offX0 + dir * moveSpeed * dt)

    y0 = playerY app
    vy0 = playerVY app

    jumpNow = inputJump inp0 && isOnGround y0 vy0
    vy1 = if jumpNow then jumpVelocity else vy0

    inp1 = inp0 {inputJump = False}

    vy2 = vy1 - gravity * dt
    y1 = y0 + vy2 * dt

    (y2, vy3) = applyGroundCollision y1 vy2

isOnGround :: Float -> Float -> Bool
isOnGround y vy =
  bottomY <= groundTopY + 0.001 && vy <= 0
  where
    bottomY = y - playerHeight / 2

applyGroundCollision :: Float -> Float -> (Float, Float)
applyGroundCollision y vy =
  if bottomY < groundTopY
    then (groundTopY + playerHeight / 2, 0)
    else (y, vy)
  where
    bottomY = y - playerHeight / 2

boolToFloat :: Bool -> Float
boolToFloat b =
  if b then 1 else 0

clamp :: Float -> Float -> Float -> Float
clamp lo hi x
  | x < lo = lo
  | x > hi = hi
  | otherwise = x