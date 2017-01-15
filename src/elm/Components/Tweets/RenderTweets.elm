module Components.Tweets.RenderTweets exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import List

renderTweet : String -> Html a
renderTweet tweet =
  div [class "tweet"][text (tweet)]

renderTweets : List String -> Html a
renderTweets tweets =
  div [class "tweets"]
  (tweets
  |> List.map renderTweet)
