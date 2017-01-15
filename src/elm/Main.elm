module Main exposing (..)

import Html exposing(..)
import Components.Tweets.TwitterContainer exposing(..)

-- PROGRAM

main : Program Never AppModel Msg
main = 
    Html.program 
        { init = init 
        , update = update
        , subscriptions = \_ -> Sub.none
        , view = view
        }

type alias AppModel = {
  twitterContainerModel : Components.Tweets.TwitterContainer.Model
}

init : (AppModel, Cmd Msg)
init =
    ( { twitterContainerModel = Components.Tweets.TwitterContainer.model}, Cmd.none )

-- UPDATE
type Msg = TwitterMsg Components.Tweets.TwitterContainer.Msg

update : Msg -> AppModel -> (AppModel, Cmd Msg)
update msg model =
  case msg of
    TwitterMsg subMsg ->
      let
          twitterContainerModel =
              Components.Tweets.TwitterContainer.update subMsg model.twitterContainerModel
      in
          ( { model | twitterContainerModel = twitterContainerModel }, Cmd.map TwitterMsg Cmd.none )

-- VIEW
view : AppModel -> Html Msg
view model =
  Html.map TwitterMsg (Components.Tweets.TwitterContainer.view model.twitterContainerModel)