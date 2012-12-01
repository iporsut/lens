{-# LANGUAGE CPP #-}
{-# LANGUAGE Rank2Types #-}
#if defined(__GLASGOW_HASKELL__) && __GLASGOW_HASKELL__ >= 704
{-# LANGUAGE Trustworthy #-}
#endif
-----------------------------------------------------------------------------
-- |
-- Module      :  Data.Typeable.Lens
-- Copyright   :  (C) 2012 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  experimental
-- Portability :  Rank2Types
--
----------------------------------------------------------------------------
module Data.Typeable.Lens
  ( _cast
  , _gcast
  ) where

import Control.Applicative
import Control.Lens
import Data.Typeable
#ifndef SAFE
import Unsafe.Coerce as Unsafe
#else
import Data.Maybe
#endif

-- | A 'Simple' 'Traversal' for working with a 'cast' of a 'Typeable' value.
_cast :: (Typeable s, Typeable a) => Simple Traversal s a
_cast f s = case cast s of
#ifndef SAFE
  Just a  -> Unsafe.unsafeCoerce <$> f a
#else
  Just a  -> fromMaybe (error "_cast: recast failed") . cast <$> f a
#endif
  Nothing -> pure s
{-# INLINE _cast #-}

-- | A 'Simple' 'Traversal' for working with a 'gcast' of a 'Typeable' value.
_gcast :: (Typeable s, Typeable a) => Simple Traversal (c s) (c a)
_gcast f s = case gcast s of
#ifndef SAFE
  Just a  -> Unsafe.unsafeCoerce <$> f a
#else
  Just a  -> fromMaybe (error "_gcast: recast failed") . gcast <$> f a
#endif
  Nothing -> pure s
{-# INLINE _gcast #-}
