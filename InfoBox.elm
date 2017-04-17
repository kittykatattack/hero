module InfoBox exposing (..)

import Html exposing (..)
import Html
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Defaults
import Data
import List.Extra
import ImageButton
import Task
-- import Task.Extra
import Markdown
import LabeledButton


-- For elm-html-animation

import Time exposing (second)
import Animation
import Animation.Messenger exposing (..)


-- MODEL


type alias Model =
    { width : Int
    , height : Int
    , inventory : Data.Inventory
    , meterWidth : Int
    , meterHeight : Int
    , meterBorderRadius : Int
    , meterX : Int
    , meterY : Int
    , storyLevel : Int
    , storyChapter : String
    , totalStoryLevels : Int
    , totalStoryChapters : Int
    , storyPhases : List String
    , storyPhaseChapters : List String
    , currentStoryPhaseChapter : Int
    , infoPages : List String
    --, infoButton : ImageButton.Model
    , infoButton : LabeledButton.Model
    , infoBoxIsOpen : Bool
    , styleInfo : Animation.State
    , styleMeter : Animation.State
    }


model : Model
model =
    { width = Defaults.width
    , height = 120
    , inventory = Data.inventory
    , meterWidth = 450
    , meterHeight = 16
    , meterBorderRadius = 4
    , meterX = 38
    , meterY = 27 
    , storyLevel = 1
    , storyChapter = "No Chapter Selected"
    , totalStoryLevels = 0
    , totalStoryChapters = 0
    , storyPhases = Data.storyPhases
    , storyPhaseChapters = Data.storyPhaseChapters
    , currentStoryPhaseChapter = 1
    , infoPages = Data.infoPages
    -- , infoButton = ImageButton.info
    , infoButton = LabeledButton.init "view details" 30 50
    , infoBoxIsOpen = False
    , styleInfo =
        Animation.styleWith
            (Animation.spring
                { stiffness = 400
                , damping = 23
                }
            )
            [ Animation.top (Animation.px -10.0)
            ]
    , styleMeter =
        Animation.styleWith
            (Animation.easing
                { duration = 0.3 * second
                , ease = smoothstep
                }
            )
            [ Animation.width (Animation.px 450.0)
            ]
    }


smoothstep =
    (\x -> x * x * (3 - 2 * x))


subscriptions : Model -> Sub Msg
subscriptions model =
    Animation.subscription Animate
        [ model.styleInfo
        , model.styleMeter
        ]


