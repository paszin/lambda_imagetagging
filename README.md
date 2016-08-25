# lambda_imagetagging

Microservice to tag images based on microsoft cognitive services api.

## What"s going on?
1. GET Request  to `$ENDPOINT` to receive a list of urls pointing to photos. 

2. Use Microsoft Image Tagging to analyze photos.

3. POST Request per photo to `$ENDPOINT` with tags, categories and colors.


## Initial setup

`make createconfig` 

`npm install -g node-lambda`

`npm install -g lambda-local`

`npm install`

## Run

`make` run locally

`make package` generates zip file to upload



