This is a set of scripts that can be used to pull JS and CSS files from a remote server then utilize maven to minify and bundle them accordingly.  For JS files it has the option to build 2 bundles - the head and footer bundles.

The stack used is:
bash scripting
maven
expect scripting - for SCP automation

NOTE:  You must supply a the TEXT files containing the list of JS/CSS files that you want to work on:
cssFiles.txt - List all of the CSS files to be minified and bundled into a single bundle
jsHeadFiles.txt - List all of the Head related JS files to be minified and bundled into a single bundle
jsFooterFiles.txt - List all of the Footer related JS files to be minified and bundled into a single bundle
