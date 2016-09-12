module Experiments exposing (..)

import Html.App as App
import Html exposing (Html, div)
import Color exposing (rgb)
import Graphics.Render as Render
import Time


main : Program Never
main =
    App.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }



-- MODEL


type alias Model =
    { angle : Int
    , board : List Render.Point
    }


init : ( Model, Cmd Msg )
init =
    ( { angle = 0, board = [ ( 0, 0 ), ( 0, 100 ), ( 100, 100 ), ( 100, 0 ) ] }, Cmd.none )



-- UPDATE


type Msg
    = Tick Float


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Tick time ->
            ( { model | angle = model.angle + 10 }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every Time.second Tick



-- VIEW


board : Model -> Render.Form msg
board model =
    Render.polygon model.board
        |> Render.solidFill (rgb 255 0 0)


view : Model -> Html Msg
view model =
    div []
        [ board model
            |> Render.svg 400 400
        ]
