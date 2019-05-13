{-# LANGUAGE OverloadedStrings #-}
import System.Environment
import System.IO

import Control.Concurrency

import Graphics.Image.Types
import Graphics.Image.Processing

import qualified Graphics.Image as HIP

type Extension = String
type IMG = (Image VU RGBA Double) 
data File = File { 
  name    :: String, 
  scale   :: Maybe String,
  ext     :: String, 
  content :: IMG
}

toFile :: String -> IO File
toFile = undefined

path :: File -> String
path = undefined

main :: IO ()
main = do
  args <- getArgs
  if null args then
    putStrLn "nothing to do."
  else
    mapM_ (generateImages . getFileProps) args

generate1x :: (String, String) -> IMG -> IO()
generate1x (b,e) img = do
  putStr $ "  generating " ++ filename ++ "... "
  hFlush stdout
  let newimg = scale Bilinear Edge (1.0/3.0, 1.0/3.0) img 
  HIP.writeImage filename newimg
  putStrLn "done."
  where filename = makeFileName (b,"",e)

generate2x :: (String, String) -> IMG -> IO()
generate2x (b,e) img = do
  putStr $ "  generating " ++ filename ++ "... "
  hFlush stdout
  let newimg = scale Bilinear Edge (2.0/3.0, 2.0/3.0) img 
  HIP.writeImage filename newimg
  putStrLn "done."
  where filename = makeFileName (b,"@2x",e)

resizeTo :: (Base, Extension) -> Int -> IMG -> IMG
resizeTo (b,e) d = do
  putStr $ "  generating " ++ filename ++ "... "
  hFlush stdout
  HIP.writeImage filename (scale Bilinear Edge (d/1024.0, d/1024.0))
  putStrLn "done."
  where filename = b++"-"++d++"px."++e 

generateImages :: (String, String, String) -> IO()
generateImages (b, "@3x", e) = do
  putStrLn $ "convert: " ++ filename
  img <- HIP.readImageRGBA VU filename
  forkIO $ generate2x (b,e) img
  forkIO $ generate1x (b,e) img
  putStrLn ""
  where filename = makeFileName (b,"@3x",e)
generateImages (b, "@base", e) = do
  putStrLn $ "generating " ++ filename ++ ".Appicon"
  img <- HIP.readImageRGBA VU filename
  mapM_ (\d -> forkIO $ resizeTo (b,e) d img) [29,40,57,58,60,80,120,114,180]
  where filename = makeFileName (b,"@base",e)
generateImages (b, s, e) = putStrLn $ "ignore: " ++ b ++ s ++ e ++ "\n"
