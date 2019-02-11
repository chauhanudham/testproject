var express = require('express');
var app = express();
var version=process.env.version
var lastcommitsha=process.env.lastcommitsha
if(version==null)
	{
		version="not set"
	}
if(lastcommitsha==null)
	{
		lastcommitsha="not set"
	}
let results = {"myapplication": [{ "version":version, "description":"pre-interview technical test", "lastcommitsha":lastcommitsha }]};


app.get('/info', function(req, res){
	res.status("200").send(results);	
});
app.get('/healthcheck', function(req, res){
	res.status("200").send("Healthy");
});

var port = process.env.PORT || 8080;
app.listen(port);

module.exports = app;
