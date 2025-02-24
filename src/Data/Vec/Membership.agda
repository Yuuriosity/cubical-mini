{-# OPTIONS --safe #-}
module Data.Vec.Membership where

open import Foundations.Base

open import Meta.Search.Discrete

open import Data.Dec as Dec
open import Data.Empty.Base
open import Data.Fin.Base
open import Data.Sum.Base
open import Data.Sum.Instances.Decidable
open import Data.Vec.Operations.Inductive

private variable
  ℓ : Level
  A : Type ℓ
  @0 n : ℕ

_∈_ : A → Vec A n → Type _
x ∈ xs = Σ[ idx ꞉ Fin _ ] (lookup xs idx ＝ x)

_∉_ : A → Vec A n → Type _
x ∉ xs = ¬ (x ∈ xs)

_∈!_ : A → Vec A n → Type _
x ∈! xs = is-contr (x ∈ xs)

_∈?_ : {@(tactic discrete-tactic-worker) di : is-discrete A }
     → Π[ x ꞉ A ] Π[ as ꞉ Vec A n ] Dec (x ∈ as)
_∈?_ {n = 0} x [] = no λ()
_∈?_ {n = suc _} {di} x (a ∷ as) =
  Dec.map [ fzero ,_ , (λ { (i , q) → fsuc i , q }) ]ᵤ
          (λ { x∉as (fzero  , q) → x∉as $ inl q
             ; x∉as (fsuc i , q) → x∉as $ inr $ i , q })
          (⊎-decision (is-discrete-β di a x) (_∈?_ {di = di} x as))
