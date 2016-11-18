module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, type', value, class)
import Html.Events exposing (onClick)
import Html.App
import Http
import Task exposing (Task)
import Json.Decode as Decode

-- MODEL


type alias Model =
    String


init : ( Model, Cmd Msg )
init =
    ( "", Cmd.none )



-- MESSAGES


type Msg
    = Fetch
    | FetchSuccess String
    | FetchError Http.Error



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ form []
          [ input [ id "test", type' "text", value model ] [] ]
        , button [ onClick Fetch ] [ text "Fetch" ]
        ]


decode : Decode.Decoder String
decode =
    Decode.at [ "name" ] Decode.string


url : String
url =
    "/api"


fetchTask : Task Http.Error String
fetchTask =
    Http.get decode url


fetchCmd : Cmd Msg
fetchCmd =
    Task.perform FetchError FetchSuccess fetchTask



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Fetch ->
            ( model, fetchCmd )

        FetchSuccess name ->
            ( name, Cmd.none )

        FetchError error ->
            ( toString error, Cmd.none )



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
