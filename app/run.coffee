path = require "path"
async = require "async"
Scrapper = require "./../lib/Scrapper/FacebookPictures"

storagePath = path.resolve "downloads"
baseFBid = 100000425733973
fetchParallel = 2

q = async.queue((task, callback) ->

  if task.fbid

    scrapper = new Scrapper(storagePath);
    scrapper.download task.fbid,(err)->
      if !err
        console.log "Download done"
      else
        console.error "Error downloading file"
      callback()

, fetchParallel)

for num in [1..1]
  baseFBid++
  q.push {fbid: baseFBid}


q.drain = () ->

  console.log 'all items have been processed'
  for num in [1000..1]
    baseFBid++
    q.push {fbid: baseFBid}

