var gulp = require('gulp');
var gutil = require('gulp-util');
var wait = require('gulp-wait');
var get = require('simple-get');
var rename = require('gulp-rename');
var savefile = require('gulp-savefile');
var fs = require('fs');
var concat = require('concat-stream');

var BASE = __dirname;

function serverPath (path) {
  // Obtiene la direccion a la que se enviaran los datos
  var rgx = /[a-zA-Z-_~\. ]*$/;
  path = path.replace(rgx, '');
  return path.replace(BASE,'');
}


copy = function copyAndReload (event) {
  path = event.path.replace(BASE + '\\mxoptix\\','');
  console.log('Processed file: ', path);

  fs.readFile(event.path, 'utf8' , function read (err, content) {
    
    body = JSON.stringify({
      query:content,
      user:'macampos',
      database:'mxoptix'
    });

    var opts = {
      url : 'http://cymautocert/osaapp/query/query.php',
      method: 'POST',
      body: body,
      headers:{
        'user-agent':'my-cool-app'
      }
    }



    fs.writeFile('ask.html',JSON.stringify(opts))
    get.post(opts, function (err, res){
      if (err) throw err
      string = '';

      res.on('data', function(buffer){
        // console.log('readable: ' + buffer);
        // var part = buffer;
        string += buffer;
        // console.log('Streamed: \n\n' + part);
      });

      res.on('end', function () {
        console.log('final output: \n\n' + string)
        fs.writeFile('ans.html',string)
      })

      // console.log(res.headers)
      // res.pipe(concat(function(data){
      //   console.log(data);  
      // }));  
    })

    // gulp.src(event.path)
    //      // .pipe(gulp.dest(event.path + ".csv"))
    //      .pipe(wait(1200))
  });
}


gulp.task('watch', function () {
  gulp.watch(['mxoptix/**'], function (event) {
  }).on('change', function (event) {
     copy(event);
  });
});

gulp.task('default', ['watch']);
