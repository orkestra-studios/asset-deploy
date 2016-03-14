extern crate image;

use std::fs::File;
use std::path::Path;
use std::env;

use image::GenericImage;
use image::FilterType::CatmullRom;

fn main() {
  let path = &env::args().nth(1).unwrap();
  let img = image::open(&Path::new(path)).unwrap();

  println!("dimensions {:?}", img.dimensions());
	let v: Vec<&str> = path.split(".").collect();
	let w: Vec<&str> = v[0].split("@").collect();
	let basename = w[0];
	let scale    = w[1];
	let (width, height) = img.dimensions();

	println!("file: {} @ {}", basename, scale);
	let path2x = String::from(basename) + "@2x.png";
	let path1x = String::from(basename) +    ".png";

	let img2x = img.clone().resize(width*2/3, height*2/3,CatmullRom);
	let img1x = img.clone().resize(width  /3, height  /3,CatmullRom);

  let ref mut fout2x = File::create(&Path::new(&path2x)).unwrap();
  let ref mut fout1x = File::create(&Path::new(&path1x)).unwrap();

  let _ = img2x.save(fout2x, image::PNG).unwrap();
  let _ = img1x.save(fout1x, image::PNG).unwrap();
}
