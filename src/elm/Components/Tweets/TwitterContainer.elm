module Components.Tweets.TwitterContainer exposing (..)

import Array
import Maybe
import Html exposing (..)
import Html.Events exposing (..)
import Http
import Json.Decode as Decode

import Components.Tweets.RenderTweets exposing (renderTweets)

usernames : Array.Array String
usernames = Array.fromList ["trump", "other"]

type Msg = Toggle
  | ReceiveTweets (Result Http.Error String)

type alias Model = {
  index: Int,
  tweets: Maybe (List String)
}

model : Model
model = Model 0 Nothing

-- UPDATE
update : Msg -> Model -> Model
update msg model = 
  case msg of
    Toggle ->
      Model ((model.index + 1) % (Array.length usernames)) Nothing
    ReceiveTweets (Ok data) ->
      Model model.index (Just (extractTweets data))
    ReceiveTweets (Err _) ->
      Model model.index Nothing


-- VIEW
view : Model -> Html Msg
view model = 
  div []
  [ button [onClick Toggle] [text ("Toggle")],
  div [] [text(getUsername model), div []
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

getUsername : Model -> String
getUsername model = 
  Array.get model.index usernames
    |> Maybe.withDefault "trump"