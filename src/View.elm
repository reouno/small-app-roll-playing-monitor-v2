module View exposing (..)

import Html exposing (Html, div, text)
import Models exposing (Model, PlayerId)
import Msgs exposing (Msg)
import Players.Edit
import Players.List
import Players.New
import RemoteData

view : Model -> Html Msg
view model =
    div []
        [ page model ]

page : Model -> Html Msg
page model =
    case model.route of
        Models.PlayersRoute ->
            Players.List.view model.players
        Models.PlayerRoute id ->
            playerEditPage model id
        Models.CreatePlayerRoute ->
            Players.New.view model
        Models.NotFoundRoute ->
            notFoundView

playerEditPage : Model -> PlayerId -> Html Msg
playerEditPage model playerId =
    case model.players of
        RemoteData.NotAsked ->
            text "WebData not asked."
        RemoteData.Loading ->
            text "Loading ..."
        RemoteData.Failure error ->
            text ( toString error )
        RemoteData.Success players ->
            let
                maybePlayer =
                    players
                        |> List.filter ( \player -> player.id == playerId )
                        |> List.head
            in
                case maybePlayer of
                    Just player ->
                        Players.Edit.view player
                    Nothing ->
                        notFoundView

notFoundView : Html msg
notFoundView =
    div []
        [ text "Page not found." ]
