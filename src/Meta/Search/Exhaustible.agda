{-# OPTIONS --safe #-}
module Meta.Search.Exhaustible where

open import Foundations.Base
open import Foundations.Equiv

open import Meta.Reflection
open import Meta.Search.Base public
open import Meta.Search.Decidable
open import Meta.Search.HLevel

open import Correspondences.Exhaustible
open Correspondences.Exhaustible public
  using ( Exhaustible ; exhaustible-β ; exhaustible-η
        ; exhaust
        ; Π-decision )

open import Data.Dec.Base as Dec
open import Data.Empty.Base as ⊥
open import Data.Fin.Instances.FromNat
open import Data.List.Instances.FromProduct

private variable
  ℓ ℓ′ ℓa ℓb ℓc ℓd : Level
  T : Type ℓ
  A : Type ℓa
  B : A → Type ℓb
  C : (a : A) (b : B a) → Type ℓc
  D : (a : A) (b : B a) (c : C a b) → Type ℓd
  n : HLevel

instance
  Tactic-exhaust : Tactic-desc (quote Exhaustible) none
  Tactic-exhaust .Tactic-desc.args-length = 3
  Tactic-exhaust .Tactic-desc.goal-selector = 2
  Tactic-exhaust .Tactic-desc.other-atoms = [ quote _≃_ ]
  Tactic-exhaust .Tactic-desc.instance-helper = quote exhaust

exhaust-tactic-worker = search-tactic-worker Tactic-exhaust
macro exhaust! = exhaust-tactic-worker

instance
  decomp-exh-lift : goal-decomposition (quote Exhaustible) (Lift ℓ′ A)
  decomp-exh-lift = decomp (quote lift-exhaustible) [ `search (quote Exhaustible) ]

  decomp-dec-Π : goal-decomposition (quote Dec) (Π[ a ꞉ A ] B a )
  decomp-dec-Π = decomp (quote Π-decision) [ `search-under 1 (quote Dec) , `search (quote Exhaustible) ]

-- TODO more decompositions

-- Usage
private
  module _ ⦃ A-exh : Exhaustible {ℓ′ = ℓ′} A ⦄ where
    _ : Exhaustible {ℓ′ = ℓ′} (Lift ℓ A)
    _ = exhaust!
