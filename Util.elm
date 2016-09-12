module Util exposing (newPosition)


type alias Position =
    ( Float, Float )


newPosition : Position -> Position -> Position
newPosition offSet position =
    let
        ( offX, offY ) =
            offSet

        ( x, y ) =
            position
    in
        ( x + offX, y + offY )
