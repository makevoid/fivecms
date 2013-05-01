path = File.expand_path '../../', __FILE__
PATH = path

APP = "textilecms"

require "bundler/setup"
Bundler.require :default
module Utils
  def require_all(path)
    Dir.glob("#{path}/**/*.rb") do |model|
      require model
    end
  end
end
include Utils

require_all "#{path}/lib"

env = ENV["RACK_ENV"] || "development"
# DataMapper.setup :default, "mysql://localhost/textilecms_#{env}"
require_all "#{path}/models"
# DataMapper.finalize


