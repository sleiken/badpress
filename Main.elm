module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (id, type', value, class, autocomplete, placeholder)
import Html.Events exposing (onClick)
import Html.App
import Http
import Task exposing (Task)
import Json.Decode exposing ((:=), Decoder, string, object4)
import Keyboard exposing (..)
import Char exposing (..)
import Dom


-- MODEL


type alias Model =
    { query: String
    , result: ResultRecord
    , class: String
    }

init : ( Model, Cmd Msg )
init =
    ( { query = "", result = {p = "", n = "", s = "", t = ""}, class = "hidden" }, Cmd.none )


-- MESSAGES


type Msg
    = Fetch
    | FetchSuccess ResultRecord
    | FetchError Http.Error
    | Query String


-- VIEW


view : Model -> Html Msg
view model =
    div [ class "h-align-center"]
      [ div [ class "block" ]
        [ div [ class "v-align-center search-bar" ]
          [ form [ Html.Events.onSubmit Fetch, autocomplete False ]
            [ input [ id "search", type' "text", Html.Events.onInput Query, placeholder "Enter a word or phrase to analyze", value model.query ] []
            ]
          ]
        , div [ class ("term " ++ model.class) ] [ text  model.result.t ]
        , div [ class ("results " ++ model.class) ]
          [ div [class "positivity"] [ text ("Positive Tweets: " ++ model.result.p ++ "%") ]
          , div [class "negativity"] [ text ("Negative Tweets: " ++ model.result.n ++ "%") ]
          , div [class "subjectivity"] [ text ("Subjectivity Score: " ++ model.result.s ++ " / 100") ]
          ]
        ]
      ]

type alias ResultRecord =
  { p : String
  , n : String
  , s : String
  , t : String
  }

decode : Decoder ResultRecord
decode =
  object4 ResultRecord
    ("pos" := string)
    ("neg" := string)
    ("subjectivity" := string)
    ("term" := string)

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
            ( { model | query = "" }, fetchCmd model )

        FetchSuccess result ->
            ( { model | result = { p = result.p, n = result.n, s = result.s, t = result.t }, class = "" }, Cmd.none )

        FetchError error ->
            ( model, Cmd.none )


-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = (always Sub.none)
        }
