
fs      = require 'fs'
path    = require 'path'

stylus  = require 'stylus'

inFile  = './site/documenten/stijlen/index.styl'
outFile = './site/bestanden/stijlen/algemeen.css'

stylus(fs.readFileSync(inFile,'utf-8')).set("filename", outFile).set("paths", ['site/documenten/stijlen']).render (err, css) ->
    throw err if err
    fs.writeFile outFile, css, (err, data) ->
        throw err if err
        console.log "Saved at #{outFile} path"
