module Components.Tweets.RenderTweets exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import List
import Markdown

renderTweet : String -> Html a
renderTweet tweet =
  div [class "ui raised segment"][Markdown.toHtml [] tweet]

renderTweets : List String -> Html a
renderTweets tweets =
  div []
  (tweets
  |> List.map renderTweet)
