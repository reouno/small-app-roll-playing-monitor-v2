module Players.New exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Models exposing (Model)
import Msgs exposing (Msg)
import RemoteData exposing (WebData)
import Players.Widgets

view : Model -> Html Msg
view model =
    div []
        [ Players.Widgets.nav
        , formNewPlayer model
        ]

formNewPlayer : Model -> Html Msg
formNewPlayer model =
    let
        newLevelMsg input =
            case ( String.toInt input ) of
                Ok value ->
                    Msgs.NewLevel value
                Err error ->
                    Msgs.NewLevel 1
    in
        div []
            [ input [ type_ "text", placeholder "ID", onInput Msgs.NewId ] []
            , input [ type_ "text", placeholder "Name", onInput Msgs.NewName ] []
            , input [ type_ "number", placeholder "1", onInput newLevelMsg ] []
            , button [ onClick Msgs.CreateNewPlayer ] [ text "confirm" ]
            , validationView model
            ]

validationView : Model -> Html Msg
validationView model =
    let
        ( color, info ) =
            if String.length model.newPlayer.id == 0 then
                ( "black", "Enter new ID." )
            else
                validate model
    in
        div [ style [ ( "color", color ) ] ]
            [ text info ]


validate : Model -> ( String, String )
validate model =
    case model.players of
        RemoteData.NotAsked ->
            ( "black", "" )
        RemoteData.Loading ->
            ( "black", "Validating ID ..." )
        RemoteData.Success players ->
            let
                ids = List.map ( \player -> player.id ) players
                isIdNew = not ( List.member model.newPlayer.id ids )
            in
                if isIdNew then
                    ( "green", "You can use this ID." )
                else
                    ( "red", "The ID already exists!! Enter another ID." )
        RemoteData.Failure err ->
            ( "red", "Error occurs. Cannot validate ID." )
