module Experiments exposing (..)

import Html.App as App
import Html exposing (Html, div, text)
import Color exposing (rgb)
import Graphics.Render as Render
import AnimationFrame


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
    { angle : Float
    , board : List Vec3
    }


type alias Vec3 =
    ( Float, Float, Float )


toRenderPoint : Vec3 -> Render.Point
toRenderPoint vec3 =
    let
        ( x, y, z ) =
            vec3

        dz =
            z + 50
    in
        ( x / dz, y / dz )


init : ( Model, Cmd Msg )
init =
    ( { angle = 0.001, board = [ ( -100, -100, 0 ), ( -100, 100, 0 ), ( 100, 100, 0 ), ( 100, -100, 0 ) ] }, Cmd.none )



-- UPDATE


type Msg
    = Tick Float


updateBoard : Model -> List Vec3
updateBoard model =
    List.map
        (\point ->
            let
                ( x, y, z ) =
                    point

                ca =
                    cos model.angle

                sa =
                    sin model.angle

                cx =
                    x * ca

                cy =
                    (y - 50) * ca

                cz =
                    (z - 50) * ca

                sx =
                    x * sa

                sy =
                    (y - 50) * sa

                sz =
                    (z - 50) * sa

                zz =
                    z

                newX =
                    x

                newY =
                    cy + sz

                newZ =
                    cz - sy
            in
                ( newX, newY, newZ )
        )
        model.board


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Tick time ->
            ( { model | board = updateBoard model }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    AnimationFrame.diffs Tick



-- VIEW


board : Model -> Render.Form msg
board model =
    Render.polygon (List.map toRenderPoint model.board)
        |> Render.solidFill (rgb 255 0 0)


view : Model -> Html Msg
view model =
    div []
        [ board model
            |> Render.svg 500 500
        ]
