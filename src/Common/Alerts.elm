module Common.Alerts exposing ( viewAlertInfo
                              , viewAlertError
                              )

import Html exposing (Html, a, div, h3, li, p, span, text, ul)
import Html.Attributes as Attr
import Svg exposing (path, svg)
import Svg.Attributes as SvgAttr

viewAlertInfo: String -> Html msg
viewAlertInfo message =
    div
        [ Attr.class "rounded-md bg-blue-50 p-4"
        ]
        [ div
            [ Attr.class "flex"
            ]
            [ div
                [ Attr.class "flex-shrink-0"
                ]
                [ svg
                    [ SvgAttr.class "h-5 w-5 text-blue-400"
                    , SvgAttr.viewBox "0 0 20 20"
                    , SvgAttr.fill "currentColor"
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ path
                        [ SvgAttr.fillRule "evenodd"
                        , SvgAttr.d "M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7-4a1 1 0 11-2 0 1 1 0 012 0zM9 9a.75.75 0 000 1.5h.253a.25.25 0 01.244.304l-.459 2.066A1.75 1.75 0 0010.747 15H11a.75.75 0 000-1.5h-.253a.25.25 0 01-.244-.304l.459-2.066A1.75 1.75 0 009.253 9H9z"
                        , SvgAttr.clipRule "evenodd"
                        ]
                        []
                    ]
                ]
            , div
                [ Attr.class "ml-3 flex-1 md:flex md:justify-between"
                ]
                [ p
                    [ Attr.class "text-sm text-blue-700"
                    ]
                    [ text message ]
                ]
            ]
        ]

viewAlertError: String -> Html msg
viewAlertError message =
    div
        [ Attr.class "rounded-md bg-red-50 p-4"
        ]
        [ div
            [ Attr.class "flex"
            ]
            [ div
                [ Attr.class "flex-shrink-0"
                ]
                [ svg
                    [ SvgAttr.class "h-5 w-5 text-red-400"
                    , SvgAttr.viewBox "0 0 20 20"
                    , SvgAttr.fill "currentColor"
                    , Attr.attribute "aria-hidden" "true"
                    ]
                    [ path
                        [ SvgAttr.fillRule "evenodd"
                        , SvgAttr.d "M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z"
                        , SvgAttr.clipRule "evenodd"
                        ]
                        []
                    ]
                ]
            , div
                [ Attr.class "ml-3"
                ]
                [ h3
                    [ Attr.class "text-sm font-medium text-red-800"
                    ]
                    [ text "Error" ]
                , div
                    [ Attr.class "ml-3 flex-1 md:flex md:justify-between"
                    ]
                    [ p
                        [ Attr.class "text-sm text-red-700"
                        ]
                        [ text message ]
                    ]
                ]
            ]
        ]
