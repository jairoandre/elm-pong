module Ball exposing (Ball, view, update)

import Graphics.Render as Render
import Color exposing (rgb)
import Util exposing (newPosition)


type alias Ball =
    { radius : Float
    , position : ( Float, Float )
    , velocitys : ( Float, Float )
    }


view : ( Float, Float ) -> Ball -> Render.Form msg
view offSet ball =
    Render.ellipse ball.radius ball.radius
        |> Render.solidFill Color.red
        |> Render.position (newPosition offSet ball.position)


update : ( Float, Float ) -> Ball -> Ball
update boardDimensions ball =
    let
        ( w, h ) =
            boardDimensions

        ( x, y ) =
            ball.position

        ( vx, vy ) =
            ball.velocitys

        ( nextX, nextVx ) =
            if (x + ball.radius) > w then
                ( w - ball.radius, vx * -1 )
            else if (x - ball.radius) < 0 then
                ( ball.radius, vx * -1 )
            else
                ( x + vx, vx )

        ( nextY, nextVy ) =
            if (y + ball.radius) > h then
                ( h - ball.radius, vy * -1 )
            else if (y - ball.radius) < 0 then
                ( ball.radius, vy * -1 )
            else
                ( y + vy, vy )
    in
        { ball | position = ( nextX, nextY ), velocitys = ( nextVx, nextVy ) }
