-- ============================================================
-- Модуль: Game.Constants
-- Описание: Все настраиваемые параметры игры.
-- Группировка по функциональному назначению.
-- ============================================================

module Game.Constants
  (
    -- * Окно и основные настройки
    windowTitle, windowWidth, windowHeight, windowPos,
    backgroundColor, fps,

    -- * Главное меню
    titleText, titleX, titleY, titleScale, titleColor,
    menuItemX, menuItemY0, menuItemY1, menuItemY2, menuItemY3, menuItemY4,
    menuItemScale, menuItemColor, menuSelectedColor,
    menuHintText, menuHintX, menuHintY, menuHintScale, menuHintColor,

    -- * Игрок
    playerWidth, playerHeight, playerStartY, playerBaseX,
    steerRange, invBlinkHz, moveSpeed,
    runSpeedEasy, runSpeedNormal, runSpeedHard,
    metersPerPixel, gravity, jumpVelocity,
    playerSpritePxW, playerSpritePxH, playerRunFrameStep,

    -- * Земля и мир
    groundY, groundHeight, groundTopY, groundColor,
    markSpacing, markColor, distanceColor,
    deathY, maxLives, invincibilityDuration,
    heartW, heartH, heartSpacing, heartFullColor, heartEmptyColor,

    -- * Генерация уровней (объекты)
    chunkWidth, spawnAhead, despawnBehind,
    holeWidth,
    platformW, platformH, platformLift, platformEdgeInset, platformColor,
    spikeW, spikeH, spikeColor,
    medkitW, medkitH, medkitLift, medkitColor, medkitCrossColor,

    -- * Экран Game Over
    gameOverTitleText, gameOverTitleX, gameOverTitleY,
    gameOverTitleScale, gameOverTitleColor,
    gameOverHintText, gameOverHintX, gameOverHintY,
    gameOverHintScale, gameOverHintColor,

    -- * Экран паузы
    pauseTitleText,
    pausePanelW, pausePanelH, pausePanelColor, pausePanelBorderColor,
    pauseTitleScale, pauseTitleColor,
    pauseItemScale, pauseItemSelectedColor, pauseItemColor,
    pauseHintText, pauseHintScale, pauseHintColor,
    pauseItem3Y,

    -- * База данных и сохранения
    dbFileName, leaderboardLimit,
    defaultPlayerName, playerNameMaxLen,
    scoreSavedText, saveSlotsCount, defaultSaveSeed
  ) where

import Graphics.Gloss (Color, makeColorI)

------------------------------------------------------------------------------
-- Окно и основные настройки
------------------------------------------------------------------------------

windowTitle :: String
windowTitle = "Endless Runner"

windowWidth :: Int
windowWidth = 960

windowHeight :: Int
windowHeight = 540

windowPos :: (Int, Int)
windowPos = (100, 100)

backgroundColor :: Color
backgroundColor = makeColorI 15 20 25 255

fps :: Int
fps = 60

------------------------------------------------------------------------------
-- Главное меню
------------------------------------------------------------------------------

titleText :: String
titleText = "Endless Runner"

titleX :: Float
titleX = -330

titleY :: Float
titleY = 120

titleScale :: Float
titleScale = 0.6

titleColor :: Color
titleColor = makeColorI 220 235 250 255 

menuItemX :: Float
menuItemX = -325

menuItemY0, menuItemY1, menuItemY2, menuItemY3, menuItemY4 :: Float
menuItemY0 = 40
menuItemY1 = 5
menuItemY2 = -30
menuItemY3 = -65
menuItemY4 = -100

menuItemScale :: Float
menuItemScale = 0.26

menuItemColor :: Color
menuItemColor = makeColorI 200 215 230 255 

menuSelectedColor :: Color
menuSelectedColor = makeColorI 200 255 0 255

menuHintText :: String
menuHintText =
  "Up/Down: choose  |  Left/Right: LEVEL  |  Enter: select  |  Esc: exit"

menuHintX :: Float
menuHintX = -440

menuHintY :: Float
menuHintY = -170

menuHintScale :: Float
menuHintScale = 0.18

menuHintColor :: Color
menuHintColor =  makeColorI 200 215 230 255 

------------------------------------------------------------------------------
-- Игрок (физика, размеры, анимация)
------------------------------------------------------------------------------

playerWidth, playerHeight :: Float
playerWidth = 40
playerHeight = 60

playerStartY :: Float
playerStartY = groundTopY + playerHeight / 2   -- зависит от земли, см. ниже

playerBaseX :: Float
playerBaseX = -300   -- смещение игрока относительно центра экрана

steerRange :: Float
steerRange = 140      -- максимальное отклонение влево/вправо от центра

invBlinkHz :: Float
invBlinkHz = 12       -- частота мигания при получении урона

moveSpeed :: Float
moveSpeed = 260       -- скорость горизонтального движения (пикселей/сек)

-- Базовая скорость бега (world scroll) для разных уровней сложности
runSpeedEasy, runSpeedNormal, runSpeedHard :: Float
runSpeedEasy   = 280
runSpeedNormal = 320
runSpeedHard   = 380

metersPerPixel :: Float
metersPerPixel = 0.10   -- сколько метров в одном пикселе (для отображения дистанции)

gravity :: Float
gravity = 1200

jumpVelocity :: Float
jumpVelocity = 520

-- Размеры спрайтов (для масштабирования)
playerSpritePxW, playerSpritePxH :: Float
playerSpritePxW = 180
playerSpritePxH = 180

