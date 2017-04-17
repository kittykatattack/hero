module Page exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html


-- import String
-- import Task
-- import Defaults

import Choice
import GameEvent
import Data
import LabeledButton
import ImageButton
import List.Extra
import Markdown
import Defaults


-- MODEL
-- The `Alignemnt` determines how the page is alignent. `Top` means
-- that the story and event boxes are aligned along the top, `Left`
-- means that they're aligned along the left side


type Alignment
    = Top
    | Left



-- The `PageType` determines what kind of page this will be


type PageType
    = Choice Alignment
      -- Multiple choice page
    | GameEvent Alignment



-- Game event page


type alias Model =
    { heading : String
    , subheading : String
    , description : String
    , image : String
    , width : Int
    , height : Int
    , choices : List (String, String)
    , choiceLinks : List Data.ID
    , choiceBoxes : List Choice.Model
    , pageType : PageType
    , gameEventBox : GameEvent.Model
    , buttonLink : Data.ID
    , activeLink :
        Data.ID
        -- The actual link that will be used to load a new page
    }


model : Model
model =
    let
        choices_ =
            [ ("A", "This is the first choice that the player has.")
            , ("B", "This is the second choice that the player has.")
              --, "This is the third choice that the player has."
            ]

        choiceLinks_ =
            [ 1.1
            , 2.1
            ]

        choiceBoxes_ =
            List.map (\(label, description) -> Choice.init description label) choices_
    in
        { heading = "Adventure!"
        , subheading = "The Quest Begins"
        , description =
            """\x0D
        Lorem ipsum dolor sit amet, \x0D
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, \x0D
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, \x0D
        volutpat eros massa ut, vel semper bibendum pharetra fringilla ullamcorper cras, \x0D
     """
        , image = Defaults.imagesLocation ++ "test.png"
        , width = Defaults.width
        , height = 479
        , choices = choices_
        , choiceLinks = choiceLinks_
        , choiceBoxes = choiceBoxes_
        , pageType = Choice Top
        , gameEventBox =
            GameEvent.init
                "label"
                "This is a really long description of a game event that might occur"
                GameEvent.NextPage
        , buttonLink = 1.1
        , activeLink = 1.1
        }


init : Data.Page -> ( Model, Cmd Msg )
init data =
    let
        alignment =
            case data.alignment of
                "top" ->
                    Top

                "left" ->
                    Left

                _ ->
                    Top

        typeOfPage =
            if List.length data.choices > 1 then
                Choice
            else
                GameEvent

        choiceBoxes_ =
            -- List.map (\string -> Choice.init string "test") data.choices
            List.map (\(label, description) -> Choice.init description label) data.choices

        gameEventBox_ =
            let
                buttonEventType_ =
                    case data.buttonEventType of
                        "next" ->
                            GameEvent.NextPage

                        "Msg" ->
                            GameEvent.TakeMsg

                        "gameover" ->
                            GameEvent.GameOver

                        "question" ->
                            GameEvent.Question

                        _ ->
                            GameEvent.Any
            in
                GameEvent.init
                    data.buttonLabel
                    data.buttonEventDescription
                    buttonEventType_
    in
        noFx
            { model
                | heading = data.heading
                , subheading = data.subheading
                , description =
                    data.description
                    -- This duplicate definition of `image` isn't caught by the compiler and
                    -- produces a bug in IE10
                    --, image = data.image
                , choices = data.choices
                , choiceLinks = data.choiceLinks
                , choiceBoxes = choiceBoxes_
                , pageType = typeOfPage alignment
                , image = Defaults.imagesLocation ++ data.image
                , gameEventBox = gameEventBox_
                , buttonLink = data.buttonLink
                , activeLink = data.id
            }


noFx model =
    ( model, Cmd.none )


type alias Id =
    Int



-- UPDATE


