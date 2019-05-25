{-# LANGUAGE OverloadedStrings #-}
import System.Environment
import System.IO
import Control.Concurrent

import Graphics.Image.Types
import Graphics.Image.Processing

import qualified Graphics.Image as HIP

type Extension = String
type IMG = (Image VS RGBA Double) 
type OUT = (Image VS RGBA Word8) 

data File = File { 
  getName    :: String, 
  getScale   :: Maybe String,
  getExt     :: String, 
  getContent :: IMG
}

toFile :: String -> IO File
toFile = undefined

path :: File -> String
path f = undefined

main :: IO ()
main = do
  putStrLn "macula v0.6.1"
  args <- getArgs
  if null args 
    then
      putStrLn "nothing to do."
    else
      mapM_ (generateImages . getFileProps) args

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

resizeTo :: (String, String) -> IMG -> Double -> IO ()
resizeTo (b,e) img d = do
    putStr $ "  generating " ++ filename ++ "... "
    hFlush stdout
    let newimg = scale Bilinear Edge (d/1024.0, d/1024.0) img
    HIP.writeImageExact PNG [] filename (newimg)
    putStrLn "done."
  where filename = b ++ "-" ++ (show . round) d ++ "px." ++ e 

generateImages :: (String, String, String) -> IO()
generateImages (b, "@3x", e) = do
    putStrLn $ "convert: " ++ filename
    img <- HIP.readImageExact' PNG filename :: IO IMG
    generate2x (b,e) img
    generate1x (b,e) img
    putStrLn ""
  where filename = makeFileName (b,"@3x",e)
generateImages (b, "@base", e) = do
    putStrLn $ "generating " ++ filename ++ ".Appicon"
    img <- HIP.readImageExact' PNG filename :: IO IMG
    mapM_ (resizeTo (b,e) img) [29,40,57,58,60,80,120,114,180]
  where filename = makeFileName (b,"@base",e)
generateImages (b, s, e) = putStrLn $ "ignore: " ++ b ++ s ++ e ++ "\n"
