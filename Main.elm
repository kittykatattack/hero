module Main exposing (..)

import Adventure exposing (init, update, view, subscriptions)
import Html


main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }
