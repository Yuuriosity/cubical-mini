{-# OPTIONS --safe #-}
module Foundations.Path.Groupoid where

open import Foundations.Base
open import Foundations.Transport

private variable
  ℓ ℓ′ : Level
  A : Type ℓ
  B : Type ℓ′
  w x y z : A

opaque
  unfolding _∙∙_∙∙_
  ∙-filler₂ : (q : x ＝ y) (r : y ＝ z)
            → Square q (q ∙ r) refl r
  ∙-filler₂ q r k i = hcomp (k ∨ ∂ i) λ where
    l (l = i0) → q (i ∨ k)
    l (k = i1) → r (l ∧ i)
    l (i = i0) → q k
    l (i = i1) → r l

  ∙-id-l : (p : x ＝ y) → refl ∙ p ＝ p
  ∙-id-l p = sym (∙-filler′ refl p)

  ∙-id-r : (p : x ＝ y) → p ∙ refl ＝ p
  ∙-id-r p = sym (∙-filler p refl)

  ∙-assoc : (p : w ＝ x) (q : x ＝ y) (r : y ＝ z)
          → p ∙ (q ∙ r) ＝ (p ∙ q) ∙ r
  ∙-assoc p q r i = ∙-filler p q i ∙ ∙-filler′ q r (~ i)

  ∙-inv-l : (p : x ＝ y) → sym p ∙ p ＝ refl
  ∙-inv-l {y} p i j = hcomp (∂ j ∨ i) λ where
    k (j = i0) → y
    k (j = i1) → p (k ∨ i)
    k (i = i1) → y
    k (k = i0) → p (~ j ∨ i)

  ∙-cancel-l : (p : x ＝ y) (q : y ＝ z)
             → (sym p ∙ p ∙ q) ＝ q
  ∙-cancel-l {y} p q i j = hcomp (∂ i ∨ ∂ j) λ where
    k (k = i0) → p (i ∨ ~ j)
    k (i = i0) → ∙-filler (sym p) (p ∙ q) k j
    k (i = i1) → q (j ∧ k)
    k (j = i0) → y
    k (j = i1) → ∙-filler₂ p q i k

  ∙-inv-r : (p : x ＝ y) → p ∙ sym p ＝ refl
  ∙-inv-r p = ∙-inv-l (sym p)

  ∙-cancel-r : (p : x ＝ y) (q : z ＝ y)
             → ((p ∙ sym q) ∙ q) ＝ p
  ∙-cancel-r q p = sym $ ∙-unique _ λ i j →
    ∙-filler q (sym p) (~ i) j

  commutes→square : {p : w ＝ x} {q : w ＝ y} {s : x ＝ z} {r : y ＝ z}
                  → p ∙ s ＝ q ∙ r
                  → Square p q r s
  commutes→square {p} {q} {s} {r} fill i j =
    hcomp (∂ i ∨ ∂ j) λ where
      k (k = i0) → fill j i
      k (i = i0) → q (k ∧ j)
      k (i = i1) → s (~ k ∨ j)
      k (j = i0) → ∙-filler p s (~ k) i
      k (j = i1) → ∙-filler₂ q r k i

  square→commutes : {p : w ＝ x} {q : w ＝ y} {s : x ＝ z} {r : y ＝ z}
                  → Square p q r s
                  → p ∙ s ＝ q ∙ r
  square→commutes {p} {q} {s} {r} fill i j = hcomp (∂ i ∨ ∂ j) λ where
    k (k = i0) → fill j i
    k (i = i0) → ∙-filler p s k j
    k (i = i1) → ∙-filler₂ q r (~ k) j
    k (j = i0) → q (~ k ∧ i)
    k (j = i1) → s (k ∨ i)

  square→conjugate
    : {p : x ＝ y} {q : x ＝ z} {r : z ＝ w} {s : y ＝ w}
    → Square p q r s
    → s ＝ sym p ∙ q ∙ r
  square→conjugate {p} {q} {r} {s} θ =
    sym (transport-flip {A = λ i → p i ＝ r i} $ from-pathP⁻ θ) ∙ transport-path q p r

  conjugate→square
    : {p : x ＝ y} {q : x ＝ z} {r : z ＝ w} {s : y ＝ w}
    → s ＝ sym p ∙ q ∙ r
    → Square p q r s
  conjugate→square {p} {q} {r} {s} α = to-pathP (transport-path q p r ∙ sym α)

  ∙-cancel′-l : (p : x ＝ y) (q r : y ＝ z)
              → p ∙ q ＝ p ∙ r
              → q ＝ r
  ∙-cancel′-l p q r sq =
       sym (∙-cancel-l p q)
    ∙∙ ap (sym p ∙_) sq
    ∙∙ ∙-cancel-l p r

  ∙-cancel′-r : (p : y ＝ z) (q r : x ＝ y)
              → q ∙ p ＝ r ∙ p
              → q ＝ r
  ∙-cancel′-r p q r sq =
       sym (∙-cancel-r q (sym p))
    ∙∙ ap (_∙ sym p) sq
    ∙∙ ∙-cancel-r r (sym p)

  homotopy-invert : {f : A → A}
                  → (H : Π[ x ꞉ A ] (f x ＝ x)) {x : A}
                  → H (f x) ＝ ap f (H x)
  homotopy-invert {f} H {x} i j = hcomp (∂ i ∨ ∂ j) λ where
    k (k = i0) → H x       (j ∧ i)
    k (j = i0) → H (f x)   (~ k)
    k (j = i1) → H x       (~ k ∧ i)
    k (i = i0) → H (f x)   (~ k ∨ j)
    k (i = i1) → H (H x j) (~ k)

  homotopy-natural : {f g : A → B}
                     (H : Π[ a ꞉ A ] (f a ＝ g a))
                     {x y : A} (p : x ＝ y)
                   → H x ∙ ap g p ＝ ap f p ∙ H y
  homotopy-natural {f} {g} H {x} {y} p = ∙-unique _ λ i j →
    hcomp (~ i ∨ ∂ j) λ where
      k (k = i0) → H x (j ∧ i)
      k (i = i0) → f (p (j ∧ k))
      k (j = i0) → f x
      k (j = i1) → H (p k) i

  homotopy-sym-inv : {f : A → A}
                     (H : Π[ a ꞉ A ] (f a ＝ a))
                     (x : A)
                   → Path (f x ＝ f x) (λ i → H (H x (~ i)) i) refl
  homotopy-sym-inv {f} H x i j = hcomp (∂ i ∨ ∂ j) λ where
    k (i = i0) → H (H x (~ j)) j
    k (i = i1) → H x (j ∧ ~ k)
    k (j = i0) → f x
    k (j = i1) → H x (i ∧ ~ k)
    k (k = i0) → H (H x (i ∨ ~ j)) j
