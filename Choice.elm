module Choice exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html


-- import String
--import Defaults

import ImageButton


-- MODEL


type alias Model =
    { label : String
    , button : ImageButton.Model
    }


model =
    { label = "X"
    , button = ImageButton.choice
    }


init : String -> Model
init label_ =
    --noFx
    { model
        | label = label_
    }


noFx model =
    ( model, Cmd.none )



-- UPDATE


type Msg
    = UpdateButton ImageButton.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateButton buttonMsg ->
            let
                button_ =
                    ImageButton.update buttonMsg model.button

                currentMsg_ =
                    .currentMsg button_
            in
                --noFx
                { model
                    | button = button_
                }



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ containerStyle ]
        --[ ImageButton.view buttonAddress model.button
        [ Html.map UpdateButton (ImageButton.view model.button)
        , p [ class "choiceText", paragraphStyle ] [ text model.label ]
        ]



-- CSS Styles


(=>) =
    (,)


containerStyle : Attribute msg
containerStyle =
    style
        [ "text-align" => "center"
        , "width" => "50%"
          --, "vertical-align" => "top"
          --, "display" => "inline-block"
          --, "zoom" => "1"
          --, "float" => "left"
          --, "background-color" => "pink"
          -- , "border" => "1px dashed black"
        , "padding" => "0 0.3em 0 0.3em"
        , "-webkit-user-select" => "none"
        , "-moz-user-select" => "none"
        , "-khtml-user-select" => "none"
        , "-ms-user-select" => "none"
        , "userSelect" => "none"
        , "line-height" => "1.3em"
        ]


paragraphStyle : Attribute msg
paragraphStyle =
    style
        [ "font-size" => "0.8em"
        , "font-family" => "Helvetica, Arial, sans-serif"
        , "padding" => "0.2em 1em 1.3em 1em"
        , "margin" => "0"
        , "line-height" => "1.3em"
        ]
