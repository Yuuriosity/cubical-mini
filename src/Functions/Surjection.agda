{-# OPTIONS --safe #-}
module Functions.Surjection where

open import Foundations.Base
open import Foundations.Equiv

open import Meta.Search.HLevel

open import Truncation.Propositional.Base

private variable
  ℓ ℓ′ : Level
  A : Type ℓ
  B : Type ℓ′
  f : A → B
  g : B → A

Split-surjective : (A → B) → Type _
Split-surjective f = Π[ y ꞉ _ ] fibre f y

_↠!_ : Type ℓ → Type ℓ′ → Type _
A ↠! B = Σ[ f ꞉ (A → B) ] Split-surjective f

is-surjective : (A → B) → Type _
is-surjective f = Π[ y ꞉ _ ] ∥ fibre f y ∥₁

is-surjective-is-prop : is-prop (is-surjective f)
is-surjective-is-prop = hlevel!

_↠_ : Type ℓ → Type ℓ′ → Type _
A ↠ B = Σ[ f ꞉ (A → B) ] is-surjective f

is-left-inverse-of→is-surjective : f is-left-inverse-of g → is-surjective f
is-left-inverse-of→is-surjective {g} s b = ∣ g b , s b ∣₁

is-equiv→is-surjective : is-equiv f → is-surjective f
is-equiv→is-surjective r y = ∣ equiv-proof r y .fst ∣₁
