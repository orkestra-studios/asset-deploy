# fovea
fovea is a small command line tool that generates assets in required sizes(3x,2x,1x) for iOS application development.

### Installation

#### Adding binary to your path (Recommended)

First, open your terminal and make sure the binary is executable:
 
  `$ chmod +x fovea`

Then, open(or create) .bash_profile or your preferred shell's configuration file in your home directory and add the following line:
 
  `export PATH="/folder/containing/fovea/binary:$PATH"`

That's all! Now you can start using fovea after restarting your terminal session.

#### Copying binary to /bin directory (Alternative)

if you have root access you can copy the executable or make a symbolic link to your `bin` folder:
 
  `# cp /path/to/fovea /usr/bin/.` or `# ln -s /path/to/fovea /usr/bin/fovea`

## Usage  

Just provide the path of your source asset as an argument:

  `$ fovea /path/to/my/asset@3x.png`
  
fovea will create `xxx@2x.png` and `xxx.png` in the same directory as the original file. One important thing: your original asset must have @3x suffix, or it will be ignored. Fovea also accepts multiple files e.g:

  `$ fovea /path/to/my/asset1.png /path/to/my/asset2.png ...`

or even better:

  `$ fovea '/my/assets/folder/*`

will generate scaled versions for all the 3x images in the folder. leaving the rest of the files untouched.
