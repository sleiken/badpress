module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, type', value, class)
import Html.Events exposing (onClick)
import Html.App
import Http
import Task exposing (Task)
import Json.Decode exposing ((:=), Decoder, string, object2)
import Keyboard

-- MODEL


type alias Model =
    { query: String
    , result: ResultRecord
    }


init : ( Model, Cmd Msg )
init =
    ( { query = "", result = {p = "", s = ""} }, Cmd.none )


-- MESSAGES


type Msg
    = Fetch
    | FetchSuccess ResultRecord
    | FetchError Http.Error
    | Query String



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ form [ Html.Events.onSubmit Fetch ] [ input [ id "test", type' "text", Html.Events.onInput Query ] [] ]
        , text model.result.p
        , text model.result.s
        ]


type alias ResultRecord =
  { p : String
  , s : String
  }


decode : Decoder ResultRecord
decode =
  object2 ResultRecord
    ("positivity" := string)
    ("subjectivity" := string)


fetchTask : Model -> Task Http.Error ResultRecord
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
            ( { model | result = { p = result.p, s = result.s } }, Cmd.none )

        FetchError error ->
            ( { model | query = toString error }, Cmd.none )


-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
