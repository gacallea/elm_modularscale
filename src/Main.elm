module Main exposing (main)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Events exposing (onClick)
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)



-- CONSTANTS


color =
    { darkBlue = rgb255 96 120 143
    , darkGreen = rgb255 87 129 130
    , amaranto = rgb255 130 88 87
    , darkCharcoal = rgb255 0x2E 0x34 0x36
    , beige = rgb255 235 230 224
    , lightBeige = rgb255 248 246 244
    , white = rgb255 0xFF 0xFF 0xFF
    }



-- MESSAGES


type Msg
    = UserTypedBaseFont String
    | UserTypedRatio String
    | UserChoseAlgorithm ModularFunAlgo
    | UserChoseCssUnit CssUnits
    | UserSelectedTab Tab
    | Increment
    | Decrement



-- TYPES


type ModularFunAlgo
    = Original
    | Fixed


type CssUnits
    = Em
    | Rem
    | Px


type Tab
    = TextView
    | TableView
    | Comparison



-- MODEL


type alias Model =
    { basefont : Float
    , ratio : Float
    , multiplier : Int
    , cssUnit : CssUnits
    , algo : ModularFunAlgo
    , rangeStart : Int
    , rangeEnd : Int
    , fontView : Tab
    }



-- INIT


initialModel : Model
initialModel =
    { basefont = 16
    , ratio = 1.25
    , multiplier = 0
    , cssUnit = Px
    , algo = Fixed
    , rangeStart = -6
    , rangeEnd = 16
    , fontView = Comparison
    }



-- VIEW


view : Model -> Html Msg
view model =
    Element.layout [ width fill, height fill ] <|
        row
            [ width fill
            , height fill
            , Border.color color.darkGreen
            , Border.solid
            , Border.widthEach
                { bottom = 0
                , left = 0
                , right = 0
                , top = 4
                }
            , Font.family
                [ Font.typeface "LiberationSansRegular"
                , Font.sansSerif
                ]
            , Font.size 16
            ]
            [ column
                [ height fill
                , Background.color color.beige
                , Border.color color.darkBlue
                , Border.solid
                , Border.widthEach
                    { bottom = 0
                    , left = 0
                    , right = 1
                    , top = 0
                    }
                , paddingEach
                    { bottom = 0
                    , left = 20
                    , right = 16
                    , top = 30
                    }
                , spacing 30
                ]
                [ el [ Font.size 32 ] (text "Modular Scale")
                , column
                    [ Border.color color.darkBlue
                    , Border.solid
                    , Border.widthEach
                        { bottom = 1
                        , left = 0
                        , right = 0
                        , top = 1
                        }
                    , width fill
                    , spacing 10
                    , paddingEach
                        { bottom = 20
                        , left = 0
                        , right = 0
                        , top = 20
                        }
                    ]
                    [ el [] (text rationale)
                    , newTabLink [ Font.color color.darkBlue ]
                        { label = Element.text "Click here for the real deal"
                        , url = "https://www.modularscale.com/"
                        }
                    , newTabLink [ Font.color color.darkBlue ]
                        { label = Element.text "elm-ui GitHub Issue 331"
                        , url = "https://github.com/mdgriffith/elm-ui/issues/331"
                        }
                    ]
                , Input.text
                    [ Border.color color.darkBlue
                    , Border.width 1
                    , Border.solid
                    , Border.rounded 1
                    , padding 4
                    ]
                    { onChange = UserTypedBaseFont
                    , text = String.fromFloat model.basefont
                    , placeholder = Just <| Input.placeholder [] <| text "Bases"
                    , label = Input.labelAbove [] <| text "Bases"
                    }
                , Input.text
                    [ Border.color color.darkBlue
                    , Border.width 1
                    , Border.solid
                    , Border.rounded 1
                    , padding 4
                    ]
                    { onChange = UserTypedRatio
                    , text = String.fromFloat model.ratio
                    , placeholder = Just <| Input.placeholder [] <| text "Ratio"
                    , label = Input.labelAbove [] <| text "Ratio"
                    }
                , Input.radioRow
                    [ width fill
                    , spacing 16
                    , Background.color color.white
                    , Border.color color.darkBlue
                    , Border.width 1
                    , Border.solid
                    , Border.rounded 1
                    , padding 4
                    ]
                    { onChange = UserChoseAlgorithm
                    , selected = Just model.algo
                    , label = Input.labelAbove [ paddingEach { bottom = 6, top = 0, left = 0, right = 0 } ] <| text "Algorithm"
                    , options =
                        [ Input.option Original <| text "Original"
                        , Input.option Fixed <| text "Fixed"
                        ]
                    }
                , Input.radioRow
                    [ width fill
                    , spacing 16
                    , Background.color color.white
                    , Border.color color.darkBlue
                    , Border.width 1
                    , Border.solid
                    , Border.rounded 1
                    , padding 4
                    ]
                    { onChange = UserChoseCssUnit
                    , selected = Just model.cssUnit
                    , label = Input.labelAbove [ paddingEach { bottom = 6, top = 0, left = 0, right = 0 } ] <| text "CSS Unit"
                    , options =
                        [ Input.option Em <| text "em"
                        , Input.option Rem <| text "rem"
                        , Input.option Px <| text "px"
                        ]
                    }
                ]
            , column
                [ width fill, height fill ]
                [ row
                    [ width fill
                    , paddingEach
                        { bottom = 12
                        , left = 8
                        , right = 0
                        , top = 0
                        }
                    ]
                    [ tabEl Comparison model.fontView
                    , tabEl TableView model.fontView
                    , tabEl TextView model.fontView
                    ]
                , row
                    [ width fill
                    , paddingEach
                        { bottom = 0
                        , left = 16
                        , right = 0
                        , top = 12
                        }
                    , spacing 30
                    ]
                    [ case model.fontView of
                        TableView ->
                            fontsTableView model

                        TextView ->
                            fontsTextView model

                        Comparison ->
                            comparisonView model
                    ]
                ]
            ]



