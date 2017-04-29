module Cliente exposing (..)

import Html            exposing (text, input, label, fieldset, div, form, button, Html, program, tbody, thead, tr, table, td, th)
import Html.Events     exposing (onSubmit, onInput, onClick)
import Html.Attributes exposing (name, type_, placeholder, value, checked, disabled)
import Http            exposing (Error, send, post, jsonBody, get)
import Json.Decode as DE     exposing (field, int)
import Json.Encode     exposing (..)

type alias Cliente = {
    clienteId : Int,
    nome : String
}

type alias Model = {cliente : Cliente, allCli : List Cliente, nome : String}

encodeCliente : Cliente -> Value
encodeCliente c =
    Json.Encode.object
        [ ("nome", Json.Encode.string c.nome)
        ]

decodeClientes : DE.Decoder (List Cliente)
decodeClientes = field "resp" <| DE.list <| DE.map2 Cliente
    (field "id" DE.int)
    (field "nome" DE.string)

type Msg
    = ClienteNome String
    | Submit
    | Listagem
    | Sucesso (Result Error Int)
    | GetClientes (Result Error (List Cliente))

update : Msg -> Model -> (Model, Cmd Msg)
update msg m =
    case msg of
        Submit          -> (m,
            send Sucesso <| post "@{ClienteR}"
                (jsonBody <| encodeCliente (Cliente 0 m.nome)) (field "resp" <| DE.int))
        GetClientes (Ok x)    -> ({m | allCli = x}, Cmd.none)
        GetClientes (Err err) -> (m, Cmd.none)
        
        ClienteNome x -> ({m | nome = x}, Cmd.none)
        
        Sucesso _-> (m, Cmd.none)
        
        Listagem -> (m, send GetClientes <| get ("@{ListClienteR}") decodeClientes)
        

view : Model -> Html Msg
view model =
    let thh campo = th [] [text campo]
        trr cli     = tr [] 
            [ td [] [text <| toString cli.clienteId]
            , td [] [text <| cli.nome]
            ]
    in
        div [] [
          input [onInput ClienteNome] []
        , button [onClick Submit] [text "Inserir"]
        , table []
                            [ thead [] [tr [] (List.map thh ["ID", "nome"])]
                            , tbody [] (List.map trr model.allCli)
                            ]
        ]

main = program
    { init = (Model (Cliente 0 "") [] "", send GetClientes <| get ("@{ListClienteR}") decodeClientes)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }
