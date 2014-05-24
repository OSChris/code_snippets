require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/contractor.db")

class Snippet

  include DataMapper::Resource

  property :id, Serial
  property :kind, String
  property :title, String
  property :work, Text

end

DataMapper.finalize

Snippet.auto_upgrade!

get '/' do
  erb :index, layout: :default_layout
end

get '/add' do
  erb :add_snippet, layout: :default_layout
end