-- VIEW HELPERS


rationale : String
rationale =
    "A simple demo of an Elm UI bug"


comparisonView : Model -> Element Msg
comparisonView model =
    column
        [ width fill
        , paddingEach
            { top = 16
            , left = 0
            , right = 0
            , bottom = 0
            }
        , spacing 16
        ]
        [ el
            [ width fill
            , Border.color color.beige
            , Border.solid
            , Border.widthEach
                { bottom = 1
                , left = 0
                , right = 0
                , top = 0
                }
            ]
            (Element.text
                ("Bases: " ++ String.fromFloat model.basefont)
            )
        , el
            [ width fill
            , Border.color color.beige
            , Border.solid
            , Border.widthEach
                { bottom = 1
                , left = 0
                , right = 0
                , top = 0
                }
            ]
            (Element.text
                ("Ratio: " ++ String.fromFloat model.ratio)
            )
        , row
            [ spacing 12
            , width fill
            , Border.color color.beige
            , Border.solid
            , Border.widthEach
                { bottom = 1
                , left = 0
                , right = 0
                , top = 0
                }
            ]
            [ el []
                (Element.text
                    ("Multiplier: " ++ String.fromInt model.multiplier)
                )
            , Input.button
                [ Border.color color.darkBlue
                , Border.width 1
                , Border.solid
                , Border.rounded 1
                , padding 4
                ]
                { onPress = Just Decrement, label = Element.text "-1" }
            , Input.button
                [ Border.color color.darkBlue
                , Border.width 1
                , Border.solid
                , Border.rounded 1
                , padding 4
                ]
                { onPress = Just Increment, label = Element.text "+1" }
            ]
        , el
            [ width fill
            , Border.color color.beige
            , Border.solid
            , Border.widthEach
                { bottom = 1
                , left = 0
                , right = 0
                , top = 0
                }
            ]
            (Element.text
                ("Original: " ++ (String.fromFloat <| scaledOriginal model))
            )
        , el
            [ width fill
            , Border.color color.beige
            , Border.solid
            , Border.widthEach
                { bottom = 1
                , left = 0
                , right = 0
                , top = 0
                }
            ]
            (Element.text
                ("Fixed: " ++ (String.fromFloat <| scaledFixed model))
            )
        ]


