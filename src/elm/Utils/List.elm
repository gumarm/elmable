module Utils.List exposing (..)

import Array
import Maybe

getByIndex : List a -> Int -> a -> a
getByIndex list index default = 
  Array.get index (Array.fromList list)
    |> Maybe.withDefault default