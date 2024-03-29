import XMonad.Actions.Plane
import XMonad.Actions.Promote
import XMonad.Util.Dzen


    -- Base
import XMonad
import System.Directory
import System.IO (hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W
import Control.Monad (liftM2)           -- For viewshift

    -- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextWS, prevWS, toggleWS)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

    -- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

    -- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.WorkspaceHistory

    -- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed

    -- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.Magnifier
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))

   -- Utilities
-- import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Layout.Hidden (hiddenWindows, hideWindow, popOldestHiddenWindow)

myFont :: String
myFont = "xft:Ubuntu:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty" -- Sets default terminal

myBrowser :: String
myBrowser = "qutebrowser"  -- Sets firefox as browser

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String
myNormColor   = "#6272a4"   -- Border color of normal windows

myFocusColor :: String
myFocusColor  = "#8be9fd"   -- Border color of focused windows

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
    spawnOnce "picom --experimental-backends &"
    spawnOnce "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &"
    spawnOnce "numlockx &"
    spawnOnce "setxkbmap -option grp:alt_shift_toggle us,ir &"
    spawnOnce "xsetroot -cursor_name left_ptr &"
    spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 0 --tint 0x282a36 --height 22 &"
    spawnOnce "~/.fehbg &"
    spawnOnce "volnoti &"
    spawnOnce "xautolock -time 10 -locker 'i3lock-fancy' -detectsleep &"
    spawnOnce "pfetch &"
    setWMName "LG3D"

--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining layouts
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall     = renamed [Replace "tall"]
           $ smartBorders
           $ addTabs shrinkText myTabTheme
           $ subLayout [] (smartBorders Simplest)
           $ limitWindows 12
           $ mySpacing 6 
           $ ResizableTall 1 (3/100) (1/2) []
tabs     = renamed [Replace "tabs"]
           -- I won't add spacing to this layout because it will
           -- add spacing between window and tabs which looks bad.
           $ tabbed shrinkText myTabTheme

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = myFont
                 , activeColor         = "#6272a4"
                 , inactiveColor       = "#282a36"
                 , activeBorderColor   = "#bd93f9"
                 , inactiveBorderColor = "#44475a"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:JetBrains Mono NL:bold:size=30"
    , swn_fade              = 0.5
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

-- The layout hook
myLayoutHook = avoidStruts $ mouseResize $ windowArrange  $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) $ hiddenWindows myDefaultLayout
             where
               myDefaultLayout = withBorder myBorderWidth tall ||| noBorders tabs


-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 "]
myWorkspaces = [" chat ", " web ", " code ", " sys ", " vid ", " office ", " art "]
-- myWorkspaces = [" one ", " two ", " three ", " four ", " five ", " six ", " seven "]

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
     -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
     -- using 'doShift ( myWorkspaces !! 0)' sends program to workspace 1!
     -- I'm doing it this way because otherwise I would have to write out the full
     -- name of my workspaces and the names would be very long if using clickable workspaces.
     [ 
       className =? "confirm"                       --> doFloat
     , className =? "file_progress"                 --> doFloat
     , className =? "dialog"                        --> doFloat
     , className =? "download"                      --> doFloat
     , className =? "error"                         --> doFloat
     , className =? "notification"                  --> doFloat
     , className =? "pinentry-gtk-2"                --> doFloat
     , className =? "splash"                        --> doFloat
     , className =? "toolbar"                       --> doFloat
     , className =? "copyq"                         --> doFloat
     , title =? "Oracle VM VirtualBox Manager"      --> doFloat

  -- Specific apps to appropriate workspace
     -- browsers
     , className =? "librewolf"                     --> viewShift " web "
     , className =? "qutebrowser"                   --> viewShift " web "
     -- code editors
     , className =? "VSCodium"                      --> doShift " code "

     -- chat apps
     , className =? "TelegramDesktop"               --> doShift " chat "
     , className =? "discord"                       --> doShift " chat "
     , className =? "whatsapp-nativefier-d40211"    --> doShift " chat "

     -- system apps
     , className =? "Pcmanfm"                       --> viewShift " sys "

     -- multimedia apps
     , className =? "mpv"                           --> viewShift " vid "
     , className =? "vlc"                           --> viewShift " vid "

     -- office and virtualboxes
     , className =? "VirtualBox Manager"            --> doShift " office "
     , className =? "libreoffice-startcenter"       --> doShift " office "

     -- CGI apps
     , className =? "Gimp-2.10"                     --> doShift " art "
     , className =? "Inkscape"                      --> doShift " art "
     , className =? "krita"                         --> doShift " art "
     , className =? "kdenlive"                      --> doShift " art "


     -- Float dialogs
     , (className =? "firefox" <&&> resource =? "Dialog")           --> doFloat
     , (className =? "Gimp-2.10" <&&> resource =? "Dialog")         --> doFloat 
     ] 
  where viewShift = doF . liftM2 (.) W.greedyView W.shift

