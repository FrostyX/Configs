--import XMonad
import XMonad hiding ((|||))
import Data.Ratio ((%))
import XMonad.Actions.NoBorders
import XMonad.Actions.Plane
import XMonad.Config.Gnome
import XMonad.Config.Desktop
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
--import XMonad.Layout
import XMonad.Layout.Circle
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Magnifier
import XMonad.Layout.Named
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.WindowNavigation
import XMonad.Prompt
import XMonad.Prompt.Workspace
import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Util.EZConfig
import XMonad.Util.NamedWindows (getName)
import qualified Data.Map as M
import qualified XMonad.StackSet as W
import System.IO

myFont = "xft:Tahoma:size=8"

myTheme :: Theme
myTheme = defaultTheme
	{ 
		activeColor		= "#83b9e7"
		,inactiveColor		= "#4d4d4d"
		,urgentColor		= "#4d4d4d"
		,activeTextColor	= "#4d4d4d"
		,inactiveTextColor	= "#dfdfdf"
		,urgentTextColor	= "#ff0000"
		,activeBorderColor	= "#83b9e7"
		,inactiveBorderColor	= "#7298b8"
		,urgentBorderColor	= "#ff0000"
		,fontName		= myFont
		,decoHeight		= 18
	}

--myManageHook = composeAll . concat $
--	[ 
--	  [ className                        =? c --> doFloat           | c <- floatsList ]
--	, [ className                        =? c --> doIgnore          | c <- ignoresList ]
--	, [ stringProperty "WM_WINDOW_ROLE"  =? p --> doFloat           | p <- bigFloatsList ]
--	, [ className                        =? c --> doF (W.shift "WB") | c <- toThird ]
--	, [ className                        =? c --> doF (W.shift "IM") | c <- toFourth ]
--	, [ className                        =? c --> doF (W.shift "MA") | c <- toFifth ]
--	, [ className                        =? c --> doF (W.shift "FS") | c <- toFileSystem ]
--	, [ className                        =? c --> doF (W.shift "TW") | c <- toTemp ]
--	, [ className                        =? c --> doF (W.shift "MM") | c <- toMultiMedia ]
--	, [ className                        =? c --> doF (W.shift "BH") | c <- toBlackHole ]
--	, [ className                        =? c --> doF (W.shift "MP") | c <- toMusicPlayer ]
--	, [ className                        =? c --> doF (W.shift "GE") | c <- toGraphic ]
--	, [ className                        =? c --> doF (W.shift "GG") | c <- toGaming ]
--	]
--
--toThird = [ "Iceweasel", "Firefox", "Navigator", "Minefield", "chromium-browser", "Chromium-browser" ]
--toFourth = [ "Pidgin", "Skype", "Gwibber", "gwibber", "gajim.py", "Gajim.py" ]
--toFifth = [ "claws-mail", "Claws-mail" ]
--toFileSystem = [ "nautilus", "Nautilus" ]
--toMultiMedia = [ "mplayer", "MPlayer", "smplayer", "vlc", "Vlc" ]
--toTemp = [ "OpenOffice.org 3.2", "Revelation", "revelation" ]
--toBlackHole = [ "blackhole" ]
--toMusicPlayer = [ "clementine", "Clementine" ]
--toGraphic = [ "Gimp-2.6", "gimp-2.6", "Inkscape", "inkscape", "gimp-2.7", "Gimp-2.7" ]
--toGaming = [ "Wine", "heroes-of-newerth", "Heroes of Newerth", "hon-x86_64" ]
--ignoresList = [ "stalonetray", "notification-daemon", "Notification-daemon" ]
--floatsList = [ "pinentry-gtk-2", "cryptkeeper", "Cryptkeeper", "spring", "Spring", "wine", "Wine", "smplayer", "Smplayer", "mplayer", "MPlayer", "vlc", "Vlc" ]
--bigFloatsList = 
--	[
--		"gimp-toolbox-color-dialog"
--		,"gimp-layer-new"
--		,"gimp-vectors-edit"
--		,"gimp-dock"
--		,"gimp-levels-tool"
--		,"preferences"
--		,"gimp-keyboard-shortcuts-dialog"
--		,"gimp-modules"
--		,"unit-editor"
--		,"screenshot"
--		,"gimp-message-dialog"
--		,"gimp-tip-of-the-day"
--		,"plugin-browser"
--		,"procedure-browser"
--		,"gimp-display-filters"
--		,"gimp-color-selector"
--		,"gimp-file-open-location"
--		,"gimp-color-balance-tool"
--		,"gimp-hue-saturation-tool"
--		,"gimp-colorize-tool"
--		,"gimp-brightness-contrast-tool"
--		,"gimp-threshold-tool"
--		,"gimp-curves-tool"
--		,"gimp-posterize-tool"
--		,"gimp-desaturate-tool"
--		,"gimp-scale-tool"
--		,"gimp-shear-tool"
--		,"gimp-perspective-tool"
--		,"gimp-rotate-tool"
--		,"file transfer"
--	]

