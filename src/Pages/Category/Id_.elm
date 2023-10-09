module Pages.Category.Id_ exposing (Model, Msg, page)

import Common.Alerts exposing (viewAlertError, viewAlertInfo)
import Common.Response exposing (Category, FoodItem, Product, productDecoder)
import Effect exposing (Effect)
import Gen.Params.Category.Id_ exposing (Params)
import Gen.Route
import Html exposing (Html, a, button, div, h2, img, input, li, main_, p, span, text, ul)
import Html.Attributes as Attr
import Html.Events exposing (onClick, onInput)
import Http
import Page
import Shared exposing (Msg(..))
import Request exposing (Request)
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr
import View exposing (View)
import Common.Base exposing (baseUrl, cdnUrl)

page : Shared.Model -> Request.With Params -> Page.With Model Msg
page shared req =
    Page.advanced
        { init = init req
        , update = update req
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
    , search: String
    }

type Msg
    = GotProducts (Result Http.Error Product)
    | ChangedSearch String
    | ClickedBack
    | ClickedItem FoodItem

init: Request.With Params -> (Model, Effect Msg)
init req =
    let
        tmpModel = { status = Loading
                   , product = Nothing
                   , categoryId = req.params.id
                   , page = 0
                   , search = ""
                   }
    in
    ( tmpModel
    , Effect.batch [ getAllProductsByCategory tmpModel
                   , Effect.fromShared (UpdateSelectedCategory req.params.id)
                   ]
    )


-- Update

getAllProductsByCategory: Model -> Effect Msg
getAllProductsByCategory model =
    Effect.fromCmd
        ( Http.get
            { url = baseUrl ++ "/en/ALL/food-list/" ++ model.categoryId ++ "/pageno/" ++ (String.fromInt model.page) ++ "/itemsperpage/60"
            , expect = Http.expectJson GotProducts productDecoder
            }
        )

update: Request.With Params -> Msg -> Model -> (Model, Effect Msg)
update req msg model =
    case msg of
        GotProducts result ->
            case result of
                Ok newProduct ->
                    if not (List.isEmpty newProduct.food) then
                        case model.product of
                            Just oldProduct ->
                                let
                                    tmpFood = List.append oldProduct.food newProduct.food
                                    tmpProduct = { oldProduct | food = tmpFood }
                                    tmpModel = { model | product = Just tmpProduct, page = model.page + 1, status = None }
                                in
                                ( tmpModel, getAllProductsByCategory tmpModel )

                            Nothing ->
                                let
                                    tmpModel = { model | product = Just newProduct, page = model.page + 1, status = None }
                                in
                                ( tmpModel, getAllProductsByCategory tmpModel )

                    else
                        ( model, Effect.none )

                Err _ ->
                    ( { model | status = Failure "Unable to fetch food items" }, Effect.none )

        ChangedSearch search ->
            ( { model | search = search }, Effect.none )

        ClickedBack ->
            ( model
            , Effect.fromCmd (Request.pushRoute Gen.Route.Home_ req)
            )

        ClickedItem item ->
            ( model
            , Effect.fromShared (Shared.UpdateSelectedItem item)
            )

-- View


view : Model -> View Msg
view model =
    { title = "Category Items | Fodmap"
    , body = [ viewMain model ]
    }

filterFood: String -> FoodItem -> Bool
filterFood search item =
    String.contains (String.toLower search) (String.toLower item.name)

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
                            ( case model.product of
                                Just product ->
                                    [ text (String.replace "&amp;" "&" product.category.name)
                                    , p
                                        [ Attr.class "truncate text-sm text-gray-500"
                                        ]
                                        [ text (String.replace "&amp;" "&" product.category.description) ]
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
                        , div []
                            [ div
                                [ Attr.class "relative mt-2 flex items-center"
                                ]
                                [ input
                                    [ Attr.type_ "text"
                                    , Attr.name "search"
                                    , Attr.id "search"
                                    , Attr.class "block w-full rounded-md border-0 py-1.5 pl-1.5 pr-14 text-gray-900 shadow-sm ring-1 ring-inset ring-gray-300 placeholder:text-gray-400 focus:ring-2 focus:ring-inset focus:ring-indigo-600 sm:text-sm sm:leading-6"
                                    , Attr.placeholder "Quick search"
                                    , Attr.value model.search
                                    , onInput ChangedSearch
                                    ]
                                    []
                                ]
                            ]
                        ]
                    , ul
                        [ Attr.attribute "role" "list"
                        , Attr.class "divide-y divide-gray-100 overflow-hidden bg-white shadow-sm ring-1 ring-gray-900/5 sm:rounded-xl mt-6"
                        ]
                        (case model.product of
                            Just p ->
                                let
                                    filteredFood = List.filter (filterFood model.search) p.food
                                in
                                if List.isEmpty filteredFood then
                                    [ viewAlertInfo "No items meet that search criteria" ]
                                else
                                    List.map viewFoodItem filteredFood

                            Nothing ->
                                [ div [] [] ]
                        )
                    , case model.status of
                        Failure error -> viewAlertError error
                        Loading -> viewAlertInfo "Loading food items..."
                        None -> div [] []
                    ]
                ]
            ]
        ]

viewFoodItem: FoodItem -> Html Msg
viewFoodItem foodItem =
    li
        [ Attr.class "relative flex justify-between gap-x-6 px-4 py-5 hover:bg-gray-50 sm:px-6"
        , onClick (ClickedItem foodItem)
        ]
        [ div
            [ Attr.class "flex min-w-0 gap-x-4"
            ]
            [ (case List.head foodItem.images of
                Just i ->
                    img
                        [ Attr.class "h-12 w-12 flex-none rounded-full bg-gray-50"
                        , Attr.src (cdnUrl ++ "/food/forType/1/imageid/" ++ i)
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
                        , text foodItem.name
                        ]
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
