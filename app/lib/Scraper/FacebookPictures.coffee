request = require "request"
_ = require "underscore"
async = require "async"
mkdirp = require "mkdirp"
fs = require "fs"

class FacebookPictures

  baseUrl: "https://graph.facebook.com/"
  storagePath: null

  constructor: (@storagePath="downloads") ->

  _createUrl: (fbid) =>
    "#{this.baseUrl}#{fbid}/picture?type=large"

  _fbid2file: (fbid) ->
    "#{fbid}.jpg"

  _prepareStorage: (callb) ->
    mkdirp @storagePath, callb

  download: (fbid, callb) =>
    callb = callb || () ->

    @_prepareStorage (err) =>

      if !err
        filename = "#{@storagePath}/#{@_fbid2file(fbid)}"
        fh = fs.createWriteStream(filename)
        fh.on "open", () =>
          console.log "Downloading #{@_createUrl(fbid)}"

        fh.on "finish", ()=>

          fs.stat "#{filename}", (err, stats) =>

            # Ignore default pictures
            blackList = [0, 978, 1291, 2155, 2120]
            if _.contains(blackList, stats.size)
              fs.unlink filename
              console.log "No profile image."
            else
              console.log "Saving image to #{filename}"

            callb.apply @, arguments

        fh.on "error", callb

        request(@_createUrl(fbid)).pipe(fh)

      else
        console.error "Error creating storage: #{@storagePath}"
        console.error err

module.exports = FacebookPictures