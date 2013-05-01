class Textilecms < Sinatra::Base
  get "/" do
    haml :index
  end

  get "/site.json" do
    Site.first.to_json
  end
end