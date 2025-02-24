{-# OPTIONS --safe #-}
module Data.FinSum.Base where

open import Foundations.Base

open import Data.Nat.Base
  using (ℕ; zero; suc)
open import Data.Empty.Base
  using (⊥; absurd)
open import Data.Sum.Base

private variable
  ℓ : Level
  m n : ℕ

Fin : ℕ → Type
Fin zero    = ⊥
Fin (suc n) = ⊤ ⊎ Fin n

pattern fzero  = inl tt
pattern fsuc n = inr n

elim
  : (P : ∀ {n} → Fin n → Type ℓ)
  → (∀ {n} → P {suc n} fzero)
  → (∀ {n} {fn : Fin n} → P fn → P (fsuc fn))
  → {n : ℕ} (fn : Fin n) → P fn
elim P fz fs {(zero)} f0        = absurd f0
elim P fz fs {suc k}  fzero     = fz
elim P fz fs {suc k}  (fsuc fk) = fs (elim P fz fs fk)
