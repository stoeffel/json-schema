module Json.Schema.Builder
    exposing
        ( blankSchema
        , withType
        , withNullableType
        , withUnionType
        )

import Set
import Util exposing (foldResults)
import Data.Schema
    exposing
        ( Schema
        , Type(AnyType, SingleType, NullableType, UnionType)
        , SingleType(IntegerType, NumberType, StringType, NullType, ArrayType, ObjectType)
        , stringToType
        )


blankSchema =
    { type_ = Nothing
    , title = Nothing
    , description = Nothing
    , default = Nothing
    , examples = Nothing
    }


withType t schema =
    t
        |> stringToType
        |> Result.map (\x -> { schema | type_ = SingleType x })


withNullableType t schema =
    t
        |> stringToType
        |> Result.map (\r ->
            case r of
                NullType ->
                    { schema | type_ = SingleType NullType }

                r ->
                    { schema | type_ = NullableType r }
        )



withUnionType listTypes schema =
    listTypes
        |> List.sort
        |> List.map stringToType
        |> foldResults
        |> Result.map (\x -> { schema | type_ = UnionType x })