myKeys :: [(String, X ())]
myKeys =
        [
        -- If you set <myModMask> variable to mod4mask
        -- M  => Super key/Windows key
        -- C  => Ctrl
        -- S  => Shift
        -- M1 => Alt

        -- If you set <myModMask> variable to mod1mask
        -- M => Alt
        -- C  => Ctrl
        -- S  => Shift
        -- M1  => Super key/Windows key
------------------------------------------------------------------------------------

-- 90% of these keybindings will work on most keyboard layouts
-- for full functionality your keyboard layout should be en-us
-- to set your keymap to en-us simply execute this command on your terminal

--                   setxkbmap us

------------------------------------------------------------------------------------

    -- Xmonad
          ("M-C-r", spawn "xmonad --recompile")                -- Recompiles xmonad
        , ("M-S-r", spawn "xmonad --restart")                  -- Restarts xmonad
        , ("M-S-q", io exitSuccess)                            -- Quits xmonad
        , ("M-c", kill)  -- "M-S-c" works too but it's tiring  -- Kill focused
	, ("C-M1-x", spawn "xkill")
    
    -- Screen Locking
        , ("M-p", spawn "i3lock-fancy ")

    -- Run Prompt
    --  , ("M-S-<Return>", spawn "dmenu_run -i -p \"Run: \"") -- Dmenu
        , ("M-S-<Return>", spawn "/home/imaan/.xmonad/rofi.sh launcher") -- Rofi launcher
	, ("M-0", spawn "/home/imaan/.xmonad/rofi.sh powermenu") -- Rofi powermenu

    -- Useful Programs
        , ("M-<Return>", spawn (myTerminal))    -- Terminal
        , ("M-b", spawn myBrowser) -- Browser
        , ("M-e", spawn "pcmanfm")

     -- Workspaces
        , ("M-.", nextWS)  -- Move to next workspace
	, ("M-S-.", moveTo Next EmptyWS)  -- Move to next empty workspace
	, ("M-C-.", shiftTo Next EmptyWS)  -- Shift window to next empty workspace
        , ("M-,", prevWS)  -- Move to prev workspace
	, ("M-S-,", moveTo Prev EmptyWS) -- Move to prev empty workspace
	, ("M-C-,", shiftTo Prev EmptyWS) -- Shift window to prev empty workspace
	, ("M-<Tab>", toggleWS) -- Move to recent workspace

    -- Floating windows
    --  , ("M-f", sendMessage (T.Toggle "floats")) -- Toggles my 'floats' layout ( Should be reconfig!! )
        , ("M-t", withFocused $ windows . W.sink)  -- Push floating window back to tile
        , ("M-S-t", sinkAll)                       -- Push ALL floating windows to tile

    -- Increase/decrease spacing (gaps)
        , ("C-M1-j", decWindowSpacing 2)         -- Decrease window spacing
        , ("C-M1-k", incWindowSpacing 2)         -- Increase window spacing
        , ("C-M1-h", decScreenSpacing 2)         -- Decrease screen spacing
        , ("C-M1-l", incScreenSpacing 2)         -- Increase screen spacing

    -- Windows navigation
        , ("M-m", windows W.focusMaster)  -- Move focus to the master window
        , ("M-j", windows W.focusDown)    -- Move focus to the next window
        , ("M-k", windows W.focusUp)      -- Move focus to the prev window
        , ("M-S-m", windows W.swapMaster) -- Swap the focused window and the master window
        , ("M-S-j", windows W.swapDown)   -- Swap focused window with next window
        , ("M-S-k", windows W.swapUp)     -- Swap focused window with prev window
        , ("M-<Backspace>", promote)      -- Moves focused window to master, others maintain order
        , ("M-S-<Tab>", rotSlavesDown)    -- Rotate all windows except master and keep focus in place
	, ("M-C-<Tab>", rotAllDown)       -- Rotate all the windows in the current stack
  	, ("M-S-h", withFocused hideWindow)           -- Hide focused window
  	, ("M-C-h", popOldestHiddenWindow)           -- Show hidden window

    -- Layouts
        , ("M-<Esc>", sendMessage NextLayout)           -- Switch to next layout
        , ("M-<Space>", sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts) -- full screen view

    -- Increase/decrease windows in the master pane or the stack
        , ("M-S-<Up>", sendMessage (IncMasterN 1))      -- Increase # of clients master pane
        , ("M-S-<Down>", sendMessage (IncMasterN (-1))) -- Decrease # of clients master pane
        , ("M-C-<Up>", increaseLimit)                   -- Increase # of windows
        , ("M-C-<Down>", decreaseLimit)                 -- Decrease # of windows

    -- Window resizing
        , ("M-h", sendMessage Shrink)                   -- Shrink horiz window width
        , ("M-l", sendMessage Expand)                   -- Expand horiz window width
        , ("M-M1-j", sendMessage MirrorShrink)          -- Shrink vert window width
        , ("M-M1-k", sendMessage MirrorExpand)          -- Expand vert window width

   
    -- Controls volume 
        , ("<XF86AudioRaiseVolume>", spawn "/home/imaan/.xmonad/volume.sh up")    -- Raise Volume
        , ("<XF86AudioLowerVolume>", spawn "/home/imaan/.xmonad/volume.sh down")  -- Lower volume
        , ("<XF86AudioMute>", spawn "/home/imaan/.xmonad/volume.sh mute")         -- Mute volume
    
    -- Control music
        , ("<XF86AudioPlay>", spawn "playerctl play-pause")  -- Play/Pause music
	, ("<XF86AudioNext>", spawn "playerctl next")        -- Next music 
	, ("<XF86AudioPrev>", spawn "playerctl previous")    -- Previous music
	, ("<XF86AudioStop>", spawn "playerctl stop")        -- Stop music

    -- Keyboard backlight
        , ("<Scroll_lock>", spawn "/home/imaan/.xmonad/kbdlight.sh")

    -- Screenshot
        , ("<Print>", spawn "spectacle -fb")              -- Full screenshot
	, ("M1-<Print>", spawn "spectacle -ab")  	        -- Focus window screenshot 
	, ("S-<Print>", spawn "spectacle -rb")            -- Select area screenshot
        ]
         


