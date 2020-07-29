-- Copyright (c) 2016-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree.


{-# LANGUAGE GADTs #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE LambdaCase #-}

module Duckling.Numeral.ES.Rules (rules) where

import qualified Data.HashMap.Strict as HashMap
import Data.Maybe
import Data.String
import qualified Data.Text as Text
import Prelude

import Duckling.Dimensions.Types
import Duckling.Numeral.Helpers
import Duckling.Numeral.Types (NumeralData(..))
import qualified Duckling.Numeral.Types as TNumeral
import Duckling.Regex.Types
import Duckling.Types

ruleNumeralsPrefixWithNegativeOrMinus :: Rule
ruleNumeralsPrefixWithNegativeOrMinus = Rule
  { name = "numbers prefix with -, negative or minus"
  , pattern = [regex "-|menos", Predicate isPositive]
  , prod = \tokens -> case tokens of
      (_ : Token Numeral NumeralData { TNumeral.value = Just v } : _) ->
        double $ v * (-1)
      _ -> Nothing
  }

byTensMap :: HashMap.HashMap Text.Text Integer
byTensMap =
  HashMap.fromList
    [ ("veinte", 20)
    , ("treinta", 30)
    , ("cuarenta", 40)
    , ("cincuenta", 50)
    , ("sesenta", 60)
    , ("setenta", 70)
    , ("ochenta", 80)
    , ("noventa", 90)
    ]

ruleNumeral2 :: Rule
ruleNumeral2 = Rule
  { name = "number (20..90)"
  , pattern =
      [ regex
          "(veinte|treinta|cuarenta|cincuenta|sesenta|setenta|ochenta|noventa)"
      ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (match : _)) : _) ->
        HashMap.lookup (Text.toLower match) byTensMap >>= integer
      _ -> Nothing
  }

zeroToFifteenMap :: HashMap.HashMap Text.Text Integer
zeroToFifteenMap =
  HashMap.fromList
    [ ("zero", 0)
    , ("cero", 0)
    , ("un", 1)
    , ("una", 1)
    , ("uno", 1)
    , ("dos", 2)
    , ("trés", 3)
    , ("tres", 3)
    , ("cuatro", 4)
    , ("cinco", 5)
    , ("seis", 6)
    , ("séis", 6)
    , ("siete", 7)
    , ("ocho", 8)
    , ("nueve", 9)
    , ("diez", 10)
    , ("dies", 10)
    , ("once", 11)
    , ("doce", 12)
    , ("trece", 13)
    , ("catorce", 14)
    , ("quince", 15)
    ]

ruleNumeral :: Rule
ruleNumeral = Rule
  { name = "number (0..15)"
  , pattern =
      [ regex
          "((c|z)ero|un(o|a)?|dos|tr(é|e)s|cuatro|cinco|s(e|é)is|siete|ocho|nueve|die(z|s)|once|doce|trece|catorce|quince)"
      ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (match : _)) : _) ->
        HashMap.lookup (Text.toLower match) zeroToFifteenMap >>= integer
      _ -> Nothing
  }

sixteenToTwentyNineMap :: HashMap.HashMap Text.Text Integer
sixteenToTwentyNineMap =
  HashMap.fromList
    [ ("dieciseis", 16)
    , ("diesiséis", 16)
    , ("diesiseis", 16)
    , ("dieciséis", 16)
    , ("diecisiete", 17)
    , ("dieciocho", 18)
    , ("diecinueve", 19)
    , ("veintiuno", 21)
    , ("veintiuna", 21)
    , ("veintidos", 22)
    , ("veintidós", 22)
    , ("veintitrés", 23)
    , ("veintitres", 23)
    , ("veinticuatro", 24)
    , ("veinticinco", 25)
    , ("veintiséis", 26)
    , ("veintiseis", 26)
    , ("veintisiete", 27)
    , ("veintiocho", 28)
    , ("veintinueve", 29)
    ]

ruleNumeral5 :: Rule
ruleNumeral5 = Rule
  { name = "number (16..19 21..29)"
  , pattern =
      [ regex
          "(die(c|s)is(é|e)is|diecisiete|dieciocho|diecinueve|veintiun(o|a)|veintid(o|ó)s|veintitr(é|e)s|veinticuatro|veinticinco|veintis(é|e)is|veintisiete|veintiocho|veintinueve|treinta)"
      ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (match : _)) : _) ->
        HashMap.lookup (Text.toLower match) sixteenToTwentyNineMap >>= integer
      _ -> Nothing
  }

