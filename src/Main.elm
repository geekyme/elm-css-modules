module Main exposing (..)

import Html exposing (..)
import Html.App as App
import Class
import Users
import Login
import Articles

main : Program Never
main =
  App.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }

type alias Model =
  { login: Login.Model
  , users: Users.Model
  , articles: Articles.Model
  }

init : (Model, Cmd Msg)
init =
  let
    (loginModel, loginCmd) = Login.init
    (usersModel, usersCmd) = Users.init
    (articlesModel, articlesCmd) = Articles.init
    model = Model loginModel usersModel articlesModel
  in
    ( model
    , Cmd.batch
        [ Cmd.map Login loginCmd
        , Cmd.map Articles articlesCmd
        , Cmd.map Users usersCmd
        , Class.fetchClasses "./Main.css"
        ]
    )

type Msg
  = Login Login.Msg
  | Users Users.Msg
  | Articles Articles.Msg

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    Login msg ->
      let
        (login, cmd) = Login.update msg model.login
      in
        ({ model | login = login }, Cmd.map Login cmd)
    Users msg ->
      let
        (users, cmd) =
          (Users.update msg model.users)
      in
        ({ model | users = users }, Cmd.map Users cmd)
    Articles msg ->
      let
        (articles, cmd) =
          (Articles.update msg model.articles)
      in
        ({ model | articles = articles }, Cmd.map Articles cmd)


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Sub.map Login (Login.subscriptions model.login)
    , Sub.map Users (Users.subscriptions model.users)
    , Sub.map Articles (Articles.subscriptions model.articles)
    ]

view : Model -> Html Msg
view model =
  div []
    [ App.map Login (Login.view model.login)
    , App.map Users (Users.view model.users)
    , App.map Articles (Articles.view model.articles)
    ]
