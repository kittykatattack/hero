Hero Quest
===========

Hero Quest's source files were written in Elm 0.16 and compiled with elm-webpack-starter:

https://github.com/moarwick/elm-webpack-starter

The entry point for the application is `Main.elm`, but it's really just a hook for `Adventure.elm` which initializes the app. Here's an overview of all the Elm modules and how they interrelate.

App initialization modules
---------------------

- `Data.elm`: All the data used to create the story pages. This data is used by `Adventure.elm` to configure the game.
- `Defaults.elm`: Global project defaults like image file location and app width and height
- `Main.elm`: Starts Elm and loads `Adventure.elm` into Elm's StartApp framework.
- `Adventure.elm`: Configures the game using `Data.elm`. It also displays and updates the two top level components, `Page.elm` and `InfoBox.elm` as well as handling transitions between pages. this is where you should start to initialize and make global changes to the game.


Component modules
-----------------

These are self-contained components that are composed together to form the app.

###Level A

- `Page.elm`: Displays the main story pages. 
- `InfoBox.elm`: Uses the game data to display the inventory, game progress meter and info screen.

###Level B

- `Choice.elm`: An `ImageButton` of a star with a user-definable label.
- `GameEvent`: A box that displays a button with a single action that the user can take. 

###Level C

- `LabeledButton.elm`: Creates a CSS button with a label.
- `ImageButton.elm`: Creates a button from an image file.


How it works
------------

Let's take a tour of how all these components fit together.

###Defaults.elm

A simple data file that describes some application default values.

```
imagesLocation = "../images/"
-- imagesLocation = "/digitalresources/html/eng4cc/images/"
width = 770
height = 600
fontFamily = "Helvetica, Arial, sans-serif"
```

###Data.elm

Contains the data that's used by the game to display the pages of the story.

- `inventory`: A list of `Item`s, in this case the "Magic Pills" and the "Transformations".
- `infoPages`: A list of three markdown elements that describe the the main information pages in the game (`infoPageOne`, `infoPageTwo` and `infoPageThree`).
- `storyPhases`: A list of each of the 9 major phases of the story. These are displayed above the story progress meter.
- `storyPhaseChapters`: A list of the 3 major sections of the story. These are displayed above the story meter.
- `story`: a list of `Page` records. These define each page that's displayed in the story. Each page has a unique `ID` that is used to link pages to buttons.

###Adventure.elm

Takes the Data from Data.elm and uses it to build:

- The page: the upper part of the game that describes the story events.
- The info box: The lower part of the game that displays the inventory and game progress data.

It also manages the page fade in/out transition effect using `elm-html-animation`.

New pages are requested whenever the current model's `activeLink` value is different from its previous `activeLink` value. From the `update` function:
```
activeLink =
   .activeLink currentPage' 

previousLink =
   .activeLink model.currentPage

newPageRequested =
  activeLink /= previousLink
```

If a new page is requested then a `Page` is initialized using the most recent current page data.
```
currentPageData' = 
  getCurrentPageData model.story activeLink

currentPage' = 
  fst (Page.update pageAction model.currentPage)

newPage =
  if newPageRequested then
    fst (Page.init currentPageData')
  else
    currentPage'
```

