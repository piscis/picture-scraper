cv = require "opencv"
fs = require "fs"
mime = require "mime"

checkFile = (path,cb) ->

  if mime.lookup(path) != "image/jpeg"
    cb("Mimetype check failed",null)

  fs.readFile path, (err,data) ->

    if data.length <= 512
      cb('Filesize <= 0',null)
    else
      cb(null,true)


# Detect face
exports.hasFace = (filePath, cb) ->

  try

    checkFile filePath, (err, data) ->

      if err
        throw new Error(err)

      cv.readImage filePath, (err, im) ->

        im.detectObject cv.FACE_CASCADE, {}, (err, faces) ->

          if err
              cb false
          else
            # Check face count
            if faces.length > 0
              cb true
            else
              cb false
  catch e
    console.log e
    cb false

# Mark face with a red circle
exports.markFaces = (filePath, cb) ->


  console.log mime.lookup(filePath)

  cv.readImage filePath,(err,im) ->

    if !err
      im.detectObject cv.FACE_CASCADE, {}, (err, faces) ->

        if !err

          if faces.length <= 0
            cb "No faces detected", null
          else

            i = 0
            while i < faces.length
              x = faces[i]
              im.ellipse x.x + x.width / 2, x.y + x.height / 2, x.width / 2, x.height / 2
              i++

            cb null, im

        else
          cb err, null

    else
      cb err, null