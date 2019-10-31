module Electron.Remote.App (getAppPath, getPath, quit) where

import Effect (Effect)
import Electron.App (Path(..))
import Prelude (Unit, (>>>))


-- | The current application directory.
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/app#appgetapppath)
foreign import getAppPath :: Effect String

-- TODO: Remove this duplicate function when you figure out how to expose it
-- without it being part of the public API
-- Original function found in Electron.App
stringifyPath :: Path -> String
stringifyPath =
  case _ of
    Home -> "home"
    AppData -> "appData"
    UserData -> "userData"
    Temporary -> "temp"
    Executable -> "exe"
    Module -> "module"
    Desktop -> "desktop"
    Documents -> "documents"
    Downloads -> "downloads"
    Music -> "music"
    Pictures -> "pictures"
    Videos -> "videos"
    PepperFlash -> "pepperFlashSystemPlugin"

foreign import getPath_ :: String -> Effect String

-- | A path to a special directory or file.
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/app#appgetpathname)
getPath :: Path -> Effect String
getPath =
  stringifyPath >>> getPath_


-- | Try to close all windows.
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/app#appquit)
foreign import quit :: Effect Unit
