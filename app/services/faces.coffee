# Track or mark faces with OpenCV
coffee = require 'coffee-script'
face = require __dirname+"/../lib/Api/Facedetection"
mkdirp = require "mkdirp"
fs = require "fs"
path = require "path"
_s = require "underscore"
async = require "async"
q = {}


module.exports = (inputPath,outputPath,trackMode) ->

  process.on 'uncaughtException', (exception) ->
    console.log(exception)

  trackFn = (task, callback) ->

    console.log('Testing: '+task.filename)

    face.hasFace inputPath+"/"+task.filename, (state) ->

      if(state)
        fs.createReadStream(inputPath+"/"+task.filename).pipe(fs.createWriteStream(outputPath+"/marked_"+task.filename));

      callback();


  markFn = (task, callback) ->

    console.log('Testing: '+task.filename)

    face.markFaces inputPath+"/"+task.filename, (err, img) ->

      if(!err)
        img.save(outputPath+"/marked_"+task.filename)

      callback()


  if(trackMode=='track')
    q = async.queue(trackFn, 100);
  else
    q = async.queue(markFn, 100);


  # assign a callback
  q.drain = () ->
    console.log('all items have been processed')

  mkdirp outputPath, (err) =>

    if(err)
        console.log(err)
    else

      mkdirp inputPath, (err) =>

        if (err)
          console.error(err)
        else

          fs.readdir inputPath, (err,data) =>

            _s.each data, (item) =>

              if(path.extname(item) == '.jpg')
                q.push({filename:item})