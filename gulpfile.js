var gulp = require('gulp');
var gutil = require('gulp-util');
var wait = require('gulp-wait');
var get = require('simple-get');

var BASE = __dirname;

function serverPath (path) {
  // Obtiene la direccion a la que se enviaran los datos
  var rgx = /[a-zA-Z-_~\. ]*$/;
  path = path.replace(rgx, '');
  return path.replace(BASE,'');
}

body = JSON.stringify({
  query:'select sysdate from dual',
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

copy = function copyAndReload (event) {
  console.log('Sended to: ', event.path);

  get.post(opts, function (err, res){
    if (err) throw err

    res.pipe(process.stdout);  
  })

  // gulp.src(event.path)
  //      // .pipe(gulp.dest(event.path + ".csv"))
  //      .pipe(wait(1200))
}


gulp.task('watch', function () {
  gulp.watch(['mxoptix/**'], function (event) {
  }).on('change', function (event) {
     copy(event);
  });
});

gulp.task('default', ['watch']);
