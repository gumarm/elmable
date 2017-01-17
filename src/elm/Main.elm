module Main exposing (..)

import Array
import Maybe
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import Regex exposing (..)

import Components.Tweets.RenderTweets exposing (renderTweets)

type Msg = Toggle
  | ReceiveTweets (Result Http.Error String)

type alias Model = {
  userIndex: Int,
  tweets: Maybe (List String)
}

-- PROGRAM

main : Program Never Model Msg
main =
  Html.program
  { init = init 0
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
  }

init: Int -> (Model, Cmd Msg)
init index = 
  (Model index Nothing,
  loadTweets (getUsername index))

usernames : List String
usernames = ["realDonaldTrump", "HillaryClinton", "barackobama", "jfdoube"]

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Toggle ->
      let
        newIndex = ((model.userIndex + 1) % (List.length usernames))
      in
      (Model newIndex Nothing, loadTweets (getUsername newIndex))
    ReceiveTweets (Ok data) ->
      (Model model.userIndex (Just (extractTweets data)), Cmd.none)
    ReceiveTweets (Err _) ->
      (Model model.userIndex Nothing, Cmd.none)

-- [ button [onClick Toggle] [text ("Toggle")],
-- VIEW
view : Model -> Html Msg
view model = 
  div [class "funBackground"] [
    div [class "narrow"] [
    div [class "ui three item menu"] [
      a [class "item", onClick Toggle][text("Toggle")]
    ],
    section [] [
      h1 [class "ui horizontal divider header"][
        i [class "twitter icon"] [],
        text(getUsername model.userIndex)
      ],
      div [] [div []
        [
        model.tweets
          |> Maybe.map renderTweets
          |> Maybe.withDefault (div [class "ui ignored info message"] [text("No tweets!")])
        ]]
      ]
    ]
  ]

loadTweets : String -> Cmd Msg
loadTweets user =
  let
    url =
      "https://cors-anywhere.herokuapp.com/https://twitter.com/" ++ user
  in
    Http.send ReceiveTweets (Http.getString url)

extractTweets : String -> List String
extractTweets data = 
  (Regex.find All (Regex.regex """<p.+data-aria-label-part="0">(.+)</p>""") data)
    |> List.map (\m -> m.submatches)
    |> List.map (\m -> getByIndex m 0 Nothing)
    |> List.map (\m -> Maybe.withDefault "" m)

getUsername : Int -> String
getUsername index = 
  getByIndex usernames index "realDonaldTrump"

getByIndex : List a -> Int -> a -> a
getByIndex list index default = 
  Array.get index (Array.fromList list)
    |> Maybe.withDefault default