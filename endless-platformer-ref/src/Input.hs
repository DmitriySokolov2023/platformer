module Input
  ( handleInputEvent
  ) where

import Graphics.Gloss.Interface.IO.Game
  ( Event (EventKey)
  , Key (Char, SpecialKey)
  , KeyState (Down)
  , SpecialKey (KeyLeft, KeyRight, KeySpace, KeyUp)
  )
import World (InputState (..))

handleInputEvent :: Event -> InputState -> InputState
handleInputEvent ev st =
  case ev of
    EventKey key keyState _ _
      | isLeftKey key -> st {inputLeft = keyState == Down}
      | isRightKey key -> st {inputRight = keyState == Down}
      | isJumpKey key && keyState == Down -> st {inputJump = True}
      | otherwise -> st
    _ -> st

isLeftKey :: Key -> Bool
isLeftKey key =
  key `elem` [SpecialKey KeyLeft, Char 'a', Char 'A']

isRightKey :: Key -> Bool
isRightKey key =
  key `elem` [SpecialKey KeyRight, Char 'd', Char 'D']

isJumpKey :: Key -> Bool
isJumpKey key =
  key `elem` [SpecialKey KeySpace, SpecialKey KeyUp, Char 'w', Char 'W']
