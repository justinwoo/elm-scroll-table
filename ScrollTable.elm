module ScrollTable exposing (..)

import Html exposing (..)
import Html.App exposing (beginnerProgram)
import Html.Attributes exposing (id, class, style)
import Html.Events exposing (on)
import Json.Decode as Json
import Array as Array
import Maybe exposing (withDefault)
import List exposing (map, length)


-- DOM helper


onScroll : (Int -> msg) -> Attribute msg
onScroll tagger =
    on "scroll" <| Json.map tagger scrollTop


scrollTop : Json.Decoder Int
scrollTop =
    Json.at [ "target", "scrollTop" ] Json.int



-- Convenience type


type alias VisibleIndices =
    List Int



-- Model Calculations Util


calculateVisibleIndices : Model -> Int -> Model
calculateVisibleIndices model scrollTop =
    let
        { rowHeight, rowCount, height } =
            model

        firstRow =
            scrollTop // rowHeight

        visibleRows =
            (height + 1) // rowHeight

        lastRow =
            min rowCount <| firstRow + visibleRows + 10
    in
        { model | visibleIndices = [firstRow..lastRow] }



-- MODEL


type alias Model =
    { height : Int
    , width : Int
    , rowCount : Int
    , rowHeight : Int
    , visibleIndices : VisibleIndices
    }



-- UPDATE


type Msg
    = NoOp
    | UserScroll Int


update : Msg -> Model -> Model
update action model =
    case action of
        NoOp ->
            model

        UserScroll scrollTop ->
            calculateVisibleIndices model scrollTop



-- VIEW


type alias RowViewProps =
    { index : Int
    , rowHeight : Int
    , columnWidths : Array.Array Int
    }


rowView : RowViewProps -> Html Msg
rowView props =
    let
        { index, rowHeight, columnWidths } =
            props

        trStyle =
            style
                [ ( "position", "absolute" )
                , ( "top", toString (index * rowHeight) ++ "px" )
                , ( "width", "100%" )
                , ( "borderBottom", "1px solid black" )
                ]

        firstCol =
            Array.get 0 columnWidths |> withDefault 300

        secondCol =
            Array.get 1 columnWidths |> withDefault 300

        thirdCol =
            Array.get 2 columnWidths |> withDefault 300
    in
        tr [ trStyle ]
            [ td [ style [ ( "width", (toString firstCol) ++ "px" ) ] ]
                [ text (toString (index))
                ]
            , td [ style [ ( "width", (toString secondCol) ++ "px" ) ] ]
                [ text (toString (index * 10))
                ]
            , td [ style [ ( "width", (toString thirdCol) ++ "px" ) ] ]
                [ text (toString (index * 100))
                ]
            ]


type alias TableViewProps =
    { rowCount : Int
    , rowHeight : Int
    , visibleIndices : VisibleIndices
    , columnWidths : Array.Array Int
    }


tableView : TableViewProps -> Html Msg
tableView props =
    let
        { rowCount, rowHeight, columnWidths, visibleIndices } =
            props

        rows =
            map
                (\index ->
                    rowView
                        { index = index
                        , rowHeight = rowHeight
                        , columnWidths = columnWidths
                        }
                )
                visibleIndices
    in
        table [ style [ ( "height", toString (rowCount * rowHeight) ++ "px" ) ] ]
            [ tbody [] rows
            ]


view : Model -> Html Msg
view model =
    let
        { height, width, rowCount, rowHeight, visibleIndices } =
            model
    in
        div []
            [ h1 [ style [ ( "text-align", "center" ) ] ] [ text "Scroll Table!!!!" ]
            , div [ id "app-container" ]
                [ div
                    [ class "scroll-table-container"
                    , style
                        [ ( "margin", "auto" )
                        , ( "position", "relative" )
                        , ( "overflowX", "hidden" )
                        , ( "border", "1px solid black" )
                        , ( "height", (toString height) ++ "px" )
                        , ( "width", (toString width) ++ "px" )
                        ]
                    , onScroll UserScroll
                    ]
                    [ tableView
                        { rowCount = rowCount
                        , rowHeight = rowHeight
                        , visibleIndices = visibleIndices
                        , columnWidths =
                            Array.fromList
                                [ 300
                                , 300
                                , 300
                                ]
                        }
                    ]
                ]
            ]



-- Bootstrap


initialModel : Model
initialModel =
    { height = 500
    , width = 800
    , rowCount = 1000
    , rowHeight = 30
    , visibleIndices = []
    }


initializedModel : Model
initializedModel =
    calculateVisibleIndices initialModel 0


main : Program Never
main =
    beginnerProgram
        { model = initializedModel
        , view = view
        , update = update
        }
