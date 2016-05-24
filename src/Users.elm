port module Users exposing
  ( Model
  , init
  , update
  , view
  , Msg(..)
  , subscriptions
  ) -- TODO: remove 'port' since its only there to satisfy linter

import Html exposing (..)
import Html.Attributes exposing (class)
import Class

type alias User = {
  bio: String
}

type alias Users = List User

type alias Model = {
  users: Users,
  classes: Class.Model
}

type Msg
  = LoadUsers Users
  | UsersClasses Class.Msg

port users : (Users -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ users LoadUsers
    , Sub.map UsersClasses Class.subscriptions
    ]

init : (Model, Cmd Msg)
init =
  ( Model [] Class.init
  , Class.fetchClasses "./Users.css"
  )

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    LoadUsers users ->
      ({ model | users = users }, Cmd.none)
    UsersClasses submsg ->
      let
        (classes, _) =
          Class.update submsg model.classes
      in
        ({ model | classes = classes }, Cmd.none)

view : Model -> Html Msg
view model =
  div [ class (Class.getClass "users" model.classes) ]
    (List.map viewUser model.users)

viewUser : User -> Html Msg
viewUser { bio } =
  div []
    [ text bio
    ]
