var visionAPI, request;

request = require('request');


visionAPI = (function() {
  function visionAPI(key) {
    this.key = key;
  }

  visionAPI.prototype.apiURL = 'https://api.projectoxford.ai/vision/v1.0/';

  visionAPI.prototype.api = function(url, option, data, cb) {
    request({
      url: this.apiURL + url,
      method: 'POST',
      qs: option,
      json: data,
      headers: {
        'Ocp-Apim-Subscription-Key': this.key
      }
    }, function(error, res, body) {
      return cb(error, res, body);
    });
  };




  return visionAPI;

})();

module.exports = visionAPI;
