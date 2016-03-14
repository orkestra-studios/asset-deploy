# fovea
fovea is a command line tool for creating assets in different sizes for iOS applications. It generates @1x and @2x versions of the raw asset, also renaming it to @3x version, making it ready for deployment.

### Installation

#### Adding binary to your path

First, open your terminal and make sure the binary is executable:
  `$ chmod +x fovea`
Then, pen .bashrc, .bash_profile or your preferred shell's configuration file in your home directory and add the following line:
  `export PATH="/path/to/fovea:$PATH"`
That's all! Now you can start using fovea.

#### Copying binary to /bin directory

Aternatively, if you have root access you can copy the executable or make a symbolic link to your `bin` folder:
  `# cp /path/to/fovea /usr/bin/.` or `# ln -s /path/to/fovea /usr/bin/fovea`

## Usage  

Just provide the path of your `xxx@3x.png` img as an argument:
  `$ fovea /path/to/my/asset@3x.png`
fovea will create `xxx@2x.png` and `xxx.png` in the same directory as the original file.

