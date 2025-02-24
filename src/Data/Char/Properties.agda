{-# OPTIONS --safe #-}
module Data.Char.Properties where

open import Foundations.Base
open import Foundations.Equiv

open import Data.Id

open import Data.Char.Base public

open import Agda.Builtin.Char.Properties public
  using ()
  renaming ( primCharToNatInjective to char→ℕ-injⁱ)

char→ℕ-inj
  : {c₁ c₂ : Char}
  → char→ℕ c₁ ＝ char→ℕ c₂ → c₁ ＝ c₂
char→ℕ-inj p =
  Id≃path .fst (char→ℕ-injⁱ _ _ ((Id≃path ₑ⁻¹) .fst p))
