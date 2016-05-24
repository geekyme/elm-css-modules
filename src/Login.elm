port module Login exposing
  ( Model
  , init
  , update
  , view
  , Msg(..)
  , subscriptions
  ) -- TODO: remove 'port' since its only there to satisfy linter

import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (type', value, class)
import Class

type alias Model =
  { email : String
  , password : String
  , isAuthenticated : Bool
  , classes : Class.Model
  }

type Msg
  = InputEmail String
  | InputPassword String
  | Logout
  | Login
  | Authenticated Bool
  | LoginClasses Class.Msg

port login : (String, String) -> Cmd msg

port logout : String -> Cmd msg

port authenticated : (Bool -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ authenticated Authenticated
    , Sub.map LoginClasses Class.subscriptions
    ]

init : (Model, Cmd Msg)
init =
  ( Model "" "" False Class.init
  , Cmd.batch
      [ Class.fetchClasses "./Login.css"
      , Class.fetchClasses "./Ui.css"
      ]
  )

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    InputEmail email ->
      ({ model | email = email }, Cmd.none)
    InputPassword password ->
      ({ model | password = password }, Cmd.none)
    Login ->
      ({ model | password = "", email = "" }, login (model.email, model.password))
    Logout ->
      (model, logout model.email)
    Authenticated state ->
      ({ model | isAuthenticated = state }, Cmd.none)
    LoginClasses submsg ->
      let
        (classes, _) =
          Class.update submsg model.classes
      in
        ({ model | classes = classes }, Cmd.none)


view : Model -> Html Msg
view model =
  form [ onSubmit Login, class (Class.getClass "login" model.classes) ]
    [ viewAuthenticated model
    , input [ onInput InputEmail, type' "text", value model.email ] []
    , input [ onInput InputPassword, type' "password", value model.password ] []
    , button [ type' "submit", class (Class.getClass "button" model.classes) ] [ text "submit" ]
    ]

viewAuthenticated : Model -> Html Msg
viewAuthenticated model =
  case model.isAuthenticated of
    True ->
      div []
        [ text "Logged In"
        , button [ onClick Logout ] [ text "Sign out"]
        ]
    False ->
      text "Not logged in"
