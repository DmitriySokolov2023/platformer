module Game
  ( runGame
  ) where

import Assets (loadAssets)
import Config (loadConfig)
import Game.Constants
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game
import Input (handleInputEvent)
import Render (drawAppIO)
import System.Exit (die, exitSuccess)
import World
  ( App
  , Screen (..)
  , appInput
  , appScreen
  , goTitle
  , initialApp
  , menuAdjustDifficulty
  , menuDifficultyIx
  , menuExitIx
  , menuIx
  , menuLeaderboardIx
  , menuLoadIx
  , menuMove
  , menuStartIx
  , pauseActivate
  , pauseMove
  , startPlaying
  , stepWorld
  , togglePause
  , viewH
  , viewW
  )

runGame :: IO ()
runGame = do
  eCfg <- loadConfig "config.json"
  case eCfg of
    Left err -> die err
    Right cfg -> do
      eAssets <- loadAssets
      case eAssets of
        Left err -> die err
        Right assets ->
          playIO
            gameDisplay
            backgroundColor
            fps
            (initialApp cfg)
            (drawAppIO assets)
            handleEvent
            stepApp

gameDisplay :: Display
gameDisplay = InWindow windowTitle (windowWidth, windowHeight) windowPos

handleEvent :: Event -> App -> IO App
handleEvent ev app =
  case ev of
    EventResize (w, h) ->
      pure app {viewW = w, viewH = h}

    EventKey (SpecialKey KeyEsc) Down _ _ ->
      exitSuccess

    EventKey key Down _ _
      | isPauseKey key ->
          pure (togglePause app)
      | appScreen app == Title && isMenuUpKey key ->
          pure (menuMove (-1) app)
      | appScreen app == Title && isMenuDownKey key ->
          pure (menuMove 1 app)
      | appScreen app == Title && isMenuLeftKey key ->
          pure (menuAdjustDifficulty (-1) app)
      | appScreen app == Title && isMenuRightKey key ->
          pure (menuAdjustDifficulty 1 app)
      | appScreen app == Paused && isMenuUpKey key ->
          pure (pauseMove (-1) app)
      | appScreen app == Paused && isMenuDownKey key ->
          pure (pauseMove 1 app)

    EventKey (SpecialKey KeyEnter) Down _ _ ->
      handleEnter app

    EventKey (SpecialKey KeyBackspace) Down _ _ ->
      pure (goTitle app)

    _ ->
      pure (applyInput ev app)

handleEnter :: App -> IO App
handleEnter app =
  case appScreen app of
    Title ->
      case menuIx app of
        i | i == menuStartIx -> pure (startPlaying app)
        i | i == menuDifficultyIx -> pure (menuAdjustDifficulty 1 app)
        i | i == menuLeaderboardIx -> pure app {appScreen = Leaderboard}
        i | i == menuLoadIx -> pure app {appScreen = LoadGame}
        i | i == menuExitIx -> exitSuccess
        _ -> pure app
    Paused ->
      pure (pauseActivate app)
    _ ->
      pure (startPlaying app)

isPauseKey :: Key -> Bool
isPauseKey key =
  key == Char 'p' || key == Char 'P'

isMenuUpKey :: Key -> Bool
isMenuUpKey key =
  key == SpecialKey KeyUp || key == Char 'w' || key == Char 'W'

isMenuDownKey :: Key -> Bool
isMenuDownKey key =
  key == SpecialKey KeyDown || key == Char 's' || key == Char 'S'

isMenuLeftKey :: Key -> Bool
isMenuLeftKey key =
  key == SpecialKey KeyLeft || key == Char 'a' || key == Char 'A'

isMenuRightKey :: Key -> Bool
isMenuRightKey key =
  key == SpecialKey KeyRight || key == Char 'd' || key == Char 'D'

applyInput :: Event -> App -> App
applyInput ev app =
  case appScreen app of
    Playing -> app {appInput = handleInputEvent ev (appInput app)}
    _ -> app

stepApp :: Float -> App -> IO App
stepApp dt app =
  pure (stepWorld dt app)