type Msg
    = NoOp
    | ClickChoices Id Choice.Msg
    | ClickGameEventBox GameEvent.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            noFx model

        ClickChoices id choiceMsg ->
            let
                -- An updated list of the choice boxes
                choiceBoxes_ =
                    List.indexedMap updateChoice model.choiceBoxes

                -- The current choice, based on the updated list of choice boxes
                currentChoice_ =
                    List.Extra.getAt id choiceBoxes_
                        |> Maybe.withDefault Choice.model

                -- Click the current choice box if it matches the current id
                updateChoice choiceId choiceModel =
                    if choiceId == id then
                        Choice.update choiceMsg choiceModel
                    else
                        choiceModel

                -- Find the current choice link that matches the current choice id
                choiceLink_ =
                    List.Extra.getAt id model.choiceLinks
                        |> Maybe.withDefault 1.1

            in
                -- Changing the model's `activeLink` flags the main `Adventure` module to
                -- initialize a new page. So, the code should only change the active link
                -- if the button has been clicked
                -- If the choice button is being clicked, set the model's `activeLink`
                if .currentMsg (.button currentChoice_) == LabeledButton.Click then
                    ( { model
                        | choiceBoxes = choiceBoxes_
                        , activeLink = choiceLink_
                      }
                    , Cmd.none
                    )
                    -- If the button isn't being clicked, just return the model with the updated choices
                    -- but don't change the `activeLink`
                else
                    ( { model
                        | choiceBoxes = choiceBoxes_
                      }
                    , Cmd.none
                    )

        ClickGameEventBox gameEventMsg ->
            -- This follows the same format as `ClickChoices`
            let
                gameEventBox_ =
                    GameEvent.update gameEventMsg model.gameEventBox

                button =
                    .button gameEventBox_

                --_ = Debug.log "test: " (toString model.buttonLink)

            in
                -- Checking for `model.buttonLink /= 0` in the following if statement is to prevent a 
                -- strange bug where the Enter key will incorrectly trigger `ClickGameEventBox` when
                -- it should be triggering `ClickChoices`. If you remove thiis additional check you'll
                -- notice that the default `Data.pageOne` is inexplicably displayed if you tab+Enter through the button
                -- button choices 
                if button.currentMsg == LabeledButton.Click && model.buttonLink /= 0 then
                    ( { model
                        | gameEventBox = gameEventBox_
                        , activeLink = model.buttonLink
                      }
                    , Cmd.none
                    )
                else
                    {-
                    ( { model
                        | gameEventBox = gameEventBox_
                      }
                    , Cmd.none
                    )
                    -}
                    (model, Cmd.none)



-- VIEW


