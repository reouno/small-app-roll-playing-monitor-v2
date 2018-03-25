module Commands exposing (..)

import Http
import Json.Decode as Decode
import Json.Decode.Pipeline exposing (decode, required)
import Json.Encode as Encode
import Msgs exposing (Msg)
import Models exposing (PlayerId, Player)
import RemoteData

fetchPlayers : Cmd Msg
fetchPlayers =
    Http.get fetchPlayersUrl playersDecoder
        |> RemoteData.sendRequest
        |> Cmd.map Msgs.OnFetchPlayers

fetchPlayersUrl : String
fetchPlayersUrl =
    "http://localhost:4000/players"

playersDecoder : Decode.Decoder (List Player)
playersDecoder =
    Decode.list playerDecoder

playerDecoder : Decode.Decoder Player
playerDecoder =
    decode Player
        |> required "id" Decode.string
        |> required "name" Decode.string
        |> required "level" Decode.int

savePlayerUrl : PlayerId -> String
savePlayerUrl playerId =
    "http://localhost:4000/players/" ++ playerId

savePlayerRequest : Player -> Http.Request Player
savePlayerRequest player =
    Http.request
        { body = playerEncoder player |> Http.jsonBody -- convert Encode.Value into JSON string
        , expect = Http.expectJson playerDecoder -- specify how to parse the response
        , headers = []
        , method = "PATCH" -- http method when updating records
        , timeout = Nothing
        , url = savePlayerUrl player.id
        , withCredentials = False
        }

savePlayerCmd : Player -> Cmd Msg
savePlayerCmd player =
    savePlayerRequest player -- create the save request
        |> Http.send Msgs.OnPlayerSave -- generate a command to send the request

playerEncoder : Player -> Encode.Value -- encode the given player
playerEncoder player =
    let
        attributes =
            [ ( "id", Encode.string player.id )
            , ( "name", Encode.string player.name )
            , ( "level", Encode.int player.level )
            ]
    in
        Encode.object attributes

addPlayerRequest : Player -> Http.Request Player
addPlayerRequest player =
    Http.request
        { method = "POST"
        , headers = []
        , url = fetchPlayersUrl
        , body = playerEncoder player |> Http.jsonBody
        , expect = Http.expectJson playerDecoder
        , timeout = Nothing
        , withCredentials = False
        }

addPlayerCmd : Player -> Cmd Msg
addPlayerCmd player =
    addPlayerRequest player
        |> Http.send Msgs.OnCreatePlayer

deletePlayerRequest : Player -> Http.Request String
deletePlayerRequest player =
    Http.request
        { method = "DELETE"
        , headers = []
        , url = savePlayerUrl player.id
        , body = playerEncoder player |> Http.jsonBody
        , expect = Http.expectString
        , timeout = Nothing
        , withCredentials = False
        }

deletePlayerCmd : Player -> Cmd Msg
deletePlayerCmd player =
    deletePlayerRequest player
        |> Http.send Msgs.OnDeletePlayer
