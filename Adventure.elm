module Adventure exposing (..)

import Html exposing (..)
import Html.App
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Task
import Task.Extra
import Page
import InfoBox
import Data 
import Defaults
import LabeledButton
import GameEvent

-- For elm-html-animation
import Time exposing (second)
import Animation

-- MODEL

type alias Model =
  { story : Data.Story 
  , currentPageData : Data.Page
  , currentPageID : Data.ID
  , currentPage : Page.Model
  , previousPage : Page.Model
  , infoBox : InfoBox.Model 
  , storyLevel : Int
  , storyPhases : List String
  , storyChapter : String
  , storyPhaseChapters : List String
  , inventory : Data.Inventory
  , infoPages : List String
  , pageMsg : Page.Msg
  , stylePreviousPage : Animation.State
  , styleCurrentPage : Animation.State
  }

model : Model 
model = 
  let
    pageData =
      Data.pageOne
  in 

  { story = Data.story
  , currentPageData = getCurrentPageData Data.story 1.1
  , currentPageID = 1.1 
  , currentPage = getCurrentPage pageData
  , previousPage = getCurrentPage pageData 
  , infoBox = 
      InfoBox.init 
        Data.inventory 
        (getStoryLevel 1.1)
        pageData.storyChapter
        Data.storyPhases
        Data.storyPhaseChapters
        Data.infoPages

  , storyLevel = getStoryLevel 1.1 
  , storyChapter = pageData.storyChapter
  , storyPhases = Data.storyPhases
  , storyPhaseChapters = Data.storyPhaseChapters
  , inventory = Data.inventory
  , infoPages = Data.infoPages
  , pageMsg = Page.NoOp

  -- Set the start opacity for the current and previous page divs.
  -- These values will be flipped in the update section when the animation 
  -- runs. This trick is what causes the fade-in/fade-out effect 
  , stylePreviousPage = Animation.style [ Animation.opacity 0.0 ]
  , styleCurrentPage = Animation.style [ Animation.opacity 1.0 ]
  }



init : (Model, Cmd Msg)
init =
  let

    -- The page id on which the story should start
    id = 
      1.1 --3.1 

    currentPageData' = 
      getCurrentPageData model.story id

    currentPage' = getCurrentPage currentPageData'

    storyLevel =
       getStoryLevel id
  in
    -- withFx  
    { model 
        | currentPage = currentPage'
        , currentPageData = currentPageData'
        , previousPage = currentPage'
        , infoBox = 
            InfoBox.init 
              model.inventory 
              storyLevel
              model.storyChapter
              model.storyPhases
              model.storyPhaseChapters
              model.infoPages
    }
    ! [] 

subscriptions : Model -> Sub Msg
subscriptions model =

  -- The animations for the this module
  Sub.batch [
    Animation.subscription Animate 
      [ model.stylePreviousPage
      , model.styleCurrentPage 
      ]

    --, The animations for the InfoBox module
   , Sub.map UpdateInfoBox (InfoBox.subscriptions model.infoBox)
  ]

-- Calculate the `storyLevel` by taking the 
-- page ID, truncating the decimal value, and
-- subtracting it by one. It has to be subtracted
-- by one so that numbering starts at 0, which is what the
-- `infoBox` needs to figure out the correct story phase and
-- story chapter
getStoryLevel : Data.ID -> Int
getStoryLevel id =
  (truncate id) - 1

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
    

-- UPDATE

