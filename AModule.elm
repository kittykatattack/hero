module AModule where

import Effects exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String
import Button
import Task
import List.Extra


-- MODEL

type alias Model = 
  { pressedButton : Button.Model
  , buttonAction : Button.Action
  , colors : List String
  , colorCounter : Int
  , selectedColor : String
  }


model : Model
model =
  let
    colors' = [ "cyan", "pink", "olive" ]
  in
  { pressedButton = Button.init "X" 0 0
  , buttonAction = Button.NoOp
  , colors = colors'
  , colorCounter = 0
  , selectedColor = List.head colors' |> Maybe.withDefault "black"
  }


init : String -> (Model, Effects Action)
init label' =
  noFx 
   { model 
     | pressedButton = Button.init label' 80 120
     , colorCounter = 0
   }


noFx model = (model, Effects.none)


-- UPDATE

type Action
  = UpdateButton Button.Action
  | ChangeColor


updateButton : Action -> Model -> (Model, Effects Action)
updateButton action model =
  case action of
    UpdateButton buttonAction ->
      let
        button' = Button.update buttonAction model.pressedButton
      in
      (
        { model 
           | pressedButton = button'
           , buttonAction = buttonAction
        }
      , Effects.task <| Task.succeed ChangeColor 
      )

    ChangeColor ->
      let

        colorCounter' = 
          if model.colorCounter < List.length model.colors - 1 then
            model.colorCounter + 1
          else
            0

        buttonAction' = model.pressedButton.currentAction

        selectedColor' = 
          List.Extra.getAt model.colors colorCounter' 
            |> Maybe.withDefault "black"

      in
      if buttonAction' == Button.Down then 
          noFx
            { model
                | colorCounter = colorCounter'
                , selectedColor = selectedColor'
            }
      else
        noFx model


buttonView : Signal.Address Action -> Model -> Html
buttonView address model =
  let
    buttonAddress = Signal.forwardTo address <| UpdateButton
  in
  div
    [ containerStyle model ]
    [ p [ paragraphStyle ] [ text "Parent Container" ]
    , p [ paragraphStyle ] [ text <| "colorCounter: " ++ toString model.colorCounter ]
    , p [ paragraphStyle ] [ text <| "selectedColor: " ++ model.selectedColor ]
    , p [ paragraphStyle ] [ text <| "buttonAction: " ++ toString model.buttonAction ]
    , Button.view buttonAddress model.pressedButton 
    ]


(=>) = (,)

containerStyle : Model -> Attribute
containerStyle model = 
  style
    [ "position" => "relative"
    , "height" => "300px"
    , "width" => "300px"
    , "background-color" => model.selectedColor
    ]

paragraphStyle : Attribute
paragraphStyle =
  style
    [ "font" => "16px"
    , "padding" => "0"
    , "margin" => "0"
    ]



