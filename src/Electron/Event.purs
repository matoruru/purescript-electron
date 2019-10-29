module Electron.Event (Event, preventDefault, stopPropagation) where

import Prelude (Unit)

foreign import data Event :: Type

foreign import preventDefault :: Event -> Effect Unit

foreign import stopPropagation :: Event -> Effect Unit
