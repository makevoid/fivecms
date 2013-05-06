should = require "should"

$ = require "jquery"

jsdom = require("jsdom").jsdom;
doc = jsdom '<html><body></body></html>'
window = doc.createWindow()


path = "../../public/js"

require "#{path}/vendor/jquery"
require "#{path}/app"



describe 'example', ->
  it 'is a lie', ->
    example.truth().should.equal true