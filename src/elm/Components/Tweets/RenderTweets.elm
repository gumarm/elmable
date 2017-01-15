module Components.Tweets.RenderTweets exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import List

type alias Tweet = 
  String

type alias Tweets =
  List Tweet

renderTweet : Tweet -> Html a
renderTweet tweet =
  div [class "tweet"][text (tweet)]

-- Tweets component
renderTweets : Tweets -> Html a
renderTweets tweets =
  div [class "tweets"]
  (tweets
  |> List.map renderTweet)