playerRunFrameStep :: Float
playerRunFrameStep = 28   -- пикселей прокрутки мира для смены кадра бега

------------------------------------------------------------------------------
-- Земля и статическое окружение
------------------------------------------------------------------------------

groundY :: Float
groundY = -200

groundHeight :: Float
groundHeight = 20

groundTopY :: Float
groundTopY = groundY + groundHeight / 2

groundColor :: Color
groundColor = makeColorI 80 170 80 255   -- зелёная трава

markSpacing :: Float
markSpacing = 120       -- расстояние между метками на земле

markColor :: Color
markColor = makeColorI 120 220 120 255   -- светлые зелёные метки

distanceColor :: Color
distanceColor = makeColorI 240 240 240 255  -- белый текст счётчика

deathY :: Float
deathY = -300            -- порог смерти (игрок провалился)

maxLives :: Int
maxLives = 3

invincibilityDuration :: Float
invincibilityDuration = 0.8   -- секунд неуязвимости после урона

-- Параметры сердечек (визуализация жизней)
heartW, heartH, heartSpacing :: Float
heartW = 18
heartH = 14
heartSpacing = 24

heartFullColor, heartEmptyColor :: Color
heartFullColor  = makeColorI 220 80 80 255    -- красное
heartEmptyColor = makeColorI 70 70 70 255     -- тёмно-серое

------------------------------------------------------------------------------
-- Генерация уровней (чанки и объекты)
------------------------------------------------------------------------------

chunkWidth :: Float
chunkWidth = 700

spawnAhead :: Float
spawnAhead = 2000      -- сколько пикселей вперёд генерировать

despawnBehind :: Float
despawnBehind = 800    -- за какой границей удалять объекты

-- Ямы
holeWidth :: Float
holeWidth = 160

-- Платформы
platformW, platformH, platformLift :: Float
platformW = 180
platformH = 18
platformLift = 50       -- подъём над землёй

platformEdgeInset :: Float
platformEdgeInset = 0   -- запас по краям платформы (для безопасного стояния)

platformColor :: Color
platformColor = makeColorI 120 120 220 255   -- синеватые

-- Шипы
spikeW, spikeH :: Float
spikeW = 40
spikeH = 35

spikeColor :: Color
spikeColor = makeColorI 220 80 80 255        -- красные

-- Аптечки
medkitW, medkitH, medkitLift :: Float
medkitW = 26
medkitH = 26
medkitLift = 70         -- высота парения над поверхностью

medkitColor, medkitCrossColor :: Color
medkitColor      = makeColorI 80 200 120 255   -- зелёная
medkitCrossColor = makeColorI 240 240 240 255  -- белый крест

------------------------------------------------------------------------------
-- Экран Game Over
------------------------------------------------------------------------------

gameOverTitleText :: String
gameOverTitleText = "Game Over"

gameOverTitleX, gameOverTitleY :: Float
gameOverTitleX = -170
gameOverTitleY = 80

gameOverTitleScale :: Float
gameOverTitleScale = 0.5

gameOverTitleColor :: Color
gameOverTitleColor = makeColorI 255 0 0 0   -- бледно-розовый

gameOverHintText :: String
gameOverHintText = "Enter: restart  |  Backspace: menu  |  Esc: quit"

gameOverHintX, gameOverHintY :: Float
gameOverHintX = -360
gameOverHintY = -250

gameOverHintScale :: Float
gameOverHintScale = 0.2

gameOverHintColor :: Color
gameOverHintColor = makeColorI 240 240 240 255    -- белый

------------------------------------------------------------------------------
-- Экран паузы
------------------------------------------------------------------------------

pauseTitleText :: String
pauseTitleText = "Paused"

pausePanelW, pausePanelH :: Float
pausePanelW = 600
pausePanelH = 300

pausePanelColor, pausePanelBorderColor :: Color
pausePanelColor       = makeColorI 30 30 30 235      -- тёмный полупрозрачный
pausePanelBorderColor = makeColorI 220 220 220 255   -- светло-серый

pauseTitleScale :: Float
pauseTitleScale = 0.35

pauseTitleColor :: Color
pauseTitleColor = makeColorI 200 255 0 255

pauseItemScale :: Float
pauseItemScale = 0.24

pauseItemSelectedColor, pauseItemColor :: Color
pauseItemSelectedColor = makeColorI 255 255 255 255   -- ярко-белый
pauseItemColor         = makeColorI 180 180 180 255   -- серый

pauseHintText :: String
pauseHintText = "Up/Down: choose  |  Enter: select  |  P: resume"

pauseHintScale :: Float
pauseHintScale = 0.14

pauseHintColor :: Color
pauseHintColor = makeColorI 160 160 160 255

pauseItem3Y :: Float
pauseItem3Y = -70    -- позиция третьего пункта ("Quit to Title")

------------------------------------------------------------------------------
-- База данных и сохранения
------------------------------------------------------------------------------

dbFileName :: FilePath
dbFileName = "game.db"

leaderboardLimit :: Int
leaderboardLimit = 10

defaultPlayerName :: String
defaultPlayerName = "Player"

playerNameMaxLen :: Int
playerNameMaxLen = 16

scoreSavedText :: String
scoreSavedText = "Score saved to leaderboard."

saveSlotsCount :: Int
saveSlotsCount = 3

defaultSaveSeed :: Int
defaultSaveSeed = 0