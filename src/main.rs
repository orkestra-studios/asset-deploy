extern crate image;

use std::fs::File;
use std::path::Path;
use std::env;

use image::GenericImage;
use image::FilterType::CatmullRom;

fn main() {
	let path = match env::args().nth(1) {
	  None => {
			println!("Error: invalid path!");
			return;
		},
		Some(val) => val,
	};

  let img = match image::open(&Path::new(&path)) {
	  Result::Err(_) => {
			println!("Error: not an image file!");
			return;
		},
		Result::Ok(val) => val, 
	};

  //get image properties
	let (width, height) = img.dimensions();
	let v: Vec<&str> = path.split(".").collect();
	let w: Vec<&str> = v[0].split("@").collect();
	let basename = w[0];
	if w.len()<2 {
		  //create @3x image if not exists
			println!("Warning: cannot infer scale, assuming @3x.");
		  let path3x = String::from(basename) + "@3x.png";
			create_image(path3x, img.clone());
	}

  //create image paths
	let path2x = String::from(basename) + "@2x.png";
	let path1x = String::from(basename) +    ".png";

  //create images
	create_image(path2x, img.clone().resize(width*2/3, height*2/3,CatmullRom));
	create_image(path1x, img.clone().resize(width*1/3, height*1/3,CatmullRom));
	println!("done.");
}

fn create_image(path: String, img: image::DynamicImage) {
  let ref mut fout = File::create(&Path::new(&path)).unwrap();
  let _ = img.clone().save(fout, image::PNG).unwrap();
	println!("created: {}", path);
}	
