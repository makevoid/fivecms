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

  class Content
    # attr :type
    # attr :cont
  end

  class Page

    def self.create_accessors(hash)
      attr_accessor *hash.keys
    end

    def self.load(hash)
      page = Page.new
      page.load hash
      page.classify_contents
      page
    end

    def load(hash)
      Page.create_accessors hash
      load_contents hash
    end

    def classify_contents
      # default type: text

      #...
    end

    private

    def load_contents

    end

  end

  class Site
    extend Mhash

    def self.first
      pages = [
        {
          name: "home",
          contents: [
            {
              type: "text",
              cont: "Welcome to my site!",
            },
            {
              type: "image",
              cont: "<binary_image_file>", # TODO: File.read(image_file)
            },
          ]
        },
        {
          name: "antani",
          contents: [
            {
              cont: "antani page!",
            },
          ]
        },
        {
          name: "contacts",
          contents: [
            {
              cont: "Contact me at: email@example.com",
            },
          ]
        },
      ]

      # pages = pages.map{ |page| to_mhash page }
      pages = pages.map{ |page| Page.load(page) }

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


  helpers do
    def metas
      site
    end
  end

end

require_all "#{path}/routes"