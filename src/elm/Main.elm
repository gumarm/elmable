module Main exposing (..)

import Array
import Maybe
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

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

usernames : Array.Array String
usernames = Array.fromList ["trump", "other"]

-- UPDATE
-- update : Msg -> Model -> Model
-- update msg model = 
--   case msg of
--     Toggle ->
--       Model ((model.index + 1) % (Array.length usernames)) Nothing
--     ReceiveTweets (Ok data) ->
--       Model model.index (Just (extractTweets data))
--     ReceiveTweets (Err _) ->
--       Model model.index Nothing

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = 
  case msg of
    Toggle ->
      let
        newIndex = ((model.userIndex + 1) % (Array.length usernames))
      in
      (Model newIndex Nothing, loadTweets (getUsername newIndex))
    ReceiveTweets (Ok data) ->
      (Model model.userIndex (Just (extractTweets data)), Cmd.none)
    ReceiveTweets (Err _) ->
      (Model model.userIndex Nothing, Cmd.none)


-- VIEW
view : Model -> Html Msg
view model = 
  div []
  [ button [onClick Toggle] [text ("Toggle")],
  div [] [text(getUsername model.userIndex), div []
    [
    model.tweets
      |> Maybe.map renderTweets
      |> Maybe.withDefault (div [] [text("No tweets!")])
    ]]
  ]

loadTweets : String -> Cmd Msg
loadTweets user =
  let
    url =
      "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=" ++ user
  in
    Http.send ReceiveTweets (Http.get url decodeGifUrl)

decodeGifUrl : Decode.Decoder String
decodeGifUrl =
  Decode.at ["data", "image_url"] Decode.string

extractTweets : String -> List String
extractTweets data = 
  [data]

getUsername : Int -> String
getUsername index = 
  Array.get index usernames
    |> Maybe.withDefault "trump"