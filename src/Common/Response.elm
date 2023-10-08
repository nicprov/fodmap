module Common.Response exposing ( Category
                                , Product
                                , FoodItem
                                , ServingItem
                                , categoryDecoder
                                , productDecoder
                                , foodItemDecoder
                                , servingItemDecoder
                                )

import Json.Decode as Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (optional, required)

type alias Category =
    { id: String
    , foodCategoryIid: Int
    , name: String
    , description: String
    }

type alias Product =
    { totalPages: Int
    , totalItems: Int
    , pageNumber: Int
    , category: Category
    , food: List FoodItem
    }

type alias FoodItem =
    { id: String
    , foodId: Int
    , name: String
    , code: String
    , overall: Int
    , serves: List ServingItem
    , images: List String
    }

type alias ServingItem =
    { id: String
    , comment: String
    , fodmap: List Int
    , title: String
    }


categoryDecoder: Decoder Category
categoryDecoder =
    Decode.succeed Category
        |> required "id" string
        |> required "food_category_id" int
        |> required "name" string
        |> required "description" string

productDecoder: Decoder Product
productDecoder =
    Decode.succeed Product
        |> required "totalPages" int
        |> required "totalItems" int
        |> required "pageNumber" int
        |> required "category" categoryDecoder
        |> required "food" (Decode.list foodItemDecoder)

foodItemDecoder: Decoder FoodItem
foodItemDecoder =
    Decode.succeed FoodItem
        |> required "id" string
        |> required "food_id" int
        |> required "name" string
        |> required "code" string
        |> required "overall" int
        |> required "serves" (Decode.list servingItemDecoder)
        |> required "images" (Decode.list string)

servingItemDecoder: Decoder ServingItem
servingItemDecoder =
    Decode.succeed ServingItem
        |> required "id" string
        |> required "comment" string
        |> required "fodmap" (Decode.list int)
        |> required "title" string