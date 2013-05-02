class Page

  include Blizz::Resource

  DEFAULT_TYPE = "text"


  # methods

  def name_url
    # TODO: urlize
    name.downcase.gsub(/\s/, "_")
  end

  def url
    "/pages/#{name_url}" # can be abbreviated to /p/, but it's a needed namespace so you can attach other services to other urls
  end

  def to_json(generator)
    contents = self.contents.map do |content|
      {
        type: content.type,
        cont: content.cont,
      }
    end

    {
      name:     self.name,
      url:      self.url,
      name_url: self.name_url,
      contents: contents,
    }.to_json generator
  end

end

class Text
  include Blizz::Resource
end

class Image
  include Blizz::Resource
end