path = File.expand_path '../', __FILE__

require "#{path}/config/env"
require "#{path}/models/models"

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

  class Content
    # attr :type
    # attr :cont
  end

  class Site
    extend Mhash

    def self.first
      pages = PAGES

      # pages = pages.map{ |page| to_mhash page }
      pages = pages.map{ |page| Blizz.load Page, page }

      nav = pages.map{ |page| page.name }

      to_mhash({
        name: "makevoid's portfolio",
        domain: "makevoid.com",
        nav: nav,
        pages: pages,
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

  def self.site
    Site.first
  end

  def self.create_routes(site)

    site.pages.each do |page|
      get page.url do
        @@current_page = page
        # initialize instance variable(s)
        haml "templates/#{page.template}".to_sym
      end
    end

  end

  create_routes site

  helpers do
    def metas
      site
    end

    def page
      @@current_page
    end
  end

end

require_all "#{path}/routes"