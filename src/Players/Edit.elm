module Players.Edit exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Msgs exposing (Msg)
import Models exposing (Player)
import Players.Widgets

view : Player -> Html Msg
view model =
    div []
        [ Players.Widgets.nav
        , form model
        ]

form : Player -> Html Msg
form player =
    div [ class "m3" ]
        [ h1 [] [ text player.name ]
        , formName player
        , formLevel player
        , formDelete player
        ]

formName : Player -> Html Msg
formName player =
    let
        message =
            Msgs.ChangeName player
    in
        div []
            [ input [ type_ "text", placeholder "New name", onInput message ] [] ]

formLevel : Player -> Html Msg
formLevel player =
    div [ class "clearfix py1" ]
        [ div [ class "col col-5" ] [ text "Level" ]
        , div [ class "col col-7" ]
            [ span [ class "h2 bold" ] [ text (toString player.level) ]
            , btnLevelDecrease player
            , btnLevelIncrease player
            ]
        ]

btnLevelDecrease : Player -> Html Msg
btnLevelDecrease player =
    let
        message =
            Msgs.ChangeLevel player -1
    in
        a [ class "btn ml1 h1"
          , onClick message
          ]
            [ i [ class "fa fa-minus-circle" ] [] ]

btnLevelIncrease : Player -> Html Msg
btnLevelIncrease player =
    let
        message =
            Msgs.ChangeLevel player 1
    in
        a [ class "btn ml1 h1"
          , onClick message
          ]
            [ i [ class "fa fa-plus-circle" ] [] ]

formDelete : Player -> Html Msg
formDelete player =
    div [ class "clearfix py1" ]
        [ div [ class "col col-5" ] []
        , div [ class "col col-7" ] [ btnDelete player ] ]

btnDelete : Player -> Html Msg
btnDelete player =
    a [ class "btn ml1", onClick ( Msgs.DeletePlayer player ) ]
        [ i [ class "bg-white border not-rounded", style [ ( "color", "red" ) ] ] [ text "Delete this player" ] ]
