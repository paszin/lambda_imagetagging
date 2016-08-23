#

async = require "async"
request = require "request"
msVisionApi = require "./ms-vision-api"
msVision = new msVisionApi process.env.MICROSOFT_VISION_KEY

endpoint = process.env.ENDPOINT #|| "http://localhost:9000/api/newphotos"

console.log "started analyzing photos"

makeRequest = (url, callback) -> 
	#console.log "got url", url
	tags = []
	msVision.api 'analyze',{visualFeatures:'Categories,Tags,Faces,Color'}, {"url": url}, (err, res, data) -> 
				if err
					console.log "ERROR", err
				else
					tags.push {name: tag.name, prob: tag.confidence} for tag in data.tags
					postTags url, tags, callback
					
				
postTags = (filepath_1280, tags, callback) -> 
	request {method: "POST", uri: endpoint, qs: {filepath_1280: filepath_1280}, body: {tags: tags}, json: true}, (err, res, data) -> callback err, data

findUrls = (context) ->
	console.log "make request to", endpoint
	request.get endpoint, {json: true}, (err, res, data) ->
		console.log "request responsed"
		if err
			console.log "ERROR in request"
			return context.done err, data
		else
			console.log "DATA", data
			console.log "length", data.length
		if data.length == 0
			console.log "call context.done"
			context.done null, 0
		else
			console.log "found unttaged photos", data.length
			paths = (d.filepath_1280 for d in data)
			async.each(paths, makeRequest, (err) -> context.done err, paths.length)


exports.handler = (event, context) ->
	console.log "Enpoint: ", endpoint
	console.log "API Key:", msVision.key
	findUrls context
	