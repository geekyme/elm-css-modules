port module Class exposing (..)

import Dict exposing (Dict, union, empty, get)
import Json.Decode exposing (dict, string, Decoder, Value, decodeValue)

type Msg = ReceiveClass Model

type alias Model = Dict String String

port fetchClasses : String -> Cmd msg

port receiveClasses : (Value -> msg) -> Sub msg

subscriptions : Sub Msg
subscriptions = receiveClasses (\(v) -> ReceiveClass (getDecodedResult v))

decoder : Decoder Model
decoder = dict string

getDecodedResult : Value -> Model
getDecodedResult v =
  case decodeValue decoder v of
    Ok val -> val
    Err _ -> empty

update : Msg -> Model -> (Model, Cmd Msg)
update message model =
  case message of
    ReceiveClass d ->
      (union d model, Cmd.none)

getClass : String -> Model -> String
getClass key dict =
  case get key dict of
    Just class -> class
    Nothing -> ""

init : Model
init = empty
