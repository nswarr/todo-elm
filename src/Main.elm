module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, div, h1, img, input, text)
import Html.Attributes exposing (placeholder, src, type_, value)
import Html.Events exposing (keyCode, on, onInput)
import Json.Decode as Decode



---- MODEL ----


type alias Model =
    { newTaskText : String, tasks : List String }


init : ( Model, Cmd Msg )
init =
    ( { newTaskText = "", tasks = [] }, Cmd.none )



---- UPDATE ----


type Msg
    = NewTaskEnterKeyed Int
    | NewTaskTextChanged String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewTaskEnterKeyed keyPressed ->
            if keyPressed == 13 then
                ( { model
                    | newTaskText = ""
                    , tasks = model.newTaskText :: model.tasks
                  }
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        NewTaskTextChanged taskText ->
            ( { model | newTaskText = taskText }, Cmd.none )


drawListOfTasks : Model -> List (Html Msg)
drawListOfTasks model =
    model.tasks |> List.map (\task -> div [] [ text task ])



---- VIEW ----


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "Elm ToDo!" ]
        , div []
            [ input
                [ placeholder "Enter a task to do!"
                , value model.newTaskText
                , onInput NewTaskTextChanged
                , type_ "input"
                , on "keydown" (Decode.map NewTaskEnterKeyed keyCode)
                ]
                []
            ]
        , div []
            (drawListOfTasks model)
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
