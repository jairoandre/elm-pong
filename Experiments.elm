module Experiments exposing (..)

import Html.App as App
import Html exposing (Html, div, text)
import Color exposing (rgb)
import Graphics.Render as Render
import AnimationFrame
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
    { angle : Float
    , board : List Vec3
    , acumulate : Float
    }


type alias Vec3 =
    ( Float, Float, Float )


toRenderPoint : Vec3 -> Render.Point
toRenderPoint vec3 =
    let
        ( x, y, z ) =
            vec3

        pZ =
            z - 30
    in
        ( x / pZ, y / pZ )


d =
    600


zIdx =
    0


init : ( Model, Cmd Msg )
init =
    ( { angle = 0.01
      , board =
            [ ( -d, -d, zIdx )
            , ( -d, d, -zIdx )
            , ( d, d, -zIdx )
            , ( d, -d, zIdx )
            ]
      , acumulate = 0
      }
    , Cmd.none
    )



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
                    model.angle |> degrees |> cos

                sa =
                    model.angle |> degrees |> sin

                newX =
                    x

                newY =
                    ca * y + sa * z

                newZ =
                    ca * z - sa * y
            in
                ( newX, newY, newZ )
        )
        model.board


maxAcumulate =
    1


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Tick time ->
            let
                newAngle =
                    if model.acumulate > maxAcumulate then
                        if model.angle > 0 then
                            -model.angle
                        else
                            model.angle
                    else if model.acumulate < -maxAcumulate then
                        if model.angle < 0 then
                            -model.angle
                        else
                            model.angle
                    else
                        model.angle
            in
                ( { model | angle = newAngle, board = updateBoard model, acumulate = model.acumulate + model.angle }, Cmd.none )



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
        [ div [] [ model |> toString |> text ]
        , board model
            |> Render.svg 500 500
        ]
