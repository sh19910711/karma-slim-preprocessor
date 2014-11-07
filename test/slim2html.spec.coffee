describe 'preprocessors slim2html', ->
  chai = require('chai')
  templateHelpers = require('./helpers/template_cache')
  slim2html = require('../index')['preprocessor:slim'][1]
  {which} = require('shelljs')

  chai.use(templateHelpers)
  {expect} = chai

  slimCommand = which 'slimrb'
  if !slimCommand
    throw new Error("Cannot find a slimrb on your path, aborting tests.")

  noop = ->
  logger = create: -> {debug: noop, info: noop, error: noop}

  # TODO(vojta): refactor this somehow ;-) it's copy pasted from lib/file-list.js
  File = (path, mtime) ->
    @path = path
    @originalPath = path
    @contentPath = path
    @mtime = mtime
    @isUrl = false


  it 'converts slim to html', (done) ->
    file = new File 'test/fixtures/index.slim'
    process = slim2html({}, logger)
    process '', file, (result) ->
      expect(result).to.equal('<h1>Hello</h1><div class="dece">And welcome!</div>\n')
      done()

  it 'throws an error given invalid slim markup', (done) ->
    file = new File 'test/fixtures/invalid.slim'
    process = slim2html({}, logger)
    process '', file, (result) ->
      expect(result).to.match(/SyntaxError: Malformed indentation/)
      done()

  it 'allows configuring the path of the slimrb binary', (done) ->
    file = new File 'test/fixtures/index.slim'
    process = slim2html({ command: slimCommand }, logger)
    process '', file, (result) ->
      expect(result).to.equal('<h1>Hello</h1><div class="dece">And welcome!</div>\n')
      done()

  it 'throws an error given an invalid slim command configuration', (done) ->
    file = new File 'test/fixtures/index.slim'
    process = slim2html({ command: "foooooooooooo" }, logger)
    process '', file, (result) ->
      console.log('done')
      done()

