# macula
macula is a small command line tool that generates retina assets with different scales(3x,2x,1x) for iOS application development.

### Installation

#### Adding binary to your path (Recommended)

First, open your terminal and make sure the binary is executable:
 
  `$ chmod +x macula`

Then, open(or create) .bash_profile or your preferred shell's configuration file in your home directory and add the following line:
 
  `export PATH="/folder/containing/macula/binary:$PATH"`

That's all! Now you can start using macula after restarting your terminal session.

#### Copying binary to /bin directory (Alternative)

if you have root access you can copy the executable or make a symbolic link to your `bin` folder:
 
  `# cp /path/to/macula /usr/bin/.` or `# ln -s /path/to/macula /usr/bin/macula`

## Usage  

Just provide the path of your source asset as an argument:

  `$ macula /path/to/my/asset@3x.png`
  
macula will create `xxx@2x.png` and `xxx.png` in the same directory as the original file. One important thing: your original asset must have @3x suffix, or it will be ignored. macula also accepts multiple files e.g:

  `$ macula /path/to/my/asset1.png /path/to/my/asset2.png ...`

or even better:

  `$ macula '/my/assets/folder/*`

will generate scaled versions for all the 3x images in the folder. leaving other files untouched.
