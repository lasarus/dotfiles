import XMonad
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Layout 
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders   ( noBorders, smartBorders )
import XMonad.Layout.Tabbed
import XMonad.Layout.ToggleLayouts
import XMonad.Actions.MouseGestures
import XMonad.Layout.MouseResizableTile
import XMonad.Layout.Gaps
import XMonad.Layout.Spacing
import XMonad.Hooks.DynamicLog

myManageHook = composeAll
    [
    className =? "Zenity" --> doFloat
    , isFullscreen --> doFloat
    ]

-- layout = smartBorders $ {- gaps [(U, 16)] -} tiled ||| Mirror tiled ||| noBorders Full ||| (gaps [(U, 16), (R, 16), (L, 16), (D, 16)] $ mouseResizableTile)
layout = smartBorders $ {- gaps [(U, 16)] -} tiled ||| Mirror tiled ||| noBorders Full ||| (gaps [(U, 16), (R, 16), (L, 16), (D, 16)] $ mouseResizableTile)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

main = do
    xmonad $ defaultConfig
        {
	manageHook = manageDocks <+> myManageHook
			<+> manageHook defaultConfig
	, terminal = "urxvt"
        , modMask = mod4Mask
        , borderWidth = 1
	, layoutHook = layout

	-- , isFullscreen -?> doFullFloat
	-- , className =? "Xmessage"  --> doFloat
        } `additionalKeys`
        [
         ((mod4Mask, xK_s), spawn "setxkbmap se"),
         ((mod4Mask, xK_u), spawn "setxkbmap us")
        ]
