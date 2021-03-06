{-# LANGUAGE CPP #-}

module Agda.TypeChecking.LevelConstraints ( simplifyLevelConstraint ) where

import qualified Data.List as List
import Data.Maybe
import Agda.Syntax.Internal
import Agda.TypeChecking.Monad.Base
import Agda.TypeChecking.Substitute
import Agda.TypeChecking.Free
import Agda.Utils.Impossible

#include "undefined.h"

-- | @simplifyLevelConstraint c cs@ turns an @c@ into an equality
--   constraint if it is an inequality constraint and the reverse
--   inequality is contained in @cs@.
--
--   The constraints doesn't necessarily have to live in the same context, but
--   they do need to be universally quanitfied over the context. This function
--   takes care of renaming variables when checking for matches.
simplifyLevelConstraint :: Constraint -> [Constraint] -> [Constraint]
simplifyLevelConstraint new old =
  case inequalities new of
    Just eqs -> map simpl eqs
    Nothing  -> [new]
  where
    simpl (a :=< b) | any (matchLeq (b :=< a)) leqs = LevelCmp CmpEq  (Max [a]) (Max [b])
                    | otherwise                     = LevelCmp CmpLeq (Max [a]) (Max [b])
    leqs = concat $ mapMaybe inequalities old

data Leq = PlusLevel :=< PlusLevel
  deriving (Show, Eq)

-- | Check if two inequality constraints are the same up to variable renaming.
matchLeq :: Leq -> Leq -> Bool
matchLeq (a :=< b) (c :=< d)
  | length xs == length ys = (a, b) == applySubst rho (c, d)
  | otherwise              = False
  where
    free :: Free a => a -> [Int]
    free = List.nub . runFree (:[]) IgnoreNot  -- Note: use a list to preserve order of variables
    xs  = free (a, b)
    ys  = free (c, d)
    rho = mkSub $ List.sort $ zip ys xs
    mkSub = go 0
      where
        go _ [] = IdS
        go y ren0@((y', x) : ren)
          | y == y'   = Var x [] :# go (y + 1) ren
          | otherwise = Strengthen __IMPOSSIBLE__ $ go (y + 1) ren0

-- | Turn a level constraint into a list of level inequalities, if possible.

inequalities :: Constraint -> Maybe [Leq]

inequalities (LevelCmp CmpLeq (Max as) (Max [b])) = Just $ map (:=< b) as  -- Andreas, 2016-09-28
  -- Why was this most natural case missing?
  -- See test/Succeed/LevelLeqGeq.agda for where it is useful!

-- These are very special cases only, in no way complete:
inequalities (LevelCmp CmpEq (Max as) (Max [b])) =
  case break (== b) as of
    (as0, _ : as1) -> Just [ a :=< b | a <- as0 ++ as1 ]
    _              -> Nothing
inequalities (LevelCmp CmpEq (Max [b]) (Max as)) =
  case break (== b) as of
    (as0, _ : as1) -> Just [ a :=< b | a <- as0 ++ as1 ]
    _              -> Nothing
inequalities _ = Nothing
