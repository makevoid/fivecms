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

    DEFAULT_TYPE = "text"


    # methods

    def name_url
      # TODO: urlize
      name.gsub(/\s/, "_")
    end

    def url
      "/pages/#{name_url}" # can be abbreviated to /p/, but it's a needed namespace so you can attach other services to other urls
    end

    # content loading

    def self.create_accessors(hash)
      attr_accessor *hash.keys
    end
    def self.create_accessor(name)
      attr_accessor name
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

    def load_contents(hash)
      hash.map do |key, val|
        # self.send "#{key}=", val
        instance_variable_set "@#{key}", val
      end

      val = hash[:type] || DEFAULT_TYPE
      Page.create_accessor :type
      instance_variable_set "@type", val
    end



  end

  class Site
    extend Mhash

    def self.first
      pages = [
        {
          name: "Home",
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
          name: "Antani",
          contents: [
            {
              cont: "antani page!",
            },
          ]
        },
        {
          name: "Contacts",
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

  def self.site
    Site.first
  end

  def self.create_routes(site)

    site.pages.each do |page|
      get page.url do
        @@current_page = page
        # initialize instance variable(s)
        haml page.type.to_sym
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