{-# LANGUAGE MultiParamTypeClasses #-}

module Vision.Image.RGBImage.Storage (
    ) where

import Data.Word

import Data.Array.Repa (
      Z (..), (:.) (..), (!), unsafeIndex, extent, delay, computeS
    )
    
import qualified Data.Array.Repa.IO.DevIL as IL

import Data.Convertible (convert)

import qualified Vision.Image as I
import Vision.Image.RGBImage.Base
import Vision.Image.RGBImage.Conversion
import Vision.Image.GreyImage.Base (GreyImage (..))
import Vision.Image.RGBAImage.Base (RGBAImage (..))

import Vision.Primitive (Point (..), Size (..))

instance I.StorableImage RGBImage Pixel where
    load path =
        IL.runIL $ fromILImage `fmap` IL.readImage path
    {-# INLINE load #-}
        
    save path (RGBImage image) = 
        IL.runIL $ IL.writeImage path (IL.RGB $ computeS image)
    {-# INLINE save #-}

-- | Converts an image from its DevIL representation to a 'RGBImage'.
fromILImage :: IL.Image -> RGBImage
fromILImage (IL.RGB i)  = RGBImage $ delay i
fromILImage (IL.RGBA i) = convert $ RGBAImage $ delay i
fromILImage (IL.Grey i) = convert $ GreyImage $ delay i
{-# INLINE fromILImage #-}