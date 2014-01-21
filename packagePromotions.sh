#!/bin/bash
TYPE=$1
HOST=$2
USER=$3
PUSH_TO_DIR=$4

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 4 ] || die "The following arguments required <TYPE> <HOST> <USER> <PUSH_TO_DIR>, $# provided;  Example: packagePromotions.sh css myhost.com myUser /path/to/push/bundleFiles"

read -s -p "Password: " mypassword

if [[ ! -d ./tmp ]]
 then mkdir tmp
fi

CSS_RESULT_FILE=
JS_RESULT_HEAD_FILE=
JS_RESULT_FOOTER_FILE=

# Run mvn merge/min process on CSS files
packageCSS () {
	# Copy down CSS files
	while read -r line || [[ -n $line ]]
	do 
		./updatePromotions.sh pull $HOST $USER $mypassword $line
	done < cssFiles.txt
	# Merge and minify

}
# Run mvn merge/min process on JS files
packageJS () {
	# Copy down JS Head files
	while read -r line || [[ -n $line ]]
	do 
		./updatePromotions.sh pull $HOST $USER $mypassword $line
	done < jsHeadFiles.txt
	# Merge and minify the head files

	# Copy down JS Footer files
	while read -r line || [[ -n $line ]]
	do 
		./updatePromotions.sh pull $HOST $USER $mypassword $line
	done < jsFooterFiles.txt
	# Merge and minify the footer files

}
# Push merged/min CSS files to remote server
pushCSS () {
	#./updatePromotions.sh push $HOST $USER $mypassword $CSS_RESULT_FILE $PUSH_TO_DIR
	echo foo;
}

# Push merged/min JS files to remote server
pushJS () {
	#./updatePromotions.sh push $HOST $USER $mypassword $JS_RESULT_HEAD_FILE $PUSH_TO_DIR
	#./updatePromotions.sh push $HOST $USER $mypassword $JS_RESULT_FOOTER_FILE $PUSH_TO_DIR
	echo foo;
}

case $TYPE in
    'all' )
        packageCSS 
  		packageJS
  		pushCSS
  		pushJS
        ;;
    'css' )
        packageCSS
        pushCSS
        ;;
    'js' )
        packageJS
        pushJS
        ;;
esac
