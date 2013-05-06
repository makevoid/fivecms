var $, doc, jsdom, path, should, window;

should = require("should");

$ = require("jquery");

jsdom = require("jsdom").jsdom;

doc = jsdom('<html><body></body></html>');

window = doc.createWindow();

path = "../../public/js";

require("" + path + "/vendor/jquery");

require("" + path + "/app");

describe('example', function() {
  return it('is a lie', function() {
    return example.truth().should.equal(true);
  });
});
