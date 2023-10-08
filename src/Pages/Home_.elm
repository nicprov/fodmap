module Pages.Home_ exposing (Model, Msg, page)

import Common.Footer exposing (viewFooter)
import Common.Header exposing (viewHeader)
import Common.Response exposing (Category, categoryDecoder)
import Gen.Route as Route
import Html exposing (Html, a, b, br, button, dd, div, dl, dt, h1, h2, h3, img, li, main_, p, span, text, ul)
import Html.Attributes as Attr exposing (class)
import Http
import Json.Decode as Decode exposing (Decoder, int, string)
import Page
import Shared
import Request exposing (Request)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import View exposing (View)
import Common.Base exposing (baseUrl)

page : Shared.Model -> Request -> Page.With Model Msg
page shared _ =
    Page.element
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
    , categories: List Category
    }

type Msg
    = GotCategories (Result Http.Error (List Category))

init: (Model, Cmd Msg)
init =
    let
        tmpModel = { status = Loading
                   , categories = []
                   }
    in
    ( tmpModel, getAllCategories )


-- Update

getAllCategories: Cmd Msg
getAllCategories =
    Http.get
        { url = baseUrl ++ "/en/ALL/categories-list.json"
        , expect = Http.expectJson GotCategories (Decode.list categoryDecoder)
        }

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotCategories result ->
            case result of
                Ok categories ->
                    ( { model | categories = categories, status = None }, Cmd.none)

                Err _ ->
                    ( { model | status = Failure "Unable to fetch categories" }, Cmd.none )


-- View


view : Model -> View Msg
view model =
    { title = "Categories | Fodmap"
    , body = [ div
                [ class "bg-gray-50 h-screen"
                ]
                [ viewMain model
                ]
             ]
    }

viewMain: Model -> Html Msg
viewMain model =
    main_ [ ]
        [ div
            [ Attr.class "max-w-7xl mx-auto sm:px-6 lg:px-8"
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
                            [ text "Categories" ]
                        ]
                    , br [] []
                    , ul
                        [ Attr.class "my-6 grid grid-cols-1 gap-6 sm:grid-cols-2 lg:grid-cols-3"
                        ]
                        (List.map viewCategories model.categories)
                    ]
                ]
            ]
        ]


viewCategories: Category -> Html Msg
viewCategories category =
    div
        [ Attr.class "relative flex items-center space-x-3 rounded-lg border border-gray-300 bg-white px-6 py-5 shadow-sm focus-within:ring-2 focus-within:ring-indigo-500 focus-within:ring-offset-2 hover:border-gray-400"
        ]
        [ div
            [ Attr.class "flex-shrink-0"
            ]
            [ img
                [ Attr.class "h-10 w-10 flex-shrink-0 rounded-full bg-gray-300"
                , Attr.src (baseUrl ++ "/category/forType/1/CategoryId/" ++ category.id ++ ".json")
                , Attr.alt (category.name ++ " image")
                ]
                []
            ]
        , div
            [ Attr.class "min-w-0 flex-1"
            ]
            [ a
                [ Attr.href (Route.toHref (Route.Category__Id_ { id = category.id }))
                , Attr.class "focus:outline-none"
                ]
                [ span
                    [ Attr.class "absolute inset-0"
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    []
                , h3
                    [ Attr.class "text-gray-900 font-medium text-lg truncate"
                    , Attr.style "width" "calc(100% - 4rem)"
                    ]
                    [ text category.name ]
                , p
                    [ Attr.class "truncate text-sm text-gray-500"
                    ]
                    [ text (String.replace "&amp;" "&" category.description) ]
                ]
            ]
        ]