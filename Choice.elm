module Choice exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html


-- import String
--import Defaults

import LabeledButton


-- MODEL


type alias Model =
    { description : String
    , label : String
    , button : LabeledButton.Model
    }


model =
    { description = "No description"
    , label = "Choice"
    , button = LabeledButton.init "X" 30 50
    }


init : String -> String -> Model
init description_ label_ =
    --noFx
    { model
        | description = description_
        , button = LabeledButton.init label_ 30 50
    }


noFx model =
    ( model, Cmd.none )



-- UPDATE


type Msg
    = UpdateButton LabeledButton.Msg


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateButton buttonMsg ->
            let
                button_ =
                    LabeledButton.update buttonMsg model.button

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
        [ Html.map UpdateButton (LabeledButton.view model.button)
        , p [ class "choiceText", paragraphStyle ] [ text model.description ]
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
        , "display" => "flex"
        , "align-items" => "center"
        , "flex-direction" => "column"
        --, "justify-content" => "center" 
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
        , "padding" => "1em 1em 1.3em 1em"
        , "margin" => "0"
        , "line-height" => "1.3em"
        ]
