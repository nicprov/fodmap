module Pages.Authenticate exposing (Model, Msg, page)

import Common.Alerts exposing (viewAlertError)
import Common.Response exposing (Category, categoryDecoder)
import Effect exposing (Effect)
import Gen.Route as Route
import Hotkeys exposing (onKeyCode)
import Html exposing (Html, a, br, button, div, h2, h3, img, input, label, main_, p, span, text, ul)
import Html.Attributes as Attr
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as Decode exposing (Decoder)
import Page
import Shared
import Request exposing (Request)
import View exposing (View)
import Common.Base exposing (baseUrl, cdnUrl)

page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.advanced
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }

-- Init

type Status
    = Failure String
    | Loading
    | None

type alias Model =
    { status: Status
    , password: String
    }

type Msg
    = ChangedPassword String
    | ClickedSubmit

secret: String
secret =
    "test123"

init: (Model, Effect Msg)
init =
    (Model None "", Effect.none)


-- Update

update: Msg -> Model -> (Model, Effect Msg)
update msg model =
    case msg of
        ClickedSubmit ->
            if model.password == secret then
                ( model
                , Effect.fromShared (Shared.UpdateUser { password = model.password })
                )
            else
                ( { model | status = Failure "Invalid password" }, Effect.none)

        ChangedPassword password ->
            ( { model | password = password }, Effect.none )

-- View


view : Model -> View Msg
view model =
    { title = "Authenticate | Fodmap"
    , body = [ viewMain model ]
    }

viewMain: Model -> Html Msg
viewMain model =
    main_ [ ]
        [ div
            [ Attr.class "max-w-5xl mx-auto sm:px-6 lg:px-8"
            ]
            [ div
                [ Attr.class "px-4 py-8 sm:px-0"
                ]
                [ div
                    [ Attr.attribute "lass" "container pt-6"
                    ]
                    [ div
                        [ Attr.class "mt-6 pb-5 border-b border-gray-200 flex items-center justify-between"
                        ]
                        [ h2
                            [ Attr.class "text-2xl font-bold leading-7 text-gray-900 sm:text-3xl sm:leading-9 sm:truncate flex-shrink-0"
                            ]
                            [ text "Authenticate" ]
                        ]
                    , br [] []
                    , (case model.status of
                        Failure err -> viewAlertError err
                        _ -> div [] []
                    )
                    , div []
                        [ label
                            [ Attr.for "password"
                            , Attr.class "block text-sm font-medium leading-6 text-gray-900"
                            ]
                            [ text "Password" ]
                        , div
                            [ Attr.class "flex mt-2"
                            ]
                            [ input
                                [ Attr.type_ "password"
                                , Attr.name "password"
                                , Attr.id "password"
                                , Attr.class "pl-2 block w-full rounded-md border-0 py-1.5 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                                , Attr.placeholder "Password"
                                , onInput ChangedPassword
                                , onKeyCode 13 ClickedSubmit
                                ]
                                []
                            , button
                                [ Attr.type_ "button"
                                , Attr.class "ml-2 rounded bg-indigo-600 px-2 py-1 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600"
                                , onClick ClickedSubmit
                                ]
                                [ text "Login" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]