port module Main exposing (Flags, Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Html as H exposing (Html)
import Html.Attributes as HA
import Html.Events as HE
import Json.Encode as Encode
import Maybe

port getPhoto : () -> Cmd msg
port gotPhoto : (String -> msg) -> Sub msg

-- MODEL


type alias Model =
  { imgPath: Maybe String }


type alias Flags =
  {}


init : Flags -> ( Model, Cmd Msg )
init flags =
  ( { imgPath = Nothing }
  , Cmd.none
  )



-- UPDATE


type Msg
  = NoOp
  | GetPhoto
  | GotPhoto String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    GetPhoto ->
      ( model, getPhoto () )
    GotPhoto imgPath ->
      ( { model | imgPath = Just imgPath }, Cmd.none )
    NoOp ->
      ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
  let
    photoElem =
      case model.imgPath of
        Just path ->
          H.node "ion-col"
            [ HA.attribute "size" "6" ]
            [ H.node "ion-img"
              [ HA.src path ]
              []
            ]
        Nothing ->
          H.span [] []
  in
    H.node "ion-app"
      []
      [ H.node "ion-header" []
        [ H.node "ion-toolbar"
          [ HA.attribute "color" "primary" ]
          [ H.node "ion-title"
            [ HA.attribute "color" "light" ]
            [ H.text "Photo Example" ]
          ]
        ]

      , H.node "ion-content" []
          [ H.node "ion-grid"
            []
            [ H.node "ion-row"
              []
              [ photoElem ]
            ]
          , H.node "ion-fab"
              [ HA.attribute "vertical" "bottom"
              , HA.attribute "horizontal" "center"
              , HA.attribute "slot" "fixed"
              ]
              [
                H.node "ion-fab-button"
                  [ HE.onClick GetPhoto ]
                  [ H.node "ion-icon"
                    [ HA.attribute "name" "camera"
                    , HA.src "https://ionicons.com/ionicons/svg/ios-camera.svg"
                    ]
                    []
                  ]
              ]
          ]
      ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  gotPhoto GotPhoto


main : Program Flags Model Msg
main =
  Browser.element
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
