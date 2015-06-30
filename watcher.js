var watch = require('node-watch')
var unirest = require('unirest')
var Papa = require('papaparse')
var fs = require('fs')

var watchedFolders = ['mxoptix','wp_db']
filter = function(pattern, fn){
	return function(filename){
		if(pattern.test(filename)){
			fn(filename)
		}
	}
}
var callService= function callService (query, connection) {
	return unirest.post('http://cymautocert/osaapp/query/query.php')
	.send(JSON.stringify({
		"query":query,
		"user":"macampos",
		"database":connection
	}))
}

watch(watchedFolders,filter(/\.sql$/, function(filename){
	watchedFolders.map(function(folderName){
		if(filename.slice(0,filename.indexOf('\\')) === folderName){
			connection = folderName
		}
	})
	 if(!connection){ return 'not from a watched folder: ' + filename}
	console.log(connection)
	fs.readFile(filename,'utf8',function readFileHandler (err, query) {
		if(err){throw err}
		ans = callService(query,connection)
		ans.end(function(response){
			outputFileName = filename.replace(/sql$/i,'csv')
			console.log(outputFileName)
			fs.writeFile(outputFileName, Papa.unparse(response.body,{quotes:true}), function (err) {
				if(err){throw err}
			})
		})
	})
}))