module Pages.Category.Id_ exposing (Model, Msg, page)

import Common.Response exposing (Category, FoodItem, Product, productDecoder)
import Gen.Params.Category.Id_ exposing (Params)
import Html exposing (Html, a, b, br, button, dd, div, dl, dt, h1, h2, h3, img, li, main_, p, span, text, time, ul)
import Html.Attributes as Attr exposing (class)
import Http
import Page
import Shared
import Request exposing (Request)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import View exposing (View)
import Common.Base exposing (baseUrl)

page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init req.params.id
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
    , product: Maybe Product
    , categoryId: String
    , page: Int
    }

type Msg
    = GotProducts (Result Http.Error Product)

init: String -> (Model, Cmd Msg)
init categoryId =
    let
        tmpModel = { status = Loading
                   , product = Nothing
                   , categoryId = categoryId
                   , page = 0
                   }
    in
    ( tmpModel, getAllProductsByCategory tmpModel )


-- Update

getAllProductsByCategory: Model -> Cmd Msg
getAllProductsByCategory model =
    Http.get
        { url = baseUrl ++ "/en/ALL/food-list/" ++ model.categoryId ++ "/pageno/" ++ (String.fromInt model.page) ++ "/itemsperpage/60"
        , expect = Http.expectJson GotProducts productDecoder
        }

update: Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotProducts result ->
            case result of
                Ok product ->
                    ( { model | product = Just product, status = None }, Cmd.none)

                Err err ->
                    ( { model | status = Failure (Debug.toString err) }, Cmd.none )


-- View


view : Model -> View Msg
view model =
    { title = "Category Items | Fodmap"
    , body = [ div
                [ class "bg-gray-50"
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
                            [ text "Products" ]
                        ]
                    , ul
                        [ Attr.attribute "role" "list"
                        , Attr.class "divide-y divide-gray-100 overflow-hidden bg-white shadow-sm ring-1 ring-gray-900/5 sm:rounded-xl mt-6"
                        ]
                        (case model.product of
                            Just p ->
                                List.map viewFoodItem p.food

                            Nothing ->
                                [ div [] [] ]
                        )
                    ]
                ]
            ]
        ]

viewFoodItem: FoodItem -> Html Msg
viewFoodItem foodItem =
    li
        [ Attr.class "relative flex justify-between gap-x-6 px-4 py-5 hover:bg-gray-50 sm:px-6"
        ]
        [ div
            [ Attr.class "flex min-w-0 gap-x-4"
            ]
            [ (case List.head foodItem.images of
                Just i ->
                    img
                        [ Attr.class "h-12 w-12 flex-none rounded-full bg-gray-50"
                        , Attr.src (baseUrl ++ "/food/forType/1/imageid/" ++ i)
                        , Attr.alt (foodItem.name ++ " image")
                        ]
                        []

                Nothing ->
                    img [] []
              )
            , div
                [ Attr.class "min-w-0 flex-auto"
                ]
                [ p
                    [ Attr.class "text-sm font-semibold leading-6 text-gray-900"
                    ]
                    [ a
                        [ Attr.href "#"
                        ]
                        [ span
                            [ Attr.class "absolute inset-x-0 -top-px bottom-0"
                            ]
                            []
                        , text foodItem.name ]
                    ]
                , p
                    [ Attr.class "mt-1 flex text-xs leading-5 text-gray-500"
                    ]
                    [ a
                        [ Attr.href "mailto:leslie.alexander@example.com"
                        , Attr.class "relative truncate hover:underline"
                        ]
                        [ text foodItem.code ]
                    ]
                ]
            ]
        , div
            [ Attr.class "flex shrink-0 items-center gap-x-4"
            ]
            [ div
                [ case foodItem.overall of
                    1 -> Attr.class "w-10 h-10 bg-green-500 rounded-full"
                    2 -> Attr.class "w-10 h-10 bg-yellow-500 rounded-full"
                    _ -> Attr.class "w-10 h-10 bg-red-500 rounded-full"
                ]
                []
            ]
        ]