init : Data.Inventory -> Int -> String -> List String -> List String -> List String -> Model
init inventory_ storyLevel_ storyChapter_ storyPhases_ storyPhaseChapters_ infoPages_ =
    let
        totalStoryLevels_ =
            List.length storyPhases_
    in
        { model
            | inventory = inventory_
            , storyLevel = storyLevel_
            , storyChapter = storyChapter_
            , storyPhases = storyPhases_
            , totalStoryLevels = totalStoryLevels_
            , totalStoryChapters = List.length storyPhaseChapters_
            , storyPhaseChapters = storyPhaseChapters_
            , infoPages = infoPages_
            , styleMeter =
                Animation.style
                    [ Animation.width (Animation.px (toFloat (model.meterWidth // totalStoryLevels_)))
                    ]
        }



-- `meterSegmentWidth` calculates the width of each meter segment


meterSegmentWidth : Model -> Int
meterSegmentWidth model =
    model.meterWidth // model.totalStoryLevels



-- `meterWidth` calculates the width of the foreground


meterWidth : Model -> Int
meterWidth model =
    (meterSegmentWidth model) * (model.storyLevel + 1)



-- `currentStoryPhase` selects the correct story phase desription
-- from the `storyPhases` list


currentStoryPhase model =
    List.Extra.getAt model.storyLevel model.storyPhases
        |> Maybe.withDefault "No story phase selected"


currentStoryChapter level totalStoryChapters =
    let
        chapterNumber =
            level // totalStoryChapters
    in
        List.Extra.getAt chapterNumber model.storyPhaseChapters
            |> Maybe.withDefault "No story chapter selected"



-- UPDATE


type Msg
    -- = UpdateButton ImageButton.Msg
    = UpdateButton LabeledButton.Msg
    | ShowInfo
    | HideInfo
    | Animate Animation.Msg
    | UpdateData Int (List Int) Int
    | NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    -- This code sets up a toggle button effect on the `infoButton`
    let
        -- The current, updated version of the model's `infoButton`
        infoButton_ buttonMsg =
            --ImageButton.update buttonMsg model.infoButton
            LabeledButton.update buttonMsg model.infoButton

        {-
           `runCorrectEffect` will choose three possible Cmd to run:
           1. If the button is `Down`, and the infoBox is closed, then the effect
              runs `ShowInfo`
           2. If the button is `Down` and the info box is open, the the effect runs
              `HideInfo`
           3. In any other condition, don't run any Cmd
           This forms the basis of the toggle effect
        -}
        runCorrectEffect buttonMsg model =
            
            case
                --( .currentMsg (infoButton_ buttonMsg) == ImageButton.Down
                ( .currentMsg (infoButton_ buttonMsg) == LabeledButton.Click
                , model.infoBoxIsOpen == False
                )
            of
                ( True, True ) ->
                    --Cmd.task <| Task.succeed ShowInfo
                    --Cmd.batch [ Task.Extra.performFailproof ShowInfo ]
                    update ShowInfo model

                ( True, False ) ->
                    --Cmd.task <| Task.succeed HideInfo
                    --Cmd.batch [ Task.Extra.performFailproof HideInfo ]
                    update HideInfo model

                _ ->
                    --Cmd.none
                    model ! []
            

    in
        case msg of
            Animate animMsg ->
                ( { model
                    | styleInfo = Animation.update animMsg model.styleInfo
                    , styleMeter = Animation.update animMsg model.styleMeter
                  }
                , Cmd.none
                )

            -- Update the `infoButton` toggle button, and run an animation to
            -- display the `infoBox` if the button is in the correct toggle state
            UpdateButton buttonMsg ->
                let
                    model_ =
                        { model
                            | infoButton = infoButton_ buttonMsg
                        }
                in
                    runCorrectEffect buttonMsg model_

            -- An animation to show the `infoBox`
            ShowInfo ->
                let
                    -- An updated model where `infoBoxIsOpen` is set to `True`
                    model_ =
                        { model
                            | infoBoxIsOpen = True
                            , styleInfo =
                                Animation.interrupt
                                    [ Animation.to
                                        [ Animation.top (Animation.px -300)
                                        ]
                                    ]
                                    model.styleInfo
                        }
                in
                    model_ ! []

            -- An animation to hide the `infoBox`
            HideInfo ->
                let
                    -- An updated model where `infoBoxIsOpen` is set to `True`
                    model_ =
                        { model
                            | infoBoxIsOpen = False
                            , styleInfo =
                                Animation.interrupt
                                    [ Animation.to
                                        [ Animation.top (Animation.px -10)
                                        ]
                                    ]
                                    model.styleInfo
                        }
                in
                    model_ ! []

            UpdateData level quantities currentStoryPhaseChapter_ ->
                let
                    item_ item id =
                        { item
                            | quantity = List.Extra.getAt id quantities |> Maybe.withDefault 0
                        }

                    inventory_ =
                        List.indexedMap (\id item -> item_ item id) model.inventory

                    model_ =
                        { model
                            | storyLevel = level
                            , storyChapter = currentStoryChapter level model.totalStoryChapters
                            , inventory = inventory_
                            , currentStoryPhaseChapter = currentStoryPhaseChapter_
                        }

                    -- Update the animation using the newly calculated model values
                    model__ =
                        { model_
                            | styleMeter =
                                Animation.interrupt
                                    [ Animation.to
                                        [ Animation.width (Animation.px (toFloat (meterWidth model_)))
                                        ]
                                    ]
                                    model_.styleMeter
                        }
                in
                    model__ ! []

            NoOp ->
                model ! []



-- VIEW


view : Model -> Html Msg
view model =
    let
        -- Map the inventory items
        inventoryItem item =
            div
                [ inventoryItemStyle item ]
                [ div [ paragraphStyle ] [ text <| item.name ++ ": " ++ (toString item.quantity) ]
                ]

        inventoryItemList =
            List.map inventoryItem model.inventory

        -- Map the meter markers
        marker level =
            div [ markerStyle model level ] []

        meterMarkers =
            List.map marker (List.range 1 (model.totalStoryLevels - 1))

        markerStyle model level =
            let
                meterX =
                    model.meterX - (meterWidth model) + ((meterSegmentWidth model) * level)
            in
                style
                    [ "width" => px (meterWidth model)
                    , "height" => "6px"
                      --, "background-color" => "green"
                    , "border-right" => "1px solid darkGray"
                    , "position" => "absolute"
                    , "top" => px (model.meterY + model.meterHeight)
                    , "left" => px meterX
                    ]

        -- The `storyPhaseMarker` sits above the meter bar and points to the
        -- current phase of the story
        storyPhaseMarker =
            div [ storyPhaseMarkerStyle model.storyLevel ] []

        storyPhaseMarkerStyle level =
            let
                meterX =
                    model.meterX - (meterWidth model) + ((meterSegmentWidth model) * (level + 1))
            in
                style
                    [ "width" => px (meterWidth model)
                    , "height" => px 6
                      --, "background-color" => "green"
                    , "border-right" => "1px solid darkGray"
                    , "position" => "absolute"
                    , "top" => px (model.meterY - 6)
                    , "left" => px meterX
                    ]

        -- The `storyPhaseContainer` holds the `model.storyPhase` text that
        -- tells you which phase of the story we're currently at
        storyPhaseTitle storyPhase =
            div
                [ storyPhaseTitleStyle model.storyLevel ]
                [ p [ storyPhaseStyle ] [ text storyPhase ]
                ]

        storyPhaseTitleStyle level =
            let
                height =
                    30

                width =
                    250

                meterX =
                    model.meterX + ((meterSegmentWidth model) * (level + 1)) - width // 2

                meterY =
                    model.meterY - height
            in
                style
                    [ "width" => px width
                    , "height" => px height
                      -- , "background-color" => "green"
                    , "position" => "absolute"
                    , "top" => px meterY
                    , "left" => px meterX
                    , "text-align" => "center"
                    ]

        storyPhaseStyle =
            style
                [ "font-weight" => "bold"
                , "font-size" => "0.7em"
                , "font-family" => "Helvetica, Arial, sans-serif"
                ]

        -- The `storyPhaseChapters` are displayed under the meter and
        -- represent the major chapters of the story
        storyPhaseChapters =
            let
                chapterHeading heading =
                    div [ chapterHeadingStyle heading ] [ text heading ]
            in
                List.map chapterHeading model.storyPhaseChapters

        chapterHeadingStyle heading =
            let
                isChapter heading =
                    heading == model.storyChapter

                fontWeight =
                    if isChapter heading then
                        "bold"
                    else
                        "normal"

                fontColor =
                    if isChapter heading then
                        "black"
                    else
                        "darkGray"
            in
                style
                    -- The width of each story phase chapter heading is determined
                    -- by the width of the width of the `chapterHeadingContainerStyle` box
                    -- that it's contained in, divided by the number of story phase chapters
                    [ "width" => px (450 // List.length model.storyPhaseChapters)
                    , "display" => "inline-block"
                    , "text-align" => "center"
                    , "font-size" => "0.7em"
                    , "font-weight" => fontWeight
                    , "color" => fontColor
                    , "font-family" => "Helvetica, Arial, sans-serif"
                    ]

        -- Choose the correct info page to display based on the current story phase chapter,
        -- and convert it to HTML
        infoPageContent =
            List.Extra.getAt (model.currentStoryPhaseChapter - 1) model.infoPages
                |> Maybe.withDefault "No info page selected"
    in
        div
            [ containerStyle model ]
            [ div
                ((Animation.render model.styleInfo ++ [ infoContainer ]) ++ [ onMouseLeave HideInfo ])
                [ Markdown.toHtml [] infoPageContent ]
            , div
                [ mainAnimationContainerStyle ]
                [ div
                    [ class "inventoryItemList" ]
                    inventoryItemList
                , div
                    [ class "meter", meterContainerStyle ]
                    [ div [ class "meterBackground", meterBackgroundStyle model ] []
                    , div ((Animation.render model.styleMeter ++ [ meterForeground model ]) ++ [ class "meterForeground" ]) []
                    , div [] meterMarkers
                    , storyPhaseMarker
                      -- The title of the chapter
                    , storyPhaseTitle (currentStoryPhase model)
                      -- The 3 main story phase chapter headings
                    , div [ chapterHeadingContainerStyle ] storyPhaseChapters
                    ]
                --, div [ infoButtonContainerStyle ] [ Html.map UpdateButton (ImageButton.view model.infoButton) ]
                , div [ infoButtonContainerStyle ] [ Html.map UpdateButton (LabeledButton.view model.infoButton) ]
                ]
            ]



-- CSS Styles
-- Helper functions


(=>) =
    (,)


px number =
    (toString number) ++ "px"


backgroundImage imageName =
    ("url('" ++ Defaults.imagesLocation ++ imageName ++ ".png" ++ "')")


mainAnimationContainerStyle =
    style
        [ "z-index" => "2"
        , "position" => "relative"
          -- , "background-color" => "#eeeeee"
        , "background-image" => backgroundImage "watercolorTexture"
        , "userSelect" => "none"
        , "border-top" => "1px darkGray solid"
        , "-webkit-box-shadow" => "0px -1px 6px 0px rgba(50, 50, 50, 0.50)"
        , "-moz-box-shadow" => "0px -1px 6px 0px rgba(50, 50, 50, 0.50)"
        , "box-shadow" => "0px -1px 6px 0px rgba(50, 50, 50, 0.50)"
        ]


infoContainer =
    style
        [ "position" => "absolute"
        , "width" => px (Defaults.width - 60)
        , "height" => px 500
          --, "background-color" => "red"
        , "z-index" => "1"
        , "border-top" => "1px darkGray solid"
        , "padding" => "20px 30px 0px 30px"
        , "font-family" => Defaults.fontFamily
        , "font-size" => "0.9em"
        , "background-image" => backgroundImage "watercolorTexture2"
        ]


infoButtonContainerStyle =
    style
        [ "position" => "absolute"
        , "top" => px 77
        , "right" => px 200
        ]


chapterHeadingContainerStyle =
    style
        [ "width" => "470px"
        , "position" => "absolute"
        , "padding-top" => "49px"
        , "user-select" => "none"
        , "left" => px 45
          -- , "background-color" => "pink"
        ]


containerStyle model =
    style
        [ "position" => "relative"
        , "bottom" => "0px"
        , "left" => "0px"
        , "width" => px model.width
        , "height" => px model.height
        ]


meterContainerStyle =
    style
        [ "width" => "528px"
        , "height" => "121px"
        , "position" => "absolute"
        , "top" => "0px"
        , "right" => "0px"
        --, "background-color" => "pink"
        ]


meterBackgroundStyle model =
    style
        [ "width" => px model.meterWidth
        , "height" => px model.meterHeight
        , "background-color" => "white"
        , "position" => "absolute"
        , "top" => px model.meterY
        , "left" => px model.meterX
        , "border-radius" => px model.meterBorderRadius
        ]


meterForeground model =
    style
        --[ "width" => px (meterWidth model)
        [ "height" => px model.meterHeight
        , "position" => "absolute"
        , "top" => px model.meterY
        , "left" => px model.meterX
        , "border-radius" => px model.meterBorderRadius
          -- Permalink - use to edit and share this gradient: http://colorzilla.com/gradient-editor/#1e5799+0,2989d8+50,207cca+51,7db9e8+100;Blue+Gloss+Default */
        , "background" => "#7abcff"
        , "background" => "-moz-linear-gradient(top, #7abcff 0%, #60abf8 44%, #4096ee 100%)"
        , "background" => "-webkit-linear-gradient(top, #7abcff 0%,#60abf8 44%,#4096ee 100%)"
        , "background" => "linear-gradient(to bottom, #7abcff 0%,#60abf8 44%,#4096ee 100%)"
        ]


meterForegroundStyle model =
    style
        --[ "width" => px (meterWidth model)
        [ "height" => px model.meterHeight
        , "position" => "absolute"
        , "top" => px model.meterY
        , "left" => px model.meterX
        , "border-radius" => px model.meterBorderRadius
          -- Permalink - use to edit and share this gradient: http://colorzilla.com/gradient-editor/#1e5799+0,2989d8+50,207cca+51,7db9e8+100;Blue+Gloss+Default */
        , "background" => "#7abcff"
        , "background" => "-moz-linear-gradient(top, #7abcff 0%, #60abf8 44%, #4096ee 100%)"
        , "background" => "-webkit-linear-gradient(top, #7abcff 0%,#60abf8 44%,#4096ee 100%)"
        , "background" => "linear-gradient(to bottom, #7abcff 0%,#60abf8 44%,#4096ee 100%)"
        ]


inventoryItemStyle item =
    let
        -- Choose the correct image to display based on which inventory item this
        -- is and what its current quantity is
        chooseCorrectImage =
            case item.name of
                "Magic Pills" ->
                    "pill_" ++ toString item.quantity

                "Transformations" ->
                    "wand_" ++ toString item.quantity

                _ ->
                    item.image
    in
        style
            [ "width" => "121px"
            , "height" => "121px"
            , "display" => "inline-block"
            , "font-family" => "Helvetica, Arial, sans-serif"
            , "background-image" => backgroundImage chooseCorrectImage
              -- , "background-image" => ("url('" ++ Defaults.imagesLocation ++ item.image ++ "')")
            , "border-right" => "1px darkGray solid"
            , "user-select" => "none"
            ]


inventoryContainerStyle =
    style
        [ "z-index" => "3"
        , "width" => "242px"
        , "height" => "121px"
        , "position" => "absolute"
        , "user-select" => "none"
        ]


paragraphStyle =
    style
        [ "font-size" => "0.7em"
        , "text-align" => "center"
        , "padding-top" => "98px"
        , "user-select" => "none"
        ]
