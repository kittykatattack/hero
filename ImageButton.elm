module ImageButton exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Defaults


-- import Defaults
-- MODEL


type alias Model =
    { width : Int
    , height : Int
    , currentMsg : Msg
    , baseBackgroundImage : String
    , backgroundImage : String
    }


model : Model
model =
    { width = 32
    , height = 32
    , currentMsg = Up
    , baseBackgroundImage = "next"
    , backgroundImage = Defaults.imagesLocation ++ "nextButtonUp.png"
    }


init : String -> Int -> Int -> Model
init baseBackgroundImage_ width_ height_ =
    let
        backgroundImage_ =
            Defaults.imagesLocation
                ++ baseBackgroundImage_
                ++ "Button"
                ++ "Up"
                ++ ".png"
    in
        -- noFx
        { model
            | baseBackgroundImage = baseBackgroundImage_
            , backgroundImage = backgroundImage_
            , width = width_
            , height = width_
        }



-- Preconfigured buttons
-- The `choice` button is used for multiple choices


choice =
    init "star" 40 20



-- The `next` button is used to proceed to the next page


next =
    init "next" 26 27



-- The `next` button is used to proceed to the next page


info =
    init "info" 32 32



-- `noFx` helper function


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
    let
        backgroundImage_ =
            Defaults.imagesLocation
                ++ model.baseBackgroundImage
                ++ "Button"
                ++ toString msg
                ++ ".png"
    in
        case msg of
            Up ->
                --noFx
                { model
                    | backgroundImage = backgroundImage_
                    , currentMsg = msg
                }

            Over ->
                --noFx
                { model
                    | backgroundImage = backgroundImage_
                    , currentMsg = msg
                }

            Down ->
                --noFx
                { model
                    | currentMsg = msg
                }

            Click ->
                -- noFx
                { model
                    | currentMsg = msg
                }

            NoOp ->
                --noFx model
                model



-- VIEW


view : Model -> Html Msg
view model =
    div
        [ buttonStyle model
        , onMouseOver Over
        , onMouseOut Up
        , onMouseDown Down
        , onClick Click
        , class "selectableButton"
        , tabIndex "1"
        ]
        -- [ text model.label ]
        []



-- Create a custom infix operator to reduce the number of
-- parentheses when adding CSS attributes


(=>) =
    (,)


buttonStyle : Model -> Attribute msg
buttonStyle model =
    style
        [ "background-image" => ("url('" ++ model.backgroundImage ++ "')")
        , "background-repeat" => "no-repeat"
        , "height" => (toString model.width ++ "px")
        , "width" => (toString model.height ++ "px")
        , "margin" => "auto"
          -- , "border" => "1px solid black"
        , "cursor" => "pointer"
        , "-webkit-user-select" => "none"
        , "-moz-user-select" => "none"
        , "-khtml-user-select" => "none"
        , "-ms-user-select" => "none"
        , "userSelect" => "none"
        ]
