module Main exposing (..)

import Array
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Components.Tweets.TwitterContainer exposing (loadTweets)

-- APP
main : Program Never Model Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = Int

model : Model
model = 0

usernames : Array.Array String
usernames = Array.fromList ["trump", "other"]

-- UPDATE
type Msg = NoOp | Toggle

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model
    Toggle -> (model + 1) % Array.length usernames

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
          ,(Array.get model usernames)
            |> Maybe.map loadTweets
            |> Maybe.withDefault (div [] [text("Nothing here to show")])
        ]
      ]
    ]
  ]