myManageHook = composeAll . concat $
	[ 
	  [ className		=? c --> doFloat				| c <- floatsList ]
	, [ className		=? c --> doIgnore				| c <- ignoresList ]
	, [ className		=? c --> doF (W.shift "web")	| c <- toWeb ]
	, [ className		=? c --> doF (W.shift "com")	| c <- toCom ]
	, [ className		=? c --> doF (W.shift "fun")	| c <- toFun ]
	, [ className		=? c --> doF (W.shift "uti")	| c <- toUti ]
	, [ className		=? c --> doSideFloat NE			| c <- notifDaemon ]
	, [ className		=? c --> doCenterFloat			| c <- kupferLauncher ]
	, [ isDialog		-->	doCenterFloat ]
	]
--	, [ role	=?  "_NET_WM_WINDOW_TYPE_NOTIFICATION" --> doSideFloat NW ]
--	] where
--		role = stringProperty "_NET_WM_WINDOW_TYPE(ATOM)"

kupferLauncher = [ "kupfer.py", "Kupfer.py" ]
notifDaemon = [ "notification-daemon", "Notification-daemon" ]

toWeb = [ "Iceweasel", "Firefox", "Navigator", "Minefield", "chromium-browser", "Chromium-browser" ]
toCom = [ "Pidgin", "Skype", "Gwibber", "gwibber", "gajim.py", "Gajim.py", "claws-mail", "Claws-mail", "ts3client_linux_amd64", "Ts3client_linux_amd64" ]
toUti = [ "keepassx", "Keepassx", "gnomint" ]
toFun = [	"mplayer"
			,"MPlayer"
			,"ffplay"
			,"smplayer"
			,"Smplayer"
			,"vlc"
			,"Vlc"
			,"Gimp-2.6"
			,"gimp-2.6"
			,"Inkscape"
			,"inkscape"
			,"gimp-2.7"
			,"Gimp-2.7"
			,"Wine"
			,"heroes-of-newerth"
			,"Heroes of Newerth"
			,"hon-x86_64"
		]

floatsList = [	"pinentry-gtk-2"
				,"cryptkeeper"
				,"Cryptkeeper"
				,"spring"
				,"Spring"
				,"wine"
				,"Wine"
				,"ffplay"
				,"smplayer"
				,"Smplayer"
				,"mplayer"
				,"MPlayer"
				,"vlc"
				,"Vlc"
				,"kupfer.py"
				,"Kupfer.py"
			 ]

ignoresList = [ "stalonetray", "notification-daemon", "Notification-daemon" ]


myPP h = defaultPP 
	{ 

		ppCurrent = wrap "^bg(#83b9e7)^r(5x0)^fg(#ffffff)" "^r(5x0)"
		,ppVisible = wrap "" ""
		,ppHidden = wrap "^bg(#4d4d4d)^r(5x0)" "^r(5x0)"
		,ppHiddenNoWindows = wrap "^bg(#404040)^r(5x0)^fg(#7298b8)" "^r(5x0)"
		,ppUrgent = wrap "^bg(#ef5835)^r(5x0)^fg(#ffffff)" "^r(5x0)"
		,ppSep = "^p(0)^bg()"
		,ppWsSep = "^bg(#404040)^r(1x0)^fg(#e5e5e5)"
		,ppTitle = wrap "^fg(#83b9e7)^p(+5)<^p(+5)^fg(#e5e5e5)" "^fg()^fg(#83b9e7)^p(+5)>^fg()" . shorten 75
		,ppLayout  = wrap "^bg(#313433)^r(1x0)^bg()^fg(#e5e5e5)^p(+6)" "^p(+6)^bg(#313433)^r(1x0)^bg()" .
			(\x -> case x of
				"Magrid" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/magrid.xbm)"
				"Tall" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/tall.xbm)"
				"Mirror" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/mirror.xbm)"
				"Full" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/full.xbm)"
				"TrueFull" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/full.xbm)"
				"Tabbed" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/tabbed.xbm)"
