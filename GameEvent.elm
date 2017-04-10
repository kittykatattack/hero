module GameEvent exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html
import String
import Defaults
import LabeledButton


-- MODEL


type EventType
    = GameOver
    | TakeMsg
    | Question
    | NextPage
    | Any


type alias Image =
    String


type alias Model =
    { description : String
    , button : LabeledButton.Model
    , eventType : EventType
    }


init : String -> String -> EventType -> Model
init buttonLabel_ description_ eventType_ =
    --noFx
    { button = LabeledButton.init buttonLabel_ 30 50
    , description = description_
    , eventType = eventType_
    }


noFx model =
    ( model, Cmd.none )



-- UPDATE


type Msg
    = UpdateButton LabeledButton.Msg
    | NoOp


update : Msg -> Model -> Model
update msg model =
    case msg of
        UpdateButton buttonMsg ->
            let
                button_ =
                    LabeledButton.update buttonMsg model.button
            in
                -- noFx
                { model
                    | button = button_
                }

        NoOp ->
            model



-- VIEW


view : Model -> Html Msg
view model =
    let
        --buttonAddress = Html.App.map <| UpdateButton
        -- Display a different image based on the kind of event that's taking place
        eventImageSource =
            case model.eventType of
                GameOver ->
                    Defaults.imagesLocation ++ "skull.png"

                TakeMsg ->
                    Defaults.imagesLocation ++ "exclamationMark.png"

                Question ->
                    Defaults.imagesLocation ++ "questionMark.png"

                NextPage ->
                    Defaults.imagesLocation ++ "nextIcon.png"

                Any ->
                    ""

        -- Only display an image if the `EventType` is not `Any`
        image =
            case model.eventType of
                Any ->
                    div [ noDisplay ] []

                _ ->
                    img [ src eventImageSource, imageStyle ] []

        eventText =
            case model.description of
                "" ->
                    p [ noDisplay ] []

                _ ->
                    p [ paragraphStyle ] [ text model.description ]
    in
        div []
            [ eventText
            , div [ containerStyle, class "gameEventBox" ]
                [ image
                  --, LabeledButton.view buttonAddress model.button
                , Html.map UpdateButton (LabeledButton.view model.button)
                ]
            ]



-- CSS Styles


(=>) =
    (,)



{-
   containerStyle : Attribute
   containerStyle =
     style
       [ "text-align" => "center"
       --, "width" => "25%"
       , "vertical-align" => "top"
       , "display" => "inline-block"
       , "zoom" => "1"
       , "float" => "left"
       -- , "background-color" => "pink"
       -- , "border" => "1px dashed black"
        , "padding" => "0 0.3em 0 0.3em"
       ]
-}


noDisplay : Attribute msg
noDisplay =
    style
        [ "display" => "none"
        ]


containerStyle : Attribute msg
containerStyle =
    style
        [ "padding" => "5% 0.3em 5% 0em"
        , "width" => "100%"
        , "display" => "-ms-flexbox"
        , "-ms-flex-direction" => "row"
        , "-ms-flex-pack" => "center"
        , "-ms-justify-content" => "center"
        , "display" => "flex"
        , "flex-direction" => "row"
        , "align-items" => "center"
        , "justify-content" => "center"
        ]


imageStyle : Attribute msg
imageStyle =
    style
        [ "margin" => "0% 0% 0% 0%"
          --, "padding" => "0% 10% 0% 0%"
        , "padding" => "0px 40px 0 0"
          --, "display" => "inline-block"
          --, "width" => "42px"
          --, "clear" => "both"
          --, "height" => "48px"
          --, "background-color" => "aliceBlue"
        ]


paragraphStyle : Attribute msg
paragraphStyle =
    style
        [ "padding" => "0% 10% 0% 10%"
        , "display" => "block"
        , "font-size" => "0.9em"
        , "font-weight" => "bold"
        , "font-family" => "Helvetica, Arial, sans-serif"
        , "text-align" => "center"
        ]


imageAndButtonContainer : Attribute msg
imageAndButtonContainer =
    style
        [ "text-align" => "justify"
        , "text-justify" => "distribute-all-lines"
        , "display" => "flex"
        , "justify-content" => "center"
          -- , "background-color" => "yellow"
          --, "-ms-justify-content" => "center"
          --, "display" => "-ms-flex"
          --, "-ms-text-justify" => "distribute-all-lines"
        ]
