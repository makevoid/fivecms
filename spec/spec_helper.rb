ENV["RACK_ENV"] = "test"

require_relative "../config/env"

# requests spec_helper

#require "spec_helper"

require 'rack/test'


def app
  Textilecms
end
include Rack::Test::Methods

require_relative "../textilecms"


def body
  last_response.body
end
