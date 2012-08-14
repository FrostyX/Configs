--
-- xmonad example config file.
--
-- A template showing all available configuration hooks,
-- and how to override the defaults in your own xmonad.hs conf file.
--
-- Normally, you'd only override those defaults you care about.
--

import XMonad
import Data.Monoid
import Data.Ratio ((%))
import System.Exit
import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Minimize
import XMonad.Layout.IM
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Tabbed
import XMonad.Layout.Magnifier
import XMonad.Layout.Grid
import XMonad.Layout.Named

import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.Minimize


import XMonad.Actions.CycleWS
import XMonad.Actions.SpawnOn
import XMonad.Util.Themes
import XMonad.Util.Run(spawnPipe) -- spawnPipe and hPutStrLn
import System.IO        -- hPutStrLn -- scope
import XMonad.Hooks.EwmhDesktops
import Data.List
import XMonad.Util.EZConfig
import XMonad.Config.Desktop

import Graphics.X11.ExtraTypes.XF86


import XMonad.Util.NamedWindows (getName)

colorBlue = "#3189FF"
colorPink = "#FF0099"

-- The preferred terminal program, which is used in a binding below and by
-- certain contrib modules.
--
myTerminal      = "urxvt"

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Width of the window border in pixels.
--
myBorderWidth   = 1

-- modMask lets you specify which modkey you want to use. The default
-- is mod1Mask ("left alt").  You may also consider using mod3Mask
-- ("right alt"), which does not conflict with emacs keybindings. The
-- "windows key" is usually mod4Mask.
--
myModMask       = mod1Mask
keyWin          = mod4Mask
keyR_Alt        = mod3Mask

-- The default number of workspaces (virtual screens) and their names.
-- By default we use numeric strings, but any string may be used as a
-- workspace name. The number of workspaces is determined by the length
-- of this list.
--
-- A tagging example:
--
-- > workspaces = ["web", "irc", "code" ] ++ map show [4..9]
--
myWorkspaces    = ["IM","Web","Misc","Dev","Docs","Mail","Cal","Virtual","Media"]

-- Border colors for unfocused and focused windows, respectively.
--
myNormalBorderColor  = "#000000"
myFocusedBorderColor = colorPink

