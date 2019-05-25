{-# LANGUAGE OverloadedStrings #-}
import System.Environment
import System.IO
import Control.Concurrent

import Graphics.Image.Types
import Graphics.Image.Processing

import qualified Graphics.Image as HIP

type IMG = (Image VS RGBA Double) 
type OUT = (Image VS RGBA Word8) 

main :: IO ()
main = do
  putStrLn "macula v0.5.4"
  args <- getArgs
  mapM_ (generateImages . getFileProps) args
  putStrLn "done."

getFileProps :: String -> (String, String, String)
getFileProps s = (base, scale, ext)
  where ext = dropWhile (/='.') s
        base = takeWhile (\c -> c/='@' && c/='.') s
        scale = takeWhile (/='.') $ dropWhile (/='@') s

makeFileName :: (String, String, String) -> String
makeFileName (b,s,e) = b ++ s ++ e

generate1x :: (String, String) -> IMG -> IO()
generate1x (b,e) img = do
  putStr $ "  generating " ++ filename ++ "... "
  hFlush stdout
  let newimg = scale Bilinear Edge (0.334, 0.334) img
  HIP.writeImageExact PNG [] filename (toWord8I newimg :: OUT)
  putStrLn "done."
  where filename = makeFileName (b,"",e)

generate2x :: (String, String) -> IMG -> IO()
generate2x (b,e) img = do
  putStr $ "  generating " ++ filename ++ "... "
  hFlush stdout
  let newimg = scale Bilinear Edge (0.667, 0.667) img 
  HIP.writeImageExact PNG [] filename (toWord8I newimg :: OUT)
  putStrLn "done."
  where filename = makeFileName (b,"@2x",e)

generateImages :: (String, String, String) -> IO()
generateImages (b, "@3x", e) = do
  putStrLn $ "convert: " ++ filename
  img <- HIP.readImageExact' PNG filename :: IO IMG
  generate2x (b,e) img
  generate1x (b,e) img
  putStrLn ""
  where filename = makeFileName (b,"@3x",e)
generateImages (b, s, e) = putStrLn $ "ignore: " ++ b ++ s ++ e ++ "\n"
