{-# LANGUAGE TemplateHaskell #-}

module Cable where

import Control.Lens
--import Graphics.Gloss.Data.Color

import Sound.MoodlerLib.Symbols

newtype Cable = Cable { _from :: UiId } deriving (Eq, Ord, Show, Read)

$(makeLenses ''Cable)
