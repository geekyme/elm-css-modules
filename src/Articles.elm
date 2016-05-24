port module Articles exposing
  ( Model
  , Msg
  , subscriptions
  , update
  , init
  , view
  )

import Class
import Html exposing (..)
import Html.Attributes exposing (class)

type alias Article = {
  id: String,
  title: String
}

type alias Articles = List Article

type alias Model = {
  articles: Articles,
  classes: Class.Model
}

type Msg
  = LoadArticles Articles
  | ArticlesClasses Class.Msg

port articles : (Articles -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ articles LoadArticles
    , Sub.map ArticlesClasses Class.subscriptions
    ]

init : (Model, Cmd Msg)
init =
  ( Model [] Class.init
  , Class.fetchClasses "./Articles.css"
  )

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    LoadArticles articles ->
      ({ model | articles = articles }, Cmd.none)
    ArticlesClasses submsg ->
      let
        (classes, _) =
          Class.update submsg model.classes
      in
        ({ model | classes = classes }, Cmd.none)

view : Model -> Html Msg
view model =
  div [ class (Class.getClass "articles" model.classes) ]
    (List.map viewArticle model.articles)

viewArticle : Article -> Html Msg
viewArticle article =
  div []
    [ text article.title
    ]

