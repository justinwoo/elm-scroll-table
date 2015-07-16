module ScrollTable where

import Html exposing (..)
import Html.Attributes exposing (id, class, style)
import Html.Events exposing (on)
import Json.Decode as Json
import Debug exposing (log)
import List exposing (indexedMap, length)
import StartApp

-- DOM helper
scrollTop : Json.Decoder Int
scrollTop =
  Json.at ["target", "scrollTop"] Json.int

-- Convenience type
type alias VisibleIndices = List Int

-- Model Calculations Util
calculateVisibleIndices : Model -> Int -> Model
calculateVisibleIndices model scrollTop =
  let
    {
      rowHeight,
      rowCount,
      height
    } = model
    firstRow = scrollTop // rowHeight
    visibleRows = (height + 1) // rowHeight
    lastRow = firstRow + visibleRows
  in
    {model | visibleIndices <- [firstRow..lastRow]}

-- MODEL

type alias Model =
  {
    height: Int,
    width: Int,
    rowCount: Int,
    rowHeight: Int,
    visibleIndices: VisibleIndices
  }


-- UPDATE

type Action
  = NoOp |
    UserScroll Int

update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model
    UserScroll scrollTop -> calculateVisibleIndices model scrollTop
    _ -> model


-- VIEW
type alias RowViewProps =
  {
    key: String,
    index: Int,
    rowHeight: Int,
    columnWidths: List Int
  }
rowView : RowViewProps -> Html
rowView props =
  let
    {
      key,
      index,
      rowHeight,
      columnWidths
    } = props
    trStyle = style [
        ("position", "absolute"),
        ("top", toString (index * rowHeight) ++ "px"),
        ("width", "100%"),
        ("borderBottom", "1px solid black")
      ]
    [firstCol, secondCol, thirdCol] = columnWidths
  in
    tr [trStyle, Html.Attributes.key key] [
      td [style [("width", (toString firstCol) ++ "px")]] [
        text (toString (index))],
      td [style [("width", (toString secondCol) ++ "px")]] [
        text (toString (index * 10))],
      td [style [("width", (toString thirdCol) ++ "px")]] [
        text (toString (index * 100))]]

type alias TableViewProps =
  {
    rowCount: Int,
    rowHeight: Int,
    visibleIndices: VisibleIndices,
    columnWidths: List Int
  }
tableView : TableViewProps -> Html
tableView props =
  let
    {
      rowCount,
      rowHeight,
      columnWidths,
      visibleIndices
    } = props
    rows = indexedMap (\i index ->
                 rowView
                   {
                     key = toString (i % (length visibleIndices)),
                     index = index,
                     rowHeight = rowHeight,
                     columnWidths = columnWidths
                   })
                 visibleIndices
  in
    table [style [("height", toString (rowCount * rowHeight) ++ "px")]] [
      tbody [] rows]

view : Signal.Address Action -> Model -> Html
view address model =
  let
      {
        height,
        width,
        rowCount,
        rowHeight,
        visibleIndices
      } = model
  in
    div [] [
      div [id "app-container"] [
        div
          [
            class "scroll-table-container",
            style
              [
                ("margin", "auto"),
                ("position", "relative"),
                ("overflowX", "hidden"),
                ("border", "1px solid black"),
                ("height", (toString height) ++ "px"),
                ("width", (toString width) ++ "px")
              ],
            on "scroll" scrollTop (Signal.message address << UserScroll)
          ]
          [
            tableView
              {
                rowCount = rowCount,
                rowHeight = rowHeight,
                visibleIndices = visibleIndices,
                columnWidths =
                  [
                    300,
                    300,
                    300
                  ]
              }]]]

-- Bootstrap
initialModel: Model
initialModel =
  {
    height = 500,
    width = 800,
    rowCount = 10000,
    rowHeight = 30,
    visibleIndices = []
  }

initializedModel = calculateVisibleIndices initialModel 0

main =
  StartApp.start
  {
    model = initializedModel,
    update = update,
    view = view
  }
