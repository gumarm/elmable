module Components.Tweets.TwitterContainer exposing (..)

import Maybe
import Html exposing (..)
import Components.Tweets.RenderTweets exposing (renderTweets)

model : Maybe (List String)
model = Nothing

loadTweets : String -> Html a
loadTweets user = 
  div [] [text(user), div [] [
    model
      |> Maybe.map renderTweets
      |> Maybe.withDefault (div [] [text("No tweets!")])
    ]]