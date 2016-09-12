module Main exposing (..)

import Html.App
import Game.Pong


main : Program Never
main =
    Html.App.program
        { init = ( Game.Pong.init, Cmd.none )
        , subscriptions = Game.Pong.subscriptions
        , update =
            \msg model ->
                ( Game.Pong.update msg model
                , Cmd.none
                )
        , view = Game.Pong.view
        }
