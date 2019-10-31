module Electron.Options (encodeOptions) where

import Data.Argonaut.Core (Json)
import Data.Argonaut.Encode (encodeJson)
import Data.Foldable (foldl)
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(Just))
import Data.Monoid ((<>))
import Foreign.Object as O
import Data.String (Pattern(..), drop, lastIndexOf, take, toLower)
import Prelude ((+), (>>>), unit, (#), map)

encodeOptions :: forall a. (Generic a) => Array a -> Json
encodeOptions = map toSpine >>> encodeOptions'

encodeOptions' :: Array GenericSpine -> Json
encodeOptions' = foldl insertOption O.empty >>> encodeJson
  where
  insertOption strMap option =
    case option of
      SProd qname [arg] -> O.insert (encodeKey qname) (encodeValue (force arg)) strMap
      _                 -> strMap
  encodeKey = simpleName >>> toCamelCase
  encodeValue (SArray options) = map force options # encodeOptions'
  encodeValue value = gEncodeJson' value
  force = (#) unit

toCamelCase :: String -> String
toCamelCase s = toLower (take 1 s) <> drop 1 s

simpleName :: String -> String
simpleName qname =
  case lastIndexOf (Pattern ".") qname of
    Just index -> drop (index + 1) qname
    _          -> qname
