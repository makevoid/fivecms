class Textilecms < Sinatra::Base
  get "/" do
    haml :index
  end

  get "/site.json" do
    Site.first.to_json
  end

  # TODO: remove me, just for testing w/ ember
   get "/*" do
    haml :index
  end


end