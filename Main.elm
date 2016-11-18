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
    | Query String



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ form [ Html.Events.onSubmit Fetch ] [ input [ id "test", type' "text", Html.Events.onInput Query ] [] ]
        , text model.result
        ]


decode : Decode.Decoder String
decode =
    Decode.at [ "name" ] Decode.string


fetchTask : Model -> Task Http.Error String
fetchTask model =
    Http.post
      decode
      "/api"
      (Http.string model.query)


fetchCmd : Model -> Cmd Msg
fetchCmd model =
    Task.perform FetchError FetchSuccess (fetchTask model)


-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Query query ->
            ( { model | query = query }, Cmd.none )

        Fetch ->
            ( model, fetchCmd model )

        FetchSuccess result ->
            ( { model | result = result }, Cmd.none )

        FetchError error ->
            ( { model | result =toString error }, Cmd.none )


-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
