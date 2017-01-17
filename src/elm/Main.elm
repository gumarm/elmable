module Main exposing (..)

import Maybe
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)
import Http
import Regex exposing (..)
import Time

import Utils.List exposing (getByIndex)
import Components.Tweets.RenderTweets exposing (renderTweets)

type Msg = Toggle | ReceiveTweets (Result Http.Error String) | Refresh Time.Time

type alias Model = {
  userIndex: Int,
  isLoading: Bool,
  tweets: Maybe (List String)
}

-- PROGRAM
main : Program Never Model Msg
main =
  Html.program
  { init = init 0
    , view = view
    , update = update
    , subscriptions = \_ -> Time.every (10 * Time.second) Refresh
  }

init: Int -> (Model, Cmd Msg)
init index = 
  (Model index True Nothing,
  loadTweets (getUsername index))

usernames : List String
usernames = ["realDonaldTrump", "HillaryClinton", "barackobama", "jfdoube"]

colors: List String
colors = ["#e1f7d5", "#ffbdbd", "#c9c9ff", "#f1cbff"]

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Toggle ->
      let
        newIndex = ((model.userIndex + 1) % (List.length usernames))
      in
      (Model newIndex True Nothing, loadTweets (getUsername newIndex))
    Refresh _ ->
      (Model model.userIndex True Nothing, loadTweets (getUsername model.userIndex))
    ReceiveTweets (Ok data) ->
      (Model model.userIndex False (Just (extractTweets data)), Cmd.none)
    ReceiveTweets (Err _) ->
      (Model model.userIndex False Nothing, Cmd.none)

-- VIEW
view : Model -> Html Msg
view model = 
  div [class "fun-background", style [("backgroundColor", getByIndex colors model.userIndex "#FFF")]] [
    div [class "narrow"] [
    div [class "ui three item menu"] [
      a [class "item", onClick Toggle][text "Toggle"]
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
          |> Maybe.withDefault (getDefaultState model)
        ]]
      ]
    ]
  ]

getDefaultState : Model -> Html a
getDefaultState model = 
  case model.isLoading of
    True -> div [class "ui active centered inline loader"] []
    False -> div [class "ui ignored info message"] [text "No tweets!"]

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
