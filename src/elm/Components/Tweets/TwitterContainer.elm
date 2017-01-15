module Components.Tweets.TwitterContainer exposing (..)

import Maybe
import Html exposing (..)
import Http
import Json.Decode as Decode

import Components.Tweets.RenderTweets exposing (renderTweets)

type Msg = ReceiveTweets (Result Http.Error String)

type alias Model = {
  user: String,
  tweets: Maybe (List String)
}

model : Model
model = Model "trump" Nothing

update : Msg -> Model -> Model
update msg model = 
  case msg of
    ReceiveTweets (Ok data) ->
      Model model.user (Just (extractTweets data))
    ReceiveTweets (Err _) ->
      Model model.user Nothing


view : Model -> Html a
view model = 
  div [] [text(model.user), div [] [
    model.tweets
      |> Maybe.map renderTweets
      |> Maybe.withDefault (div [] [text("No tweets!")])
    ]]

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