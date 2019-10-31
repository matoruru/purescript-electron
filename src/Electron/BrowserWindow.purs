module Electron.BrowserWindow
  ( BrowserWindow
  , newBrowserWindow
  -- Browser Window Options
  , BrowserWindowOptions
  , defaultBrowserWindowOptions
  , changeWidth
  , changeHeight
  , hidden
  , frameless
  , allowRunningInsecureContent
  , changeZoomFactor
  -- Instance Methods
  , close
  , loadURL
  , minimize
  , show
  -- Instance Events
  , onClose
  , onClosed
  , onceReadyToShow
  , WebContents
  , webContents
  , onDidFinishLoad
  , onDidGetRedirectRequest
  , onDidNavigate
  , onDidNavigateInPage
  , onDomReady
  , onNewWindow
  , onWillNavigate
  , DevToolOption(Detach)
  , openDevTools
  , send
  ) where

import Data.Argonaut.Core (Json)
import Data.Generic.Rep (class Generic)
import Effect (Effect)
import Electron.Event (Event)
import Electron.Options (encodeOptions)
import Prelude (Unit, (>>>))


foreign import data BrowserWindow :: Type

foreign import newBrowserWindow :: BrowserWindowOptions -> Effect BrowserWindow


newtype BrowserWindowOptions
  = BrowserWindowOptions
    { width :: Int
    , height :: Int
    , show :: Boolean
    , frame :: Boolean
    , webPreferences ::
      { allowRunningInsecureContent :: Boolean
      , zoomFactor :: Number
      }
    }

defaultBrowserWindowOptions :: BrowserWindowOptions
defaultBrowserWindowOptions =
  BrowserWindowOptions
    { width: 800
    , height: 600
    , show: true
    , frame: true
    , webPreferences:
      { allowRunningInsecureContent: false
      , zoomFactor: 1.0
      }
    }


-- | Change the window's width in pixels. Default is 800.
changeWidth :: Int -> BrowserWindowOptions -> BrowserWindowOptions
changeWidth width (BrowserWindowOptions opts) =
  BrowserWindowOptions opts { width = width }


-- | Change the window's height in pixels. Default is 600.
changeHeight :: Int -> BrowserWindowOptions -> BrowserWindowOptions
changeHeight height (BrowserWindowOptions opts) =
  BrowserWindowOptions opts { height = height }


-- | Do not show the window when created.
hidden :: BrowserWindowOptions -> BrowserWindowOptions
hidden (BrowserWindowOptions opts) =
  BrowserWindowOptions opts { show = false }


-- | Open a window without toolbars, borders, or other graphical "chrome".
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/frameless-window)
frameless :: BrowserWindowOptions -> BrowserWindowOptions
frameless (BrowserWindowOptions opts) =
  BrowserWindowOptions opts { frame = false }


-- | Allow an https page to run JavaScript, CSS or plugins from http URLs.
allowRunningInsecureContent :: BrowserWindowOptions -> BrowserWindowOptions
allowRunningInsecureContent (BrowserWindowOptions opts) =
  BrowserWindowOptions opts { webPreferences { allowRunningInsecureContent = true } }


-- | The default zoom factor of the page, `3.0` represents `300%`. Default is
-- | `1.0`.
changeZoomFactor :: Number -> BrowserWindowOptions -> BrowserWindowOptions
changeZoomFactor zoom (BrowserWindowOptions opts) =
  BrowserWindowOptions opts { webPreferences { zoomFactor = zoom } }


-- | Try to close the window. This has the same effect as a user manually
-- | clicking the close button of the window. The web page may cancel the close
-- | though.
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/browser-window#winclose)
foreign import close :: BrowserWindow -> Effect Unit


foreign import loadURL :: BrowserWindow -> String -> Effect Unit


-- | Minimizes the window. On some platforms the minimized window will be shown
-- | in the Dock.
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/browser-window#winminimize)
foreign import minimize :: BrowserWindow -> Effect Unit


-- | Shows and gives focus to the window.
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/browser-window#winshow)
foreign import show :: BrowserWindow -> Effect Unit


foreign import onClose :: BrowserWindow -> Effect Unit -> Effect Unit


-- | Emitted when the window is closed. After you have received this event you
-- | should remove the reference to the window and avoid using it any more.
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/browser-window#event-closed)
foreign import onClosed :: BrowserWindow -> Effect Unit -> Effect Unit


-- | Emitted when the web page has been rendered (while not being shown) and
-- | window can be displayed without a visual flash.
-- |
-- | [Official Electron documentation](https://electronjs.org/docs/api/browser-window#event-ready-to-show)
foreign import onceReadyToShow :: BrowserWindow -> Effect Unit -> Effect Unit


foreign import data WebContents :: Type

foreign import webContents :: BrowserWindow -> Effect WebContents


foreign import onDidFinishLoad :: WebContents -> Effect Unit -> Effect Unit


-- | Emitted when a redirect is received while requesting a resource.
-- |
-- | [Official Electron documentation](http://electron.atom.io/docs/api/web-contents/#event-did-get-redirect-request)
foreign import onDidGetRedirectRequest :: WebContents -> (Event -> String -> String -> Boolean -> Int -> String -> String -> Object String -> Effect Unit) -> Effect Unit


-- | Emitted when a navigation is done.
-- |
-- | [Official Electron documentation](http://electron.atom.io/docs/api/web-contents/#event-did-navigate)
foreign import onDidNavigate :: WebContents -> (Event -> String -> Effect Unit) -> Effect Unit


-- | Emitted when an in-page navigation happened.
-- |
-- | [Official Electron documentation](http://electron.atom.io/docs/api/web-contents/#event-did-navigate-in-page)
foreign import onDidNavigateInPage :: WebContents -> (Event -> String -> Effect Unit) -> Effect Unit


-- | Emitted when the document in the given frame is loaded.
-- |
-- | [Official Electron documentation](http://electron.atom.io/docs/api/web-contents/#event-dom-ready)
foreign import onDomReady :: WebContents -> (Event -> Effect Unit) -> Effect Unit


foreign import onNewWindow :: WebContents -> (Event -> String -> Effect Unit) -> Effect Unit


foreign import onWillNavigate :: WebContents -> (Event -> String -> Effect Unit) -> Effect Unit


data DevToolOption
  = Detach Boolean

derive instance genericDevToolOption :: Generic DevToolOption

-- | Opens the devtools.
-- |
-- | [Official Electron documentation](http://electron.atom.io/docs/all/#webcontents-opendevtools-options)
openDevTools :: WebContents -> Array DevToolOption -> Effect Unit
openDevTools wc =
  encodeOptions >>> openDevToolsImpl wc

foreign import openDevToolsImpl :: WebContents -> Json -> Effect Unit


foreign import send :: WebContents -> String -> Json -> Effect Unit
