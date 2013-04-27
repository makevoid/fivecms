path = File.expand_path '../', __FILE__

require "#{path}/config/env.rb"

class Textilecms < Sinatra::Base
  include Voidtools::Sinatra::ViewHelpers

  # set :logging, true
  # log = File.new "log/development.log", "a"
  # STDOUT.reopen log
  # STDERR.reopen log

  # partial :comment, { comment: "blah" }
  # partial :comment, comment

  def partial(name, value={})
    locals = if value.is_a? Hash
      value
    else
      hash = {}; hash[name] = value
      hash
    end
    haml "_#{name}".to_sym, locals: locals
  end

  #

  class Site
    extend Mhash
    def self.first
      to_mhash({
        name: "makevoid's portfolio",
        domain: "makevoid.com",
        nav: ["home", "antani", "contacts"]
        # pages
        # subpages
        # photo
        # videos

      })
    end
  end

  def site
    Site.first
  end


  helpers do
    def metas
      site
    end
  end

end

require_all "#{path}/routes"