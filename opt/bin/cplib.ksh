#!/usr/bin/ksh -e
# Copy the X32 members to the Xany archive
# script to combine archive members from X32/opt/lib and X64/opt/lib to Xany/opt/lib
# does not do/work with sub-directories if X??/opt/lib (yet)

lib=$(basename $1)
prefix=$2
lib32=X32${prefix}/lib/${lib}
lib64=X64${prefix}/lib/${lib}
libXany=Xany${prefix}/lib/${lib}

	print ${lib64} starting
        [[ -L ${lib64} ]] && print skipping symbolic link $i && exit 0

	rm -f ${libXany}
	cp -p ${lib64} ${libXany}

	mkdir -p .tmp.$$
	cd .tmp.$$
	ar -X32 x ../${lib32}
	ar -X32 t ../${lib32} | xargs ar -X32 r ../${libXany}

	cd ..
	rm -rf .tmp.$$

	print archive: ${libXany} contents
	ar -Xany -tv ${libXany} | sort -k 8
	print ${libXany} finished
