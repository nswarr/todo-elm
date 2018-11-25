module Main exposing (Model, Msg(..), init, main, update, view)

import Browser
import Html exposing (Attribute, Html, div, h1, img, input, text)
import Html.Attributes exposing (checked, placeholder, src, type_, value)
import Html.Events exposing (keyCode, on, onClick, onInput)
import Json.Decode as Decode
import List.Extra exposing (updateAt)



---- MODEL ----


type alias Model =
    { newTaskText : String, tasks : List Task }


type alias Task =
    { text : String
    , isComplete : Bool
    }


init : ( Model, Cmd Msg )
init =
    ( { newTaskText = "", tasks = [] }, Cmd.none )



---- UPDATE ----


type Msg
    = NewTaskEnterKeyed Int
    | NewTaskTextChanged String
    | TaskCompleteToggled Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newTask : String -> Task
        newTask taskText =
            { text = taskText, isComplete = False }
    in
    case msg of
        NewTaskEnterKeyed keyPressed ->
            if keyPressed == 13 then
                ( { model
                    | newTaskText = ""
                    , tasks = newTask model.newTaskText :: model.tasks
                  }
                , Cmd.none
                )

            else
                ( model, Cmd.none )

        NewTaskTextChanged taskText ->
            ( { model | newTaskText = taskText }, Cmd.none )

        TaskCompleteToggled index ->
            let
                toggleTask : Task -> Task
                toggleTask task =
                    { task | isComplete = not task.isComplete }
            in
            ( { model | tasks = updateAt index toggleTask model.tasks }, Cmd.none )


drawListOfTasks : Model -> List (Html Msg)
drawListOfTasks model =
    List.indexedMap drawTask model.tasks


drawTask : Int -> Task -> Html Msg
drawTask index task =
    div []
        [ div [] [ input [ type_ "checkbox", checked task.isComplete, onClick (TaskCompleteToggled index) ] [] ]
        , div [] [ text task.text ]
        ]



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
