port module Shared exposing
    ( Flags
    , Model
    , Msg(..)
    , init
    , subscriptions
    , update
    )

import Common.Response exposing (FoodItem)
import Gen.Route
import Json.Decode as Json
import Request exposing (Request)


port setBodyClass : String -> Cmd msg

type alias Flags =
    Json.Value


type alias Model =
    { selectedItem: Maybe FoodItem
    , selectedCategory: String
    }


type Msg
    = UpdateSelectedItem FoodItem
    | UpdateSelectedCategory String


init : Request -> Flags -> ( Model, Cmd Msg )
init _ _ =
    ( { selectedItem = Nothing
      , selectedCategory = ""
      }
    , setBodyClass "bg-gray-50"
    )


update : Request -> Msg -> Model -> ( Model, Cmd Msg )
update req msg model =
    case msg of
        UpdateSelectedItem item ->
            ( { model | selectedItem = Just item }
            , Request.pushRoute (Gen.Route.Food__Id_ { id = item.id }) req
            )

        UpdateSelectedCategory category ->
            ( { model | selectedCategory = category }, Cmd.none )


subscriptions : Request -> Model -> Sub Msg
subscriptions _ _ =
    Sub.none
