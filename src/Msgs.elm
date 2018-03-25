module Msgs exposing (..)

import Http
import Models exposing (Model, Player)
import Navigation exposing (Location)
import RemoteData exposing (WebData)

type Msg
    = OnFetchPlayers ( WebData ( List Player ) ) -- プレイヤーリストをapiで取ってきたよ、というメッセージ
    | OnLocationChange Location -- ロケーション（URL）が変わったよ、というメッセージ
    | ChangeLevel Player Int
    | ChangeName Player String
    | OnPlayerSave ( Result Http.Error Player )
    | CreateNewPlayer
    | NewId String
    | NewName String
    | NewLevel Int
    | OnCreatePlayer ( Result Http.Error Player )
    | DeletePlayer Player
    | OnDeletePlayer ( Result Http.Error String )
