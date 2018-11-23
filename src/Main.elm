module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, div, h1, img, input, text)
import Html.Attributes exposing (placeholder, src, type_, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Decode



---- MODEL ----


type alias Model =
    { newTaskText : String }


init : ( Model, Cmd Msg )
init =
    ( { newTaskText = "" }, Cmd.none )



---- UPDATE ----


type Msg
    = NewTaskEnterKeyed Int
    | NewTaskTextChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTaskEnterKeyed int ->
            if int == 13 then
                ( { model | newTaskText = "" }, Cmd.none )

            else
                ( model, Cmd.none )

        NewTaskTextChanged string ->
            ( { model | newTaskText = string }, Cmd.none )



---- VIEW ----


onKeyDown : (Int -> msg) -> Attribute msg
onKeyDown tagger =
    on "keydown" (Decode.map tagger keyCode)


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm ToDo!" ]
        , div []
            [ input [ placeholder "Enter a task to do!", value model.newTaskText, onInput NewTaskTextChanged, type_ "input", onKeyDown NewTaskEnterKeyed ] [] ]
        ]



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = always Sub.none
        }
