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
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.InsertPosition

myManageHook = composeAll
    [
    className =? "Zenity" --> doFloat
    , className =? "boltzmann" --> insertPosition Below Older
    , isFullscreen --> doFloat
    ]

-- layout = smartBorders $ {- gaps [(U, 16)] -} tiled ||| Mirror tiled ||| noBorders Full ||| (gaps [(U, 16), (R, 16), (L, 16), (D, 16)] $ mouseResizableTile)
-- layout = smartBorders $ tiled ||| Mirror tiled ||| noBorders Full ||| (gaps [(U, 16), (R, 16), (L, 16), (D, 16)] $ mouseResizableTile)
layout = smartBorders tiled ||| noBorders Full
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
    xmonad $ def
        {
	manageHook =  manageDocks <+> myManageHook
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
