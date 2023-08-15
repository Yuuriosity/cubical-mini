{-# OPTIONS --safe #-}
module Data.Fin.Instances.Show where

open import Meta.Show

open import Agda.Builtin.String
open import Data.Nat.Base

instance
  show-nat : Show ℕ
  show-nat .shows-prec _ = primShowNat
