module Game
  ( runGame
  ) where

import Game.Constants
import Graphics.Gloss
import Graphics.Gloss.Interface.IO.Game
import Input (handleInputEvent)
import Render (drawAppIO)
import System.Exit (exitSuccess)
import World (App, Screen (Playing), appInput, appScreen, goTitle, initialApp, startPlaying, stepWorld)

runGame :: IO ()
runGame =
  playIO
    gameDisplay
    backgroundColor
    fps
    initialApp
    drawAppIO
    handleEvent
    stepApp

gameDisplay :: Display
gameDisplay = InWindow windowTitle (windowWidth, windowHeight) windowPos

handleEvent :: Event -> App -> IO App
handleEvent ev app =
  case ev of
    EventKey (SpecialKey KeyEsc) Down _ _ -> exitSuccess
    EventKey (SpecialKey KeyEnter) Down _ _ -> pure (startPlaying app)
    EventKey (SpecialKey KeyBackspace) Down _ _ ->
      pure (goTitle app)
    _ ->
      pure (applyInput ev app)

applyInput :: Event -> App -> App
applyInput ev app =
  case appScreen app of
    Playing -> app {appInput = handleInputEvent ev (appInput app)}
    _ -> app

stepApp :: Float -> App -> IO App
stepApp dt app =
  pure (stepWorld dt app)