#[macro_use]
extern crate clap;
extern crate image;

use std::fs::File;
use std::path::Path;

use image::GenericImage;
use image::FilterType;

// ripgrep's eprintln macro
macro_rules! eprintln {
    ($($tt:tt)*) => {{
        use std::io::Write;
        let _ = writeln!(&mut ::std::io::stderr(), $($tt)*);
    }}
}

fn main() {
    let matches = clap_app!(fovea =>
        (about: "deploys original asset image(3x) in 1x and 2x sizes for iOS apps.")
        (@arg FILES: +required +multiple "files")
    ).get_matches();

    let files = matches.values_of("FILES").unwrap();

    for file in files {
        read_image_file(file).unwrap_or_else(|e| eprintln!("Warning file '{}': {}", file, e));
    }

    println!("done.");
}

fn read_image_file(path_str: &str) -> Result<(), String> {
    let path = Path::new(path_str);
    let err_to_string = |e| format!("{}", e);

    let stem = match path.file_stem() {
        Some(name) => name,
        None => return Err(format!("Can't get file basename from '{}'", path_str)),
    };

    let w: Vec<&str> =
        stem.to_str().ok_or(format!("Can't convert to unicode string"))?.split('@').collect();

    let basename = w[0];

    if w.len() < 2 || w[1] != "3x" {
        return Err(format!("Filename '{}' doesn't match @3x", path_str));
    } else if !path.is_file() {
        return Err(format!("'{}' isn't a file", path_str));
    }

    let dirname = path.parent()
        .ok_or(format!("Can't get parent dir"))?
        .to_str()
        .map(|s| if s == "" { "." } else { s })
        .ok_or(format!("Can't convert to unicode string"))?;

    // get image properties
    let img = image::open(&path).map_err(&err_to_string)?;
    let (width, height) = img.dimensions();

    println!("asset: {}", path_str);

    // create image paths
    let path2x = format!("{}/{}@2x.png", dirname, basename);
    let path1x = format!("{}/{}.png", dirname, basename);

    // create images
    create_image(&path2x, img.clone().resize(width * 2 / 3, height * 2 / 3, FilterType::Nearest))
        .map_err(&err_to_string)?;

    create_image(&path1x, img.clone().resize(width * 1 / 3, height * 1 / 3, FilterType::Nearest))
        .map_err(&err_to_string)?;

    println!("");

    Ok(())
}

fn create_image(path: &str, img: image::DynamicImage) -> Result<(), image::ImageError> {
    let mut fout = File::create(&Path::new(path))?;
    img.clone().save(&mut fout, image::PNG)?;
    println!("created: {}", path);
    Ok(())
}
