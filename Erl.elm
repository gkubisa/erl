module Erl where

import Dict
import String exposing (..)

type alias Url = {
  path: List String,
  hash: List String,
  query: Dict.Dict String String
}

-- HASH

hashPart: String -> String
hashPart str =
  let
    parts = split "#" str
    maybeFirst = List.head (List.drop 1 parts)
  in
    Maybe.withDefault "" maybeFirst

hashList: String -> List String
hashList str =
  let
    list = split "/" (hashPart str)
    notEmpty = \x -> not (isEmpty x)
  in
    List.filter notEmpty list

-- QUERY

queryPart: String -> String
queryPart str =
  let
    parts = split "?" str
    maybeFirst = List.head (List.drop 1 parts)
  in
    Maybe.withDefault "" maybeFirst


-- "a=1" --> ("a", "1")
queryStringElementToTuple: String -> (String, String)
queryStringElementToTuple element =
  let
    splitted =
      split "=" element
    first l =
      Maybe.withDefault "" (List.head l)
    second l =
      Maybe.withDefault "" (List.head (List.drop 1 l))
  in
    (first splitted, second splitted)

queryTuples: String -> List (String, String)
queryTuples queryString =
  let
    splitted =
      split "&" queryString
  in
    List.map queryStringElementToTuple splitted

query: String -> Dict.Dict String String
query str =
  let
    queryString =
      queryPart str
  in
    Dict.fromList (queryTuples queryString)

-- MAIN

parse: String -> Url
parse str =
  {
    path = [],
    hash = (hashList str),
    query = (query str)
  }
