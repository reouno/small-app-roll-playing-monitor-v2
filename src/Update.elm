module Update exposing (..)

import Commands exposing (deletePlayerCmd, fetchPlayers, savePlayerCmd, addPlayerCmd)
import Models exposing (Model, Player)
import Msgs exposing (Msg)
import RemoteData
import Routing exposing (parseLocation)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Msgs.OnFetchPlayers response ->
            ( { model | players = response }, Cmd.none )
        Msgs.OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )
        Msgs.ChangeLevel player howMuch ->
            let
                updatedPlayer =
                    { player | level = player.level + howMuch }
            in
                ( model, savePlayerCmd updatedPlayer )
        Msgs.ChangeName player newName ->
            let
                updatedPlayer =
                    { player | name = newName }
            in ( model, savePlayerCmd updatedPlayer )
        Msgs.OnPlayerSave ( Ok player ) ->
            ( updatePlayer model player, Cmd.none )
        Msgs.OnPlayerSave ( Err error ) ->
            ( model, Cmd.none )
        Msgs.NewId id ->
            let
                newPlayer = Player id model.newPlayer.name model.newPlayer.level
                newModel = { model | newPlayer = newPlayer }
            in
                ( newModel, Cmd.none )
        Msgs.NewName name ->
            let
                newPlayer = Player model.newPlayer.id name model.newPlayer.level
                newModel =
                    { model | newPlayer = newPlayer }
            in
                ( newModel, Cmd.none )
        Msgs.NewLevel level ->
            let
                newPlayer = Player model.newPlayer.id model.newPlayer.name level
                newModel =
                    { model | newPlayer = newPlayer }
            in
                ( newModel, Cmd.none )
        Msgs.CreateNewPlayer ->
            let
                newPlayer = model.newPlayer
                newModel =
                    { model | newPlayer = Player "" "" 0}
            in
                ( newModel, addPlayerCmd newPlayer )
        Msgs.OnCreatePlayer ( Ok player ) ->
            ( model, fetchPlayers )
        Msgs.OnCreatePlayer ( Err error ) ->
            ( model, Cmd.none )
        Msgs.DeletePlayer player ->
            ( model, deletePlayerCmd player )
        Msgs.OnDeletePlayer ( Ok _ ) ->
            ( { model | route = Models.PlayersRoute }, fetchPlayers )
        Msgs.OnDeletePlayer ( Err error ) ->
            ( model, fetchPlayers )


updatePlayer : Model -> Player -> Model
updatePlayer model updatedPlayer =
    let
        pick currentPlayer =
            if updatedPlayer.id == currentPlayer.id then
                updatedPlayer
            else
                currentPlayer
        updatePlayerList players =
            List.map pick players
        updatedPlayers =
            RemoteData.map updatePlayerList model.players
    in
        { model | players = updatedPlayers }
