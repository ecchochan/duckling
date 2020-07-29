-- Copyright (c) 2016-present, Facebook, Inc.
-- All rights reserved.
--
-- This source code is licensed under the BSD-style license found in the
-- LICENSE file in the root directory of this source tree.


{-# LANGUAGE OverloadedStrings #-}

module Duckling.Numeral.VI.Corpus
  ( corpus ) where

import Prelude
import Data.String

import Duckling.Locale
import Duckling.Numeral.Types
import Duckling.Resolve
import Duckling.Testing.Types

corpus :: Corpus
corpus = (testContext {locale = makeLocale VI Nothing}, testOptions, allExamples)

allExamples :: [Example]
allExamples = concat
  [ examples (simple 0)
             [ "0"
             , "không"
             ]
  , examples (simple 1)
             [ "1"
             , "một"
             ]
  , examples (simple 2)
             [ "2"
             , "hai"
             ]
  , examples (simple 33)
             [ "33"
             , "ba mươi ba"
             ]
  , examples (simple 14)
             [ "14"
             , "mười bốn"
             ]
  , examples (simple 16)
             [ "16"
             , "mười sáu"
             ]
  , examples (simple 17)
             [ "17"
             , "mười bảy"
             ]
  , examples (simple 18)
             [ "18"
             , "mười tám"
             ]
  , examples (simple 100)
            [ "100"
            , "trăm"
            ]
  , examples (simple 1.1)
             [ "1,1"
             , "1,10"
             , "01,10"
             ]
  , examples (simple 0.77)
             [ "0,77"
             , ",77"
             ]
  , examples (simple 100000)
             [ "100.000"
             , "100000"
             , "100K"
             , "100k"
             ]
  , examples (simple 3000000)
             [ "3M"
             , "3000K"
             , "3000000"
             , "3.000.000"
             ]
  , examples (simple 1200000)
             [ "1.200.000"
             , "1200000"
             , "1,2M"
             , "1200K"
             , ",0012G"
             ]
  , examples (simple (-1200000))
             [ "- 1.200.000"
             , "-1200000"
             , "âm 1.200.000"
             , "-1,2M"
             , "-1200K"
             , "-,0012G"
             ]
  , examples (simple 20)
             [ "hai chục"
             , "hai mươi"
             ]
  , examples (simple 5000)
             [ "5 nghìn"
             , "năm nghìn"
             , "năm ngàn"
             ]
  , examples (simple 200000)
             [ "hai trăm nghìn"
             , "hai trăm ngàn"
             ]
  , examples (simple 1000000000)
             [ "một tỷ"
             , "một tỉ"
             ]
  , examples (simple 21011)
             [ "hai mươi mốt nghìn không trăm mười một"
             ]
  , examples (simple 721012)
             [ "bảy trăm hai mươi mốt nghìn không trăm mười hai"
             ]
  ]
