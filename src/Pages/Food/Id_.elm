module Pages.Food.Id_ exposing (Model, Msg, page)

import Array
import Common.Response exposing (Category, FoodItem, Product, ServingItem)
import Gen.Params.Category.Id_ exposing (Params)
import Gen.Route
import Html exposing (Html, a, button, div, h2, h3, li, main_, p, text, ul)
import Html.Attributes as Attr
import Html.Events exposing (onClick)
import Page
import Shared
import Request exposing (Request)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import View exposing (View)

page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.element
        { init = init shared req
        , update = update shared req
        , view = view shared
        , subscriptions = \_ -> Sub.none
        }

-- Init

type Status
    = Failure String
    | None

type alias Model =
    {}

type Msg
    = ClickedBack

init: Shared.Model -> Request.With Params -> (Model, Cmd Msg)
init shared req =
    case shared.selectedItem of
        Just _ ->
            ( Model, Cmd.none )

        Nothing ->
            ( Model
            , Request.pushRoute Gen.Route.Home_ req
            )

-- Update

update: Shared.Model -> Request.With Params -> Msg -> Model -> (Model, Cmd Msg)
update shared req msg model =
    case msg of
        ClickedBack ->
            ( model
            , Request.pushRoute (Gen.Route.Category__Id_ { id = shared.selectedCategory }) req
            )


-- View


view : Shared.Model -> Model -> View Msg
view shared model =
    { title = "Category Items | Fodmap"
    , body = [ viewMain shared model ]
    }

viewMain: Shared.Model -> Model -> Html Msg
viewMain shared model =
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
                            ( case shared.selectedItem of
                                Just item ->
                                    [ text item.name
                                    , p
                                        [ Attr.class "truncate text-sm text-gray-500"
                                        ]
                                        [ text item.code ]
                                    , button
                                        [ Attr.type_ "button"
                                        , Attr.class "rounded-md bg-white mt-3 px-3 py-2 text-sm font-semibold text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 hover:bg-gray-50"
                                        , onClick ClickedBack
                                        ]
                                        [ div
                                            [ Attr.class "flex flex-row align-middle"
                                            ]
                                            [ svg
                                                [ SvgAttr.class "w-5 mr-2"
                                                , SvgAttr.fill "currentColor"
                                                , SvgAttr.viewBox "0 0 20 20"
                                                ]
                                                [ path
                                                    [ SvgAttr.fillRule "evenodd"
                                                    , SvgAttr.d "M7.707 14.707a1 1 0 01-1.414 0l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 1.414L5.414 9H17a1 1 0 110 2H5.414l2.293 2.293a1 1 0 010 1.414z"
                                                    , SvgAttr.clipRule "evenodd"
                                                    ]
                                                    []
                                                ]
                                            , text "Go Back"
                                            ]
                                        ]
                                    ]

                                Nothing ->
                                    [ text "" ]
                            )
                        ]
                    , ul
                        [ Attr.attribute "role" "list"
                        , Attr.class "divide-y divide-gray-100 overflow-hidden bg-white shadow-sm ring-1 ring-gray-900/5 sm:rounded-xl mt-6"
                        ]
                        (case shared.selectedItem of
                            Just item ->
                                List.map viewServing item.serves

                            Nothing ->
                                [ div [] [] ]
                        )
                    ]
                ]
            ]
        ]

viewServing: ServingItem -> Html Msg
viewServing servingItem =
    div []
        [ div
            [ Attr.class "border-gray-200 bg-white px-4 py-5 sm:px-6"
            ]
            [ div
                [ Attr.class "-ml-4 -mt-4 flex flex-wrap items-center justify-between sm:flex-nowrap"
                ]
                [ div
                    [ Attr.class "ml-4 mt-4"
                    ]
                    [ h3
                        [ Attr.class "text-base font-semibold leading-6 text-gray-900"
                        ]
                        [ text servingItem.title ]
                    , p
                        [ Attr.class "mt-1 text-sm text-gray-500"
                        ]
                        [ text (String.replace "&#39;" "'" servingItem.comment) ]
                    ]
                ]
            ]
        , viewFodmapInfo servingItem.fodmap
        ]

