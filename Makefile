all:
	export $(cat config/keys_local.env | xargs)
	coffee --compile index.coffee
	lambda-local -f index.js -e sample.js
	
package:
	node-lambda package -p build -n imagetagger  -e dev -x Makefile -x index.coffee -x package.json -x sample.js -f config/keys_deploy.env