module Players.Widgets exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Msgs exposing (Msg)
import Routing exposing (playersPath)

nav : Html Msg
nav =
    div [ class "clearfix mb2 white bg-black p1" ]
        [ listBtn ]

listBtn : Html Msg
listBtn =
    a [ class "btn regular"
      , href playersPath
      ]
      [ i [ class "fa fa-chevron-left mr1" ] []
      , text "List"
      ]
