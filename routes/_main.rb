class Textilecms < Sinatra::Base
  get "/" do
    haml :index
  end
end