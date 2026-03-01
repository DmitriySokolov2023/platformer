module Render (drawAppIO) where

import Graphics.Gloss
import Game.Constants
import World (App (..), Screen (..))

drawAppIO :: App -> IO Picture
drawAppIO = pure . drawApp

drawApp :: App -> Picture
drawApp app =
  case appScreen app of
    Title -> drawTitle
    Playing -> drawPlaying app

drawTitle :: Picture
drawTitle =
  pictures
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
    [ worldLayer
    , hudLayer app
    ]
  where
    cameraX = worldScroll app - playerBaseX
    worldLayer =
      translate (-cameraX) 0 $
        pictures
          [ drawGround cameraX
          , drawGroundMarks cameraX
          , drawPlayer app
          ]

hudLayer :: App -> Picture
hudLayer app =
  pictures
    [ drawPlayingUi
    , drawDistance app
    ]

drawPlayingUi :: Picture
drawPlayingUi =
  pictures
    [ translate playingX playingY
        $ scale playingScale playingScale
        $ color playingColor
        $ Text playingText
    , translate playingHintX playingHintY
        $ scale playingHintScale playingHintScale
        $ color playingHintColor
        $ Text playingHintText
    ]

drawDistance :: App -> Picture
drawDistance app =
  translate distanceX distanceY $
    scale distanceScale distanceScale $
      color distanceColor $
        Text ("Distance: " ++ show meters ++ " m")
  where
    meters = floor (worldScroll app * metersPerPixel) :: Int

drawGround :: Float -> Picture
drawGround cameraX =
  translate cameraX groundY
    $ color groundColor
    $ rectangleSolid (fromIntegral windowWidth + 200) groundHeight

drawGroundMarks :: Float -> Picture
drawGroundMarks cameraX =
  pictures [drawMark (fromIntegral k * markSpacing) | k <- [k0 .. k1]]
  where
    halfW = fromIntegral windowWidth / 2
    leftX = cameraX - halfW - markSpacing
    rightX = cameraX + halfW + markSpacing

    k0 = floor (leftX / markSpacing) :: Int
    k1 = ceiling (rightX / markSpacing) :: Int

drawMark :: Float -> Picture
drawMark x =
  translate x (groundY + groundHeight / 2 - markH / 2)
    $ color markColor
    $ rectangleSolid markW markH
  where
    markW = 10
    markH = 8

drawPlayer :: App -> Picture
drawPlayer app =
  translate px (playerY app)
    $ color playerColor
    $ rectangleSolid playerWidth playerHeight
  where
    px = worldScroll app + playerOffsetX app

-- drawTitleColorHack :: Picture
-- drawTitleColorHack = Blank