------------------------------------------------------------------------
-- Key bindings. Add, modify or remove key bindings here.
--
myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- launch a terminal
    --[ ((modm .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
    [ ((modm, xK_F1), spawn $ XMonad.terminal conf)

   -- launch dmenu
    , ((modm,               xK_w     ), spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")

	-- My applications
    , ((modm, xK_F2     ), spawn "gmrun")
    , ((modm, xK_e      ), spawn "nautilus --no-desktop")
    , ((modm, xK_q      ), spawn "chromium-browser")
    , ((modm, xK_o      ), spawn "urxvt -e sh -c 'ncmpcpp -h 127.0.0.1 -p 6600'")
    , ((modm, xK_p      ), spawn "urxvt -name irssi -e sh -c 'screen -x -p irssi'")
    , ((modm, xK_u      ), spawn "urxvt -e sh -c 'alsamixer'")
    , ((0,    xK_Print  ), spawn "scrot 'shot_%d.%m.%Y_%H:%M:%S.png' -e 'mv $f ~/images/scrot/'")

    -- , ((modm, xK_o      ), spawn "terminal -I ~/.icons/ncmpcpp.png --command='ncmpcpp -h 127.0.0.1 -p 6600'")
    -- , ((modm, xK_p      ), spawn "terminal -I ~/.icons/irssi.png --title=irssi --command='screen -x -p irssi'")
    -- , ((modm, xK_u      ), spawn "terminal -I ~/.icons/alsamixer.png --command='alsamixer'")


	--, ((modm, xK_KP_1      ), spawn "urxvt")

    -- close focused window
    --, ((modm .|. shiftMask, xK_c     ), kill)
    , ((modm, xK_F4     ), kill)

   -- Multimedia keys
   -- Have to import Graphics.X11.ExtraTypes.XF86
   -- , ((0, xF86XK_AudioMute       ), spawn "amixer -q set PCM toggle")     -- XF86AudioMute
   , ((0, xF86XK_AudioLowerVolume), spawn "amixer -q set 'Master' 0.05%-")   -- XF86AudioLowerVolume
   , ((0, xF86XK_AudioRaiseVolume), spawn "amixer -q set 'Master' 0.05%+")   -- XF86AudioRaiseVolume
   , ((0, xF86XK_AudioNext       ), spawn "mpc -h 127.0.0.1 -p 6600 next")   -- XF86AudioNext
   , ((0, xF86XK_AudioPrev       ), spawn "mpc -h 127.0.0.1 -p 6600 prev")   -- XF86AudioPrev
   , ((0, xF86XK_AudioPlay       ), spawn "mpc -h 127.0.0.1 -p 6600 toggle") -- XF86AudioPlay

    -- Jump to workspaces easily
    , ((modm, xK_d), windows (W.view "Dev"))
    , ((modm, xK_r), windows (W.view "Web"))
    , ((modm, xK_i), windows (W.view "IM"))
    , ((modm, xK_c), windows (W.view "Cal"))
    , ((modm, xK_n), windows (W.view "Mail"))

     -- Rotate through the available layout algorithms
    , ((modm,               xK_space ), sendMessage NextLayout)

    --  Reset the layouts on the current workspace to default
    , ((modm .|. shiftMask, xK_space ), setLayout $ XMonad.layoutHook conf)

    -- Resize viewed windows to the correct size
    , ((keyWin,             xK_n     ), refresh)

    -- Move focus to the next window
    , ((modm,               xK_Tab   ), windows W.focusDown)

    -- Move focus to the next window
    , ((modm,               xK_j     ), windows W.focusDown)

    -- Move focus to the previous window
    , ((modm,               xK_k     ), windows W.focusUp  )

    -- Move focus to the master window
    , ((modm,               xK_m     ), windows W.focusMaster  )

	-- Move focus to urgent window
    , ((modm,               xK_s     ), focusUrgent  )

    -- Move focus to urgent window
    , ((modm,               xK_w     ), toggleWS  )

    -- Swap the focused window and the master window
    , ((modm,               xK_Return), windows W.swapMaster)

    -- Swap the focused window with the next window
    , ((keyWin, xK_j     ), windows W.swapDown  )

    -- Swap the focused window with the previous window
    , ((keyWin, xK_k     ), windows W.swapUp    )

    -- Shrink the master area
    , ((modm,               xK_h     ), sendMessage Shrink)

    -- Expand the master area
    , ((modm,               xK_l     ), sendMessage Expand)

    -- Push window back into tiling
    , ((modm,               xK_t     ), withFocused $ windows . W.sink)

    , ((modm, xK_F11                 ), sendMessage ToggleStruts)

    , ((modm,               xK_Down  ), withFocused minimizeWindow)
    , ((modm,               xK_Up    ), sendMessage RestoreNextMinimizedWin)

    -- Increment the number of windows in the master area
    --, ((modm              , xK_comma ), sendMessage (IncMasterN 1))

    -- Deincrement the number of windows in the master area
    --, ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    --
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)

    , ((modm .|. controlMask, xK_Right), nextWS)
    , ((modm .|. controlMask, xK_Left),  prevWS)
    , ((modm .|. mod4Mask,    xK_Right), shiftToNext >> nextWS)
    , ((modm .|. mod4Mask,    xK_Left),  shiftToPrev >> prevWS)

    -- Quit xmonad
    , ((modm .|. shiftMask, xK_q     ), io (exitWith ExitSuccess))

    -- Restart xmonad
    , ((modm              , xK_b     ), spawn "xmonad --recompile; xmonad --restart")
    ]
    ++



    --
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    --
    [((m .|. shiftMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, keyWin)]]
    -- ++




    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-shift-{w,e,r}, Move client to screen 1, 2, or 3
    --
    --[((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
    --    | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
    --    , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]


------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- XMonad theme
--
newTheme :: ThemeInfo
newTheme = TI "" "" "" defaultTheme

miniBlack :: ThemeInfo
miniBlack =
    newTheme { themeName        = "miniBlack"
             , themeAuthor      = "FrostyX (Jakub Kadlčík)"
             , themeDescription = "Minimalistic black theme"
             , theme            = defaultTheme { activeColor         = "#111111"
                                               , inactiveColor       = "#111111"
                                               , activeBorderColor   = "#1B1D1E"
                                               , inactiveBorderColor = "#1B1D1E"
                                               , activeTextColor     = "#3189FF"
                                               , inactiveTextColor   = "grey"
                                               , decoHeight          = 16
                                               }
             }
------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = tiled ||| magrid ||| Mirror tiled ||| tabbedBottom shrinkText (theme miniBlack)  --- ||| simpleFloat
--myLayout = tiled ||| Mirror tiled ||| Full ||| simpleTabbed --- ||| simpleFloat
--myLayout = onWorkspace "IM" (im) $ tiled ||| Mirror tiled ||| Full ||| simpleFloat
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100
      
     magrid = named "Magrid" (desktopLayoutModifiers (magnifier (Grid)))
     --noBorders (fullscreenFull Full)

--imLayout = Tall where
--    chatLayout      = Tall
--    ratio           = 1%6
--    rosters         = [skypeRoster, pidginRoster]
--    pidginRoster    = And (ClassName "Pidgin") (Role "buddy_list")
--    skypeRoster     = (ClassName "Skype") `And` (Not (Title "Options")) `And` (Not (Role "Chats")) `And` (Not (Role "CallWindowForm"))-- imLayout = 
--            chatLayout      = Grid
--
--
--Funkcni
--imLayout = IM (1%1) (And (ClassName "Pidgin") (Role "buddy_list")) 
--
--
--imLayout = IM 
--  where 
--     (1%1) (And (ClassName "Pidgin") (Role "buddy_list")) 
--     reflectHoriz
------------------------------------------------------------------------
-- Window rules:

-- Execute arbitrary actions and WindowSet manipulations when managing
-- a new window. You can use this to, for example, always float a
-- particular program, or have a client always appear on a particular
-- workspace.
--
-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
-- and click on the client you're interested in.
--
-- To match on the WM_NAME, you can use 'title' in the same way that
-- 'className' and 'resource' are used below.
--
myManageHook = composeAll
    [
          manageDocks
        , isFullscreen                     --> doFullFloat
        , isDialog                         --> doCenterFloat
        , className =? "Claws-mail"        --> doShift "Mail"
        , className =? "Vlc"               --> doShift "Media"
        , className =? "Chromium-browser"  --> doShift "Web"
        , className =? "Google-chrome"     --> doShift "Web"
        , className =? "Acroread"          --> doShift "Docs"
        , className =? "Pidgin"            --> doShift "IM"
        , resource  =? "irssi"             --> doShift "IM"
        , resource  =? "music"             --> doShift "Media"
    ]

------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()
--myLogHook = dynamicLogDzen
--myLogHook = dynamicLogDzen

------------------------------------------------------------------------
-- Startup hook

-- Perform an arbitrary action each time xmonad starts or is r#1B1D1Eestarted
-- with mod-q.  Used by, e.g., XMonad.Layout.PerWorkspace to initialize
-- per-workspace layout choices.
--
-- By default, do nothing.
myStartupHook = return ()
--myStartupHook = do
--	spawn "~/.xmonad/autostart.sh"



------------------------------------------------------------------------
-- Statusbar
-- Run statusbar with the settings you specify.
--
myStatusBar = "dzen2 " ++ myDzenOptions
-- -w 1162
myDzenOptions = "-y 748 -w 962 -h 18 -fn -*-terminus-medium-r-*-*-12-*-*-*-*-*-*-* -ta l -e 'onstart=lower'"
myBitmapsDir = "~/.xmonad/dzen2"

myPP = dzenPP
	{
        ppCurrent           =   dzenColor "white" "#3189FF" . pad
      , ppVisible           =   dzenColor "white" "#1B1D1E" . pad
      , ppHidden            =   dzenColor "white" "#1B1D1E" . pad
      , ppHiddenNoWindows   =   dzenColor "#7b7b7b" "#1B1D1E" . pad
      , ppUrgent            =   dzenColor "white" "#F21F2B" . pad
      , ppWsSep             =   " "
      , ppSep               =   "  |  "
      , ppLayout            =   dzenColor "#ebac54" "#1B1D1E"
      , ppTitle             =   (" " ++) . dzenColor "white" "#1B1D1E" . dzenEscape
     -- , ppOutput            =   hPutStrLn myPP
    }

-- Key binding to toggle the gap for the bar.
toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_F11)

------------------------------------------------------------------------
-- Now run xmonad with all the defaults we set up.
-- Run xmonad with the settings you specify. No need to modify this.
--
main = xmonad . withUrgencyHook NoUrgencyHook =<< statusBar myStatusBar myPP toggleStrutsKey defaults -- among several ways
		{
		 --manageHook = manageDocks <+> manageHook defaultConfig
		  manageHook    = myManageHook <+> manageHook defaultConfig -- uses default too
	      --, layoutHook = avoidStruts . smartBorders $ layoutHook defaultConfig
	      , layoutHook = avoidStruts . smartBorders $ layoutHook defaults

		}

------------------------------------------------------------------------
-- A structure containing your configuration settings, overriding
-- fields in the default config. Any you don't override, will
-- use the defaults defined in xmonad/XMonad/Config.hs
--
-- No need to modify this.
--

defaults = defaultConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        workspaces         = myWorkspaces,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

      -- hooks, layouts
        layoutHook         = myLayout,
        manageHook         = myManageHook,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook
    }

-- EOF
