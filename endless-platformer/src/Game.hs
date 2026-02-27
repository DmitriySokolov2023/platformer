{- HLINT ignore "Use newtype instead of data" -}
module Game
  ( runGame
  ) where

import Game.Constants
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game
import System.Exit (exitSuccess)


data Screen = Title | Playing
  deriving (Eq, Show)

data App = App 
  { appScreen :: Screen,
    inputLeft::Bool,
    inputRight::Bool,
    playerX :: Float
  } 

  deriving (Eq, Show)

runGame :: IO ()
runGame =
  playIO
    gameDisplay --функция для отрисовки дисплея
    backgroundColor --цвет фона
    fps --количество fpr
    initialApp --начальное состояние игры
    drawApp --текущее состояние
    handleEvent --обработка событий/нажатие на клавиши
    stepApp --обновление состояния

gameDisplay :: Display
gameDisplay = InWindow windowTitle (windowWidth, windowHeight) windowPos

initialApp :: App
initialApp = App {
  appScreen = Title,
  inputLeft = False,
  inputRight = False,
  playerX = 0
}

drawApp :: App -> IO Picture
drawApp app =
  pure $
    case appScreen app of
      Title -> drawTitle
      Playing -> drawPlaying app

drawTitle :: Picture
drawTitle = pictures
    [ translate titleX titleY
    $ scale titleScale titleScale
    $ color titleColor
    $ Text titleText
    
    , translate hintX hintY
    $ scale hintScale hintScale
    $ color hintColor
    $ Text hintText
    ]

drawPlaying :: App -> Picture
drawPlaying app =
  pictures
    [ drawGround, drawPlayer app, drawPlayingUi]

drawPlayingUi :: Picture
drawPlayingUi =
  pictures
    [ translate playingX playingY $
      scale playingScale playingScale $
      color playingColor $
      Text playingText, 
      
      translate playingHintX playingHintY $
      scale playingHintScale playingHintScale $
      color playingHintColor $
      Text playingHintText
    ]

drawPlayer :: App -> Picture
drawPlayer app =
  translate (playerX app) playerY $
    color playerColor $
      rectangleSolid playerWidth playerHeight

drawGround :: Picture
drawGround =
  translate 0 groundY $
    color groundColor $
      rectangleSolid (fromIntegral windowWidth) groundHeight



handleEvent :: Event -> App -> IO App
handleEvent ev app = case ev of
    EventKey (SpecialKey KeyEsc) Down _ _ -> exitSuccess
    EventKey (SpecialKey KeyEnter) Down _ _ -> pure (startPlaying app)
    EventKey (SpecialKey KeyTab) Down _ _ -> pure (goTitle app)
    EventKey key keyState _ _ -> pure (handleMoveKey key keyState app)
    _ -> pure app

startPlaying :: App -> App
startPlaying app =
  case appScreen app of
    Title ->
      app
       {
        appScreen = Playing,
        inputLeft = False,
        inputRight = False,
        playerX = 0
       }
    Playing -> app


goTitle :: App -> App 
goTitle app =
  case appScreen app of
    Playing ->
      app
      {
        appScreen = Title,
        inputLeft = False,
        inputRight = False
      }
    Title -> app


handleMoveKey :: Key -> KeyState -> App -> App
handleMoveKey key keyState app =
  case appScreen app of 
    Title -> app 
    Playing
     | isLeftKey key -> app {inputLeft = keyState == Down}
     | isRightKey key -> app {inputRight = keyState == Down}
     | otherwise -> app 

isLeftKey :: Key -> Bool
isLeftKey key =
  key == SpecialKey KeyLeft || key == Char 'a' || key == Char 'A'

isRightKey :: Key -> Bool
isRightKey key =
  key == SpecialKey KeyRight || key == Char 'd' || key == Char 'D'

stepApp :: Float -> App -> IO App
stepApp dt app =
  pure $
    case appScreen app of
      Title -> app
      Playing -> movePlayer dt app


movePlayer :: Float -> App -> App
movePlayer dt app =
  app {playerX = clamp minX maxX (playerX app + dx)}
  where
    dir = boolToFloat (inputRight app) - boolToFloat (inputLeft app)
    dx = dir * moveSpeed * dt
    halfW = fromIntegral windowWidth / 2
    halfPlayerW = playerWidth / 2
    minX = -halfW + halfPlayerW
    maxX = halfW - halfPlayerW

boolToFloat :: Bool -> Float
boolToFloat b =
  if b then 1 else 0

clamp :: Float -> Float -> Float -> Float
clamp lo hi x
  | x < lo = lo
  | x > hi = hi
  | otherwise = x