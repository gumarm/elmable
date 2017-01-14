module Components.ShowTweets exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import List
import Maybe

type alias Tweet = 
  String

type alias Tweets =
  List Tweet

renderTweet : Tweet -> Html a
renderTweet tweet =
  div [class "tweet"][text (tweet)]

-- Tweets component
showTweets : Tweets -> Html a
showTweets tweets =
  div [class "tweets"]
  (tweets
  |> List.map renderTweet)
