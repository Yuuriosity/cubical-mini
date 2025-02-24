{-# OPTIONS --safe #-}
module Meta.Bind where

open import Foundations.Base

open import Meta.Idiom public

record Bind (M : Effect) : Typeω where
  private module M = Effect M
  field
    _>>=_ : ∀ {ℓ ℓ′} {A : Type ℓ} {B : Type ℓ′} → M.₀ A → (A → M.₀ B) → M.₀ B
    ⦃ Idiom-bind ⦄ : Idiom M

  _>>_ : ∀ {ℓ ℓ′} {A : Type ℓ} {B : Type ℓ′} → M.₀ A → M.₀ B → M.₀ B
  _>>_ f g = f >>= λ _ → g

  _=<<_ : ∀ {ℓ ℓ′} {A : Type ℓ} {B : Type ℓ′} → (A → M.₀ B) → M.₀ A → M.₀ B
  _=<<_ f x = x >>= f

open Bind ⦃ ... ⦄ public
