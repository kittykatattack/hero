module Test exposing (..)

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Defaults


-- MODEL


type alias Model =
    { label : String
    , currentAction : Action
    }


model : Model
model =
    { label = "X"
    , currentAction = Up
    }


init : String -> ( Model, Effects Action )
init label_ =
    noFx
        { model
            | label = label_
        }


noFx model =
    ( model, Effects.none )



-- UPDATE


type Action
    = Up
    | Over
    | Down
    | NoOp


update : Action -> Model -> ( Model, Effects Action )
update action model =
    case action of
        Up ->
            noFx
                { model
                    | currentAction = action
                }

        Over ->
            noFx
                { model
                    | currentAction = action
                }

        Down ->
            noFx
                { model
                    | currentAction = action
                }

        NoOp ->
            noFx model



-- VIEW


view : Signal.Address Action -> Model -> Html
view address model =
    button
        [ buttonStyle model
        , onMouseOver address Over
        , onMouseOut address Up
        , onMouseDown address Down
        ]
        [ text model.label ]



-- Create a custom infix operator to reduce the number of
-- parentheses when adding CSS attributes


(=>) =
    (,)


buttonStyle : Model -> Attribute
buttonStyle model =
    style
        [ "background" => "#3498db"
        , "background-image" => "webkit-linear-gradient(top, #3498db, #2980b9)"
        , "background-image" => "-moz-linear-gradient(top, #3498db, #2980b9)"
        , "background-image" => "-ms-linear-gradient(top, #3498db, #2980b9)"
        , "background-image" => "-o-linear-gradient(top, #3498db, #2980b9)"
        , "background-image" => "linear-gradient(to bottom, #3498db, #2980b9)"
        , "webkit-border-radius" => "5"
        , "-moz-border-radius" => "5"
        , "border-radius" => "5px"
        , "font-family" => "Arial, Helvetica, sans"
        , "color" => "#ffffff"
        , "font-size" => "13px"
        , "padding" => "10px 20px 10px 20px"
        , "text-decoration" => "none"
        ]
