module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

-- component import example
import Components.ShowTweets exposing (showTweets)


-- APP
main : Program Never Int Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = Int

model : number
model = 0


-- UPDATE
type Msg = NoOp | Toggle

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model
    Toggle -> model + 1


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ][
    div [ class "row" ][
      div [ class "col-xs-12" ][
        div [ class "jumbotron" ][
          button [ class "btn btn-primary btn-lg", onClick Toggle ] [
            span[ class "glyphicon glyphicon-star" ][]
            , span[][ text "Toggle" ]
          ]
          ,showTweets ["tweet 1", "tweet 2"]
        ]
      ]
    ]
  ]