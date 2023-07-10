{-# OPTIONS --safe #-}
module Structures.FinSet where

open import Foundations.Base
open import Foundations.Univalence

open import Meta.Underlying public

open import Structures.Base

open import Correspondences.Discrete
open import Correspondences.Finite.Bishop
open import Correspondences.Omniscient

private variable
  ℓ ℓ′ : Level
  A : Type ℓ

opaque
  FinSet : (ℓ : Level) → Type (ℓsuc ℓ)
  FinSet ℓ = Type-with (property is-fin-set λ _ → is-fin-set-is-prop)

  fin-set : (A : Type ℓ) → _ → FinSet ℓ
  fin-set = _,_

  FinSet-carrier : FinSet ℓ → Type ℓ
  FinSet-carrier = fst

  FinSet-carrier-is-fin-set : (A : FinSet ℓ) → is-fin-set (FinSet-carrier A)
  FinSet-carrier-is-fin-set = snd

  -- FinSet-carrier-is-discrete : (A : FinSet ℓ) → is-discrete (FinSet-carrier A)
  -- FinSet-carrier-is-discrete = is-fin-set→is-discrete ∘ snd

  -- FinSet-carrier-is-set : (A : FinSet ℓ) → is-set (FinSet-carrier A)
  -- FinSet-carrier-is-set = is-fin-set→is-set ∘ snd

  -- FinSet-carrier-is-omniscient : (A : FinSet ℓ) → is-omniscient {ℓ′ = ℓ′} (FinSet-carrier A)
  -- FinSet-carrier-is-omniscient = is-fin-set→is-omniscient ∘ snd

instance
  Underlying-FinSet : Underlying (FinSet ℓ)
  Underlying-FinSet {ℓ} .Underlying.ℓ-underlying = ℓ
  Underlying-FinSet .⌞_⌟ = FinSet-carrier