viewFodmapInfo: List Int -> Html Msg
viewFodmapInfo fodmap =
    ul
        [ Attr.attribute "role" "list"
        , Attr.class "grid grid-cols-2 md:grid-cols-3 gap-4"
        ]
        [ li []
            [ a
                [ Attr.href "#"
                , Attr.class "block"
                ]
                [ div
                    [ Attr.class "px-4 py-4 sm:px-6"
                    ]
                    [ div
                        [ Attr.class "flex items-center"
                        ]
                        [ viewFodmapIndicator fodmap 0
                        , div
                            [ Attr.class "truncate text-sm font-medium text-black-600 pl-3"
                            ]
                            [ text "Fructose" ]
                        ]
                    ]
                ]
            ]
        , li []
            [ a
                [ Attr.href "#"
                , Attr.class "block"
                ]
                [ div
                    [ Attr.class "px-4 py-4 sm:px-6"
                    ]
                    [ div
                        [ Attr.class "flex items-center"
                        ]
                        [ viewFodmapIndicator fodmap 1
                        , div
                            [ Attr.class "truncate text-sm font-medium text-black-600 pl-3"
                            ]
                            [ text "Lactose" ]
                        ]
                    ]
                ]
            ]
        , li []
            [ a
                [ Attr.href "#"
                , Attr.class "block"
                ]
                [ div
                    [ Attr.class "px-4 py-4 sm:px-6"
                    ]
                    [ div
                        [ Attr.class "flex items-center"
                        ]
                        [ viewFodmapIndicator fodmap 3
                        , div
                            [ Attr.class "truncate text-sm font-medium text-black-600 pl-3"
                            ]
                            [ text "Mannitol" ]
                        ]
                    ]
                ]
            ]
        , li []
            [ a
                [ Attr.href "#"
                , Attr.class "block"
                ]
                [ div
                    [ Attr.class "px-4 py-4 sm:px-6"
                    ]
                    [ div
                        [ Attr.class "flex items-center"
                        ]
                        [ viewFodmapIndicator fodmap 2
                        , div
                            [ Attr.class "truncate text-sm font-medium text-black-600 pl-3"
                            ]
                            [ text "Sorbitol" ]
                        ]
                    ]
                ]
            ]
        , li []
            [ a
                [ Attr.href "#"
                , Attr.class "block"
                ]
                [ div
                    [ Attr.class "px-4 py-4 sm:px-6"
                    ]
                    [ div
                        [ Attr.class "flex items-center"
                        ]
                        [ viewFodmapIndicator fodmap 5
                        , div
                            [ Attr.class "truncate text-sm font-medium text-black-600 pl-3"
                            ]
                            [ text "GOS" ]
                        ]
                    ]
                ]
            ]
        , li []
            [ a
                [ Attr.href "#"
                , Attr.class "block"
                ]
                [ div
                    [ Attr.class "px-4 py-4 sm:px-6"
                    ]
                    [ div
                        [ Attr.class "flex items-center"
                        ]
                        [ viewFodmapIndicator fodmap 4
                        , div
                            [ Attr.class "truncate text-sm font-medium text-black-600 pl-2"
                            ]
                            [ text "Fructan" ]
                        ]
                    ]
                ]
            ]
        ]

viewFodmapIndicator: List Int -> Int -> Html Msg
viewFodmapIndicator fodmap position =
    let
        fodmapArray = Array.fromList fodmap
        fodmapItem = Array.get position fodmapArray
    in
    case fodmapItem of
        Just level ->
            div
                [ Attr.class "flex shrink-0 items-center gap-x-4"
                ]
                [ div
                    [ case level of
                        1 -> Attr.class "w-10 h-10 bg-green-500 rounded-full"
                        2 -> Attr.class "w-10 h-10 bg-yellow-500 rounded-full"
                        _ -> Attr.class "w-10 h-10 bg-red-500 rounded-full"
                    ]
                    []
                ]

        Nothing ->
            div [] []