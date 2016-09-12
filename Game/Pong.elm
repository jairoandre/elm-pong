module Game.Pong exposing (Model, init, update, view, subscriptions)

import Graphics.Render as Render
import Html exposing (Html, div)
import Ball exposing (Ball, view, update)
import Color
import AnimationFrame


type alias Model =
    { dimensions : ( Float, Float )
    , ball : Ball
    }


boardDimensions : ( Float, Float )
boardDimensions =
    ( 1200, 600 )


offSet : ( Float, Float )
offSet =
    let
        ( w, h ) =
            boardDimensions
    in
        ( w / -2, h / -2 )


ballInitialPosition : ( Float, Float )
ballInitialPosition =
    ( 600, 300 )


ballInitialVelocitys : ( Float, Float )
ballInitialVelocitys =
    ( 10, 10 )


init : Model
init =
    { dimensions = boardDimensions
    , ball = Ball 10 ballInitialPosition ballInitialVelocitys
    }



-- UPDATE


type Msg
    = Tick Float


update : Msg -> Model -> Model
update message model =
    case message of
        Tick df ->
            { model | ball = Ball.update boardDimensions model.ball }



-- VIEW


board : Model -> Render.Form msg
board model =
    let
        ( w, h ) =
            model.dimensions
    in
        Render.rectangle w h
            |> Render.solidFillWithBorder Color.grey 1 Color.black


view : Model -> Html msg
view model =
    let
        ( w, h ) =
            model.dimensions
    in
        div []
            [ Render.group
                [ board model
                , Ball.view offSet model.ball
                ]
                |> Render.svg w h
            ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch [ AnimationFrame.diffs Tick ]
