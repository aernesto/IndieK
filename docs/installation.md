[back to table of contents](/index.md)
# Installation
The following are instructions to install IndieK v0.1.0 on a Linux machine (currently tested on Fedora 26).
Make sure, **first** that your computer posseses the commands and softwares listed in the section below.

## Prerequisites

IndieK requires the following list of commands to be available from bash shell. 
- `pdflatex` 
- `convert`   
This is a command from the [ImageMagick](https://www.imagemagick.org/script/index.php) package. To install the latter, type the following on Fedora 26:
```
sudo dnf install ImageMagick
```
- `mysql`  
The Free Software version of this command is called [MariaDB](https://fedoraproject.org/wiki/MariaDB).
- `dot`  
This is part of the [graphviz](http://www.graphviz.org/) software.
```
sudo apt-get install graphviz
```
or on Fedora 26  
```
sudo dnf install graphviz
```

- `standalone`   
This is a [LaTeX class](https://www.ctan.org/pkg/standalone?lang=en), **not** a bash command.
```
sudo apt-get install texlive-latex-extra
```
or if you have `tlgmr`  
```
tlmgr install standalone
```
or if you are using Fedora 26:
```
sudo dnf install "tex(standalone.cls)"
```

Optionally, you may want to install a software that allows you to open a `.png` image file from the command line.
On Fedora 26, I personally use [`feh`](https://feh.finalrewind.org/).

## Installing IndieK
If you have all the prerequisites listed in the previous section, you might find it easier to just follow the first videos in this [playlist](https://www.youtube.com/watch?v=XSA4KEFhVLk&list=PLJhmxsk-_V30bt1XSgXav3dLp0qyEegnD).

By now, each time you start a Shell session, all the IndieK commands will be readily accessible.