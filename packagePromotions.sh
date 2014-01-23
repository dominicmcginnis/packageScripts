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

if [[ ! -d ./src ]]
 then mkdir src
else
	rm -rf src
	mkdir src
fi

if [[ ! -d ./target ]]
 then mkdir target
else
	rm -rf target
	mkdir target
fi

CSS_RESULT_FILE="./target/home-promo-bundle.min.css"
JS_RESULT_HEAD_FILE="./target/home-promo-head-bundle.min.js"
JS_RESULT_FOOTER_FILE="./target/home-promo-footer-bundle.min.js"
JAVA_COMMAND=/usr/bin/java
YUI_LIB="./lib/yuicompressor-2.4.8.jar"
CLOSURE_LIB="./lib/compiler-closure.jar"

# Run mvn merge/min process on CSS files
packageCSS () {
	# Copy down CSS files
	while read -r line || [[ -n $line ]]
	do 
		#get file
		doUpdatePromotions pull $HOST $USER $mypassword $line
		#get Filename
		filename=`basename $line .css`
		# minify the files
		$JAVA_COMMAND -jar $YUI_LIB ./tmp/$filename.css -o ./target/$filename.min.css --charset utf-8
		# merge to output file
		cat ./target/$filename.min.css >> $CSS_RESULT_FILE
		echo '\n' >> $CSS_RESULT_FILE
	done < cssFiles.txt
}
# Run mvn merge/min process on JS files
packageJS () {
	# Copy down JS Head files
	while read -r line || [[ -n $line ]]
	do 
		#get file
		doUpdatePromotions pull $HOST $USER $mypassword $line
		#get Filename
		filename=`basename $line .js`
		# minify the files
		$JAVA_COMMAND -jar $CLOSURE_LIB --js ./tmp/$filename.js --js_output_file ./target/$filename.min.js
		# merge to output file
		cat ./target/$filename.min.js >> $JS_RESULT_HEAD_FILE
		echo '\n' >> $JS_RESULT_HEAD_FILE
	done < jsHeadFiles.txt

	# Copy down JS Footer files
	while read -r line || [[ -n $line ]]
	do 
		#get file
		doUpdatePromotions pull $HOST $USER $mypassword $line
		#get Filename
		filename=`basename $line .js`
		# minify the files
		$JAVA_COMMAND -jar $CLOSURE_LIB --js ./tmp/$filename.js --js_output_file ./target/$filename.min.js
		# merge to output file
		cat ./target/$filename.min.js >> $JS_RESULT_FOOTER_FILE
		echo '\n' >> $JS_RESULT_FOOTER_FILE
	done < jsFooterFiles.txt
}
# Push merged/min CSS files to remote server
pushCSS () {
	doUpdatePromotions push $HOST $USER $mypassword $CSS_RESULT_FILE $PUSH_TO_DIR
}
# Push merged/min JS files to remote server
pushJS () {
	doUpdatePromotions push $HOST $USER $mypassword $JS_RESULT_HEAD_FILE $PUSH_TO_DIR
	doUpdatePromotions push $HOST $USER $mypassword $JS_RESULT_FOOTER_FILE $PUSH_TO_DIR
}
#Execute updatePromotions caputring error and exiting so as to avoid account lockout...
doUpdatePromotions() {
		eval ./updatePromotions.sh $1 $2 $3 $4 $5 $6
		ret_code=$?
		if [ $ret_code -eq 1 ]
			then 
			exit 1
		fi
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