view : Model -> Html Msg
view model =
    let
        -- CSS styles
        contentBoxStyle =
            case model.pageType of
                Choice Top ->
                    contentBoxStyleTop

                Choice Left ->
                    contentBoxStyleLeft

                GameEvent Left ->
                    contentBoxStyleLeft

                GameEvent Top ->
                    contentBoxStyleTop

        storyBoxStyle =
            case model.pageType of
                Choice Top ->
                    storyBoxStyleTop

                Choice Left ->
                    storyBoxStyleLeft

                GameEvent Top ->
                    storyBoxStyleTop

                GameEvent Left ->
                    storyBoxStyleLeft

        userMsgBoxStyle =
            case model.pageType of
                Choice Top ->
                    choiceBoxStyleTop

                Choice Left ->
                    choiceBoxStyleLeft

                GameEvent Top ->
                    choiceBoxStyleTop

                GameEvent Left ->
                    choiceBoxStyleLeft

        arrowStyle =
            case model.pageType of
                Choice Top ->
                    arrowStyleTop

                Choice Left ->
                    arrowStyleLeft

                GameEvent Top ->
                    arrowStyleTop

                GameEvent Left ->
                    arrowStyleGameEventLeft

        -- The round arrow icon that connects the story box and event box
        arrowImage =
            case model.pageType of
                Choice Top ->
                    "roundArrowRight.png"

                Choice Left ->
                    "roundArrowDown.png"

                GameEvent Top ->
                    "roundArrowRight.png"

                GameEvent Left ->
                    "roundArrowDown.png"

        -- The `contentBox` function just creates the class name for the container that
        -- contains the storyBox and eventbox. The only reason I needed to generate a
        -- classname was so that I could use it to route-around IE 10 flexbox display bugs
        -- by adding some inline CSS in index.html (see that file for details).
        contentBox =
            case model.pageType of
                Choice Top ->
                    "contentBoxStyleTop"

                Choice Left ->
                    ""

                GameEvent Top ->
                    "contentBoxStyleTop"

                GameEvent Left ->
                    ""

        -- The list of choices the player has
        choiceBoxes =
            List.indexedMap (viewChoice) model.choiceBoxes

        forward toMsg =
            Html.map toMsg

        -- The kind of event box that's generated, depending on what type
        -- of page this is
        eventBox =
            let
                multipleChoiceBox =
                    -- A container for holding the choices
                    div
                        [ class "multipleChoiceBox", defaultStyle, multipleChoiceBoxStyle ]
                        [ h2 [ class "choicesHeading", defaultStyle, choicesHeadingStyle ] [ text "Choices" ]
                          -- The choice boxes are displayed dynamically depending on the number of choices
                          --, div [ class "choiceBox", defaultStyle, choiceBoxStyle ] choiceBoxes
                        , div [ choicesContainer, class "choicesContainer" ] choiceBoxes
                        , img [ src (Defaults.imagesLocation ++ arrowImage), arrowStyle ] []
                        ]

                gameEventBox =
                    -- A container for holding the choices
                    div
                        [ class "multipleChoiceBox", defaultStyle, multipleChoiceBoxStyle ]
                        -- [ div [] [ GameEvent.view gameEventAddress model.gameEventBox ]
                        -- [ GameEvent.view gameEventAddress model.gameEventBox
                        [ Html.map ClickGameEventBox (GameEvent.view model.gameEventBox)
                        , img [ src (Defaults.imagesLocation ++ arrowImage), arrowStyle ] []
                          -- , p [] [ text <| toString model.activeLink ]
                        ]
            in
                case model.pageType of
                    Choice Top ->
                        multipleChoiceBox

                    Choice Left ->
                        multipleChoiceBox

                    GameEvent Top ->
                        gameEventBox

                    GameEvent Left ->
                        gameEventBox
    in
        -- The `page` contains all the story page content, including the image,
        -- choices, and buttons
        div
            [ class "page", pageStyle model ]
            -- The `contentBox` contains the `storybox`, which holds the story content, and
            -- the `contentBox` which contains the choices
            -- For left alignment, use the "LeftAligned" style versions of the
            -- `storyBoxStyle`, `eventBoxStyle` and `contentBoxStyle`
            [ div
                [ class "pageImage", pageImageStyle model ]
                []
            , div [ class contentBox, contentBoxStyle ]
                [ -- The `storyBox` contains the heading, subheading and paragraph text.
                  div [ class "storyBox", storyBoxStyle ]
                    [ h1 [ class "storyHeading", defaultStyle, headingStyle ] [ text model.heading ]
                    , h2 [ class "storySubheading", defaultStyle, subheadingStyle ] [ text model.subheading ]
                    , div [ class "storyParagraph", defaultStyle, paragraphStyle ] [ Markdown.toHtml [] model.description ]
                      --, div [ class "clearingDiv", clearingDivStyle ] []
                    ]
                  -- The `eventBox` contains Msgs that the player can make. It will either display
                  -- a `multipleChoiceBox` for multiple choice Msgs, or a `singleChoiceBox` for
                  -- single choice Msgs
                , div [ class "eventBox", defaultStyle, userMsgBoxStyle ] [ eventBox ]
                  -- The `clearingDiv` is needed to force the `contentBox` to enclose its child containers
                , div [ class "clearingDiv", clearingDivStyle ] []
                ]
              {-
                 , div
                   []
                   [ InfoBox.view (forward ClickInfoBox) InfoBox.init ]
              -}
            ]


viewChoice : Id -> Choice.Model -> Html Msg
viewChoice id model =
    Html.map (ClickChoices id) (Choice.view model)



-- CSS styles


(=>) =
    (,)


defaultStyle : Attribute msg
defaultStyle =
    style
        [ "font-size" => "1em"
        , "color" => "black"
        , "font-family" => "Helvetica, Arial, sans-serif"
        , "padding" => "0"
        , "margin" => "0"
        ]



-- Top aligned styles


contentBoxStyleTop : Attribute msg
contentBoxStyleTop =
    style
        [ "width" => "100%"
        , "min-height" => "20%"
        , "border" => "1px solid darkgray"
        , "padding" => "0"
        , "margin" => "0"
        , "background-color" => "rgba(255, 255, 255, 0.9)"
        , "position" => "relative"
        , "overflow" => "hidden"
          --, "display" => "table"
        , "user-select" => "none"
        , "display" => "flex"
        , "flex-direction" => "row"
        , "align-items" => "start"
          --, "display" => "-ms-flexbox"
          --, "-ms-flex-direction" => "row"
          --, "-ms-flex-pack" => "start"
        ]


storyBoxStyleTop : Attribute msg
storyBoxStyleTop =
    style
        --"position" => "absolute"
        -- , "left" => "0"
        --, "top" => "0"
        [ "background-repeat" => "no-repeat"
        , "width" => "350px"
        , "padding" => "0 10% 2% 2%"
          --, "background-position" => "right 1em center"
        , "border-right" => "1px solid darkgray"
          --, "display" => "table-cell"
          --, "vertical-align" => "middle"
          --, "text-align" => "left"
        , "user-select" => "none"
          --, "background-color" => "red"
        ]


choiceBoxStyleTop : Attribute msg
choiceBoxStyleTop =
    style
        [ "width" => "40%"
        , "min-height" => "20%"
        , "align-self" => "center"
        , "-ms-flex-item-align" => "center"
          --, "background-color" => "aliceBlue"
        ]


eventBoxStyleTop : Attribute msg
eventBoxStyleTop =
    style
        --"position" => "absolute"
        --"top" => "0"
        --"left" => "50%"
        [ "float" => "right"
        , "width" => "48%"
        , "height" => "48%"
          --, "margin" => "0% 0% 0% 0%"
        , "float" => "left"
        , "border" => "1px solid darkgray"
          -- This is a "trick" to vertically positioning an element
          --, "position" => "relative"
          --, "top" => "50%"
          --, "transform" => "translateY(50%)"
        , "display" => "flex"
        , "align-items" => "center"
        , "align-self" => "center"
        ]


arrowStyleTop : Attribute msg
arrowStyleTop =
    style
        [ "position" => "absolute"
        , "top" => "35%"
        , "left" => "-4.8%"
          --, "transform" => "translateY(48%)"
        ]



-- Left Aligned styles


contentBoxStyleLeft : Attribute msg
contentBoxStyleLeft =
    style
        [ "width" => "50%"
        , "height" => "auto"
        , "min-height" => "20%"
        , "border" => "1px solid darkgray"
        , "padding" => "0"
        , "margin" => "0"
        , "background-color" => "rgba(255, 255, 255, 0.9"
        , "position" => "relative"
        , "overflow" => "hidden"
        ]


storyBoxStyleLeft : Attribute msg
storyBoxStyleLeft =
    style
        --"position" => "absolute"
        -- , "left" => "0"
        --, "top" => "0"
        [ "width" => "92%"
        , "height" => "45%"
        , "padding" => "0 4% 5% 4%"
          --, "margin" => "0% 0% 0% 1.2%"
          --, "background-color" => "cyan"
          --, "background-image" => ("url('" ++ Defaults.imagesLocation ++ "roundArrowRight.png" ++ "')")
        , "background-repeat" => "no-repeat"
        , "background-position" => "right 1em center"
        , "border-bottom" => "1px solid darkgray"
        , "user-select" => "none"
        ]


choiceBoxStyleLeft : Attribute msg
choiceBoxStyleLeft =
    style
        --"position" => "absolute"
        --"top" => "0"
        --"left" => "50%"
        [ "width" => "100%"
        , "height" => "45%"
        , "padding" => "5% 0 0 0"
          --, "border" => "1px solid darkgray"
          --, "background-color" => "red"
          --, "margin" => "0% 0% 0% 0%"
        , "position" => "relative"
        ]


eventBoxStyleLeft : Attribute msg
eventBoxStyleLeft =
    style
        --"position" => "absolute"
        --"top" => "0"
        --"left" => "50%"
        [ "width" => "100%"
        , "height" => "45%"
        , "padding" => "5% 0 0 0"
          --, "border" => "1px solid darkgray"
          --, "background-color" => "red"
          --, "margin" => "0% 0% 0% 0%"
        , "position" => "relative"
        ]


arrowStyleLeft : Attribute msg
arrowStyleLeft =
    style
        [ "position" => "absolute"
        , "left" => "47.3%"
          --, "top" => "-70%"
        , "top" => "-20.0%"
          --, "transform" => "translateY(48%)"
        ]


arrowStyleGameEventLeft : Attribute msg
arrowStyleGameEventLeft =
    style
        [ "position" => "absolute"
        , "left" => "48%"
        , "top" => "-41%"
          --, "transform" => "translateY(48%)"
        ]


multipleChoiceBoxStyle : Attribute msg
multipleChoiceBoxStyle =
    style
        [ "width" => "100%"
        , "height" => "100%"
        , "float" => "left"
        , "position" => "relative"
        ]


choicesContainer : Attribute msg
choicesContainer =
    style
        [ "padding" => "5% 0.3em 5% 0em"
          --, "width" => "100%"
        , "display" => "-ms-flexbox"
        , "-ms-flex-direction" => "row"
        , "-ms-flex-pack" => "center"
        , "-ms-justify-content" => "center"
        , "display" => "flex"
        , "flex-direction" => "row"
        , "align-items" => "flex-start"
        , "justify-content" => "center"
          --, "background-color" => "olive"
        ]


choiceBoxStyle : Attribute msg
choiceBoxStyle =
    style
        [ "width" => "50%"
        , "height" => "100%"
        , "float" => "left"
        , "display" => "inline"
        , "background-color" => "olive"
        ]


clearingDivStyle : Attribute msg
clearingDivStyle =
    style
        [ "clear" => "left"
        , "height" => "0"
        ]


pageStyle : Model -> Attribute msg
pageStyle model =
    style
        [ "width" => (toString (model.width - 37) ++ "px")
        , "height" => (toString (model.height - 15) ++ "px")
        , "padding" => "15px 20px 0px 17px"
        , "position" => "relative"
        ]


pageImageStyle : Model -> Attribute msg
pageImageStyle model =
    style
        [ "width" => (toString model.width ++ "px")
        , "height" => (toString model.height ++ "px")
        , "background-image" => ("url('" ++ model.image ++ "')")
        , "background-repeat" => "no-repeat"
        , "position" => "absolute"
        , "top" => "0px"
        , "left" => "0px"
        ]


headingStyle : Attribute msg
headingStyle =
    style
        [ "font-size" => "1em"
        , "font-weight" => "bold"
        , "font-family" => "Helvetica, Arial, sans-serif"
        , "padding" => "0.8em 0em 0.3em 0em"
        , "margin" => "0"
        ]


subheadingStyle : Attribute msg
subheadingStyle =
    style
        [ "font-size" => "0.8em"
        , "font-weight" => "bold"
        , "font-family" => "Helvetica, Arial, sans-serif"
        , "padding" => "0em 0em 0.2em 0em"
        , "margin" => "0"
        ]


choicesHeadingStyle : Attribute msg
choicesHeadingStyle =
    style
        [ "font-size" => "0.8em"
        , "font-weight" => "bold"
        , "font-family" => "Helvetica, Arial, sans-serif"
        , "padding" => "1em 0em 1em 0em"
        , "margin" => "0"
        , "text-align" => "center"
        ]


paragraphStyle : Attribute msg
paragraphStyle =
    style
        [ "font-size" => "0.8em"
        , "font-family" => Defaults.fontFamily
        , "line-height" => "1.3em"
        , "user-select" => "none"
        , "-moz-user-select" => "none"
          --, "-webkit-user-select" => "none"
          --, "display" => "block
        ]