--				"IM" ->			"^i(/datastore/home/asfethan/.local/share/dzen2/images/im.xbm)"
				"Grid" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/grid.xbm)"
				"GIMP" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/gimp.xbm)"
--				"VTT" ->		"^i(/datastore/home/asfethan/.local/share/dzen2/images/vtt.xbm)"
			)
		,ppOutput = hPutStrLn h
	}

--myWorkspaces = ["RT", "LT", "WB", "IM", "MA", "FS", "TW", "MM", "BH", "MP", "GE", "GG"]
myWorkspaces = ["rem", "loc", "web", "com", "fun", "uti" ]

defaultKeys = keys defaultConfig
newKeys x = foldr M.delete (defaultKeys x) (removedKeys x)
myKeys x = (newKeys x) `M.union` (addedKeys x)

addedKeys conf = mkKeymap conf $
	[ 
		("M-p", spawn "/usr/bin/kupfer")
		,("M-a g", spawn "/usr/bin/gvim")
		,("M-a f", spawn "/usr/bin/firefox")
		,("M-a s", spawn "/usr/bin/smplayer")
		,("M-r t", spawn "killall stalonetray && /home/asfethan/bin/stalonetray &")
--		Multimedia keys
		,("M-m", spawn "/usr/bin/mocp -p")
		,("M-x", spawn "/usr/bin/xlock -mode blank -dpmsoff 10")
		,("M-z", spawn "sleep 5 && /usr/bin/xset dpms force off")
		,("<XF86AudioLowerVolume>", spawn "/usr/bin/amixer set -c 0 Master 2%- unmute")
		,("<XF86AudioRaiseVolume>", spawn "/usr/bin/amixer set -c 0 Master 2%+ unmute")
		,("<XF86AudioMute>", spawn "/usr/bin/amixer set -c 0 Master toggle")
		,("<XF86AudioPlay>", spawn "/usr/bin/mocp -G")
		,("<XF86AudioNext>", spawn "/usr/bin/mocp -f")
		,("<XF86AudioPrev>", spawn "/usr/bin/mocp -r")
		,("<XF86AudioStop>", spawn "/usr/bin/mocp -s")
--		,("M-<Up>", windows W.focusUp)
--		,("M-<Down>", windows W.focusDown)
		,("M-<Return>", spawn $ XMonad.terminal conf)
		,("M-<Up>",  sendMessage $ Go U)
		,("M-<Down>", sendMessage $ Go D)
		,("M-<Left>", sendMessage $ Go L)
		,("M-<Right>",sendMessage $ Go R)
		,("M-S-<Up>", sendMessage $ Swap U)
		,("M-S-<Down>", sendMessage $ Swap D)
		,("M-S-<Left>", sendMessage $ Swap L)
		,("M-S-<Right>", sendMessage $ Swap R)
		,("M-S-<Return>", windows W.swapMaster)
--		,("M-S-q", spawn "gnome-session-quit --logout")
	]
	++
	[
		(m ++ "M4-" ++ "<F" ++ show k ++ ">", windows $ f i) | (i, k) <- zip myWorkspaces [ 1 .. 12 ]
		, (f, m) <- [(W.view, ""), (W.shift, "S-")]
	]

removedKeys conf@(XConfig {XMonad.modMask = modm}) =
	[
		(modm, xK_p)
		,(modm, xK_r)
		,(modm, xK_m)
		,(modm, xK_Return)
		,(modm .|. shiftMask, xK_Return)
--		,(modm .|. shiftMask, xK_q)
	]
	++
	[
		(modm, k) | k <- [xK_1 .. xK_9]
	]
	++
	[
		(shiftMask, k) | k <- [xK_1 .. xK_9]
	]

