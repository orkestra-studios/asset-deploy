{-# LANGUAGE OverloadedStrings, PatternGuards #-}
import System.Environment
import System.IO

import Graphics.Image.Types
import Graphics.Image.Processing

import qualified Graphics.Image as HIP

type IMG = (Image VU RGBA Double) 

main :: IO ()
main = do
  args <- getArgs
  mapM_ (generateImages . getFileProps) args
  putStrLn "done."

getFileProps :: String -> (String, String, String)
getFileProps s = (base, scale, ext)
  where ext = dropWhile (/='.') s
        base = takeWhile (\c -> c/='@' && c/='.') s
        scale = takeWhile (/='.') $ dropWhile (/='@') s

makeFileName :: (String, String, String) -> String
makeFileName (b,s,e) = (b ++ s ++ e)

generate1x :: (String, String) -> IMG -> IO()
generate1x (b,e) img = do
  putStr $ "  generating " ++ filename ++ "... "
  hFlush stdout
  let newimg = scale (Bilinear Edge) (1.0/3.0, 1.0/3.0) img 
  HIP.writeImage filename newimg
  putStrLn "done."
  where filename = (makeFileName (b,"",e))

generate2x :: (String, String) -> IMG -> IO()
generate2x (b,e) img = do
  putStr $ "  generating " ++ filename ++ "... "
  hFlush stdout
  let newimg = scale (Bilinear Edge) (2.0/3.0, 2.0/3.0) img 
  HIP.writeImage filename newimg
  putStrLn "done."
  where filename = (makeFileName (b,"@2x",e))

generateImages :: (String, String, String) -> IO()
generateImages (b, "@3x", e) = do
  putStrLn $ "convert: " ++ filename
  img <- HIP.readImageRGBA filename
  generate2x (b,e) img
  generate1x (b,e) img
  putStrLn ""
  where filename = makeFileName (b,"@3x",e)
generateImages (b, s, e) = putStrLn $ "ignore: " ++ b ++ s ++ e ++ "\n"
