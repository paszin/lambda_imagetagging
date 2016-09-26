all:
	coffee --compile index.coffee
	node-lambda run --handler index.handler -f ./config/keys_local.env
	
package:
	coffee --compile index.coffee
	node-lambda package -p build -n imagetagger  -e dev -x Makefile -x index.coffee -x package.json -x sample.js -f config/keys_deploy.env

createconfig:
	cat config/keys_deploy.env.sample > config/keys_deploy.env
	cat config/keys_local.env.sample > config/keys_local.env

export:
	export $(cat config/keys_local.env | xargs)

deploy:
	export $(cat config/keys_local.env | xargs)
	node-lambda deploy --accessKey AKI --secretKey OLm --environment dev --region us-west-2 --role arn:aws:iam::196010511819:role/service-role/lambda_s3 --functionName imagetagger --timeout 15 -x Makefile  -x package.json -x sample.js -f config/keys_deploy.env
