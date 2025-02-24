{-# OPTIONS --safe #-}
module Data.Vec.Instances.Discrete where

open import Foundations.Base

open import Meta.Search.Discrete

open import Correspondences.Decidable

open import Data.Dec.Base as Dec
open import Data.List.Base using ([]) renaming (_∷_ to _∷ₗ_)
open import Data.Vec.Base

private variable
  ℓ : Level
  A : Type ℓ
  @0 n : ℕ

vec-is-discrete : is-discrete A → is-discrete (Vec A n)
vec-is-discrete {A} di = is-discrete-η go where
  go : ∀ {@0 n} → (xs ys : Vec A n) → Dec (xs ＝ ys)
  go []       []       = yes refl
  go (x ∷ xs) (y ∷ ys) = Dec.map
    (λ (x=y , xs=ys) → ap₂ _∷_ x=y xs=ys)
    (λ f p → f (ap head p , ap tail p))
    (×-decision (is-discrete-β di x y) $ go xs ys)

instance
  decomp-dis-vec : goal-decomposition (quote is-discrete) (Vec A n)
  decomp-dis-vec = decomp (quote vec-is-discrete) (`search (quote is-discrete) ∷ₗ [])