The `update` function is also prepared use 2 versions of the model. The first is just used to update the model when the page doesn't need to change. The second updates the model and performs a fade in/out transition between the new and old page.
```
-- The version of the model which is only used when
-- the current page is being updated
model' =
  { model 
      | currentPage = newPage 
      , currentPageData = currentPageData'
  }

-- The version of the model which is used when a
-- new page is requested. It copies the model's
-- last recent version of the current page into the 
-- `previousPage` property. It also set the starting 
-- opacity values needed to fade the previous page from
-- 1 to 0 and the current page from 0 to 1
model'' =
  { model 
      | currentPage = newPage 
      , currentPageData = currentPageData'

      -- Set the `previousPage` to the model's `currentPage`
      -- This is the page that will be fade out in the page transition
      , previousPage = model.currentPage

      -- Flip the start opacity values for the prevoius and current page.
      -- This is what creates the fade in/out effect  
      , stylePreviousPage = UI.init [ Opacity 1.0 ]
      , styleCurrentPage = UI.init [ Opacity 0.0 ]
  }

in
if newPageRequested then

-- Return a new model with the new page, perform a transition and update the 
-- infoBox
(
  model''
, Effects.batch
    [ Effects.task <| Task.succeed FadeOutOldPage 
    , Effects.task <| Task.succeed FadeInNewPage 
    , Effects.task 
        <| Task.succeed (UpdateInfoBox (InfoBox.UpdateData storyLevel inventoryQuantities storyPhaseChapter))
    ]
)
else

-- Return a new model with the same page and update the infoBox
(
  model'
, Effects.batch
    [ Effects.task 
        <| Task.succeed (UpdateInfoBox (InfoBox.UpdateData storyLevel inventoryQuantities storyPhaseChapter)) 
    ]
)
```

#### The page transition effect

The page transition works because the model has access to both the current page and the previous page. They're initialized to the same thing when the game first starts.
```
, currentPage = getCurrentPage pageData
, previousPage = getCurrentPage pageData 
```
The model also stores two `elm-html-animation` styles for the same pages. Significantly, the opacity for the previous page is set to 0, while the opacity for the current page is set to one.
```
, stylePreviousPage = UI.init [ Opacity 0.0 ]
, styleCurrentPage = UI.init [ Opacity 1.0 ]
```
The `view` displays displays both the previous page and, on a layer below, the current page. But because the previous page's opacity is 0, it's not visible.
```
div
  [ adventureStyle ]
  [ 
    
    -- A holding div for the previous page, which is used to create the fade effect. 
    -- It's opacity is 0 when the game starts,
    -- but it's set to 1 in the update function and then faded out with each page transition
    div [ style ((previousPage) ++ (UI.render model.stylePreviousPage)) ] [ (Page.view (forward UpdatePage) model.previousPage) ]

    -- The currently active page. It's opacity is 1 when the game starts, but is set to 
    -- 0 in the update function and then faded in with
    -- each page transition 
  , div [ style ((currentPage) ++ (UI.render model.styleCurrentPage)) ] [ (Page.view (forward UpdatePage) model.currentPage) ] 
  , div [ style infoBox ] [ InfoBox.view (forward UpdateInfoBox) model.infoBox ] 
  ]
```
When the `update` function detects that a new page has been requested, it uses the 2nd model. Here's the important part! The 2nd model flips opacity values of the previous and current page. That means the current page (the brand new page) is set to 0, and the previous page (the former current page) is set to 1.
```
model'' =
  { model 
      | currentPage = newPage 
      , currentPageData = currentPageData'

      -- Set the `previousPage` to the model's `currentPage`
      -- This is the page that will be faded out in the page transition
      , previousPage = model.currentPage

      -- Flip the start opacity values for the previous and current page.
      -- This is what creates the fade in/out effect  
      , stylePreviousPage = UI.init [ Opacity 1.0 ]
      , styleCurrentPage = UI.init [ Opacity 0.0 ]
  }
```

