module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, type', value, class)
import Html.Events exposing (onClick)
import Html.App
import Http
import Task exposing (Task)
import Json.Decode as Decode
import Keyboard

-- MODEL


type alias Model =
    { query: String
    , result: String
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" "", Cmd.none )



-- MESSAGES


type Msg
    = Fetch
    | FetchSuccess String
    | FetchError Http.Error
    -- | KeyMsg Keyboard.KeyCode
    | Query String



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ form [ Html.Events.onSubmit Fetch ] [ input [ id "test", type' "text", Html.Events.onInput Query ] [] ]
        , text model.query
        ]


decode : Decode.Decoder String
decode =
    Decode.at [ "name" ] Decode.string

test : String
test =
    "TESTTTTT"

fetchTask : Task Http.Error String
fetchTask =
    Http.post
      decode
      "/api"
      (Http.string test)


fetchCmd : Cmd Msg
fetchCmd =
    Task.perform FetchError FetchSuccess fetchTask



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        -- KeyMsg key ->
        --     ( { model | result = (toString key) }, Cmd.none )

        Query query ->
            ( { model | query = query }, Cmd.none )

        Fetch ->
            ( model, fetchCmd )

        FetchSuccess name ->
            ( { model | result = name }, Cmd.none )

        FetchError error ->
            ( { model | result =toString error }, Cmd.none )


-- SUBSCRIPTIONS


-- subscriptions : Model -> Sub Msg
-- subscriptions model =
--     Keyboard.downs KeyMsg


-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
