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
            if stats.size == 978 || stats.size == 1291
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

###

import urllib.request
from urllib.error import HTTPError,URLError

#function that downloads a file
def downloadFile(file_name,file_mode,base_url):
#create the url
url = base_url + file_name + "/picture"

# Open the url
try:
f = urllib.request.urlopen(url)
print("downloading ", url)

# Open our local file for writing
    local_file = open(file_name+".jpg", "w" + file_mode)
local_file.write(f.read())
local_file.close()

#handle errors
except HTTPError as e:
    print("HTTP Error:",e.code , url)
except URLError as e:
    print("URL Error:",e.reason , url)

#End Function

profile=100000425733973 #Start From Profile ID

# Iterate over image range . Infinite Loop :)
while(1==1):
base_url ='https://graph.facebook.com/'
s_index=str(profile)
file_name =s_index;
# Now download the image. b for binary
    downloadFile(file_name,"b",base_url)
profile=profile+1
#End While Loop
#End Program

###