ruleNumeral3 :: Rule
ruleNumeral3 = Rule
  { name = "number (16..19)"
  , pattern = [oneOf[10], regex "y", numberBetween 6 10]
  , prod = \tokens -> case tokens of
      (_ : _ : Token Numeral NumeralData { TNumeral.value = Just v } : _) ->
        double $ 10 + v
      _ -> Nothing
  }

ruleNumeralsSuffixesKMG :: Rule
ruleNumeralsSuffixesKMG = Rule
  { name = "numbers suffixes (K, M, G)"
  , pattern = [dimension Numeral, regex "([kmg])(?=[\\W\\$€]|$)"]
  , prod = \tokens -> case tokens of
      (Token Numeral NumeralData { TNumeral.value = Just v } : Token RegexMatch (GroupMatch (match : _)) : _) ->
        case Text.toLower match of
          "k" -> double $ v * 1e3
          "m" -> double $ v * 1e6
          "g" -> double $ v * 1e9
          _ -> Nothing
      _ -> Nothing
  }

oneHundredToThousandMap :: HashMap.HashMap Text.Text Integer
oneHundredToThousandMap =
  HashMap.fromList
    [ ("cien", 100)
    , ("cientos", 100)
    , ("ciento", 100)
    , ("doscientos", 200)
    , ("trescientos", 300)
    , ("cuatrocientos", 400)
    , ("quinientos", 500)
    , ("seiscientos", 600)
    , ("setecientos", 700)
    , ("ochocientos", 800)
    , ("novecientos", 900)
    , ("mil", 1000)
    ]

ruleNumeral6 :: Rule
ruleNumeral6 = Rule
  { name = "number 100..1000 "
  , pattern =
      [ regex
          "(cien(to)?s?|doscientos|trescientos|cuatrocientos|quinientos|seiscientos|setecientos|ochocientos|novecientos|mil)"
      ]
  , prod = \tokens -> case tokens of
      (Token RegexMatch (GroupMatch (match : _)) : _) ->
        HashMap.lookup (Text.toLower match) oneHundredToThousandMap >>= integer
      _ -> Nothing
  }

ruleNumeral4 :: Rule
ruleNumeral4 = Rule
  { name = "number (21..29 31..39 41..49 51..59 61..69 71..79 81..89 91..99)"
  , pattern =
      [oneOf [70, 20, 60, 50, 40, 90, 30, 80], regex "y", numberBetween 1 10]
  , prod = \tokens -> case tokens of
      (Token Numeral NumeralData { TNumeral.value = Just v1 } : _ : Token Numeral NumeralData { TNumeral.value = Just v2 } : _) ->
        double $ v1 + v2
      _ -> Nothing
  }

ruleNumerals :: Rule
ruleNumerals = Rule
  { name = "numbers 200..999"
  , pattern =
      [ numberBetween 2 10
      , oneOf [100]
      , numberBetween 0 100
      ]
  , prod = \tokens -> case tokens of
      (Token Numeral NumeralData { TNumeral.value = Just v1 } : _ : Token Numeral NumeralData { TNumeral.value = Just v2 } : _) ->
        double $ 100 * v1 + v2
      _ -> Nothing
  }

ruleNumeralDotNumeral :: Rule
ruleNumeralDotNumeral = Rule
  { name = "number dot number"
  , pattern = [dimension Numeral, regex "punto", Predicate $ not . hasGrain]
  , prod = \tokens -> case tokens of
      (Token Numeral NumeralData { TNumeral.value = Just v1 } : _ : Token Numeral NumeralData { TNumeral.value = Just v2 } : _) ->
        double $ v1 + decimalsToDouble v2
      _ -> Nothing
  }

ruleBelowTenWithTwoDigits :: Rule
ruleBelowTenWithTwoDigits = Rule
  {
    name = "integer (0-9) with two digits"
  , pattern =
      [
        regex "((c|z)ero)|0"
      , numberBetween 1 10
      ]
  , prod = \case
      (
        _:
        Token Numeral NumeralData { TNumeral.value = Just v }:
        _
        ) -> double v
      _ -> Nothing
  }

rules :: [Rule]
rules =
  [ ruleBelowTenWithTwoDigits
  , ruleNumeral
  , ruleNumeral2
  , ruleNumeral3
  , ruleNumeral4
  , ruleNumeral5
  , ruleNumeral6
  , ruleNumeralDotNumeral
  , ruleNumerals
  , ruleNumeralsPrefixWithNegativeOrMinus
  , ruleNumeralsSuffixesKMG
  ]
