program = require 'commander'
fs = require 'fs'
path = require 'path'

defaultInput = path.resolve(__dirname+'/../../downloads')
defaultOutput = path.resolve(__dirname+'/../../downloads/faces')


###
fs.stat __dirname+"/../../download2/100000425734025.jpg", (err, stats) =>
  console.log(err,stats)
###


program
  .version JSON.parse(fs.readFileSync(__dirname+'/../../package.json')).version
  .on '--help', () ->
    console.log('  Examples:')
    console.log('')
    console.log('    $ node scraper fetch -h')
    console.log('    $ node scraper faces -h')
    console.log('')
    process.exit()

program
  .command 'faces'
  .description 'Detect faces in scraped images'
  .option '-i, --input <path>', "Source path where scraped images can be found '#{defaultInput}'"
  .option '-o, --output <path>', "Destination path for tracked pictures defaults to '#{defaultOutput}'"
  .option '-m, --mode <mode>', "Which mode to use [track|mark]"
  .action (cmd, options={}) ->
    input = cmd.input || __dirname+'/../../downloads'
    output = cmd.output || __dirname+'/../../downloads/faces'
    track = cmd.mode || "track"
    require('./faces')(input,output,track)
  .on '--help', () ->
    console.log('  Examples:')
    console.log()
    console.log('    $ node scraper faces')
    console.log("    $ node scraper faces -m track -i #{defaultInput} -o #{defaultOutput}")
    console.log("    $ node scraper faces -m mark -i #{defaultInput} -o #{defaultOutput}")
    console.log()

program
  .command 'fetch'
  .description 'Scrape facebook profile pictures'
  .option '-d, --destination <path>', "Path to destination path"
  .action (cmd, options={}) ->
      destination = cmd.destination || "#{defaultInput}"
      require('./fetch')(destination)
  .on '--help', () ->
    console.log('  Examples:')
    console.log()
    console.log('    $ node scraper fetch')
    console.log("    $ node scraper fetch -d #{defaultInput}")
    console.log()


program.parse(process.argv)