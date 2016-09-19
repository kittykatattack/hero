module Button where

import Effects exposing (Effects, Never)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
-- import Actions exposing (..)


-- MODEL

type alias Model = 
  { label : String
  , textColor : String
  , x : Int 
  , y : Int
  , currentAction : Action
  , backgroundColor : String
  }

model : Model
model = 
  { label = "X"
  , textColor = "white"
  , x = 0
  , y = 0
  , currentAction = NoOp
  , backgroundColor = "darkGrey"
  }


init : String -> Int -> Int -> Model
init label' x' y' = 
    { model 
      | label = label' 
      , x = x'
      , y = y'
    }

noFx model = (model, Effects.none)

-- UPDATE

type Action 
  = Down
  | Up
  | Out
  | NoOp

update : Action -> Model -> Model
update action model = 
  case action of
    Down -> 
      { model 
          | backgroundColor = "black" 
          , currentAction = action
      }

    Up -> 
      { model 
          | backgroundColor = "darkGrey" 
          , currentAction = action
      }

    Out ->
     { model 
          | backgroundColor = "darkGrey" 
          , currentAction = action
     }

    NoOp ->
      model


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div 
    [ buttonStyle model
    , onMouseDown address Down
    , onMouseUp address Up
    , onMouseOut address Out
    ] 
    [ text model.label ]

-- Create a custom infix operator to reduce the number of
-- parentheses when adding CSS attributes
(=>) = (,)

buttonStyle : Model -> Attribute
buttonStyle model =
  style 
    [ "color" => model.textColor 
    , "background" => model.backgroundColor
    , "position" => "absolute"
    , "height" => "50px"
    , "width" => "120px"
    , "top" => (toString model.y ++ "px")
    , "left" => (toString model.x ++ "px")
    , "display" => "flex"
    , "justify-content" => "center"
    , "align-items" => "center"
    , "cursor" => "pointer"
    , "margin-bottom" => "10px"
    , "-webkit-user-select" => "none"
    , "-moz-user-select" => "none"
    , "-khtml-user-select" => "none"
    , "-ms-user-select" => "none"
    , "userSelect" => "none"
    ]
