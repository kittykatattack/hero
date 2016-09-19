module ChoiceButton where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Defaults
-- import Actions exposing (..)


-- MODEL

type alias Model = 
  { label : String
  , width : Int
  , height : Int
  , currentAction : Action
  , baseBackgroundImage : String
  , backgroundImage : String
  }

model : Model
model = 
  { label = ""
  , width = 32
  , height = 32
  , currentAction = Up
  , baseBackgroundImage = "starButton"
  , backgroundImage = Defaults.imagesLocation ++ "starButtonUp" ++ ".png"
  }


init : (Model, Effects Action)
init = 
  noFx model

noFx model = (model, Effects.none)  

-- UPDATE

type Action 
  = Up
  | Over
  | Down
  | NoOp


update : Action -> Model -> (Model, Effects Action)
update action model =
  let
    backgroundImage' = 
      Defaults.imagesLocation 
      ++ model.baseBackgroundImage 
      ++ toString action
      ++ ".png"
  in
  case action of
    Up -> 
      noFx
        { model 
            | backgroundImage = backgroundImage'
            , currentAction = action
        }

    Over ->
      noFx
        { model 
            | backgroundImage = backgroundImage'
            , currentAction = action
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
  div 
    [ buttonStyle model
    , onMouseOver address Over
    , onMouseOut address Up
    , onMouseDown address Down
    ] 
    -- [ text model.label ]
    []


-- Create a custom infix operator to reduce the number of
-- parentheses when adding CSS attributes
(=>) = (,)

buttonStyle : Model -> Attribute
buttonStyle model =
  style 
    [ "background-image" => ("url('" ++ model.backgroundImage ++ "')")
    , "background-repeat" => "no-repeat"
    , "height" => (toString model.width ++ "px")
    , "width" => (toString model.height ++ "px")
    -- , "border" => "1px solid black"
    , "cursor" => "pointer"
    , "-webkit-user-select" => "none"
    , "-moz-user-select" => "none"
    , "-khtml-user-select" => "none"
    , "-ms-user-select" => "none"
    , "userSelect" => "none"
    ]
