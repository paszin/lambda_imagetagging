#

async = require "async"
request = require "request"
msVisionApi = require "./ms-vision-api"
msVision = new msVisionApi process.env.MICROSOFT_VISION_KEY

endpoint = process.env.ENDPOINT #|| "http://localhost:9000/api/newphotos"

console.log "started analyzing photos"

makeRequest = (url, callback) -> 
	console.log "start analyze request with ", url
	tags = []
	msVision.api 'analyze',{visualFeatures:'Categories,Tags,Faces,Color'}, {"url": url}, (err, res, data) -> 
		if err
			console.log "ERROR", err
		else
			console.log "request was successful"
			tags.push {name: tag.name, prob: tag.confidence} for tag in data.tags
			color = {}
			color.foreground = color.dominantColorForeground
			color.background = color.dominantColorBackground
			color.dominants = color.dominantColors
			color.accent = color.accentColor
			color.isblackwhite = color.isBWImg

			postTags url, tags, color, data.categories, callback
					
				
postTags = (filepath_1280, tags, color, categories, callback) ->
	console.log "send data back to server"
	request {method: "POST", uri: endpoint, qs: {filepath_1280: filepath_1280}, body: {tags: tags, color: color, categories: categories}, json: true}, (err, res, data) ->
		console.log "call callback"
		callback err, data


findUrls = (callback) ->
	console.log "make request to", endpoint
	request.get endpoint, {json: true}, (err, res, data) ->
		console.log "request responsed"
		if err
			console.log "ERROR in request"
			return callback err, data
		else
			console.log "DATA", data
			console.log "length", data.length
		if data.length == 0
			console.log "call callback"
			callback null, 0
		else
			console.log "found unttaged photos", data.length
			async.each(data, makeRequest, callback)


exports.handler = (event, context, callback) ->
	console.log "Enpoint: ", endpoint
	console.log "API Key:", msVision.key
	findUrls callback
	