{-# OPTIONS --safe #-}
module Data.Bool.Base where

open import Foundations.Prim.Type

open import Agda.Builtin.Bool public

private variable
  ℓ : Level
  A : Type ℓ

not : Bool → Bool
not true = false
not false = true

infixr 5 _or_
_or_ : Bool → Bool → Bool
false or x = x
true  or _ = true

infixr 6 _and_
_and_ : Bool → Bool → Bool
false and _ = false
true  and x = x

-- xor / mod-2 addition
infixr 5 _⊕_
_⊕_ : Bool → Bool → Bool
false ⊕ x = x
true  ⊕ x = not x

infix 0 if_then_else_
if_then_else_ : Bool → A → A → A
if true  then x else y = x
if false then x else y = y

elim : {P : Bool → Type ℓ} (t : P true) (f : P false) (b : Bool) → P b
elim _ f false = f
elim t _ true  = t

rec : A → A → Bool → A
rec = elim

-- dichotomyBool : (x : Bool) → (x ≡ true) ⊎ (x ≡ false)
-- dichotomyBool true  = inl refl
-- dichotomyBool false = inr refl

-- dichotomyBoolSym : (x : Bool) → (x ≡ false) ⊎ (x ≡ true)
-- dichotomyBoolSym false = inl refl
-- dichotomyBoolSym true = inr refl

-- -- Helpers for automatic proof
-- T : Bool → Type₀
-- T false = ⊥
-- T true  = Unit