The `FadeOutOldPage` and `FadeInNewPage` actions then run as effects.
```
if newPageRequested then

-- Return a new model with the new page, perform a transition and update the 
-- infoBox
(
  model''
, Effects.batch
    [ Effects.task <| Task.succeed FadeOutOldPage 
    , Effects.task <| Task.succeed FadeInNewPage 
    , Effects.task 
        <| Task.succeed (UpdateInfoBox (InfoBox.UpdateData storyLevel inventoryQuantities storyPhaseChapter))
    ]
)
```
Those actions use `elm-html-animation` fade out the old page and fade in the new one.
```
    FadeOutOldPage ->
        UI.animate
          |> UI.duration (0.5 * second)
          |> UI.props
              [ Opacity (UI.to 0.0)
              ]
          |> onOldPage model

    FadeInNewPage ->
        UI.animate
          |> UI.duration (0.5 * second)
          |> UI.props
              [ Opacity (UI.to 1.0)
              ]
          |> onNewPage model

    AnimateOldPage action ->
      onOldPage model action

    AnimateNewPage action ->
      onNewPage model action

onOldPage =
  UI.forwardTo AnimateOldPage .stylePreviousPage (\w stylePreviousPage -> { w | stylePreviousPage = stylePreviousPage })

onNewPage =
  UI.forwardTo AnimateNewPage .styleCurrentPage (\w styleCurrentPage -> { w | styleCurrentPage = styleCurrentPage })
```
An unexpected benefit to this is that the old page is never updated by the model, which means its buttons are always non-functioning. That's great because it means the user can't ever click on a button while it's fading-out, and that protects against all kind of possible bugs.

###Page.elm

The page represents the top part of the game screen and includes the description of the story, an event box that takes some kind of user action, and the current page image. It's initialized using a `Data.Page` record by the main `Adventure` module, which chooses the correct page from the `Data.story` list based on current page id. Here's the code from `Adventure.elm` that does this:
```
id =
  1.1

currentPageData' =
  getCurrentPageData model.story id

currentPage' = getCurrentPage currentPageData'
```
The game is initialized to page ID number 1.1, but you can set it to any other page id number that you like if you want to test how those pages work. `currentPageData` grabs the correct page data record from the `Data.story` list, while current page creates a new page using that data.
```
-- `getCurrentPageData` finds the correct page Record from the 
-- `story` array based on the supplied page ID 
getCurrentPageData : Data.Story -> Data.ID -> Data.Page
getCurrentPageData story id =
  List.head (List.filter (\page -> page.id == id) story)
    |> Maybe.withDefault Data.pageOne


-- `getCurrentPage` returns a `Page.Model` that's been initialized with
-- the a data Record from the `story` array
getCurrentPage : Data.Page -> Page.Model
getCurrentPage data =
    fst (Page.init data)
```
Each page can be of either two types, `Choice` or `GameEvent`. The alignment can be either `Top` or `Left` . (In practice, only one page in this game only ever ended up being aligned to the left.)
```
type Alignment
  = Top
  | Left


type PageType
  = Choice Alignment       -- Multiple choice page
  | GameEvent Alignment    -- Game event page
```
A `Choice` page is one where the user has a choice of 2 or more options. A `GameEvent` page is where the user only has one button option. (A `GameEvent` module handles how it should be displayed.) When a new page is initialized, the page type is determined depending on whether or not page data contains any values in the `choices` list. 
```
typeOfPage =
  if List.length data.choices > 1 then
    Choice 
  else
    GameEvent 
```
Leaving the `choices` list empty in a `Data.Page` record will make the page type default to a `GameEvent`, in which only only one user-action button is displayed. The page `Alignment` is also determined by the `alignment` property in a `Data.Page` record. 
The `view` chooses the correct `eventBox` based on the type and alignment of the page. 
```
eventBox =
  let

    multipleChoiceBox =

      -- A container for holding the choices
      div 
        [ class "multipleChoiceBox", defaultStyle, multipleChoiceBoxStyle ] 
        [ h2 [ class "choicesHeading", defaultStyle, choicesHeadingStyle ] [ text "Choices" ]

        -- The choice boxes are displayed dynamically depending on the number of choices
        --, div [ class "choiceBox", defaultStyle, choiceBoxStyle ] choiceBoxes
        , div [ choicesContainer ] choiceBoxes
        , img [ src (Defaults.imagesLocation ++ arrowImage), arrowStyle ] []
        ]

    gameEventBox =

      -- A container for holding the choices
      div 
        [ class "multipleChoiceBox", defaultStyle, multipleChoiceBoxStyle ]
        [ GameEvent.view (forward UpdateGameEventBox) model.gameEventBox 
        , img [ src (Defaults.imagesLocation ++ arrowImage), arrowStyle ] []
        ] 

  in 
  case model.pageType of
    Choice Top -> multipleChoiceBox 
    Choice Left -> multipleChoiceBox
    GameEvent Top -> gameEventBox
    GameEvent Left -> gameEventBox
```
The two sub-modules that are used here are `Choice.elm` and `GameEvent.elm` The `Page` model initializes them like this:
```
choiceBoxes' =
  List.map (\string -> Choice.init string) data.choices

gameEventBox' = 
    let
      buttonEventType' =
        case data.buttonEventType of
          "next" -> GameEvent.NextPage
          "action" -> GameEvent.TakeAction
          "gameover" -> GameEvent.GameOver
          "question" -> GameEvent.Question
          _ -> GameEvent.Any

    in
    GameEvent.init 
      data.buttonLabel
      data.buttonEventDescription
      buttonEventType'

```
`Choice.elm` is a simple module that creates an `ImageButton` of a star with a text description - take a look at its source code to find out how  it works. `GameEvent` creates a button of 4 different types, depending on the kind of event that needs to occur - let's look at how it works next.

