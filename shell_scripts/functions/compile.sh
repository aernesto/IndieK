compile ()
{
	# syntax: compile <item number>
  # TO IMPROVE: use mktemp instead of creating the temp file manually in tmp...
  #             Also, set file permissions as follows:
  #             *.log rw-r-----
  #             *.tex 
	if [ $# -ne 1 ]; then
		echo "error: needs exactly one argument, and it must be an existing item ID" >&2
  		return 1;
  	else
  		# check that item ID exists and is of Latex type
		local tmp0=$( mysql --defaults-file=~/.my.cnf -Ne "SELECT Latex FROM Items WHERE ItemID = ${1};" )
		if [[ -z $tmp0 ]]; then
		  	echo "error: No such item exist" >&2
		  	return 1;
		elif [ $tmp0 -ne 1 ]; then
			echo "error: item not of type Latex" >&2
			return 1;
		else
			# define string constants
			local filename=latex_item_${1}
			local imgname=img_item_${1}
			local path2tmp=$indiek_tmp/
			local path2img=$indiek_images/latex/

			# create .tex file to compile
			
			echo "\\def\\CONVERTCOMMAND{\\convertexe\\space -density \\density\\space \\infile\\space \\ifx\\size\\empty\\else -resize \\size\\fi\\space -quality 90 -alpha off \\outfile}" > $path2tmp$filename.tex
            echo "\\documentclass[" >> $path2tmp$filename.tex
            echo "    border=1pt," >> $path2tmp$filename.tex
            echo "    varwidth," >> $path2tmp$filename.tex
            echo "    convert={" >> $path2tmp$filename.tex
            echo "        true," >> $path2tmp$filename.tex
            echo "        %false," >> $path2tmp$filename.tex
            echo "        density = 160," >> $path2tmp$filename.tex
            echo "        convertexe = {convert}," >> $path2tmp$filename.tex
            echo "        command = {\\noexpand\\CONVERTCOMMAND}," >> $path2tmp$filename.tex
            echo "        }" >> $path2tmp$filename.tex
            echo "]" >> $path2tmp$filename.tex
            echo "{standalone}" >> $path2tmp$filename.tex
			#echo "\\documentclass[convert={density=160},varwidth,border=1pt]{standalone}" > $path2tmp$filename.tex
			echo "\\usepackage{amsmath, amssymb}" >> $path2tmp$filename.tex
			echo "\\begin{document}" >> $path2tmp$filename.tex
			mysql --defaults-file=~/.my.cnf -Nre "SELECT Content FROM Items WHERE ItemID = ${1};" >> $path2tmp$filename.tex
			echo "\\end{document}" >> $path2tmp$filename.tex

			# compile Latex file
			mvfwd () {
				cd $path2tmp
			}
			mvbck () {
				cd -
			}
			mvfwd
			pdflatex -shell-escape -halt-on-error $filename.tex
			mvbck

			# move png file and set proper permission rights
			mv -v $path2tmp$filename.png $path2img$imgname.png
      chmod 664 $path2img$imgname.png
			# clear tmp folder if operation successful, except for .tex and .log...
      if [ $? -eq 0 ]; then
	command rm $path2tmp*.aux
	command rm $path2tmp*.pdf
      fi
		fi
	fi
}
