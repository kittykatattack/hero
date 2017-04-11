module LabeledButton exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Defaults


-- MODEL


type alias Model =
    { label : String
    , currentMsg : Msg
    , x : Int
    , y : Int
    }


model : Model
model =
    { label = "X"
    , currentMsg = Up
    , x = 0
    , y = 0
    }


init : String -> Int -> Int -> Model
init label_ x_ y_ =
    { model
        | label = label_
        , x = x_
        , y = y_
    }


noFx model =
    ( model, Cmd.none )



-- UPDATE


type Msg
    = Up
    | Over
    | Down
    | Click
    | NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        Up ->
            --noFx
            { model
                | currentMsg = msg
            }

        Over ->
            -- noFx
            { model
                | currentMsg = msg
            }

        Down ->
            -- noFx
            { model
                | currentMsg = msg
            }

        Click ->
            -- noFx
            { model
                | currentMsg = msg
            }

        NoOp ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    button
        [ buttonStyle model
        , onMouseOver Over
        , onMouseOut Up
        , onMouseDown Down
        , onClick Click
        , class "selectableButton"
        --, autofocus True
                            ]
        [ text model.label ]



-- Create a custom infix operator to reduce the number of
-- parentheses when adding CSS attributes


(=>) =
    (,)


buttonStyle : Model -> Attribute msg
buttonStyle model =
    let
        up =
            [ "background" => "#3498db"
            , "background-image" => "webkit-linear-gradient(top, #3498db, #2980b9)"
            , "background-image" => "-moz-linear-gradient(top, #3498db, #2980b9)"
            , "background-image" => "-ms-linear-gradient(top, #3498db, #2980b9)"
            , "background-image" => "-o-linear-gradient(top, #3498db, #2980b9)"
            , "background-image" => "linear-gradient(to bottom, #3498db, #2980b9)"
            , "height" => "2em"
            , "webkit-border-radius" => "5"
            , "-moz-border-radius" => "5"
            , "border-radius" => "5px"
            , "font-family" => "Arial, Helvetica, sans"
            , "color" => "#ffffff"
            , "font-size" => "18px"
            , "padding" => "0px 10px 0px 10px"
            , "text-decoration" => "none"
            , "cursor" => "pointer"
            , "-webkit-user-select" => "none"
            , "-moz-user-select" => "none"
            , "-khtml-user-select" => "none"
            , "-ms-user-select" => "none"
            , "userSelect" => "none"
            , "outline" => "0"
            , "display" => "block"
            ]

        over =
            [ "background" => "#3cb0fd"
            , "background-image" => "-webkit-linear-gradient(top, #3cb0fd, #3498db)"
            , "background-image" => "-moz-linear-gradient(top, #3cb0fd, #3498db)"
            , "background-image" => "-ms-linear-gradient(top, #3cb0fd, #3498db)"
            , "background-image" => "-o-linear-gradient(top, #3cb0fd, #3498db)"
            , "background-image" => "linear-gradient(to bottom, #3cb0fd, #3498db)"
            , "height" => "2em"
            , "text-decoration" => "none"
            , "webkit-border-radius" => "5"
            , "-moz-border-radius" => "5"
            , "border-radius" => "5px"
            , "font-family" => "Arial, Helvetica, sans"
            , "color" => "#ffffff"
            , "font-size" => "18px"
            , "padding" => "0px 10px 0px 10px"
            , "text-decoration" => "none"
            , "cursor" => "pointer"
            , "-webkit-user-select" => "none"
            , "-moz-user-select" => "none"
            , "-khtml-user-select" => "none"
            , "-ms-user-select" => "none"
            , "userSelect" => "none"
            , "outline" => "0"
            , "display" => "block"
            ]
    in
        case model.currentMsg of
            Up ->
                style up

            Over ->
                style over

            Down ->
                style over

            Click ->
                style up

            NoOp ->
                style up