###GameEvent.elm

`GameEvent` is a box with a description and a `LabeledButton`. All the values it needs are in the `Data.Page` record for the current page:
```
-- Button
, buttonLabel = "Next"

-- The button event description appears above the button
, buttonEventDescription = ""

-- The `buttonEventType` can be "next", "action", "question". "any" or "gameover"
, buttonEventType = "any"

-- The page that the button should link to.
-- (Set it to 0 if there is no link)
, buttonLink = 1.3
```
(`buttonLink` is not used in this module, however - instead it's used by the parent `Page` module ) 

The button can be used to describe 5 possible event types.
```
type EventType 
  = GameOver
  | TakeAction
  | Question
  | NextPage
  | Any
```
The button type will be chosen based on the value of `buttonEventType` from the `Data.Page` record. It basically just selects for a different image to appear next to the button based on this type.
```
view : Signal.Address Action -> Model -> Html
view address model =
  let
    buttonAddress = Signal.forwardTo address <| UpdateButton

    -- Display a different image based on the kind of event that's taking place
    eventImageSource =
      case model.eventType of
        GameOver ->
          Defaults.imagesLocation ++ "skull.png"

        TakeAction ->
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
          div [] []

        _ ->
          img [ src eventImageSource, imageStyle ] []   

  in
  div [ containerStyle, class "gameEventBox" ]
    [ p [ paragraphStyle ] [ text model.description ]
    , div [ class "imageAndButtonContainer", imageAndButtonContainer ]
        [ image 
        , LabeledButton.view buttonAddress model.button
        ]
    ]
```
You can see it uses `LabeledButton` - so let's find out how that works next.

###LabeledButton

A `LabeledButton` has a string `label`, `currentAction` and `x` and `y` position value. 
```
model : Model
model = 
  { label = "X"
  , currentAction = Up
  , x = 0
  , y = 0
  }
```

The `update` function just assigns the action to the button's `currentAction` value.
```
type Action 
  = Up
  | Over
  | Down
  | Click
  | NoOp


update : Action -> Model -> Model
update action model =
  case action of
    Up -> 
      --noFx
        { model 
            | currentAction = action
        }

    Over ->
      -- noFx
        { model 
            | currentAction = action
        }

    Down ->
      -- noFx
        { model 
            | currentAction = action
        }

    Click ->
      -- noFx
        { model 
            | currentAction = action
        }

    NoOp ->
      model
```
The `view` fires the correct action based on mouse interactivity and the displays the button label.
```
view : Signal.Address Action -> Model -> Html
view address model =
  button 
    [ buttonStyle model
    , onMouseOver address Over
    , onMouseOut address Up
    , onMouseDown address Down
    , onClick address Click
    ] 
    [ text model.label ]
```
It also changes the button's style based on the button state.
```
case model.currentAction of
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
```

The `ImageButton` is similar, but is initialized using an image.

###ImageButton

The `ImageButton` will automatically create a multi-state button for you as long as you provide PNG image files that follow this naming convention:

```
nameButtonUp.png
nameButtonOver.png
nameButtonDown.png
nameButtonClick.png
```

Just replace `name` with the name of your button, such as `star` or `next`. The `ImageButton` will assume that you have matching image files, named the way I've described.
The rest of the functionality is very similar to `LabeledButton` - see the source code for details.

###Infobox

The last major module is the `InfoBox` This is the game data display screen below the page content. It displays three major components:

1. An inventory, which displays the number of "Magic Pills" the player has and the number of "Transformations" they've undergone.
2. A story progress meter that tells the player which chapter of the story they are on, and which major story phase they are in.
3. An expandable info page, opened by a toggle button, which tells the player the story phase and the chapters that the phase contains.

Let's look at each of these three elements.

####Inventory

The inventory is first defined by `Data.Inventory`.
```
type alias Item = 
  { name : String
  , image : String
  , quantity : Int 
  }

type alias Inventory = List Item

inventory : Inventory
inventory =
  [
    { name = "Magic Pills"
    , image = "pill.png"
    , quantity = 0
    }
  ,
    { name = "Transformations"
    , image = "wand.png"
    , quantity = 0
    }
  ]
```
It's used by `Adventure.elm` to initialize the model. The view maps this information to a box which displays the item.
```
inventoryItem item =
  div
   [ inventoryItemStyle item ]
   [ div [ paragraphStyle ] [ text <| item.name ++ ": " ++ (toString item.quantity) ]
   ]

inventoryItemList =
  List.map inventoryItem model.inventory
```

The `inventoryItemStyle` chooses the correct image for the inventory based on the current item quantity. For example, if the quantity of magic pills is currently two, this code will use `pills_2.png` for the image.
```
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
    , "border-right" => "1px darkGray solid"
    , "user-select" => "none"
    ]
```

The inventory, is updated by `Adventure.elm` using the `UpdateData` action, which we'll discuss ahead. 

####Story progress meter

The story progress meter is made up of three parts: the meter bar, the chapter heading, and the story phase titles.

The chapter headings are first determined by `Adventure.elm` by calculating the current level of the story. The story level is the the number to the left of the decimal point in the story id. That means a page with an id of 1.2 is at story level 1, a page with an id of 5.3 is at story level 5. This is how `Adventure.elm` figures it out.
```
getStoryLevel : Data.ID -> Int
getStoryLevel id =
  (truncate id) - 1
```
The `Adventure` module's `update` function calculates a new story level like this:
```
storyLevel =
   getStoryLevel (.id currentPageData')
```
And then uses that to update the `InfoBox` with an `UpdateData` action, like this:
```
, Effects.task 
    <| Task.succeed 
          (UpdateInfoBox 
            (InfoBox.UpdateData 
                storyLevel 
                inventoryQuantities 
                storyPhaseChapter
            )
          )
```
Here's the `InfoBox`'s `UpdateData` action that handles the updates.
```
UpdateData level quantities currentStoryPhaseChapter' ->
  let
    item' item id =
      { item
          | quantity = List.Extra.getAt quantities id |> Maybe.withDefault 0
      }

    inventory' =
      List.indexedMap (\id item -> item' item id) model.inventory

    model' =
      { model 
         | storyLevel = level
         , storyChapter = currentStoryChapter level model.totalStoryChapters
         , inventory = inventory'
         , currentStoryPhaseChapter = currentStoryPhaseChapter'
      }
  in
    UI.animate
      |> UI.spring UI.noWobble
      |> UI.props
          [ Width (UI.to (toFloat (meterWidth model'))) Px
          ]
      |> onMeter model'
```
(You can see that it also handles the animation of the meter - we'll get to that soon!)
The correct story chapter is displayed with the help of the `currentStoryPhase` function.
```
currentStoryPhase model =
  List.Extra.getAt model.storyPhases model.storyLevel
    |> Maybe.withDefault "No story phase selected"
```
It's selecting the correct story phase chapter based on the model's copy of `Data.storyPhases`, which looks like this:
```
storyPhases = 
  [ "Call to Adventure"
  , "Supernatural Aid"
  , "The Journey Begins"
  , "Tests and Ordeals"
  , "Confronting the Goal"
  , "Transformation"
  , "Fulfilling the Quest"
  , "Returning Home"
  , "Adjusting"
  ]
```
And displaying it using a function called `storyPhaseTitle`:
```
, storyPhaseTitle (currentStoryPhase model)
```
... which looks like this:
```
storyPhaseTitle storyPhase =
  div 
    [ storyPhaseTitleStyle model.storyLevel ] 
    [ p [ storyPhaseStyle ] [ text storyPhase ] 
    ]
```
You can see that the `storyPhaseTitleStyle` is using the `model.storyLevel` to generate the CSS. It dynamically positions the title based on the width of each meter segment and the current story level. This is what makes the chapter title appear at the correct position above the meter
```
storyPhaseTitleStyle level =
  let
    height = 30
    width = 250
    meterX =
      model.meterX + ((meterSegmentWidth model) * (level + 1)) - width // 2
    meterY = 
      model.meterY - height  
  in
  style
    [ "width" => px width
    , "height" => px height
    , "position" => "absolute"
    , "top" => px meterY
    , "left" => px meterX 
    , "text-align" => "center"
    ]


-- Helper functions

px number = 
  (toString number) ++ "px"

meterSegmentWidth model =
  model.meterWidth // model.totalStoryLevels
```
The blue progress meter's width is animated dynamically in the `UpdateData` action using the `meterWidth` function.
```
UI.animate
  |> UI.spring UI.noWobble
  |> UI.props
      [ Width (UI.to (toFloat (meterWidth model'))) Px
      ]
  |> onMeter model'
```
The `meterWidth` function figures out how wide the meter should be by multiplying the segment length by the story level

```
meterWidth model =
  (meterSegmentWidth model) * (model.storyLevel + 1)
```

The meter is actually displayed in as two long rectangles: a fixed-width white rectangle as the background, and the blue foreground rectangle which changes in width. The foreground meter is being rendered by elm-html-animation, which is why it animates when the width changes.
```
, div
    [ class "meter", meterContainerStyle ] 
    [ div [ class "meterBackground",  meterBackgroundStyle model ] []
    , div [ class "meterForeground", style ((meterForeground model) ++ (UI.render model.styleMeter)) ] []
```

The last major feature of the story meter is the story phase chapters: the three main headings that define the major story sections.

```
storyPhaseChapters =
  let
    chapterHeading heading =
      div [ chapterHeadingStyle heading ] [ text heading ]
  in 
    List.map chapterHeading model.storyPhaseChapters
```
These just maps the `Data.storyPhaseChapters` list into `div` containers.  
```
chapter1 = "Phase 1: The Departure"
chapter2 = "Phase 2: The Journey"
chapter3 = "Phase 3: The Return"

storyPhaseChapters = 
  [ chapter1
  , chapter2
  , chapter3
  ]
```

The `chapterHeadingStyle` figures out whether the text should be bold or dimmed based on whether or not the text matches the current story chapter.
```
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
```
The story progress meter also plots vertical meter markers, using similar techniques - take a look at the `storyPhaseMarker` and `meterMarker` create these marks dynamically based on the number of story chapters.
```
-- Map the meter markers

marker level = 
  div [ markerStyle model level ] []

meterMarkers =
  List.map marker [ 1 .. model.totalStoryLevels - 1 ]

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
```

####The info page
the info page is opened by a toggle button that sits at the top right corner of the game status display bar. It display the information in the `Data.infoPages` list, and chooses the correct information to display depending on the progress of the story.
The `infoButton` is an `ImageButton` which runs the `UpdateButton` action when it's clicked in the `view`
```
, div [ infoButtonContainerStyle ] 
  [ ImageButton.view (forward UpdateButton) model.infoButton ] 
```
(It uses the custom `forward` function to handle signal forwarding.)
```
forward toAction =
  Signal.forwardTo address toAction
```

When `UpdateButton` runs, it runs the correct effect depending on the state of the toggle button. If the button is `Down`  and the infoBox is closed, then the effect runs `ShowInfo`. If the button is `Down` and the info box is open, the effect runs `HideInfo`. `ShowInfo` and `HideInfo` open and close the info box using elm-html-animation to animate the box's position with a spring wobble effect.

```
update : Action -> Model -> (Model, Effects Action)
update action model =

  -- This code sets up a toggle button effect on the `infoButton`
  let

    -- The current, updated version of the model's `infoButton`
    infoButton' buttonAction =
      ImageButton.update buttonAction model.infoButton

    {-
    `runCorrectEffect` will choose three possible effects to run:
    1. If the button is `Down`, and the infoBox is closed, then the effect
       runs `ShowInfo`
    2. If the button is `Down` and the info box is open, the the effect runs
       `HideInfo`
    3. In any other condition, don't run any effects
    This forms the basis of the toggle effect
    -}

    runCorrectEffect buttonAction =
      case
        ( .currentAction (infoButton' buttonAction) == ImageButton.Down 
        , model.infoBoxIsOpen == False
        )
      of 
        (True, True) ->
          Effects.task <| Task.succeed ShowInfo

        (True, False) ->
          Effects.task <| Task.succeed HideInfo

        _ -> 
          Effects.none
  in
  case action of

    -- Update the `infoButton` toggle button, and run an animation to 
    -- display the `infoBox` if the button is in the correct toggle state
    UpdateButton buttonAction ->
      (
        { model 
            | infoButton = infoButton' buttonAction
        }
      , runCorrectEffect buttonAction
      )

    -- An animation to show the `infoBox`
    ShowInfo ->
      let

        -- An updated model where `infoBoxIsOpen` is set to `True`
        model' =
          { model 
              | infoBoxIsOpen = True
          }
      in
        UI.animate
          |> UI.spring UI.wobbly
          |> UI.props
              [ Top (UI.to -300) Px
              , Opacity (UI.to 1)
              ]
          |> onMenu model'

    -- An animation to hide the `infoBox`
    HideInfo ->
      let

        -- An updated model where `infoBoxIsOpen` is set to `True`
        model' =
          { model 
              | infoBoxIsOpen = False
          }
      in
      UI.animate
        |> UI.spring UI.wobbly
        |> UI.props
            [ Top (UI.to -10) Px
            , Opacity (UI.to 0.5)
            ]
        |> onMenu model'

    AnimateMeter action ->
      onMeter model action

    AnimateInfoBox action ->
      onMenu model action
```
Another feature of the info box is that it will close when the mouse leaves it. This is simply a matter of running the `HideInfo` action when the mouse leaves it.
```
div 
   [ style (infoContainer ++ (UI.render model.styleInfo)) 
   , onMouseLeave address HideInfo
   ] 
   [ infoPageContent ]
```
By the way, the `Data.infoPages` content is in markdown format, so elm-markdown is used to convert it to HTML. It chooses the correct content to display based on the current story phase chapter.
```
infoPageContent =
  List.Extra.getAt model.infoPages (model.currentStoryPhaseChapter - 1)
    |> Maybe.withDefault "No info page selected"
    |> Markdown.toHtml
```
And that's it! Hero Quest done!

Lessons learned?
----------------
Don't make your modules too big! The `Page.elm` and `InfoBox.elm` do far too much on their own, which makes the code look more complex than it needs to. Better to make lots of smaller modules and hook them up in a parent module. The `ImageButton` and `LabeledButton` are good examples of properly scoped modules.