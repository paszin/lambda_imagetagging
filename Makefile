all:
	coffee --compile index.coffee
	node-lambda run --handler index.handler -f ./config/keys_local.env
	
package:
	coffee --compile index.coffee
	node-lambda package -p build -n imagetagger  -e dev -x Makefile -x index.coffee -x package.json -x sample.js -f config/keys_deploy.env

createconfig:
	cat config/keys_deploy.env.sample >> config/keys_deploy.env
	cat config/keys_local.env.sample >> config/keys_local.env

export:
	export $(cat config/keys_local.env | xargs)