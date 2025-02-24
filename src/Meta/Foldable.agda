{-# OPTIONS --safe #-}
module Meta.Foldable where

open import Foundations.Base

open import Meta.Alt public

record Foldable (F : Effect) : Typeω where
  private module F = Effect F
  field
    fold-r : ∀ {ℓ ℓ′} {a : Type ℓ} {b : Type ℓ′} → (a → b → b) → b → F.₀ a → b

open Foldable ⦃ ... ⦄ public


asum
  : ∀ {F M : Effect} ⦃ f : Foldable F ⦄ ⦃ a : Alt M ⦄ {ℓ} {A : Type ℓ}
  → (let module F = Effect F)
  → (let module M = Effect M)
  → F.₀ (M.₀ A) → M.₀ A
asum = fold-r _<|>_ fail

nondet
  : ∀ (F : Effect) {M} ⦃ f : Foldable F ⦄ ⦃ t : Map F ⦄
      ⦃ a : Alt M ⦄ ⦃ i : Idiom M ⦄
      {ℓ ℓ′} {A : Type ℓ} {B : Type ℓ′}
  → (let module F = Effect F)
  → (let module M = Effect M)
  → F.₀ A → (A → M.₀ B) → M.₀ B
nondet F ⦃ f ⦄ xs k = asum ⦃ f ⦄ (k <$> xs)
