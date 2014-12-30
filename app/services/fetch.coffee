path = require "path"
async = require "async"
Scraper = require __dirname+"/../lib/Scraper/FacebookPictures"
fs = require "fs"
mkdirp = require "mkdirp"

module.exports = (destination) ->


  console.log(destination)
  destination = destination || __dirname+"/../../downloads"
  storagePath = path.resolve destination

  baseFBid = 100000425733973
  fetchParallel = 2
  idLog = storagePath + "/id_store.log"

  console.log "Start downloading to: #{storagePath}"

  mkdirp.sync(storagePath)

  getbaseFBid = (cb) ->

    fs.exists idLog, (exists) ->
      if exists

        fs.readFile idLog, 'utf8', (err, data) ->
          if err
            cb(null, baseFBid)
          else
            if isNaN(data)
              cb(null, baseFBid)
            else
              cb(null, parseInt(data))
      else
        cb(null, baseFBid)

  incBaseFBid = (cb) ->

    baseFBid++
    fs.writeFileSync idLog, baseFBid
    cb(null, baseFBid)


  q = async.queue (task, callback) ->

    if task.fbid

      scraper = new Scraper(storagePath);
      scraper.download task.fbid,(err)->
        if !err
          console.log "Download done"
        else
          console.error "Error downloading file"
        callback()

  , fetchParallel

  getbaseFBid (err, id) ->

    for num in [1..1]

      id++
      baseFBid = id

      incBaseFBid (err, id) ->

        if err
          console.log(err)
        else
          q.push {fbid: id}

  q.drain = () ->

    console.log 'all items have been processed'

    for num in [1000..1]

      incBaseFBid (err, id) ->

        if err
          console.log(err)
        else
          q.push {fbid: id}