main = do
--	mainSbar	<- spawnPipe "/usr/bin/dzen2 -p -x '0' -y '0' -w '793' -h '20' -ta 'l' -fg '#e5e5e5' -bg '#4d4d4d' -fn '-*-terminus-medium-r-*-*-12-*-*-*-*-*-iso10646-1' -e 'button2=exit:13'"
	mainSbar	<- spawnPipe "/usr/bin/xmobar /home/asfethan/.xmobarrc"
	xmonad	$ withUrgencyHookC NoUrgencyHook urgencyConfig { suppressWhen = Focused }
		$ gnomeConfig
		{
			manageHook = myManageHook <+> manageDocks
--			,logHook		= ewmhDesktopsLogHook >> dynamicLogWithPP ( myPP mainSbar )
			,logHook		= ewmhDesktopsLogHook >> dynamicLogWithPP xmobarPP
														{ ppOutput = hPutStrLn mainSbar
														, ppTitle				= wrap " <fc=#83b9e7>«</fc><fc=#dfdfdf> " " </fc><fc=#83b9e7>»</fc>" . shorten 75
														, ppCurrent 			= wrap "<fc=#ffffff,#83b9e7> " " </fc>"
														, ppVisible 			= wrap "" ""
														, ppHidden				= wrap "<fc=#dfdfdf,#4d4d4d> " " </fc>"
														, ppHiddenNoWindows		= wrap "<fc=#252525,#484848> " " </fc>"
														, ppUrgent				= wrap "<fc=#ffffff,#ef5835> " " </fc>"
														, ppSep					= ""
														, ppWsSep				= ""
														, ppLayout				= wrap "<fc=,#404040> </fc><fc=#bfbfbf> " " </fc><fc=,#404040> </fc> " .
															(\x -> case x of
																"Magrid"	-> "MGRD"
																"Tall"		-> "TALL"
																"Mirror"	-> "MIRR"
																"Full"		-> "FULL"
																"TrueFull"	-> "TFUL"
																"Tabbed"	-> "TABB"
																"Grid"		-> "GRID"
																"GIMP"		->"^GIMP"
															)
														}

			,terminal 		= "xterm"
			,normalBorderColor	= "#4d4d4d"
			,focusedBorderColor	= "#83b9e7"
			,modMask		= mod4Mask
            ,focusFollowsMouse = False
			,borderWidth		= 1
			,workspaces		= myWorkspaces
			,keys			= myKeys
			,layoutHook		= myLayout
		}

myLayout = windowNavigation
        $ smartBorders
--        $ onWorkspace "IM" (full)
--        $ onWorkspace "WB" (tabs)
--        $ onWorkspace "MA" (tabs)
--        $ onWorkspace "MM" (tfull)
--        $ onWorkspace "MP" (full)
--        $ onWorkspace "GE" (gimp)
--        $ onWorkspace "GG" (tfull)
--        $ (magrid ||| vtiled ||| htiled ||| full ||| tfull ||| tabs ||| grid ||| gimp)
        $ onWorkspace "web" (tabs)
        $ onWorkspace "com" (tabs)
        $ onWorkspace "fun" (tfull)
        $ (magrid ||| vtiled ||| htiled ||| full ||| tabs ||| grid)

	 where
		htiled = named "Tall" (avoidStrutsOn [U,D] (Tall 1 (3/100) (1/2)))
		vtiled = named "Mirror" (avoidStrutsOn [U,D] (Mirror (Tall 1 (3/100) (1/2))))
		magrid = named "Magrid" (desktopLayoutModifiers (magnifier (Grid)))
		full   = named "Full" (avoidStrutsOn [U,D] (noBorders (Full)))
		tfull  = named "TrueFull" (lessBorders (OnlyFloat) ( noBorders (Full)))
		tabs   = named "Tabbed" (avoidStrutsOn [U,D] (smartBorders (tabbed shrinkText myTheme)))
--		im     = named "IM" (spacing 5 ((withIM(1%4) (ClassName "Gwibber") . (reflectHoriz . withIM (2%9) (Role "buddy_list"))) (Mirror (Tall 1 (3/100) (1/2)))))
--		im     = named "IM" (avoidStrutsOn [U,D] ((reflectHoriz . withIM (1%6) (Role "buddy_list")) (reflectHoriz $ tabbed shrinkText myTheme)))
--		im     = named "IM" (avoidStrutsOn [U,D] (spacing 5 ((withIM (1%6) (Role "buddy_list")) (Grid))))
		grid   = named "Grid" (avoidStrutsOn [U,D] (Grid))
--		gimp   = named "GIMP" (avoidStrutsOn [U,D] (spacing 5 (withIM (1%5) (Role "gimp-toolbox") (Mirror (Tall 1 (3/100) (1/2))))))
--		vtt    = named "VTT" (avoidStrutsOn [U,D] (reflectVert (reflectVert(tabbed shrinkText myTheme) */** (vtiled))))
--		vtt    = named "VTT" (subTabbed (Tall 1 (3/100) (1/2)))
-- EOF
