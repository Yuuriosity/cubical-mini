{-# OPTIONS --safe #-}
module Structures.n-Type where

open import Foundations.Base
open import Foundations.Equiv
open import Foundations.HLevel
open import Foundations.Sigma
open import Foundations.Univalence

open import Meta.Underlying public

open import Structures.Base

private variable
  ℓ ℓ′ : Level
  A : Type ℓ
  B : Type ℓ′
  n : HLevel

record n-Type (ℓ : Level) (n : HLevel) : Type (ℓsuc ℓ) where
  constructor el
  field
    carrier : Type ℓ
    carrier-is-tr : is-of-hlevel n carrier

open n-Type

private variable
  X Y : n-Type ℓ n

instance
  Underlying-n-Type : Underlying (n-Type ℓ n)
  Underlying-n-Type {ℓ} .Underlying.ℓ-underlying = ℓ
  Underlying-n-Type .⌞_⌟ = carrier

@0 ＝-is-of-hlevel : (n : ℕ) → is-of-hlevel n A → is-of-hlevel n B → is-of-hlevel n (A ＝ B)
＝-is-of-hlevel n Ahl Bhl = is-equiv→is-of-hlevel n ua univalence⁻¹ (≃-is-of-hlevel n Ahl Bhl)

n-path : ⌞ X ⌟ ＝ ⌞ Y ⌟ → X ＝ Y
n-path f i .carrier = f i
n-path {X} {Y} f i .carrier-is-tr =
  is-prop→pathP (λ i → is-of-hlevel-is-prop {A = f i} _) (carrier-is-tr X) (carrier-is-tr Y) i

@0 n-ua : ⌞ X ⌟ ≃ ⌞ Y ⌟ → X ＝ Y
n-ua f = n-path (ua f)

opaque
  unfolding univalence⁻¹
  @0 n-univalence : (⌞ X ⌟ ≃ ⌞ Y ⌟) ≃ (X ＝ Y)
  n-univalence {X} {Y} = n-ua , is-iso→is-equiv isic where
    inv : ∀ {Y} → X ＝ Y → ⌞ X ⌟ ≃ ⌞ Y ⌟
    inv p = path→equiv (ap carrier p)

    linv : ∀ {Y} → (inv {Y}) is-left-inverse-of n-ua
    linv x = Σ-prop-path is-equiv-is-prop (fun-ext λ x → transport-refl _)

    rinv : ∀ {Y} → (inv {Y}) is-right-inverse-of n-ua
    rinv = J (λ y p → n-ua (inv p) ＝ p) path where
      path : n-ua (inv {X} refl) ＝ refl
      path i j .carrier = ua.ε refl i j
      path i j .carrier-is-tr = is-prop→squareP
        (λ i j → is-of-hlevel-is-prop
          {A = ua.ε {A = ⌞ X ⌟} refl i j } _)
        (λ j → carrier-is-tr $ n-ua {X = X} {Y = X} (path→equiv refl) j)
        (λ _ → carrier-is-tr X)
        (λ _ → carrier-is-tr X)
        (λ _ → carrier-is-tr X)
        i j

    isic : is-iso n-ua
    isic = iso inv rinv (linv {Y})

opaque
  unfolding is-of-hlevel
  @0 n-Type-is-of-hlevel : ∀ n → is-of-hlevel (suc n) (n-Type ℓ n)
  n-Type-is-of-hlevel zero x y = n-ua
    ((λ _ → carrier-is-tr y .fst) , is-contr→is-equiv (carrier-is-tr x) (carrier-is-tr y))
  n-Type-is-of-hlevel (suc n) x y =
    is-of-hlevel-≃ (suc n) (n-univalence ₑ⁻¹) (≃-is-of-hlevel (suc n) (carrier-is-tr x) (carrier-is-tr y))

Prop : ∀ ℓ → Type (ℓsuc ℓ)
Prop ℓ = n-Type ℓ 1

Set : ∀ ℓ → Type (ℓsuc ℓ)
Set ℓ = n-Type ℓ 2

-- module _ {ℓ : Level} {n : HLevel} where private
--   open import Foundations.Univalence.SIP
--   _ : n-Type ℓ n ≃ Type-with {S = is-of-hlevel n} (HomT→Str λ _ _ _ → ⊤)
--   _ = iso→equiv the-iso
--     where
--       open import Meta.Record
--       the-iso : Iso (n-Type ℓ n) (Σ[ T ꞉ Type ℓ ] is-of-hlevel n T)
--       unquoteDef the-iso = define-record-iso the-iso (quote n-Type)