main :: IO ()
main = do
    -- Launching xmobar on monitor
    xmproc <- spawnPipe "xmobar ~/.config/xmobar/xmobarrc"
    -- the xmonad, ya know...what the WM is named after!
    xmonad $ ewmh def
        { manageHook = ( isFullscreen --> doFullFloat ) <+> myManageHook <+> manageDocks
        -- Run xmonad commands from command line with "xmonadctl command". Commands include:
        -- shrink, expand, next-layout, default-layout, restart-wm, xterm, kill, refresh, run,
        -- focus-up, focus-down, swap-up, swap-down, swap-master, sink, quit-wm. You can run
        -- "xmonadctl 0" to generate full list of commands written to ~/.xsession-errors.
        , handleEventHook    = serverModeEventHookCmd
                               <+> serverModeEventHook
                               <+> serverModeEventHookF "XMONAD_PRINT" (io . putStrLn)
                               <+> docksEventHook
        , modMask            = myModMask
        , terminal           = myTerminal
        , startupHook        = myStartupHook
        , layoutHook         = showWName' myShowWNameTheme myLayoutHook
        , workspaces         = myWorkspaces
        , borderWidth        = myBorderWidth
        , normalBorderColor  = myNormColor
        , focusedBorderColor = myFocusColor
	, focusFollowsMouse = False
        , logHook = workspaceHistoryHook <+> dynamicLogWithPP xmobarPP
                        { ppOutput = \x -> hPutStrLn xmproc x -- ppOutput = \x -> hPutStrLn xmproc x     -- xmobar 
                        , ppCurrent = xmobarColor "#bd93f9" "" . wrap "[" "]" -- Current workspace in xmobar
                        , ppVisible = xmobarColor "#bd93f9" "" .clickable               -- Visible but not current workspace
                        , ppHidden = xmobarColor "#ff79c6" "" . wrap "*" "" .clickable  -- Hidden workspaces in xmobar
                        , ppHiddenNoWindows = xmobarColor "#778ED3" "" .clickable      -- Hidden workspaces (no windows)
                        , ppTitle = xmobarColor "#8be9fd" "" . shorten 60     -- Title of active window in xmobar
                        , ppSep =  "<fc=#666666> ∫ </fc>"                     -- Separators in xmobar
                        , ppUrgent = xmobarColor "#FF5555" "" . wrap "!" "!"  -- Urgent workspace
                        , ppExtras  = [windowCount]                           -- # of windows current workspace
                        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                        }
        } `additionalKeysP` myKeys