fontsTextView : Model -> Element Msg
fontsTextView model =
    List.range model.rangeStart model.rangeEnd
        |> List.reverse
        |> List.map (\multiplier -> scaled model multiplier)
        |> List.map
            (\fontSize ->
                el [ Font.size fontSize ] <| text "hello"
            )
        |> column
            [ paddingEach
                { top = 16
                , left = 0
                , right = 0
                , bottom = 0
                }
            , spacing 10
            ]


fontsTableView : Model -> Element Msg
fontsTableView model =
    List.range model.rangeStart model.rangeEnd
        |> List.reverse
        |> List.map (\multiplier -> scaled model multiplier)
        |> List.map
            (\fontSize ->
                paragraph
                    [ width fill
                    , Border.color color.beige
                    , Border.solid
                    , Border.widthEach
                        { bottom = 1
                        , left = 0
                        , right = 0
                        , top = 0
                        }
                    ]
                    [ el []
                        --     (text (String.fromInt multiplier ++ unitToShow multiplier))
                        -- , el []
                        (text (String.fromInt fontSize ++ unitToShow model.cssUnit))
                    ]
            )
        |> column
            [ paddingEach
                { top = 16
                , left = 0
                , right = 0
                , bottom = 0
                }
            , spacing 16
            , width fill
            ]


tabEl : Tab -> Tab -> Element Msg
tabEl tab selectedTab =
    let
        isSelected =
            tab == selectedTab

        bcolor =
            if isSelected then
                color.darkCharcoal

            else
                color.darkCharcoal

        colors =
            if isSelected then
                color.amaranto

            else
                color.darkGreen
    in
    el
        [ Border.widthEach { left = 1, top = 0, right = 1, bottom = 1 }
        , Border.roundEach { topLeft = 0, topRight = 0, bottomLeft = 8, bottomRight = 8 }
        , Border.color bcolor
        , Border.solid
        , Background.color colors
        , Font.color color.white
        , onClick <| UserSelectedTab tab
        ]
    <|
        el
            [ centerX
            , centerY
            , paddingEach { left = 30, right = 30, top = 10, bottom = 10 }
            ]
        <|
            text <|
                case tab of
                    TableView ->
                        "Table"

                    TextView ->
                        "Text"

                    Comparison ->
                        "Comparison"



-- HELPERS


fixedModular : Float -> Float -> Int -> Float
fixedModular normal ratio rescale =
    if rescale == 0 then
        normal

    else
        normal * ratio ^ toFloat rescale


scaled : Model -> Int -> Int
scaled model multiplier =
    case model.algo of
        Original ->
            Basics.round (Element.modular model.basefont model.ratio multiplier)

        Fixed ->
            Basics.round (fixedModular model.basefont model.ratio multiplier)


scaledOriginal : Model -> Float
scaledOriginal model =
    Element.modular model.basefont model.ratio model.multiplier


scaledFixed : Model -> Float
scaledFixed model =
    fixedModular model.basefont model.ratio model.multiplier



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UserTypedBaseFont s ->
            ( { model | basefont = Maybe.withDefault 16 (String.toFloat s) }
            , Cmd.none
            )

        UserTypedRatio s ->
            ( { model | ratio = Maybe.withDefault 1.25 (String.toFloat s) }
            , Cmd.none
            )

        UserChoseAlgorithm algo ->
            ( { model | algo = whichAlgo algo }
            , Cmd.none
            )

        UserChoseCssUnit unit ->
            ( { model | cssUnit = unit }
            , Cmd.none
            )

        UserSelectedTab tabToShow ->
            ( { model | fontView = tabToShow }, Cmd.none )

        Increment ->
            ( { model | multiplier = model.multiplier + 1 }, Cmd.none )

        Decrement ->
            ( { model | multiplier = model.multiplier - 1 }, Cmd.none )



-- UPDATE HELPERS


unitToShow : CssUnits -> String
unitToShow unit =
    case unit of
        Em ->
            "em"

        Rem ->
            "rem"

        Px ->
            "px"


whichAlgo : ModularFunAlgo -> ModularFunAlgo
whichAlgo model =
    case model of
        Original ->
            model

        Fixed ->
            model



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> ( initialModel, Cmd.none )
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
