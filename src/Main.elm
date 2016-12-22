port module Main exposing (..)

import Html exposing (Html, program, text, div, form, input, button, audio)
import Html.Events exposing (onSubmit, onInput, onClick)
import Html.Attributes exposing (value, src, controls, class)


type ChatMessage
    = Text String
    | Audio String


type Msg
    = ChangeText String
    | ToggleRecording
    | AddText String
    | AddAudio String
    | SendText String


type alias Model =
    { text : String
    , recording : Bool
    , chatMessages : List ChatMessage
    }


init : ( Model, Cmd Msg )
init =
    ( Model "" False [], Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "text-center" ] <|
        [ text (toString model)
        , form
            [ onSubmit (SendText model.text) ]
            [ input [ onInput ChangeText, value model.text ] [] ]
        , button
            [ onClick ToggleRecording ]
            [ text
                (if model.recording then
                    "Stop"
                 else
                    "Record"
                )
            ]
        ]
            ++ (List.map
                    (\chatMessage ->
                        case chatMessage of
                            Audio audioMessage ->
                                div [] [ audio [ src audioMessage, controls True ] [] ]

                            Text textMessage ->
                                div [] [ text textMessage ]
                    )
                    model.chatMessages
               )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeText text ->
            ( { model | text = text }, Cmd.none )

        ToggleRecording ->
            let
                recording =
                    not model.recording
            in
                ( { model | recording = recording }, record recording )

        AddText text ->
            ( { model | chatMessages = model.chatMessages ++ [ Text text ], text = "" }, Cmd.none )

        AddAudio audio ->
            ( { model | chatMessages = model.chatMessages ++ [ Audio audio ] }, Cmd.none )

        SendText text ->
            ( model, sendText text )


port record : Bool -> Cmd msg


port sendText : String -> Cmd msg


port receiveText : (String -> msg) -> Sub msg


port receiveAudio : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ receiveAudio AddAudio
        , receiveText AddText
        ]


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