type Msg 
  = UpdatePage Page.Msg
  | UpdateInfoBox InfoBox.Msg
  | FadeOutOldPage
  | FadeInNewPage
  | Animate Animation.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  -- The model's `currentPage` is updated with a `newPage` which can
  -- be one of two things: an updated version of the curent page,
  -- or a newly intialized `Page.Model` whith fresh data. The `newPage` 
  -- function below figures out which this should be by comparing the unupdated
  -- `currentPage`'s `activeLink` to the model's older (unupdated) `activeLink`
  -- If they're different, a completely new page is generated. If they're the
  -- same, the model's current page is just updated, so that UI events work properly
  case msg of
    Animate animMsg ->
      ( { model
          | stylePreviousPage = Animation.update animMsg model.stylePreviousPage
          , styleCurrentPage = Animation.update animMsg model.styleCurrentPage
        }
      , Cmd.none
      )

    UpdatePage pageMsg ->
      let
        currentPageData' = 
          getCurrentPageData model.story activeLink

        currentPage' = 
          fst (Page.update pageMsg model.currentPage)
          -- fst (Page.update pageMsg (getCurrentPage currentPageData'))

        activeLink =
           .activeLink currentPage' 

        previousLink =
           .activeLink model.currentPage

        newPageRequested =
          activeLink /= previousLink

        newPage =
          if newPageRequested then
            fst (Page.init currentPageData')
          else
            currentPage'

        storyLevel =
           getStoryLevel (.id currentPageData')

        inventoryQuantities =
          [ (.pillsLeft currentPageData')
          , (.transformations currentPageData') 
          ]

        storyPhaseChapter =
          .storyPhaseChapter currentPageData'

        -- The version of the model which is only used when
        -- the current page is being updated
        model' =
          { model 
              | currentPage = newPage 
              , currentPageData = currentPageData'
              , pageMsg = pageMsg
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
              -- This is the page that will be faded out in the page transition
              , previousPage = model.currentPage

              -- Flip the start opacity values for the previous and current page.
              -- This is what creates the fade in/out effect  
              , stylePreviousPage = Animation.style [ Animation.opacity 1.0 ]
              , styleCurrentPage = Animation.style [ Animation.opacity 0.0 ]
          }

      in
      if newPageRequested then

      -- Return a new model with the new page, perform a transition and update the 
      -- infoBox
        update FadeOutOldPage model''
      else

      -- Return a new model with the same page and update the infoBox
      update 
        (UpdateInfoBox 
          (InfoBox.UpdateData storyLevel inventoryQuantities storyPhaseChapter)
        ) 
        model'

    UpdateInfoBox infoBoxMsg ->

      -- This is the format for updating a child with Cmd
      let
        (infoBox', fx) = InfoBox.update infoBoxMsg model.infoBox
      in
          (
            { model 
              | infoBox = infoBox'
            }

            -- Map the Cmd up through the hierarchy so that
            -- The InfoBox's animation is run by the app
            , Cmd.map UpdateInfoBox fx
          )

    FadeOutOldPage ->
      let
        model' = 
          { model
            | stylePreviousPage =
              Animation.interrupt
                  [ Animation.to
                    [ Animation.opacity 0
                    ]
                  ]
                  model.stylePreviousPage
          }

      in 
        update FadeInNewPage model'

    FadeInNewPage ->
      let
        model' = 
          { model
            | styleCurrentPage =
              Animation.interrupt
                  [ Animation.to
                    [ Animation.opacity 1
                    ]
                  ]
                  model.styleCurrentPage
          }

      in
        update (UpdatePage model'.pageMsg) model' 


-- VIEW

view : Model -> Html Msg
view model =
  div
    [ adventureStyle ]
    [ 
      
      -- A holding div for the previous page, which is used to create the fade effect. 
      -- It's opacity is 0 when the game starts,
      -- but it's set to 1 in the update function and then faded out with each page transition 
      div (Animation.render model.stylePreviousPage ++ [ previousPageStyle ]) [ (Html.App.map UpdatePage (Page.view model.previousPage)) ]

      -- The currently active page. It's opacity is 1 when the game starts, but is set to 
      -- 0 in the update function and then faded in with
      -- each page transition 
    , div (Animation.render model.styleCurrentPage ++ [ currentPageStyle ]) [ (Html.App.map UpdatePage (Page.view model.currentPage)) ] 
    , div [ infoBoxStyle ] [ Html.App.map UpdateInfoBox (InfoBox.view model.infoBox) ] 
    ]


-- CSS styles

(=>) = (,)

adventureStyle =
  style
    [ "width" => ((toString Defaults.width) ++ "px")
    , "height" => ((toString Defaults.height) ++ "px")
    , "border" => "1px solid darkGray"
    , "position" => "relative"
    , "overflow" => "hidden" 
    ]

currentPageStyle =
  style
  [ "position" => "absolute"
  , "top" => "0px"
  , "left" => "0px" 
  -- , "opacity" => toString opacity
  ]

previousPageStyle =
  style
  [ "position" => "absolute"
  , "top" => "0px"
  , "left" => "0px"
  -- , "display" => display 
  -- , "opacity" => toString opacity
  ]

infoBoxStyle =
  style 
  [ "position" => "absolute"
  , "top" => "480px"
  , "left" => "0px" 
  ]

