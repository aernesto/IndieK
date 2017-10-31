[back to table of contents](/index.md)
# Installation
The following are instructions to install IndieK v0.1.0 on a Linux machine (currently tested on Fedora 26).
As of now, the installation of IndieK is tedious. We are working hard on improving this aspect. Bare with us please!

Since IndieK relies on many other existing free software packages, the hard part of the installation currently lies in resolving all the dependencies by hand. So, **before** installing IndieK, make sure that your computer posseses all the commands and packages listed in the section below.

If you have any suggestions to improve IndieK's installation process, please write a post on the [Mailing List](https://groups.google.com/forum/#!forum/indiek).

## Prerequisites

IndieK requires the following list of commands to be available from bash shell. 
- `pdflatex` 
- `convert`   
This is a command from the [ImageMagick](https://www.imagemagick.org/script/index.php) package. To install the latter, type the following on Fedora 26:
```
sudo dnf install ImageMagick
```
- `mysql`  
The free software version of this command is called [MariaDB](https://fedoraproject.org/wiki/MariaDB).
A good step-by-step guide to install and configure MariaDB on Fedora 26 is [this
link](https://fedoraproject.org/wiki/MariaDB).
- `dot`  
This is part of the [graphviz](http://www.graphviz.org/) package.
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

Optionally, you may want to install an application that allows you to open a `.png` image file from the command line.
On Fedora 26, I personally use [`feh`](https://feh.finalrewind.org/).

## Installing IndieK
If you have all the prerequisites listed in the previous section, you might find it easier to just follow the first videos in this [playlist](https://www.youtube.com/watch?v=XSA4KEFhVLk&list=PLJhmxsk-_V30bt1XSgXav3dLp0qyEegnD).

Otherwise, you may follow the following steps:  
1. Clone the GitHub repository of IndieK onto your local machine. Below is an
   example of what you should type on your terminal to install IndieK on your
   HOME directory:  
   ```  
   cd ~  
   git clone https://github.com/aernesto/IndieK/  
   ```  
   If you are a developper and plan on contributing to IndieK, fork my repo first, and clone your
   forked copy.  
   **In what follows, I denote by** /PATH/TO/IndieK/ **the path on your local
   machine in which you cloned the GitHub repo.**
2. Create the hidden base directory .indiek, together with its tmp/
   subdirectory, in your HOME directory. To do this automatically, you may use
   the create_indiek_tree.sh script as follows:  
   ```  
   cd /PATH/TO/IndieK/shell_scripts/scripts/  
   ./create_indiek_tree.sh
   ``` 
3. Create the MySQL database and tables required by IndieK:  
   ```  
   mysql --user=root -p
   CREATE DATABASE indiekdb;
   USE indiekdb;
   source /PATH/TO/IndieK/SQL_scripts/SQL_TABLES_CREATION.txt;
   GRANT ALL PRIVILEGES ON indiekdb.* to 'YOUR_MySQL_USERNAME'@'localhost' WITH GRANT OPTION;
   quit
   ```  
4. Add the newly created MySQL database to the config folder of IndieK. For
   this, just run the add_indiekdb.sh from IndieK's installation folder:  
   ```
   cd /PATH/TO/IndieK/shell_scripts/scripts
   ./add_indiekdb.sh  
   ```  
5. Configure your .my.cnf file in your HOME directory. Create it if it doesn't
   exist already. The necessary file content should be:  
   ```
   [client]
   user=YOUR_MySQL_USERNAME
   password=YOUR_MySQL_PASSWORD
   database=indiekdb
   no-auto-rehash
   ```  
   The file may contain more MySQL options if you wish.  
   **IMPORTANT:** Since the file contains your MySQL password, you should set
   the permissions so that only you, the owner, may read it:  
   ```  
   chmod 600 ~/.my.cnf
   ```  
7. Set your MySQL server to launch automatically on boot (if you haven't set
   this option yet). Type the following from the terminal, as root:  
   ```  
   systemctl enable mariadb
   ```
8. Modify your .bashrc file in your HOME directory, in order to automatically
   load IndieK's functions every time you open a Shell session. The content
   that you should add to your .bashrc file is contained in the
   indiek_bashrc.txt file from IndieK's installation folder. I copy the
   content here for convenience (this is only true for v0.1.0):
   ```  
   # indiek
indiek_PATH="/PATH/TO/IndieK/shell_scripts/functions"
if [ -d "$indiek_PATH/" ]; then
    # CONSTANTS
    current_db_name=$( grep database ~/.my.cnf | sed 's/database=\(.*\)/\1/g' )
    indiek_base_folder="${HOME}/.indiek/$current_db_name"
    indiek_tmp="${HOME}/.indiek/tmp"
    indiek_images="$indiek_base_folder/images"

    # This uses EDITOR as editor, or vi if EDITOR is null or unset
    EDITOR=${EDITOR:-vimx}
    # auxiliary functions
    source $indiek_PATH/die.sh
    source $indiek_PATH/get_supratopics.sh
    source $indiek_PATH/get_subtopics.sh
    source $indiek_PATH/istopic.sh
    source $indiek_PATH/setindiekdb.sh

    # main commands functions
    source $indiek_PATH/t.sh
    source $indiek_PATH/topic.sh
    source $indiek_PATH/i.sh
    source $indiek_PATH/topic.sh
    source $indiek_PATH/newtopic.sh
    source $indiek_PATH/nt.sh
    source $indiek_PATH/ntx.sh
    source $indiek_PATH/showtopic.sh
    source $indiek_PATH/sub.sh
    source $indiek_PATH/subtopic.sh
    source $indiek_PATH/compile.sh
    source $indiek_PATH/gr.sh
    source $indiek_PATH/grt.sh
    source $indiek_PATH/searchitem.sh
    source $indiek_PATH/intopic.sh
    source $indiek_PATH/notintopic.sh
    source $indiek_PATH/searchtopic.sh
    source $indiek_PATH/edititem.sh
    source $indiek_PATH/deleteitem.sh
    source $indiek_PATH/showitem.sh
fi
   ```  
   Note that /PATH/TO/IndieK/ above should be replaced by the actual path to
   your installation folder for IndieK.  
8. After you have saved your .bashrc file, restart your terminal and launch MariaDB server, if it is not running already. 

By now, each time you start a Shell session, all the IndieK commands will be readily accessible! Congratulations!

You may post any question about this (tedious) installation process on the
[Google group](https://groups.google.com/forum/#!forum/indiek), and any bug or issue may be
reported on [GitHub](https://github.com/aernesto/IndieK/issues).
