module Common.Header exposing (viewHeader)

import Html exposing (Html, a, div, header, img, span, text)
import Html.Attributes as Attr

viewHeader: Html msg
viewHeader =
    header []
        [ div
            [ Attr.class "bg-gray-50"
            ]
            [ div
                [ Attr.class "flex justify-between items-center max-w-7xl mx-auto px-4 py-6 sm:px-6 md:justify-start md:space-x-10 lg:px-8"
                ]
                [ div
                    [ Attr.class "flex justify-start lg:w-0 lg:flex-1"
                    ]
                    [ a
                        [
                        ]
                        [ span
                            [ Attr.class "sr-only"
                            ]
                            [ text "Workflow" ]
                        , img
                            [ Attr.class "h-8 w-auto sm:h-10"
                            , Attr.src "/img/logo.png"
                            , Attr.alt ""
                            ]
                            []
                        ]
                    ]
                ]
            ]
        ]