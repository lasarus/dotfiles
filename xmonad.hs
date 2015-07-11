import XMonad

main = do
    xmonad $ defaultConfig
        { terminal = "konsole"
        , modMask = mod4Mask
        , borderWidth = 1
        }
